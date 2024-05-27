import { LightningElement, api,wire } from 'lwc';

import TabRegistration from '@salesforce/label/c.TabRegistration';
import TabLoyaltyPoints from '@salesforce/label/c.TabLoyaltyPoints';
import TabStoreInfo from '@salesforce/label/c.TabStoreInfo';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';


export default class TabActivationBusinessProgram extends LightningElement {
    @api receivedId;
    @api seikoData;
    @api brand;
    @api channel;
    @api loyaltyPoints;
    showAllTab=false;

    custLabel = {
        TabRegistration,
        TabLoyaltyPoints,
        TabStoreInfo
    }

    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
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