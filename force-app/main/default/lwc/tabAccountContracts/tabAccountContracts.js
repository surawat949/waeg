import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

//Apex import call
import getRelatedContractAccountRec from '@salesforce/apex/TabAccountContractsLWCController.getAccountRelatedContracts';

import label_new from '@salesforce/label/c.NewButtonRelatedList';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_contractsCustom from '@salesforce/label/c.Contracts_custom';
import label_hoyaContractNumber from '@salesforce/label/c.Hoya_Contract_Number';
import label_expirationDate from '@salesforce/label/c.Expiration_Date';
import label_startDate from '@salesforce/label/c.Start_Date';
import label_contractClass from '@salesforce/label/c.Contract_Class';
import label_contractType from '@salesforce/label/c.Contract_Type';
import label_isActive from '@salesforce/label/c.EMEACampaignIsActive';
import label_daysTillExp from '@salesforce/label/c.Days_till_Expiration';
import label_Contract_ID from '@salesforce/label/c.Contract_ID';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class TabAccountContracts extends NavigationMixin(LightningElement) {
    @api receivedId;
    @track ContractRecord;
    CHANNEL_NAME = '/event/Refresh_Related_list_Custom_Contract__e';
    label = {label_new,label_viewall,label_contractsCustom,label_hoyaContractNumber,label_expirationDate,
        label_startDate,label_contractClass,label_contractType,label_isActive,label_daysTillExp,label_Contract_ID};

    Contract_ID = label_Contract_ID;
    Hoya_Contract_Number = label_hoyaContractNumber;
    Expiration_Date = label_expirationDate;
    Start_Date = label_startDate;
    Contract_Class = label_contractClass;
    Contract_Type = label_contractType;
    EMEACampaignIsActive = label_isActive;
    Days_till_Expiration = label_daysTillExp;

    contractData;
    contractCount;
    isContractGreaterThan5 = false;
    @track columns = [
        {
            label: this.Contract_ID,
            fieldName: 'conLink',
            type: 'url',
                typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true

        },
        {
            label: this.Contract_Type,
            fieldName: 'Contract_Type__c',
            type: 'text',
            sortable: true 
        },
        {
            label: this.Contract_Class,
            fieldName: 'Contract_Class__c',
            type: 'text',
            sortable: true
        },
        {
            label: this.Start_Date,
            fieldName: 'Start_Date__c',
            type: 'Date',
            sortable: true
        },
        {
            label: this.Expiration_Date,
            fieldName: 'Expiration_Date__c',
            type: 'Date',
            sortable: true
        },
        {
            label: this.EMEACampaignIsActive,
            fieldName: 'IsActive__c',
            type: 'boolean',
            sortable: true
        },
        {
            label: this.Days_till_Expiration,
            fieldName: 'Days_till_Expiration__c',
            type: 'text',
            sortable: true
        }
    ];

    connectedCallback() {
        this.getRelatedContractAccountRec();
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
                }, 20000); // 20000 milliseconds = 20 seconds
			}
			if(triggerAlert){
                this.showToast('Error', JSON.stringify(errorData.error), 'error');
			}
        }); 
    }

    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.getRelatedContractAccountRec();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    getRelatedContractAccountRec(){
        getRelatedContractAccountRec({receivedId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            response.forEach(res=>{
                res.conLink = '/' + res.Id;
            });
            let allContract = response;
            this.contractData = (response.length<=5) ? [...response] : [...response].splice(0,5);
            this.ContractRecord = this.contractData;
            if(allContract.length > 5){
                this.contractCount = '5+';
                this.isContractGreaterThan5 = true;
            }else{
                this.contractCount = allContract.length;
            }
        }).catch(error => {
            this.showToast('Error', 'Error', error.body.message);
        })
    }
    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Contracts__r',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }

    startNewContract(event){
        this.navigateToNewPage('Contract__c');
    }

    navigateToNewPage(objectName){
        console.log('Navig to account');
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
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
    disconnectedCallback() {
        console.log('>>>test1');
        unsubscribe(this.subscription, () => {
        });   
      } 
}