import { api, LightningElement, wire } from 'lwc';

import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_BRAND from '@salesforce/schema/Account.Brand__c';
import ACCOUNT_CHANNEL from '@salesforce/schema/Account.RecordType.Name';
import TOTAL_LOYALTY_POINTS from '@salesforce/schema/Account.Total_Loyalty_Points__c'; 

//labels
import businessProgramTab from '@salesforce/label/c.Business_Program';
import portalnameTab from '@salesforce/label/c.Portal_Name';

// apex
import getSeikoData from '@salesforce/apex/TabActivationController.getSeikoData';

export default class TabActivation extends LightningElement {
    @api recordId;
    seikoData;
    brand;
    tabName;
    channel;
    loyaltyPoints; // to be sent to Loyalty Points tab

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_BRAND, ACCOUNT_CHANNEL, TOTAL_LOYALTY_POINTS] })
    record({ error, data }) {
        if (data) {
            this.brand = data.fields.Brand__c.value;
            if(this.brand == 'HOYA'){
                this.tabName = 'HOYA Hub';
            }
            else{
                this.tabName = 'SEIKO Pro';
            }
            this.channel = data.fields.RecordType.value.fields.Name.value;
            this.loyaltyPoints = data.fields.Total_Loyalty_Points__c.value;
        }
    }

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        businessProgramTab,
        portalnameTab
    }
    connectedCallback() {
        getSeikoData({accountId : this.recordId})
        .then(response => {
            this.seikoData = response.Id;
        })
        .catch(error => {
            //console.log(error);
        })
    }

    renderedCallback(){
    }
}