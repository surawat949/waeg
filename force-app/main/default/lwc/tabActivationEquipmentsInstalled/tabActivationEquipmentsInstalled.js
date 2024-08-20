import { LightningElement, api,track } from 'lwc';
import getInstrucInShop from '@salesforce/apex/TabActivationEquipmentsInstallCntrl.getInstruInShop';
import getSoftwareInShop from '@salesforce/apex/TabActivationEquipmentsInstallCntrl.getSoftwareInShop';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//Custom Labels
import Instruments_In_Shop from '@salesforce/label/c.Instruments_In_Shop';
import Software_In_Shop from '@salesforce/label/c.Software_In_Shop';


export default class TabActivationEquipmentsInstalled extends LightningElement {
    @api receivedId;
    @track InstraucInShop;
    @track SoftwareInShop;
    CustLabel={
        Instruments_In_Shop,Software_In_Shop
    };
    connectedCallback() {
        this.getInstrucInShop();
        this.getSoftwareInShop();
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
}