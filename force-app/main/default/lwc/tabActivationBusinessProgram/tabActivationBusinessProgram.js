import { LightningElement, api } from 'lwc';

import TabRegistration from '@salesforce/label/c.TabRegistration';
import TabLoyaltyPoints from '@salesforce/label/c.TabLoyaltyPoints';
import TabStoreInfo from '@salesforce/label/c.TabStoreInfo';

export default class TabActivationBusinessProgram extends LightningElement {
    @api receivedId;
    @api seikoData;
    @api brand;
    @api channel;
    @api loyaltyPoints;
    
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
}