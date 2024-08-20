import { LightningElement, api } from 'lwc';


import tabPotential from '@salesforce/label/c.tabAccountClinicActivationPotential';
import tabGdprAgreements from '@salesforce/label/c.tabGDPRAgreements';
import tabReferringOpticians from '@salesforce/label/c.tabAccountClinicActivationRefOptician';
import tabMiyosmart from '@salesforce/label/c.tabAccountClinicActivationMiyosmart';

export default class TabMVCActivation extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tabPotential,
        tabGdprAgreements,
        tabReferringOpticians,
        tabMiyosmart
    }

    connectedCallback() {

    }
}