import { LightningElement, api, wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
//Platform Event
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
//Custom Labels
import CampaignMemberShip from '@salesforce/label/c.CampaignMemberShip';
import Member from '@salesforce/label/c.Member';
import CampaignName from '@salesforce/label/c.CampaignName';
import start from '@salesforce/label/c.start';
import End from '@salesforce/label/c.End';
import Presentation from '@salesforce/label/c.Presentation';
import Interest from '@salesforce/label/c.Interest';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_new from '@salesforce/label/c.NewButtonRelatedList';
//Apex 
import getCampaignMembership from '@salesforce/apex/TabVisitsCampOppController.getCampaignMembership';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';

export default class TabVisitsCampOpp extends NavigationMixin(LightningElement) {
    @api receivedId;
    showAllTab=false;
    displayCampaignViewAllButton = false;
    campaignCount=0;
    campaigns;
    subscription = {};
    projectName;
    CHANNEL_NAMEAC = '/event/Refresh_Related_List_AC__e';   
    label={
        CampaignMemberShip,Member,CampaignName,start,End,Presentation,Interest,label_viewall,label_new
    }
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });
    }
    @track campaigncolumns = [
        {
            label: this.label.Member,
            fieldName: 'nameLink',
            type: 'url',
                typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: false

        },
        {
            label: this.label.CampaignName,
            fieldName: 'Campaign_Name_t__c',
            type: 'text',
            sortable: false
        },
        {
            label: this.label.start,
            fieldName: 'Campaign_Start_Date_t__c',
            type: 'date',
            sortable: false 
        },
        {
            label: this.label.End,
            fieldName: 'Campaign_End_Date_t__c',
            type: 'date',
            sortable: false
        },
        {
            label: this.label.Presentation,
            fieldName: 'Date_of_presentation__c',
            type: 'date',
            sortable: false
        },
        {
            label: this.label.Interest,
            fieldName: 'Campaign_Interested__c',
            type: 'text',
            sortable: false
        }
    ];
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.isLoading = true;
        this.getCampaignMembership();    
        subscribe(this.CHANNEL_NAMEAC, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
			let triggerAlert = true;
			if(errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none"){
				triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); // 20000 milliseconds = 20 seconds
			}
			if(triggerAlert){
                this.showToast("Error", JSON.stringify(errorData.error),"error");
			}
        });

    }
    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.isLoading = true;
            this.getCampaignMembership();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAMEAC, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
    navigateToCampaignRelatedList(event){
        this.navigateToRelatedList('Campaign_Membership__r');
    }
    navigateToNewCampaignPage(objectName){
        const defaultValues = encodeDefaultFieldValues({
            Account_Name__c : this.receivedId
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
    navigateToNewPage(objectName){
        const defaultValues = encodeDefaultFieldValues({
            AccountId : this.receivedId
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
    getCampaignMembership() {
        getCampaignMembership({accountId: this.receivedId})
        .then(result => {
        if(result){
            result = JSON.parse(JSON.stringify(result));
            result.forEach(res=>{
                res.nameLink = '/' + res.Id;
            });

            let allVCampaigns=result;
            this.campaigns = (allVCampaigns.length <= 5) ? [...allVCampaigns] : [...allVCampaigns].splice(0,5);
            this.displayCampaignViewAllButton = true;

            if(result.length > 5){
                this.campaignCount='5+';
            }
            else{
                this.campaignCount=allVCampaigns.length;
            }
        }
        }).catch(error => {
            this.showToast("Error", "Error while getting the Opportunity Details : "+error, 
            "error");
        });
      }

    showCampaignPage(){
    this.navigateToNewCampaignPage('Account_Campaing_Member__c');
    }
    navigateToRecordEditPage(recordId) {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            actionName: 'edit'
        }
    });
}

    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
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