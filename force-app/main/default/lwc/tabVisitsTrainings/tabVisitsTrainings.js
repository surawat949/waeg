import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

import Instore_Training_And_Webinars from '@salesforce/label/c.Instore_Training_And_Webinars';
import ECP_Training_Name from '@salesforce/label/c.ECP_Training_Name';
import Training_Topic from '@salesforce/label/c.Training_Topic';
import Start from '@salesforce/label/c.start';
import Training_Status from '@salesforce/label/c.Training_Status';
import e_learnings from '@salesforce/label/c.e_learnings';
import e_learnings_name from '@salesforce/label/c.e_learnings_name';
import Created_Date from '@salesforce/label/c.Created_Date';
import User_Name from '@salesforce/label/c.User_Name';
import e_Email from '@salesforce/label/c.e_Email';
import e_status from '@salesforce/label/c.e_status';
import End_Date from '@salesforce/label/c.End_Date';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_new from '@salesforce/label/c.NewButtonRelatedList';
import selectTraining from '@salesforce/label/c.Select_Training';
import createFor from '@salesforce/label/c.Create_Certificate_For';
import selectAttendee from '@salesforce/label/c.Select_Attendee';
import noAttendeeError from '@salesforce/label/c.No_Attendee_Error';
import sendCertificate from '@salesforce/label/c.Send_Certificate';
import emailSent from '@salesforce/label/c.email_Sent';
import allAttendees from '@salesforce/label/c.All_Attendees';
import indiAttendee from '@salesforce/label/c.Individual_Attendee';
import noTemplateError from '@salesforce/label/c.No_Template_error';

import getTrainingRecord from '@salesforce/apex/TabVisitsTrainingsController.getTrainingRecords';
import getElearningRecords from '@salesforce/apex/TabVisitsTrainingsController.getElearningRecords';
import getECPTrainings from '@salesforce/apex/TrainingCertificateController.getECPTrainings';
import getAttendees from '@salesforce/apex/TrainingCertificateController.getAttendees';
import processCertificate from '@salesforce/apex/TrainingCertificateController.generateCertificate';
import attendeeNums from '@salesforce/apex/TrainingCertificateController.getNumAttendee';
import getAccBrand from '@salesforce/apex/TrainingCertificateController.getAccountBrand';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';

export default class TabVisitsTrainings extends NavigationMixin(LightningElement) {
    @api receivedId;
    @api showAttendees = false;
    @api showMissingError = false;
    trainingRecords;
    showAllTab=false;
    elarningRecords;
    trainingCount = 0;
    eLearningCount = 0;
    displayTrainingViewAllButton = false;
    displayElearningViewAllButton = false;
    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Related_list_Training__e';
  
    label = {Instore_Training_And_Webinars,
              ECP_Training_Name,Training_Topic,Start,
              Training_Status,e_learnings,e_learnings_name,
              e_learnings_name,Created_Date,User_Name,e_Email,
              e_status,End_Date, 
              label_viewall,label_new,
              selectTraining,
              createFor,
              selectAttendee,
              noAttendeeError,
              sendCertificate,
              emailSent,
              allAttendees,
              indiAttendee,
              noTemplateError}

   @track trainingColumns = [
    {
        label: this.label.ECP_Training_Name,
        fieldName: 'nameLink',
        type: 'url',
        typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
        sortable: true
      },
      {
        label: this.label.Training_Topic,
        fieldName: 'Training__c',
        type: 'text',
        sortable: true,
        wrapText: true
      },
      {
        label: this.label.Start,
        fieldName: 'start__c',
        type: 'date',
        sortable: true
      },
      {
        label: this.label.Training_Status,
        fieldName: 'Training_status__c',
        type: 'text',
        sortable: true
      },
   ]

   @track elarningColumns = [
    {
        label: this.label.e_learnings_name,
        fieldName: 'nameLink',
        type: 'url',
        typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
        sortable: true
      },
      {
        label: this.label.Created_Date,
        fieldName: 'CreatedDate',
        type: 'date',
        sortable: true
      },
      {
        label: this.label.User_Name,
        fieldName: 'User_Name__c',
        type: 'text',
        sortable: true
      },
      {
        label: this.label.e_Email,
        fieldName: 'email__c',
        type: 'text',
        sortable: true
      },
      {
        label: this.label.e_status,
        fieldName: 'status__c',
        type: 'text',
        sortable: true
      },
      {
        label: this.label.End_Date,
        fieldName: 'End_Date__c',
        type: 'date',
        sortable: true
      }
   ]

   @track isModalOpen = false;
   @track value1;
   @track disabledButton = true;
   @track disabledRadio = true;
   @track selectedOption = [];
   @track selectedAttendees = [];
   @track showLoading = false;
   @track certificateOptions = [{
      label : this.label.allAttendees, value : 'All'
   }, {
      label : this.label.indiAttendee, value : 'Individual'
   }];

   selectedTrainingId;
   selectedCertificateOption;
   selectedAttendeeId;
   NumOfAttendee;
   AccountBrand;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.getTrainingRecordsFromApex();
        this.ECPTranings();
        this.getAccountBrand();

        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
          this.subscription = response;
        });
        onError(error => {
          this.showToast('Server Error--->', error, 'error');
        });

    }
    refreshList = ()=> {
      this.getTrainingRecordsFromApex();
    } 
  
  getTrainingRecordsFromApex(){
    getTrainingRecord({accountId:this.receivedId}).then(result=>{
          if(result){
            let data = JSON.parse(JSON.stringify(result));
            data.forEach(res=>{
                res.nameLink = '/' + res.Id;
            });
        
            let allTrainingRecords = data;
            this.trainingRecords = (allTrainingRecords.length <= 5) ? [...allTrainingRecords] : [...allTrainingRecords].splice(0,5);
              if(allTrainingRecords.length > 5){
                this.trainingCount='5+';
                this.displayTrainingViewAllButton = true;
              }
              else{
                  this.trainingCount = allTrainingRecords.length;
                  this.displayTrainingViewAllButton = false;
              }
          }
        }).catch(error=>{
          this.showToast('Error','Error While fetching the Training Records'+error.message,'error');
        })
      }
  
  getAccountBrand(){
    getAccBrand({receivedId : this.receivedId})
    .then(result =>{
        if(result){
          let AccBrand = JSON.parse(JSON.stringify(result));
          this.AccountBrand = AccBrand;
        }
    }).catch(error=>{
        this.showToast('Error', error, 'error');
    });
  }

  ECPTranings(){
    getECPTrainings({accountId : this.receivedId})
      .then(response=>{
          if(response){
              for(const eachTraining of response){
                  const option = {
                      label : eachTraining.Name,
                      value : eachTraining.Id
                  };
                  this.selectedOption = [...this.selectedOption, option];
              }
          }
    }).catch(error=>{
        this.showToast('Error', JSON.stringify(error), 'error');
    });
  }
  @wire(getElearningRecords, {accountId:'$receivedId'}) trainingRec({error, data}){
    if(data){
      data = JSON.parse(JSON.stringify(data));
      data.forEach(res=>{
          res.nameLink = '/' + res.Id;
      });

      let allElearningRecords=data;
      this.elarningRecords = (allElearningRecords.length <= 5) ? [...allElearningRecords] : [...allElearningRecords].splice(0,5);
                
      if(allElearningRecords.length > 5){
          this.eLearningCount='5+';
          this.displayElearningViewAllButton = true;
        }
        else{
            this.eLearningCount = allElearningRecords.length;
            this.displayElearningViewAllButton = false;
        }
    }else if (error){
      this.showToast('Error','Error While fetching the E-learning Records'+error.message,'error');
  }
}
  
  showToast(title,message,variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant
    });
    this.dispatchEvent(event);
  }

  navigateToRelatedList(relationshipName){
    this[ NavigationMixin.GenerateUrl ]({
        type : 'standard__recordRelationshipPage',
        attributes : {
            recordId : this.receivedId,
            objectApiName : 'Account',
            relationshipApiName : relationshipName,
            actionName : 'view'
        }
    }).then(url => {
        window.open(url, '_blank');
    });
}

    navigateToTrainingRelatedList(event){
      this.navigateToRelatedList('ECP_Training__r');
    }

    navigateToELearningRelatedList(event){
      this.navigateToRelatedList('eLearnings__r');
    }

    navigateToTrainingCreatePage(event){
      this.navigateToNewPage('ECP_Training__c');
    }

    navigateToNewPage(objectName){
      const defaultValues = encodeDefaultFieldValues({
        Account__c : this.receivedId
      });
      this[ NavigationMixin.Navigate]({
          type : 'standard__objectPage',
          attributes : {
              objectApiName : objectName,
              actionName : 'new'
          },
          state: {
              defaultFieldValues: defaultValues,
              useRecordTypeCheck : 1,
              navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
          }
      });
    }
    disconnectedCallback() {
      unsubscribe(this.subscription, () => {
      });   
    }

    handleTrainingChange(event){
      //this.reset();
      this.selectedAttendees = [];
      this.showAttendees = false;
      this.showMissingError = false;

      setTimeout(() => {
        this.value1 = 'All';
      }, 0);
      
      this.value1 = undefined;
      this.disabledRadio = false;
      this.disabledButton = false;
      this.selectedTrainingId = event.detail.value;
      this.getAttendeeNums();
    }

    handleRadioChange(event){
        this.selectedCertificateOption = event.detail.value;
        if(this.selectedCertificateOption != null && this.selectedCertificateOption != undefined){
            if(this.selectedCertificateOption === 'Individual'){
                this.disabledButton = true;
                this.showMissingError = false;
                this.loadAttendees();
            }else{
                this.showMissingError = false;
                this.showAttendees = false;
                this.disabledButton = false;
            }
        }else{
            this.showMissingError = true;
            this.showAttendees = false;
            this.disabledButton = false;
        }
    }

    getAttendeeNums(){
      attendeeNums({trainingId : this.selectedTrainingId})
      .then(response=>{
          if(response){
            this.NumOfAttendee = response.getAttendeeNum;
            if(this.NumOfAttendee > 0){
                this.disabledButton = false;
                this.disabledRadio = false;
            }else{
                this.disabledButton = true;
                this.disabledRadio = true;
            }
          }
      }).catch(error=>{
          this.showToast('Error', JSON.stringify(error), 'error');
      })
    }

    loadAttendees(){
      this.selectedAttendees = [];
      getAttendees({trainingId : this.selectedTrainingId})
      .then(response =>{
          if(response){
              for(const eachAttendee of response){
                  var key = eachAttendee.Contact__r.Name.concat('-', eachAttendee.Contact__r.RecordType.Name);
                  const option ={
                      label : key,
                      value : eachAttendee.Id
                  };
                  this.selectedAttendees = [...this.selectedAttendees, option];

              }
              if(this.selectedAttendees != undefined && this.selectedAttendees!=0){
                  this.showAttendees = true;
              }else{
                  this.showMissingError = true;
              }
          }
      }).catch(error =>{
        this.showToast('Error', error, 'error');
      });
    }

    handleAttendeeChange(event) {
      this.disabledButton = false;
      this.selectedAttendeeId = event.detail.value;
    }

    processCertificateGeneration(){
        this.disabledButton = true;
        this.showLoading = true;
        this.isModalOpen = false;
        processCertificate({trainingId:this.selectedTrainingId, attendeeId:this.selectedAttendeeId, brand:this.AccountBrand})
            .then(response=>{
                if(response === 'Success'){
                    this.showToast('Success', this.label.emailSent, 'success');
                }else if(response === 'AttendeeError'){
                    this.showToast('Error', this.label.noAttendeeError, 'error');

                }else if(response === 'templateError'){
                    this.showToast('Error', this.label.noTemplateError, 'error');
                }else{
                    this.showToast('Error', response, 'error');
                }
                this.showLoading = false;
                this.closeModal();
            }).catch(error =>{
                this.showToast('Error', JSON.stringify(error), 'error');
                this.closeModal();
            });
    }

    openModal(){
      this.isModalOpen = true;
      this.disabledRadio = true;
    }

    closeModal(){
      this.isModalOpen = false;
      this.showMissingError = false;
      this.showAttendees = false;
      this.selectedTrainingId = null;
      this.selectedAttendeeId = null;
      this.selectedAttendees = [];
      this.disabledButton = true;
    }

    reset(){
      this.showMissingError = false;
      this.showAttendees = false;
      this.selectAttendees = [];
    }
    @wire(getChatterUserDetail)
        allStages({data }) {
			if (data) {
				this.showAllTab = data;
			} 
			else{
				this.showAllTab = false;
			}
        }

}