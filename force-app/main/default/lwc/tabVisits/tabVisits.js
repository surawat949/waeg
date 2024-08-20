import { LightningElement, api,wire } from 'lwc';

//labels
import tacticomTab from '@salesforce/label/c.Tacticom';
import Campaigns from '@salesforce/label/c.tab_Campaigns';
import Reports from '@salesforce/label/c.tabAccountClinicVisitReport';
import Trainings from '@salesforce/label/c.Trainings';
import ECP_Nearby from '@salesforce/label/c.ECP_Nearby_Label';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
import BusinessOpportunities from '@salesforce/label/c.Business_Opportunities';

export default class TabVisits extends LightningElement {
    @api recordId;
    showAllTab=false;
    constructor() {
        super();
        // record Id not generated yet here
    }

    custLabel = {
        tacticomTab,
        Campaigns,
        Reports,
        Trainings,
        ECP_Nearby,BusinessOpportunities
    }
    connectedCallback() {
       
    }

    renderedCallback(){
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
}