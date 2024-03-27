import { LightningElement, api } from 'lwc';
import tabAccClinicVisitNearby from '@salesforce/label/c.tabAccountClinicVisitNearby';
import tabAccClinicVisitReport from '@salesforce/label/c.tabAccountClinicVisitReport';
import tabAccClinicVisitTraining from '@salesforce/label/c.tabAccountClinicVisitTraining';

export default class TabMVAVisits extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tabAccClinicVisitNearby,
        tabAccClinicVisitReport,
        tabAccClinicVisitTraining
    }

    connectedCallback() {
    }

}