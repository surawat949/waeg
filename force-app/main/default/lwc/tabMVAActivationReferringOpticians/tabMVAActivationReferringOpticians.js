import { LightningElement, api, track, wire } from 'lwc';
import getAccConRelatedByAccId from '@salesforce/apex/TabMVAActivationController.getAccConRelatedListByAccId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Referring_Opticians from '@salesforce/label/c.Referring_Opticians';
import Eye_Doctor from '@salesforce/label/c.Eye_Doctor';
import Brand from '@salesforce/label/c.Brand';
import Opticians from '@salesforce/label/c.Opticians';
import Street from '@salesforce/label/c.Street';
import Postal_Code from '@salesforce/label/c.Postal_Code';
import City from '@salesforce/label/c.city';
import HVC_Loyalty_Program from '@salesforce/label/c.HVC_Loyalty_Program';

const columns = [
    {label: Eye_Doctor, fieldName: 'ContactId', type: 'url', typeAttributes: {label:{fieldName: 'ContactName'}, target:'_top'}, sortable: "true"},
    {label: Brand, fieldName: 'Brand', type: 'text', sortable: "true"},
    {label: Opticians, fieldName: 'Opticians', type: 'url', typeAttributes: {label:{fieldName: 'AccountName'}, target:'_top'}, sortable: "true"},
    {label: Street, fieldName: 'Street', type: 'text', sortable: "true"},
    {label: Postal_Code, fieldName: 'PostalCode', type: 'text', sortable: "true"},
    {label: City, fieldName: 'City', type: 'text', sortable: "true"},
    {label: HVC_Loyalty_Program, fieldName: 'SeikoNetwork', type: 'text', sortable: "true"},

];
export default class TabMVAActivationReferringOpticians extends LightningElement {
    @api receivedId;
    isLoading = false;
    @track data;
    isDataExists = false;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;

    lables={
        Referring_Opticians, Eye_Doctor, Street, Opticians, Brand, Postal_Code,
        City, HVC_Loyalty_Program
    }

    @wire(getAccConRelatedByAccId, {receivedId: '$receivedId'})
    contacts(result){
        if(result.data){
            this.isLoading = false;
            this.data = JSON.parse(JSON.stringify(result.data));
            if(this.data.length > 0)
              this.isDataExists = true;
            this.data.forEach(res=>{
                res.ContactName = res.Contact.Name,
                res.ContactId = '/' + res.Contact.Id,
                res.Brand = res.Account.Brand__c,
                res.AccountName = res.Account.Name,
                res.Opticians = '/' + res.AccountId,
                res.Street = res.Account.Shop_Street__c,
                res.City = res.Account.Shop_City__c,
                res.PostalCode = res.Account.Shop_Postal_Code__c,
                res.SeikoNetwork = res.Account.Seiko_Network__c

            });
            console.log('ddata'+this.data);
            this.error = undefined;
        }else if(result.error){
            this.error = result.error;
            this.data = undefined;
            this.isLoading = false;
            alert('>>>re1');
            this.showToast('Error',this.error ,'error');
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }

    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}