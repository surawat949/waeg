import { LightningElement, api, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//custom label import start here
import lblShipping from '@salesforce/label/c.SFDC_V_2_Account_Logistic_Shipping';
import lblLocalShipping from '@salesforce/label/c.SFDC_V_2_Account_Logistic_LocalShipping';
import lblShippingAddress from '@salesforce/label/c.SFDC_V_2_Account_Logistic_ShippingAddress';
import label_updatedSuccessfull from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_UpdateSucessfull';
//end

//start getting apex class controller from here
import getShippingAddress from '@salesforce/apex/TabAccountLogisticController.getShippingAddress';
//end

import shippingComment from '@salesforce/schema/Account.Shipping_Special_Comment__c';
import defaultWarehouse from '@salesforce/schema/Account.Default_Warehouse__c';
import ACC_SHIPPING_ACC from '@salesforce/schema/Account.Shipping_Account__c';
import ACC_SHIPPING_ACC_NAME from '@salesforce/schema/Account.Shipping_Account_Name__c';
import ACC_SHIPPING_PHONE from '@salesforce/schema/Account.Shipping_Phone_Number__c';
import ACC_SHIPPING_EMAIL from '@salesforce/schema/Account.Shipping_Email_Address__c';
import ACC_LOCAL_COURIER from '@salesforce/schema/Account.Local_Carrier__c';
import ACC_BOX from '@salesforce/schema/Account.Internal_Shipping_Box_Number__c';
import AccountObj from '@salesforce/schema/Account';
import RECORDTYPE from '@salesforce/schema/Account.RecordType.Name';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const FIELDS = [RECORDTYPE];

export default class TabAccountLogistic extends LightningElement {

    @api receivedId;
    record;
    lblUpdateSuccess = label_updatedSuccessfull;
    @track error1;
    @track isLoading = false;
    @track mapMarkers = [];
    @track markerTitle = 'Account';
    @track zoomLevel = 13;
    isHealthInsuranceRC = true;
    AccObj = AccountObj;
    specificCommentField = [shippingComment];
    ACC_SHIPPINGS = [ACC_SHIPPING_ACC, ACC_SHIPPING_ACC_NAME, ACC_SHIPPING_PHONE, ACC_SHIPPING_EMAIL];
    ACC_COURIER = [ACC_LOCAL_COURIER, ACC_BOX,defaultWarehouse];

    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }
    @wire(getRecord, {
        recordId: '$receivedId',
        fields: FIELDS
    })
    wiredAccountRecord({data}) {
        if (data) {  
            let recordTypeName = data.fields['RecordType']['value']['fields']['Name'].value;  
            if(recordTypeName == 'Health Insurance'){
                this.isHealthInsuranceRC = false; 
            }
            else{
                this.isHealthInsuranceRC = true; 
            }      
        }   
    }
    @wire(getShippingAddress, {recordId : '$receivedId'})
    fetchShippingAdress({data, error}){
        if(data){
            this.record = data[0];
            data.forEach(dataItem=>{
                this.mapMarkers = [...this.mapMarkers,
                    {
                        location : {
                            Latitude : dataItem.accountShippingLatitude,
                            Longitude : dataItem.accountShippingLongitude,
                            Street : dataItem.accountStreet,
                            City : dataItem.accountCity,
                            State : dataItem.accountState,
                            Country : dataItem.accountCountry,
                            PostalCode : dataItem.accountPostalCode
                        },
                        icon : 'standard:account',
                        title : dataItem.accountShippingName,
                    }
                
                ];
            });
            this.error1 = undefined;
        }else if(error){
            this.data = undefined;
            this.error1 = error;
            this.showToast('Error', 'error', this.error1);
        }
    }
    get Street(){
        return this.record?.accountStreet;
    }

    get City(){
        return this.record?.accountCity;
    }

    get State(){
        return this.record?.accountState;
    }

    get PostalCode(){
        return this.record?.accountPostalCode;
    }

    get Country(){
        return this.record?.accountCountry;
    }

    get urlGoogle(){
        return 'https://www.google.com/maps/?q='+this.Street+' '+this.City+' '+this.State+' '+this.Country+' '+this.PostalCode;
    }

    handleEdit(){
        this.showEditfield = !this.showEditfield;
    }

    handleSuccess(event){
        this.showToast('Success', 'success', this.lblUpdateSuccess);
        this.showEditfield = false;
    }

    custLbl = {lblShipping, lblLocalShipping, lblShippingAddress};

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}