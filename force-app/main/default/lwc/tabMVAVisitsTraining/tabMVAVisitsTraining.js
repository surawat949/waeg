import { LightningElement, api, track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// labels
import InstoreTrainingandWebinars from '@salesforce/label/c.tabClinicVisitsTraining';
import NewButton from '@salesforce/label/c.NewButtonRelatedList';
import ViewAll from '@salesforce/label/c.ViewAllRelatedList';
import ECPTrainingName from '@salesforce/label/c.tabVisitECPTrainingName';
import TrainingTopics from '@salesforce/label/c.tabVisitTrainingTopics';
import Date from '@salesforce/label/c.tabVisitDate';
import Trainer from '@salesforce/label/c.tabVisitTrainer';
import TrainingStatus from '@salesforce/label/c.tabVisitTrainingStatus';
import selectTraining from '@salesforce/label/c.Select_Training';
import createFor from '@salesforce/label/c.Create_Certificate_For';
import selectAttendee from '@salesforce/label/c.Select_Attendee';
import noAttendeeError from '@salesforce/label/c.No_Attendee_Error';
import sendCertificate from '@salesforce/label/c.Send_Certificate';
import emailSent from '@salesforce/label/c.email_Sent';
import allAttendees from '@salesforce/label/c.All_Attendees';
import indiAttendee from '@salesforce/label/c.Individual_Attendee';
import noTemplateError from '@salesforce/label/c.No_Template_error';
//Apex
import getInStoreTrainingRelatedList from '@salesforce/apex/TabMVAVisitsController.getInStoreTrainingRelatedList'
import getEcplstTraining from '@salesforce/apex/TabMVAVisitsCertificateController.getECPTrainings';
import getAttendeeList from '@salesforce/apex/TabMVAVisitsCertificateController.getAttendee';
import getAttendeeNums from '@salesforce/apex/TabMVAVisitsCertificateController.getAttendeeNumber';
import processCertificate from '@salesforce/apex/TabMVAVisitsCertificateController.generateCertificate';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';


export default class TabMVAVisitsTraining extends NavigationMixin(LightningElement){
    @api receivedId;

    custLabel = {
        InstoreTrainingandWebinars,
        NewButton,
        ViewAll,
        createFor,selectAttendee,
        noAttendeeError, sendCertificate,
        emailSent, allAttendees,
        indiAttendee, noTemplateError, selectTraining
    }

    @track isLoading = false;
    @track isModalOpen = false;
    @track selectEcpTrainingOption = [];    //store for all training record(s) here, make it into combo-box
    @track selectAttendeeOption = [];       //store for all attendees record(s) optional here
    @track certificateOptions = [{
        label : this.custLabel.allAttendees, value : 'All'
     }, {
        label : this.custLabel.indiAttendee, value : 'Individual'
     }];
    @track value1;
    @track disabledRadio = true;
    @track disabledButton = true;
    @track showAttendee = false;
    @track showMissingError = false;

    inStoreTrainingLst;
    isDataExist;
    recCount = 0;
    showTrainingCertificate = false;
    selectedTrainingId;
    attendeeId;
    selectedCertificationId;
    attendeeNumber = 0;
    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Related_list_Training__e';

    startNewInStoreTraining(event){
        this.navigateToNewPage('ECP_Training__c');
    }
    generateCertificate(event){
        this.showTrainingCertificate = true;
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
    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'ECP_Training__r',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }
    columns = [
        {label: ECPTrainingName,fieldName: 'TrainingLink',
        type: 'url', typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
        sortable: true},       
        {label: TrainingTopics,fieldName: 'Training__c'},
        {label: Date, fieldName: 'start__c'}, 
        {label: Trainer, fieldName: 'AssignedLink',
        type :'url', typeAttributes: {label: {fieldName: 'AssignedUser'}, target:'_top'}, 
        sortable: true},         
        {label: TrainingStatus, fieldName: 'Training_status__c'}
    ];
    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.getInStoreTraining();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    connectedCallback(){
        this.isLoading = true;
        //this.ECPTraining();
        this.getInStoreTraining();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
			let triggerAlert = true;
			if(errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none"){
				triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); 
			}
			if(triggerAlert){
                this.showToast('Error', 'error', JSON.stringify(errorData.error));
			}
        });    
    }
   
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
    getInStoreTraining(){
        getInStoreTrainingRelatedList({accountId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            response.forEach(res=>{              
                res.TrainingLink = '/' + res.Id;
                if(res.hasOwnProperty('Assigned_to__c'))
                    res.AssignedLink = '/' + res.Assigned_to__c; 
                else
                    res.AssignedLink ='';
                if(res.hasOwnProperty('Assigned_to__r'))
                    res.AssignedUser = res.Assigned_to__r.Name;
                else
                    res.AssignedUser = '';
            });                
            let trainingLst = response;
            this.inStoreTrainingLst = (trainingLst.length <= 5) ? [...trainingLst] : [...trainingLst].splice(0,5);
            
            if(trainingLst.length>5){
                this.recCount='5+';
            }
            else{
                this.recCount=trainingLst.length;
            }
            if(trainingLst.length > 0)
                this.isDataExist =true;
            this.isLoading = false;
        })
        .catch(error => {
            this.isLoading = true;
            this.showToast('Error', 'Error', error.message);
            this.isLoading = false;
        });

        this.ECPTraining();
    }
    ECPTraining(){
        getEcplstTraining({accountId : this.receivedId})
        .then(response=>{
            if(response){
				this.selectEcpTrainingOption = [];
                for(const eachTraining of response){
                    const option = {
                        label : eachTraining.Name,
                        value : eachTraining.Id
                    };
                    this.selectEcpTrainingOption = [...this.selectEcpTrainingOption, option];
                }
            }
        }).catch(error=>{
            this.showToast('Error', 'Error', JSON.stringify(error.message));
        });
    }

    AttendeeMember(){
        this.selectAttendeeOption = [];
        getAttendeeList({trainingId : this.selectedTrainingId})
        .then(response=>{
            if(response){
                for(const eachAttendee of response){
                    var key = eachAttendee.Contact__r.Name.concat('-', eachAttendee.Contact__r.RecordType.Name);
                    const option ={
                        label : key,
                        value : eachAttendee.Id

                    };
                    this.selectAttendeeOption = [...this.selectAttendeeOption, option];
                }
                if(this.selectAttendeeOption != undefined || this.selectAttendeeOption != 0){
                    this.showAttendee = true;
                }else{
                    this.showMissingError = true;
                }
            }
        }).catch(error=>{
            this.showToast('Error', 'Error', JSON.stringify(error.message));
        });
    }

    getAttendeeNumber(){
        getAttendeeNums({trainingId : this.selectedTrainingId})
        .then(response=>{
            if(response){
                this.attendeeNumber = response.AttendeeNumber;
                if(this.attendeeNumber > 0){
                    this.disabledButton = false;
                    this.disabledRadio = false;
                }else{
                    this.disabledButton = true;
                    this.disabledRadio = true;
                }
            }
        }).catch(error=>{
            this.showToast('Error', 'Error', JSON.stringify(error.message));
        });
    }

    processCertificateGenerate(){
        this.disabledButton = true;
        this.isModalOpen = false;
        this.isLoading = true;
        processCertificate({trainingId:this.selectedTrainingId, attendeeId:this.attendeeId})
        .then(response=>{
            if(response === 'Success'){
                this.showToast('Success', 'success', this.custLabel.emailSent);
            }else if(response === 'AttendeeError'){
                this.showToast('Error', 'error', this.custLabel.noAttendeeError);
            }else if(response === 'templateError'){
                this.showToast('Error', 'error', this.custLabel.noTemplateError);
            }else{
                this.showToast('Error', 'error', JSON.stringify(response));
            }
            this.isLoading = false;
            this.closeModal();
        }).catch(error=>{
            this.isLoading = true;
            this.showToast('Error', 'error', JSON.stringify(error.message));
            this.isLoading = false;
            this.closeModal();
        });

    }

    handleChangeTraining(event){
        this.selectAttendeeOption = [];
        this.showAttendee = false;
        this.showMissingError = false;
        setTimeout(() => {
            this.value1 = 'All';
        }, 0);
        this.value1 = undefined;
        this.disabledRadio = false;
        this.disabledButton = false;
        this.selectedTrainingId = event.detail.value;
        this.getAttendeeNumber();
        
    }
    
    handleSelectCertificatedChange(event){
        this.selectedCertificationId = event.detail.value;
        if(this.selectedCertificationId!=null && this.selectedCertificationId!=undefined){
            if(this.selectedCertificationId === 'Individual'){
                this.disabledButton = true;
                this.showMissingError = false;
                this.AttendeeMember();
            }else{
                this.showMissingError = false;
                this.showAttendee = false;
                this.disabledButton = false;

            }
        }else{
            this.showMissingError = true;
            this.showAttendee = false;
            this.disabledButton = false;
        }
    }

    handleAttendeeChange(event){
        this.disabledButton = false;
        this.attendeeId = event.detail.value;

    }

    openModal(){
        this.isLoading = true;
        this.resetComp();
        this.isModalOpen = true;
        this.isLoading = false;
    }

    closeModal(){
        this.isLoading = true;
        this.isModalOpen = false;
        this.isLoading = false;
    }

    resetComp(){
        //reset for all components neccessary to default value
        this.disabledRadio = true;
        this.disabledButton = true;
        this.showAttendee = false;
        this.showMissingError = false;
        this.selectAttendeeOption = [];
}
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });   
    }
}