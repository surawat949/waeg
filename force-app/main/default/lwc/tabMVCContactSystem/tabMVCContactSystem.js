import { LightningElement, api, track } from 'lwc';

import Contact_CreatedBy from '@salesforce/schema/Contact.CreatedById';
import Contact_CreatedDate from '@salesforce/schema/Contact.CreatedDate';
import Contact_ModifiedBy from '@salesforce/schema/Contact.LastModifiedById';
import Contact_ModifiedDate from '@salesforce/schema/Contact.LastModifiedDate';
import Contact_RecType from '@salesforce/schema/Contact.RecordTypeId';
import Contact_obj from '@salesforce/schema/Contact';

import lblSystemInfo from '@salesforce/label/c.SFDC_V_2_MVC_ContactDetails_SystemInfo';

export default class TabMVCContactSystem extends LightningElement {
    @api receivedId;

    @track isLoading = false;

    ContactCreatedBy = Contact_CreatedBy;
    ContactCreatedDate = Contact_CreatedDate;
    ContactModifiedBy = Contact_ModifiedBy;
    ContactModifiedDate = Contact_ModifiedDate;
    ContactRecType = Contact_RecType;
    objApiName = Contact_obj;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }

    label = {lblSystemInfo};

}