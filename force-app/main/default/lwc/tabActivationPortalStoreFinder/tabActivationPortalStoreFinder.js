import { LightningElement, api,wire } from 'lwc';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import OPTICIAN_FINDER_OPTION from '@salesforce/schema/Account.Optician_finder_optin__c';
import OPTICIAN_FINDER from '@salesforce/schema/Account.Optician_Finder__c';
import CHANNEL from '@salesforce/schema/Account.CHCUSTCLASSIFICATIONID__c';
import CHAINCODE from '@salesforce/schema/Account.CHINTERNATIONALGROUP__c';
import OPTICIAN_FINDER_CHANNEL from '@salesforce/schema/Account.Optician_Finder_Channel_Decision__c';
import getLastTrainingDate from '@salesforce/apex/TabActivationPortalStoreFinderController.getLastTrainingDate';
import getLastTotalMonthSale from '@salesforce/apex/TabActivationPortalStoreFinderController.getLastTotalMonthSale';

//Custom Labels
import Store_Finder from '@salesforce/label/c.Store_Finder';
import Channel from '@salesforce/label/c.Channel';
import Forced_Store_Finder from '@salesforce/label/c.Forced_Store_Finder';
import SAP_Chain_Code from '@salesforce/label/c.SAP_Chain_Code';
import Channel_Master_Setup from '@salesforce/label/c.Channel_Master_Setup';
import Last_3_Months_Total_Sales from '@salesforce/label/c.Last_3_Months_Total_Sales';
import Customer_Preference from '@salesforce/label/c.Customer_Preference';
import Seiko_Dealer_Locator_Last_Training from '@salesforce/label/c.Seiko_Dealer_Locator_Last_Training';
import Eligible_for_Optician_Finder from '@salesforce/label/c.Eligible_for_Optician_Finder';
import HelpText from '@salesforce/label/c.HelpText';
export default class TabActivationPortalStoreFinder extends LightningElement {
    @api receivedId;
    objectapiname = ACCOUNT_OBJ;
    Account_Data;
    LastTraningDate;
    isShowVisiableMsg=false;
    lastSale;
    CustLabel={
       HelpText,Store_Finder,Channel,Forced_Store_Finder,SAP_Chain_Code,Channel_Master_Setup,Last_3_Months_Total_Sales,Customer_Preference,Seiko_Dealer_Locator_Last_Training,Eligible_for_Optician_Finder
    };
    @wire(getRecord,{ recordId: '$receivedId', fields: [OPTICIAN_FINDER_OPTION,OPTICIAN_FINDER,CHANNEL,CHAINCODE,OPTICIAN_FINDER_CHANNEL] })
    record( { error, data }){
        if(data){
            this.Account_Data=data;
            if(data.fields.Optician_finder_optin__c.value == true && data.fields.Optician_Finder__c.value==true){
                this.isShowVisiableMsg=true;
            }
            else{
                this.isShowVisiableMsg=false;    
            }
        }
        else if (error) {
            this.showToast('Error1', 'Error', error);

        }
    }
    @wire(getLastTotalMonthSale,{accountId: '$receivedId'})
        getLastTotalMonthSale( { error, data }){
        if(data){
            this.lastSale=data;
        }
        else if (error) {
            this.showToast('Error2', 'Error', error);
        }
    }
    get ChannelVal(){  
        return getFieldValue(this.Account_Data,CHANNEL);     
    }
    get ChainCodeVal(){  
        return getFieldValue(this.Account_Data,CHAINCODE);     
    }
    get OptiFinderOption(){  
        return getFieldValue(this.Account_Data,OPTICIAN_FINDER_OPTION);     
    }
    get OptiFinder(){      
        return getFieldValue(this.Account_Data,OPTICIAN_FINDER);     
    }
    get OptiFinderChannel(){      
        return getFieldValue(this.Account_Data,OPTICIAN_FINDER_CHANNEL);     
    }
    get TURNOVERAMOUNT(){      
        //return getFieldValue(this.lastSale,TURNOVER_AMOUNT);     
    }
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
                    })
        .catch(error => {
            this.showToast('Error', 'Error', error);
        })
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


}