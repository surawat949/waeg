import { LightningElement, api} from 'lwc';
import tabAccClinicAddress from '@salesforce/label/c.tabAccClinicAddress';
import tabAccClinicSystem from '@salesforce/label/c.tabAccClinicSystem';

export default class TabMVAAccount extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tabAccClinicAddress,
        tabAccClinicSystem
    }

    connectedCallback() {
        
    }

}