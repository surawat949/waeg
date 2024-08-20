import { LightningElement, api } from 'lwc';

import tabWorkingPlaces from '@salesforce/label/c.Working_Places';
import tabDetails from '@salesforce/label/c.tabDetails';
import tabSystem from '@salesforce/label/c.tabAccClinicSystem';


export default class TabMVCContact extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tabWorkingPlaces,
        tabDetails,
        tabSystem
    }

    connectedCallback() {
    }
}