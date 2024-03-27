import { LightningElement, api } from 'lwc';

//labels
import tacticomTab from '@salesforce/label/c.AccountVisitTabTacticom';
import Camp_Opp from '@salesforce/label/c.Camp_Opp';
import Reports from '@salesforce/label/c.tabAccountClinicVisitReport';
import Trainings from '@salesforce/label/c.Trainings';
import ECP_Nearby from '@salesforce/label/c.ECP_Nearby_Label';


export default class TabVisits extends LightningElement {
    @api recordId;

    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tacticomTab,
        Camp_Opp,
        Reports,
        Trainings,
        ECP_Nearby
    }
    connectedCallback() {
       
    }

    renderedCallback(){
    }
}