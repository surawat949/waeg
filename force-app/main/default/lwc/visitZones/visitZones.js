import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Apex Import
import updateAccountStage from '@salesforce/apex/VisitZonesController.updateAccountStage';
import getAccounts from '@salesforce/apex/VisitZonesController.getAccountsWithTacticom';
import removeTacticomSOF from '@salesforce/apex/VisitZonesController.removeTacticomSOF';

//Custom Labels
import Planned_Visits from '@salesforce/label/c.Planned_Visits';
import Total_Prospects from '@salesforce/label/c.Total_Prospects';
import Confirm_Action from '@salesforce/label/c.Confirm_Action';
import Account_Zone_Change from '@salesforce/label/c.Account_Zone_Change';
import SFDC_V2_Confirm from '@salesforce/label/c.SFDC_V2_Confirm';
import tabLabelClose from '@salesforce/label/c.tabLabelClose';
import ButtonCancel from '@salesforce/label/c.ButtonCancel';

export default class VisitZones extends LightningElement {
    records;
    stageList;
    pickVals;

    @track isModalOpen = false;
    @track dropZone = null;
    @track dropZoneArea = null;
    @api recordId;
    @track showSpinner = false;

    custLabel ={
        tabLabelClose,ButtonCancel,Planned_Visits,Total_Prospects,Confirm_Action,Account_Zone_Change,SFDC_V2_Confirm
    }

    get equalwidthHorizontalAndVertical(){
        let len = this.pickVals.length
        return `width: calc(100%/ ${len})`
    }
    get cardStyle(){
        
    }
    connectedCallback() {
        this.showSpinner = true;
        this.getAccountData();
    }

    @api 
    refreshcardData(){
        this.getAccountData();
    }

    getAccountData(){
        console.log('getAccountData');
        getAccounts()
         .then(result => {
            this.records = result.accountList;
            this.pickVals = result.pickVals;
            this.generateAccountURL();
            this.pickVals = this.pickVals.map(item => {
                return {
                    ...item,
                    fullClass: this.getFullClass(item.zone)
                };
            });
            this.showSpinner = false;
         })
         .catch(error => {
            this.showSpinner = false;
            new ShowToastEvent({
                title: 'Error',
                message: 'Unable to fetch User Accounts',
                variant: 'error'
            })       
         });
    }
    generateAccountURL(){
        this.records = this.records.map(account => {
            return {
                ...account,
                recordUrl: `/lightning/r/Account/${account.Id}/view`
            };
        });
    }
    handleListItemDrag(event){
        this.recordId = event.detail;
    }

    handleItemDrop(event){
        console.log('handleDrop evt visit zone:', JSON.stringify(event.detail));
        this.recordId = event.detail.recordId;
        this.dropZone = event.detail.stage;
        this.dropZoneArea = event.detail.tranlated;
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    confirmDrop() {
        // Update the zones data based on the drag and drop
        this.showSpinner = true;
        this.updateHandler(this.dropZone);
        this.closeModal();
    }

    refreshData(){
        const event = new CustomEvent('refreshdata', {
            detail: 'refresh',
            bubbles: false,
            composed: true        
        });
        this.dispatchEvent(event);
    }
    updateHandler(stage){
        updateAccountStage({ accountId: this.recordId, newZone: stage })
            .then(result => {
                this.showToast('Visit Zone Updated Successfully');
                this.records = result.accountList;
                this.pickVals = result.pickVals;
                this.generateAccountURL();
                this.pickVals = this.pickVals.map(item => {
                    return {
                        ...item,
                        fullClass: this.getFullClass(item.zone)
                    };
                });
                this.refreshData();
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                })
            });
    }
    handleCardDelete(event) {
        this.showSpinner = true;
        this.recordId = event.detail.cardId;
        removeTacticomSOF({ accountId: this.recordId })
            .then(result => {
                this.showToast('VisitZones removed Successfully');
                this.records = result.accountList;
                this.pickVals = result.pickVals;
                this.generateAccountURL();
                this.pickVals = this.pickVals.map(item => {
                    return {
                        ...item,
                        fullClass: this.getFullClass(item.zone)
                    };
                });
                 this.refreshData();
                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
    showToast(displayMessage){
        this.dispatchEvent(
            new ShowToastEvent({
                title:'Success',
                message: displayMessage,
                variant:'success'
            })
        )
    }
    getFullClass(zone) {
        let baseClass = 'slds-tabs--path__item slds-is-incomplete slds-path__item slds-is-current';
        let zoneClass = '';

        switch (zone) {
            case 'Sub-area 1':
                zoneClass = 'zone1';
                break;
            case 'Sub-area 2':
                zoneClass = 'zone2';
                break;
            case 'Sub-area 3':
                zoneClass = 'zone3';
                break;
            case 'Sub-area 4':
                zoneClass = 'zone4';
                break;
            case 'Sub-area 5':
                zoneClass = 'zone5';
                break;
            default:
                zoneClass = 'bgcolor';
        }

        return `${baseClass} ${zoneClass}`;
    }
}