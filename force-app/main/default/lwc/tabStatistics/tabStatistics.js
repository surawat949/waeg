import { LightningElement, api ,wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import RoleName from '@salesforce/schema/User.Sales_Role__c';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import ProfileId from '@salesforce/schema/User.Profile.Id';
//labels
import potentialTab from '@salesforce/label/c.PotentialTab';
import netSales from '@salesforce/label/c.Net_Sales';
import grossSales from '@salesforce/label/c.Gross_Sales';
import returns from '@salesforce/label/c.Returns';
import shipments from '@salesforce/label/c.Shipments';
import pdf from '@salesforce/label/c.Product_Mix_PDF';
//fields
import accCountry from '@salesforce/schema/Account.Shop_Country__c';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
export default class TabStatistics extends LightningElement {
    @api recordId;
    isGermanyAccount;
    accountCountry;
    userId = Id;
    showAllTab=false;
    userRoleName;
    userProfileName;
    userProfileId;
    showSalesChannelTab= false;
    constructor() {
        super();
        // record Id not generated yet here
    }
    @wire(getRecord, { recordId: Id, fields: [ RoleName, ProfileName, ProfileId] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
           console.log('>>>data',data);
            if (data.fields.Sales_Role__c.value != null) {
                this.userRoleName = data.fields.Sales_Role__c.value;
                console.log('>>>data',this.userRoleName);
            }
            if (data.fields.Profile.value != null) {
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
                this.userProfileId = data.fields.Profile.value.fields.Id.value;
            }
            //Profile Id is hardcoded as it is same as production.
            if((this.userRoleName == 'KAM' && this.userProfileName == 'SALES & MARKETING') || this.userProfileName == 'SFDC LOCAL ADMIN' || this.userProfileId == '00eb0000000lainAAA'){
                this.showSalesChannelTab=true;
            } 
        }
    }
    custLabel = {
        potentialTab,netSales,grossSales,returns,shipments,pdf
    }
    @wire(getRecord, { recordId: "$recordId", fields:[accCountry] })
    record( { error, data }){
        if(data){
            this.accountCountry = data.fields.Shop_Country__c.value;
            if(this.accountCountry == 'DE')
                this.isGermanyAccount = true;
            else
                this.isGermanyAccount = false;
        }
        else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
    connectedCallback() {           
    }

    renderedCallback(){
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
    @wire(getUserDetail)
    allStages({data }) {
        if (data) {
            this.showAllTab = data;
        } 
        else{
            this.showAllTab = false;
        }
    }
}