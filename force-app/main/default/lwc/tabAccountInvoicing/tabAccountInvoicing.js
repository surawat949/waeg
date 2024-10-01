import { LightningElement, api, wire, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//label starting here
import lblInvoicing from '@salesforce/label/c.SFDC_V_2_Account_Invoicing';
import lblPayment from '@salesforce/label/c.SFDC_V_2_Account_Payments';
import lblBillingAddress from '@salesforce/label/c.SFDC_V_2_Account_Invoice_Billing';
//end

//field import start here
import VAT_EU_NUM from '@salesforce/schema/Account.VAT_EUROPEAN_NUMBER__c';
import ACC_CURRENNCY from '@salesforce/schema/Account.CurrencyIsoCode';
import ACC_BILL_ACC from '@salesforce/schema/Account.Billing_Account__c';
import ACC_BILL_ACC_NAME from '@salesforce/schema/Account.Billing_Account_Name__c';
import ACC_BILL_ACC_PHONE from '@salesforce/schema/Account.Billing_phone_number__c';
import ACC_BILL_ACC_EMAIL from '@salesforce/schema/Account.Billing_Email_address__c';
import ACC_PAYMENT_METHOD from '@salesforce/schema/Account.Payment_Method__c';
import ACC_PAYMENT_ISSUE from '@salesforce/schema/Account.Payment_issue__c';
import ACC_SAP_CODE from '@salesforce/schema/Account.SAP_Company_Code__c';
import ACC_ACCOUNT_STATUS from '@salesforce/schema/Account.Account_Status__c';
import ACC_PAYMENT_OUTSTANDING from '@salesforce/schema/Account.Outstanding_Amount__c';
import ACC_PAYMENT_LAST_OUTSTANDING from '@salesforce/schema/Account.Last_Outstanding_update__c';
import CREDIT_RISK from '@salesforce/schema/Account.Credit_Risk__c';
import RECORDTYPE from '@salesforce/schema/Account.RecordType.Name';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

//get apex class starting here
import getAccountFetchMap from '@salesforce/apex/TabAccountInvoiceController.getAccountForMap';
//end
const FIELDS = [RECORDTYPE];
export default class TabAccountInvoicing extends LightningElement {

    @api receivedId;
    record;
    @track isLoading = false;
    @track error1;
    @track mapMarkers = [];
    @track marketTitle = 'Account';
    @track zoomLevel = 13;
    isHealthInsuranceRC= true;

    ACC_BILL_FIELDS = [VAT_EU_NUM, ACC_CURRENNCY, ACC_BILL_ACC, ACC_BILL_ACC_NAME, ACC_BILL_ACC_PHONE, ACC_BILL_ACC_EMAIL];
    ACC_PAYMENT_FIELD = [ACC_PAYMENT_METHOD,ACC_SAP_CODE];
    ACC_PAYMENT_FIELDS = [ACC_PAYMENT_ISSUE, ACC_ACCOUNT_STATUS, ACC_PAYMENT_OUTSTANDING, ACC_PAYMENT_LAST_OUTSTANDING];
	Credit_Risk = [CREDIT_RISK];
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

    @wire(getAccountFetchMap, {recordId : '$receivedId'})
    wireAccount({data, error}){
        if(data){
            this.record = data[0];
            data.forEach(dataItem=>{
                this.mapMarkers = [...this.mapMarkers,
                    {
                        location : {
                            Latitude : dataItem.accountLatitude,
                            Longitude : dataItem.accountLongitude,
                            Street : dataItem.accountStreet,
                            City : dataItem.accountCity,
                            State : dataItem.accountState,
                            Country : dataItem.accountCountry,
                            PostalCode : dataItem.accountPostalCode
                        },
                        icon : 'standard:account',
                        title : dataItem.accountName,
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

    get urlGoogleLable(){
        return this.Street+'\n\n'+this.City+'\n\n'+this.State+'\n\n'+this.PostalCode+'\n\n'+this.Country;
    }

    custLbl = {lblInvoicing, lblPayment, lblBillingAddress};

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