import { LightningElement, api,wire } from 'lwc';

import TabRegistration from '@salesforce/label/c.TabRegistration';
import TabSocialMediaM from '@salesforce/label/c.TabSocialMediaM';
import TabXtranet from '@salesforce/label/c.TabXtranet';
import ConsumerProgram from '@salesforce/label/c.Consumer_Program';
import TabAcademy from '@salesforce/label/c.TabAcademy';

import Hoya_iLog from '@salesforce/label/c.Hoya_iLog';
import Store_Finder from '@salesforce/label/c.Store_Finder';
import Hoyanet from '@salesforce/label/c.Hoyanet';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';


//Hoya_iLog
//Store_Finder
//Hoyanet


export default class TabActivationPortal extends LightningElement {
    @api receivedId; 
    @api seikoData;
    _brand;
    isHoyaAcc = false;
    showAllTab=false;

    @api
    set brand (value) {
        this._brand = value;
        if (this._brand === 'HOYA') {
            this.isHoyaAcc = true;
        } else {
            this.isHoyaAcc = false;
        }
    }
    get brand() {
        return this._brand;
    }
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        
    }

    custLabel = {
        TabRegistration,
        TabSocialMediaM,
        TabXtranet,
        ConsumerProgram,
        TabAcademy,
        Hoya_iLog,
        Store_Finder,
        Hoyanet
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