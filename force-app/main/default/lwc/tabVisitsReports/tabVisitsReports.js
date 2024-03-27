import { LightningElement, api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import Last_Visit_Completed from '@salesforce/label/c.Last_Visit_Completed';
import Report_Visit_Id from '@salesforce/label/c.Report_Visit_Id';
import Report_Visit_Type from '@salesforce/label/c.Report_Visit_Type';
import Assigned_To from '@salesforce/label/c.Assigned_To';
import Report_Start from '@salesforce/label/c.Report_Start';
import Report_Visit_Objective from '@salesforce/label/c.Report_Visit_Objective';
import Report_Contact from '@salesforce/label/c.Report_Contact';
import Report_Call_To_Action_Notes from '@salesforce/label/c.Report_Call_To_Action_Notes';

import Last_Three_Visit_Completed from '@salesforce/label/c.Last_Three_Visit_Completed';
import Reports_Date from '@salesforce/label/c.Reports_Date';
import Call_To_Action from '@salesforce/label/c.Call_To_Action';
import Visit_Notes from '@salesforce/label/c.Visit_Notes';
import Last_Three_Tasks from '@salesforce/label/c.Last_Three_Tasks';
import Reports_Created_By from '@salesforce/label/c.Reports_Created_By';
import Reports_Subject from '@salesforce/label/c.Reports_Subject';
import Report_Due_Date from '@salesforce/label/c.Report_Due_Date';
import Report_Status from '@salesforce/label/c.Report_Status';
import visits from '@salesforce/label/c.visits';
import Reports_Visit_ID from '@salesforce/label/c.Reports_Visit_ID';
import Reports_Start from '@salesforce/label/c.Reports_Start';
import VisitType from '@salesforce/label/c.VisitType';
import VisitObj from '@salesforce/label/c.VisitObj';
import VisitStatus from '@salesforce/label/c.VisitStatus';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_new from '@salesforce/label/c.NewButtonRelatedList';

import getReportVisit from '@salesforce/apex/TabVisitsReportsController.getReportVisits';
import getTaskReport from '@salesforce/apex/TabVisitsReportsController.getTaskRecord';
import getVisitCompleted from '@salesforce/apex/TabVisitsReportsController.getVisitCompleted';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class TabMVCVisitsReports extends NavigationMixin(LightningElement) {
  @api receivedId;
  LastVisitCompletedData={};
  @track visitRecord;
  @track taskRecord;
  @track visitData;
  visitCount=0;
  displayVisitViewAllButton=true;
  CHANNEL_NAME = '/event/Refresh_Related_list_Visit__e';

  label = {Last_Visit_Completed,Report_Visit_Id,Report_Visit_Type,Assigned_To,
          Report_Start,Report_Visit_Objective,Report_Contact,label_viewall,label_new,
          Report_Call_To_Action_Notes,Last_Three_Visit_Completed,Reports_Date,Visit_Notes,Call_To_Action,Last_Three_Tasks,
          Reports_Created_By,Reports_Subject,Report_Due_Date,Report_Status,visits,Reports_Visit_ID, Reports_Start, VisitType,VisitObj,
          VisitStatus}

          @track visitcolumns = [
            {
              label: this.label.Reports_Date,
              fieldName: 'Start_Day__c',
              type: 'date',
              sortable: true
            },
            {
              label: this.label.Assigned_To,
              fieldName: 'Visit_assigned_to__c',
              type: 'text',
              sortable: true
            },
            {
              label: this.label.Visit_Notes,
              fieldName: 'Visit_Notes__c',
              type: 'text',
              sortable: true ,
              wrapText: true
            },
            {
              label: this.label.Call_To_Action,
              fieldName: 'Call_To_Action_Notes__c',
              type: 'text',
              sortable: true,
              wrapText: true
            }
        ];

        @track taskColumns = [
          {
            label: this.label.Reports_Created_By,
            fieldName: 'createdBy',
            type: 'text',
            sortable: true
          },
          {
            label: this.label.Reports_Subject,
            fieldName: 'nameLink',
            type: 'url',
            typeAttributes: {label: {fieldName: 'Subject'}, target:'_top'},
            sortable: true            
          },
          {
              label: this.label.Assigned_To,
              fieldName: 'ownerName',
              type: 'text',
              sortable: true
          },
          {
              label: this.label.Report_Due_Date,
              fieldName: 'ActivityDate',
              type: 'text',
              sortable: true
          },   
          {
            label: this.label.Report_Status,
            fieldName: 'Status',
            type: 'text',
            sortable: true
        }
      ];
    
      @track visitColumns = [
        {
            label: this.label.Reports_Visit_ID,
            fieldName: 'nameLink',
            type: 'url',
            typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true
        },
        {
            label: this.label.Reports_Start,
            fieldName: 'Start_Day__c',
              type: 'text',
              sortable: true
        },
        {
            label: this.label.VisitType,
            fieldName: 'Visit_Type__c',
            type: 'text',
            sortable: true 
        },
        {
            label: this.label.VisitObj,
            fieldName: 'Visit_Reason__c',
            type: 'text',
            sortable: true,
            wrapText: true
        },   
        {
          label: this.label.VisitStatus,
          fieldName: 'Visit_Status__c',
          type: 'text',
          sortable: true
      } 
    ];
  connectedCallback() {
      this.getReportVisit();
      subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
          this.subscription = response;
      });
      onError(error => {
          this.showToast('Error', 'Error', error.body.message);
      });
    }

    getReportVisit(){
      getReportVisit({accountId : this.receivedId})
      .then(response => {
        console.log('>>>test3');
        response = JSON.parse(JSON.stringify(response));
        response.forEach(res=>{
            res.nameLink = '/' + res.Id;
        });
        this.visitData = response;
        let allVisit=response;
        this.visitData = (allVisit.length <= 5) ? [...allVisit] : [...allVisit].splice(0,5);
        this.displayVisitViewAllButton = true;

        if(allVisit.length > 5){
            this.visitCount='5+';
          }
          else{
              this.visitCount=allVisit.length;
          }
      }).catch(error => {
        this.showToast('Error', 'Error', error.body.message);
    })
  }
  refreshList = ()=> {
    console.log('>>>test4');
    this.getReportVisit();
  }

  @wire(getTaskReport, {accountId:'$receivedId'}) taskRec({error, data}){
    if(data && data.length > 0){
        data = JSON.parse(JSON.stringify(data));
        data.forEach(res=>{ 
        res.nameLink = '/' + res.Id;
        res.ownerName = res.Owner.Name;
        res.createdBy = res.CreatedBy.Name +' , '+ res.Created_Date__c
      }); 
      this.taskRecord = data;
      }
      else if (error){
        this.showToast('Error','Error While fetching the Tasks'+error.message,'error');
      }
  }



  @wire(getVisitCompleted, {accountId:'$receivedId'}) visData({error, data}){
    if(data && data.length > 0){
        data = JSON.parse(JSON.stringify(data));
        data.forEach(res=>{
        res.nameLink = '/' + res.Id;
      });
      this.visitRecord = data;
      }
      else if (error){
        this.showToast('Error','Error While fetching the Visits'+error.message,'error');
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

  navigateToVisitRelatedList(event){
    this.navigateToRelatedList('Visits__r');
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

navigateVisitCreatePage(event){
  this.navigateToNewPage('Visits__c');
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
  console.log('>>>test1');
  unsubscribe(this.subscription, () => {
   });
}

}