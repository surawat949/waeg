import { LightningElement, api,track } from 'lwc';
import getInstrucInShop from '@salesforce/apex/TabActivationEquipmentsInstallCntrl.getInstruInShop';
import getSoftwareInShop from '@salesforce/apex/TabActivationEquipmentsInstallCntrl.getSoftwareInShop';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//Custom Labels
import Instruments_In_Shop from '@salesforce/label/c.Instruments_In_Shop';
import Software_In_Shop from '@salesforce/label/c.Software_In_Shop';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { subscribe, unsubscribe, onError } from 'lightning/empApi'; 

export default class TabActivationEquipmentsInstalled extends NavigationMixin(LightningElement) {
    @api receivedId;
    @track InstraucInShop;
    @track SoftwareInShop;
    CustLabel={
        Instruments_In_Shop,Software_In_Shop
    };
    CHANNEL_NAME = '/event/Refresh_Equipment__e';

    connectedCallback() {
        this.getInstrucInShop();
        this.getSoftwareInShop();
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
                this.showToast('Error', 'error', JSON.stringify(errorData.error));
            }
        });
    }
    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.getInstrucInShop();
            this.getSoftwareInShop();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
    @track columns = [
        {
            label: 'Equipment Serial Number',
            fieldName:'loyalLink', 
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'Name'
                },
                target: '_top'
        }},
        
        {label: 'Brand',fieldName:'Brand2__c', type:'text'},
        {label: 'Model',fieldName:'Model2__c', type:'text'},
        {label: 'Sub Type', fieldName:'Subtype__c', type:'text'},
        {label: 'Shipment Date', fieldName:'Shipment_date__c', type:'date'},
        {label: 'Installation Date', fieldName:'Installation_Date__c', type:'date'}
    ];
    columns2 = [
        {
            label: 'Equipment Serial Number',
            fieldName:'loyalLink', 
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'Name'
                },
                target: '_top'
            }},
        {label: 'Brand',fieldName:'Brand2__c', type:'text'},
        {label: 'Model',fieldName:'Model2__c', type:'text'},
        {label: 'Sub Type', fieldName:'Subtype__c', type:'text'},
        {label: 'Shipment Date', fieldName:'Shipment_date__c', type:'date'},
        {label: 'Installation Date', fieldName:'Installation_Date__c', type:'date'}
    ];
         
    getInstrucInShop(){
        getInstrucInShop({recordId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            response.forEach(res=>{
                res.loyalLink = '/' + res.Id;
            });
            this.InstraucInShop =response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.body.message);
        })
    }
    getSoftwareInShop(){
        getSoftwareInShop({recordId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            response.forEach(res=>{
                res.loyalLink = '/' + res.Id;
            });
            this.SoftwareInShop = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.body.message);
        })
    }
    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
    navigateToNewPage() {
        const defaultValues = encodeDefaultFieldValues({
            Account__c : this.receivedId
        });
        console.log('>>>>',this.receivedId);
        console.log('>>>de',defaultValues);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Equipment__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                useRecordTypeCheck: 1,
                navigationLocation: 'RELATED_LIST'
            }
        });
    }
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });   
    }
}