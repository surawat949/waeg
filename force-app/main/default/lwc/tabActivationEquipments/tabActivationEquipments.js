import { LightningElement, api,wire } from 'lwc';

import TabInstalled from '@salesforce/label/c.TabInstalled';
import AccountActivationVisuRealPortable from '@salesforce/label/c.AccountActivationVisuRealPortable';
import AccountActivationVisuRealMaster from '@salesforce/label/c.AccountActivationVisuRealMaster';
import AccountActivationIdentifier from '@salesforce/label/c.AccountActivationIdentifier';
import TabMyStyleV from '@salesforce/label/c.TabMyStyleV';
import TabSVXIpad from '@salesforce/label/c.TabSVXIpad';
import TabSVXeColumn from '@salesforce/label/c.TabSVXeColumn';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';


export default class TabActivationEquipments extends LightningElement {
    @api receivedId;
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
       // console.log('child connected call-' + this.receivedId);
    }

    custLabel = {
        TabInstalled,
        AccountActivationVisuRealPortable,
        AccountActivationVisuRealMaster,
        AccountActivationIdentifier,
        TabMyStyleV,
        TabSVXIpad,
        TabSVXeColumn
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