import { LightningElement, api } from 'lwc';
import tabAccClinicAccActivationContact from '@salesforce/label/c.tabAccountClinicActivationContact';
import tabAccClinicAccActivationPotential from '@salesforce/label/c.tabAccountClinicActivationPotential';
import tabAccClinicAccActivationRefOptician from '@salesforce/label/c.tabAccountClinicActivationRefOptician';
import tabAccClinicAccActivationMiyosmart from '@salesforce/label/c.tabAccountClinicActivationMiyosmart';

export default class TabMVAActivation extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tabAccClinicAccActivationContact,
        tabAccClinicAccActivationPotential,
        tabAccClinicAccActivationRefOptician,
        tabAccClinicAccActivationMiyosmart
    }
    connectedCallback() {
        
    }

}