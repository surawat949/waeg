import { LightningElement , track, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import downloadjs from '@salesforce/resourceUrl/downloadjs';
import processCertificate from '@salesforce/apex/LoyaltyPointsStmtController.generateCertificate';
import statement from '@salesforce/label/c.loyalty_points_statement';
import populateDates from '@salesforce/label/c.populate_dates';
import emailSent from '@salesforce/label/c.email_Sent';
import getPDF from '@salesforce/label/c.get_pdf';
import range_30_days from '@salesforce/label/c.range_30_days';
import SelectAddress from '@salesforce/label/c.SelectAddress';
import no_transactions_errors from '@salesforce/label/c.no_transactions_errors';
import startDateSmaller from '@salesforce/label/c.startDateSmaller';
import addressValicationError from '@salesforce/label/c.AddressValicationError';

import selectSmallerPeriod from '@salesforce/label/c.selectSmallerPeriod';
import recordsExceedLimit from '@salesforce/label/c.recordsExceedLimit';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';
import ACCOUNT_ACCOUNTEMAIL from '@salesforce/schema/Account.Shop_email_address__c';
import ACCOUNT_MARKETINGEMAIL from '@salesforce/schema/Account.email__c';
import ACCOUNT_CONFIDENTIALEMAILADDRESS from '@salesforce/schema/Account.Confidential_Email_Address__c'; 
import ACCOUNT_BRAND from '@salesforce/schema/Account.Brand__c';
//const fields=[ACCOUNT_ACCOUNTEMAIL];
export default class LoyaltyPointsStatement extends LightningElement {
   
    custLabel = {
        statement,
        populateDates,
        getPDF,
        SelectAddress,
        emailSent,
        range_30_days,
        no_transactions_errors,
        startDateSmaller,
        selectSmallerPeriod,
        recordsExceedLimit,
        addressValicationError
    };
    @api recordId;
    @track isModalOpen = false;
    @track disableButton = true;
    @track startDate;
    @track endDate;
    @track showLoading = false;
    @track accountEmailAddress;
    account;
    emailAddress=[];
    isShowAccountAddress=true;
    isShowMarketingAddress=true;
    isShowConfiAddress=true;
    isAccEmailCheckboxDisabled=false;
    isMarketEmailCheckboxDisabled=false;
    isConfiEmailCheckboxDisabled=false;
    otherEmailAddress;
    isAccEmailChecked=false;
    isMarketingEmailChecked=false;
    isConfidentialChecked=false;

    
    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_ACCOUNTEMAIL, ACCOUNT_MARKETINGEMAIL, ACCOUNT_CONFIDENTIALEMAILADDRESS, ACCOUNT_BRAND] })
    record({ error, data }) {
        if (data) {
            this.account = data;
            if(data.fields.Shop_email_address__c.value == null ){
                this.isAccEmailCheckboxDisabled = true;}
            if(data.fields.email__c.value == null ){
                this.isMarketEmailCheckboxDisabled = true;}
            if(data.fields.Confidential_Email_Address__c.value == null ){
                this.isConfiEmailCheckboxDisabled = true;}
        }
            
    }
    get emailAcc() {
        let emailField=getFieldValue(this.account, ACCOUNT_ACCOUNTEMAIL);
        if(emailField ==''){
            this.isShowAccountAddress= false;}
        return getFieldValue(this.account, ACCOUNT_ACCOUNTEMAIL);
    }
    get emailMarketing() {
        let marketingFeild = getFieldValue(this.account, ACCOUNT_MARKETINGEMAIL);
        if(marketingFeild==''){
            this.isShowMarketingAddress = false;}
        return getFieldValue(this.account, ACCOUNT_MARKETINGEMAIL);}
    get emailConfidential() {
        let confidentialEmailAddress = getFieldValue(this.account, ACCOUNT_CONFIDENTIALEMAILADDRESS);;
        if(confidentialEmailAddress==''){
            this.isShowConfiAddress = false;}
        return getFieldValue(this.account, ACCOUNT_CONFIDENTIALEMAILADDRESS);}
    get accountBrand(){
        return getFieldValue(this.account, ACCOUNT_BRAND);
    }
    
    connectedCallback () {
        console.log('Brand is '+this.accountBrand);
    }
    handleAccountEmailAddress(event){
        if(event.target.checked){
            this.emailAddress.push(this.emailAcc);
            this.isAccEmailChecked= true;
            this.disableButton = false;
            this.isAccEmailCheckboxDisabled = false;
        } 
        else{
            var index1 = this.emailAddress.indexOf(this.emailAcc);
            this.emailAddress.splice(index1,1); 
            this.isAccEmailChecked=false;
        }
    }
    handleMarketingEmailAddress(event){
        if(event.target.checked){
           this.emailAddress.push(this.emailMarketing);
           this.disableButton = false;
           this.isMarketingEmailChecked=true;
        } 
        else{
            var index2 = this.emailAddress.indexOf(this.emailMarketing);
           this.emailAddress.splice(index2,1); 
           this.isMarketingEmailChecked=false; 
          
        }
    }
    handleConfidentialEmailAddress(event){
        if(event.target.checked){
        this.emailAddress.push(this.emailConfidential);
        this.disableButton = false;
        //this.isConfidentialChecked=false;
        this.isConfidentialChecked=true;
        } 
        else{
            var index3 = this.emailAddress.indexOf(this.emailConfidential);
            this.emailAddress.splice(index3,1);  
            this.isConfidentialChecked=false;
        }
    }
    handleOtherEmailChange(event){
       this.otherEmailAddress = event.target.value
       if (this.otherEmailAddress != undefined && this.otherEmailAddress != '') {
            this.disableButton = false;
       } else {
        this.disableButton = true;
       }
       
       //this.emailAddress.push(otherEmailAddress);
    }
    renderedCallback() {
        /*loadScript(this, downloadjs)
        .then(() => console.log('Loaded download.js'))
        .catch(error => console.log(error));*/
    }  

    @api displayModal()
    {    
        this.isModalOpen = true;
        this.disableButton = true;
    }

    handleStartChange(event) {
        this.startDate = event.target.value;
        const date = new Date(this.startDate);

        // Get the year and month of the input date
        const year = date.getFullYear();
        const month = date.getMonth();
      
        // Calculate the last day of the month
        const lastDay = new Date(year, month + 1, 0);
        this.endDate = this.formatDateToYYYYMMDD(lastDay);
    }
    formatDateToYYYYMMDD(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    handleEndChange(event) {
        this.endDate = event.target.value;
        this.disableButton = false;
    }

    processPDFGeneration() {
        this.isAccEmailCheckboxDisabled=false;
        this.isMarketEmailCheckboxDisabled=false;
        this.isConfiEmailCheckboxDisabled=false;
        var d1 = new Date(this.startDate);
        var d2 = new Date(this.endDate);
        var Difference_In_Time = d2.getTime() - d1.getTime();
        var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
        if (Difference_In_Days < 0) {
            this.showToast('Error', 'Error', this.custLabel.startDateSmaller);
        } else if (Difference_In_Days >= 31) {
            this.showToast('Warning', 'Error', this.custLabel.selectSmallerPeriod);
        }
        else if (!this.isAccEmailChecked && !this.isMarketingEmailChecked && !this.isConfidentialChecked && (this.otherEmailAddress ==undefined || this.otherEmailAddress =='')){
            this.showToast('Error', 'Error', this.custLabel.addressValicationError);
        }
         else {
            this.showLoading = true;
            if (this.otherEmailAddress) {
                this.emailAddress.push(this.otherEmailAddress);
            }
            processCertificate({accountId:this.recordId, startDate:this.startDate, endDate: this.endDate, emailAddresses: this.emailAddress, brand : this.accountBrand})
            .then(response => {
                //this.showLoading = false;
                //var strFile = "data:application/pdf;base64,"+response;
                //window.download(strFile, "sample.pdf", "application/pdf");
                //this.showLoading = false;
                
                this.showLoading = false;
                if (response === 'Success') {
                    this.showToast('Success', 'Success', this.custLabel.emailSent);
                    this.isModalOpen = false;
                } else if (response === 'NoRecords') {
                    this.showToast('Warning', 'Warning', this.custLabel.no_transactions_errors);
                } else if (response === 'templateError') {
                    this.showToast('Error', 'Error', this.custLabel.noTemplateError);
                } else if (response === 'exceeded') {  
                    this.showToast('Error', 'Error', this.custLabel.recordsExceedLimit);
                }else {
                    this.showToast('Error', 'Error', response);
                }
            }).catch(error => {
                this.showLoading = false;
                console.log(error);
                this.showToast('Error', 'Error', error.body.message);
            })
        }
        
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

    closeModal() {
        this.isModalOpen = false;       
        this.disableButton = true;
        this.isAccEmailCheckboxDisabled=false;
        this.isMarketEmailCheckboxDisabled=false;
        this.isConfiEmailCheckboxDisabled=false;
        this.endDate = "";
    }

}