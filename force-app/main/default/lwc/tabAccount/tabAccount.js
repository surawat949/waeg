import { api, LightningElement,wire } from 'lwc';

//labels
import addressTab from '@salesforce/label/c.Address';
import membershipsTab from '@salesforce/label/c.Memberships';
import invoiceTab from '@salesforce/label/c.SFDC_V_2_Account_Invoicing';
import logisticTab from '@salesforce/label/c.SFDC_V_2_TabAccount_Logistic';
import contractsTab from '@salesforce/label/c.SFDC_V_2_TabAccount_Contracts';
import pricelistTab from '@salesforce/label/c.SFDC_V_2_TabAccount_PriceList';
import systemTab from '@salesforce/label/c.tabAccSystemInfo';
import { getRecord } from "lightning/uiRecordApi";
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';


export default class TabAccount extends LightningElement {
    @api recordId;
    profileName;
    notShowChatterUser=true;
    showAllTab=false;
    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        addressTab,
        membershipsTab,
        invoiceTab,
        logisticTab,
        contractsTab,
        pricelistTab,
        systemTab
        
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
    connectedCallback() {

        
    }

    renderedCallback(){
    }
}