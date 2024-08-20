import { LightningElement,api } from 'lwc';
import tabDetails from '@salesforce/label/c.tabDetails';
import tabSystem from '@salesforce/label/c.tabAccClinicSystem';
export default class TabContact extends LightningElement {
    @api recordId;
    custLabel = {
        tabDetails,
        tabSystem
    }
}