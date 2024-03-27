import { api, LightningElement } from 'lwc';

//labels
import addressTab from '@salesforce/label/c.Address';
import membershipsTab from '@salesforce/label/c.Memberships';
import invoiceTab from '@salesforce/label/c.SFDC_V_2_Account_Invoicing';
import logisticTab from '@salesforce/label/c.SFDC_V_2_TabAccount_Logistic';
import contractsTab from '@salesforce/label/c.SFDC_V_2_TabAccount_Contracts';
import pricelistTab from '@salesforce/label/c.SFDC_V_2_TabAccount_PriceList';
import systemTab from '@salesforce/label/c.tabAccSystemInfo';

export default class TabAccount extends LightningElement {
    @api recordId;

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

    connectedCallback() {
        console.log('parent connected callback call' + this.recordId);
    }

    renderedCallback(){
    }
}