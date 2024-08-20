import { LightningElement, api ,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

//labels
import ReferringOpticians from '@salesforce/label/c.tabContactActivationRefOpts';
import Brand from '@salesforce/label/c.AccountBrand';
import Account from '@salesforce/label/c.AccountName';
import ShopStreet from '@salesforce/label/c.ShopStreet';
import PostalCode from '@salesforce/label/c.PostalCode';
import ShopCity from '@salesforce/label/c.ShopCity';
import ShopPhone from '@salesforce/label/c.ShopPhone';
import Add from '@salesforce/label/c.AddRelation';
import pdfList from '@salesforce/label/c.SFDC_V_2_tabMVCContact_ReferringOptician_PDFList';
import deleteRelationShip from '@salesforce/apex/TabMVCActivationController.deleteRelationShip';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';


//Apex
import getRefOptsList from '@salesforce/apex/TabMVCActivationController.getRefferingOptsLst';

import lWCModal from 'c/tabMVCActivationPdfList';

export default class TabMVCActivationReferringOpticians extends LightningElement {

    @api receivedId;
    Columns;
    wiredResults;
    data;
    showAllTab=false;
    showSpinner=false;
    isDataExists = false;
    isLoading = true;
    custLabel = {
        ReferringOpticians,
        Add,
        pdfList
    }
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }    
    async showPopUp() {
        this.template.querySelector('c-tab-contact-create-reffering-optician-modal').displayModal();
    }

    Columns = [
        {label: Brand, fieldName: 'Brand', type: 'text'},
        {label: Account, fieldName: 'AccountId', type: 'url', typeAttributes: {label:{fieldName: 'AccountName'}, target:'_top'}},
        {label: ShopStreet, fieldName: 'ShopStreet', type: 'text'},
        {label: PostalCode, fieldName: 'PostalCode', type: 'text'},
        {label: ShopCity, fieldName: 'City', type: 'text'},
        {label: ShopPhone, fieldName: 'ShopPhone', type: 'text'},
        {label: 'Delete',type: 'button',initialWidth: 135,
            typeAttributes: {
                label: 'Delete',
                name: 'Delete',
                title: 'Delete record'
            }
        }
    ];
    ColumnsChatter = [
        {label: Brand, fieldName: 'Brand', type: 'text'},
        {label: Account, fieldName: 'AccountId', type: 'url', typeAttributes: {label:{fieldName: 'AccountName'}, target:'_top'}},
        {label: ShopStreet, fieldName: 'ShopStreet', type: 'text'},
        {label: PostalCode, fieldName: 'PostalCode', type: 'text'},
        {label: ShopCity, fieldName: 'City', type: 'text'},
        {label: ShopPhone, fieldName: 'ShopPhone', type: 'text'},
    ];
    
    getTableData() {
        this.isDataExists = false;
        getRefOptsList({contactId: this.receivedId,isMiyoSmart : false}).then((result) => {
        this.data = result;
            
        if(result){
            this.isLoading = true;
            this.data = JSON.parse(JSON.stringify(result));
            if(this.data.length > 0 )
            this.isDataExists = true;
            this.data.forEach(res=>{
                res.Brand = res.brand;
                res.AccountId = '/' + res.accountId;
                res.AccountName = res.accountName;
                res.ShopStreet = res.shopStreet;
                res.PostalCode = res.postalCode;
                res.City = res.shopCity;
                res.ShopPhone = res.shopPhone;
                res.recordId = res.recordId;
            })
            this.error = undefined;
            this.isLoading = false;
                }
        }).catch((error) => {
                this.error = error;
                this.data = undefined;
        });
    }
    connectedCallback() {
     this.getTableData();
        //console.log('child connected call-' + this.receivedId);
    }
    async showSuccessToast() {
        
        this.showToast('Success Message', 'New Referring Optician added', 'success', 'dismissible');

    }
    async performRefresh() {
        this.isLoading = true;
        this.getTableData();
        await refreshApex(this.data);
        this.template.querySelector('c-tab-m-v-c-visits-optician-nearby').handleRefreshEvent();
        this.isLoading = false; 
    }

    async openModal() {
        const result = await lWCModal.open({
            size: 'medium', //small, medium, or large default :medium
            receivedId : this.receivedId
        });
        //console.log(result);
    }
    handleRowAction(event) {
        const row = event.detail.row;
        this.isLoading = true;
        this.isDataExists=false;
        deleteRelationShip({recordId: row.recordId}).then(result => {
            this.isLoading = false;
            this.isDataExists=true;
            this.getTableData();
            this.showToast('Success', 'Record deleted successfully ', 'success', 'dismissible');
            this.template.querySelector('c-tab-m-v-c-visits-optician-nearby').handleRefreshEvent();

        }).catch(error => {
            this.error = error;
            this.showToast('Error', this.error, 'error', 'dismissible');
        });


    }
    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({title: title, message: message, variant: variant, mode: mode});


        this.dispatchEvent(evt);

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