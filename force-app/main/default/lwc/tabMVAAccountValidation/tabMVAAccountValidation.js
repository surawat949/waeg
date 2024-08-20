import { LightningElement, api, track, wire } from 'lwc';
import getValidationList from '@salesforce/apex/TabMVAAccountClinicValidation.getValidationNameByAccountId';
import getValidationAll from '@salesforce/apex/TabMVAAccountClinicValidation.getValidationNameByAccountIdAll';
//import getDeleteRecord from '@salesforce/apex/tabMVAAccountClinicValidation.DeleteValidation';
import { deleteRecord } from 'lightning/uiRecordApi';
//import { refreshApex } from '@salesforce/apex';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

//import { subscribe, unsubscribe, onError } from 'lightning/empApi';
//import showModalRecordDelete from 'c/tabMVADeleteValidationRecord';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete'},
];

const columns = [
    {label : 'Validation Request Name', fieldName : 'ValidationId', type : 'url', typeAttributes : {label : {fieldName : 'ValidationName'}, target : '_blank'}, sortable : 'true'},
    {label : 'Name', fieldName : 'WorkPlaceName', type : 'text', sortable : 'true'},
    {label : 'Request Type', fieldName : 'RequestType', type : 'text', sortable : 'true'},
    {label : 'Status', fieldName : 'Status', type : 'text', sortable : 'true'},
    {label : '', type : 'action', initialWidth:'50px', typeAttributes: { rowActions: actions },},
];

export default class TabMVAAccountValidation extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    ValidationCount;
    ValidCount;

    @track isModalOpen = false;
    @track isLoading = false;
    @track data;
    @track error;
    @track column = columns;
    @track sortBy;
    @track sortDirection;
    @track rowId;
    @track rowName;
    
    constructor(){
        super();
    }

    connectedCallback(){
        console.log('XXX Get Record Id : '+this.recordId);
    }

    renderedCallback(){

    }

    @wire(getValidationAll, {recordId : '$recordId'})
        validCount({data, error}){
            if(data){
                data = JSON.parse(JSON.stringify(data));
                let allValidCount = data;
                this.ValidationCount = (allValidCount.length<=5) ? [...allValidCount] : [...allValidCount].splice(0, 6);
                if(allValidCount.length > 5){
                    this.ValidCount = '5+';
                }else{
                    this.ValidCount = allValidCount.length;
                }
            }else if(error){
                console.log('XXX An error was occurred due =>'+JSON.stringify(error));
            }
        }

    @wire(getValidationList, {recordId : '$recordId'})
    validation(result){
        if(result.data){
            this.data = JSON.parse(JSON.stringify(result.data));
            this.data.forEach(res=>{
                res.ValidationId = '/'+res.Id;
                res.ValidationName = res.Name;
                res.WorkPlaceName = res.QIDC__Workplace_ims__r.Name;
                res.WorkPlaceId = res.QIDC__Workplace_ims__c;
                res.RequestType = res.QIDC__Request_Type_ims__c;
                res.Status = res.QIDC__Status_ims__c;
            });
            console.log('XXX Get Validation List =>'+JSON.stringify(this.data));
            this.error = undefined;
        }else if(result.error){
            this.error = result.error;
            this.data = undefined;
            console.log('XXX An error was occurred : '+JSON.stringify(this.error));
        }
    }

    doSorting(event){
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldName, direction){
        let parseData = JSON.parse(JSON.stringify(this.data));

        let keyValue = (a) => {
            return a[fieldName];
        };

        let isReverse = direction === 'asc' ? 1: -1;

        parseData.sort((x,y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch(actionName){
            case 'edit' :
                this[NavigationMixin.Navigate]({
                    type : 'standard__recordPage',
                    attributes : {
                        recordId : row.Id,
                        objectApiName : 'QIDC__Validation_Request_ims__c',
                        actionName : 'edit'
                    }
                });
                break;
            case 'delete' :
               this.openModal(row);
               break;
        }
    }
    /*
    async showDeleteRec(){
        const receivedId = await showModalRecordDelete.open({
            size: 'small',
            receivedId : this.recordId
        });
        if(receivedId){
            await this.showSuccessToast(this.receivedId);
        }
    }
    */
    showToast(message, variant, title) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    openModal(currentRow) {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.rowId = currentRow.Id;
        this.rowName = currentRow.Name;
    }

    deleteRecord(event){
        //alert(this.rowId);
        deleteRecord(this.rowId)
        .then(()=>{
            const toastEvent = new ShowToastEvent({
                title : 'Record Deleted',
                message : 'Record Deleted Successfully',
                variant : 'success',
            })
            this.dispatchEvent(toastEvent);
            this.closePopUpAndRefresh();
        })
        .catch(error =>{
            console.log('XXX Unable to removed this record due to => '+JSON.stringify(error));
        });
    }

    closePopUpAndRefresh(){
        window.location.reload();
        this.close();
    }

    navigateToNewRecord(){
        this[NavigationMixin.Navigate]({
            type : 'standard__objectPage',
            attributes : {
               objectApiName : 'QIDC__Validation_Request_ims__c',
               actionName : 'new'
            }
        });
    }

    nevigateToRelatedList(){
        this [NavigationMixin.GenerateUrl]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.recordId,
                objectApiName : 'Account',
                relationshipApiName : 'QIDC__Validation_Requests1_ims__r',
                actionName : 'view'
            }
        }).then(url=>{
            window.open(url, '_top');
        });
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    /*
    deleteRec(event) {
        deleteRecord(this.recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                // Navigate to a record home page after
                // the record is deleted, such as to the
                // contact home page
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordRelationshipPage',
                    attributes: {
                        recordId : this.recordId,
                        objectApiName: 'Account',
                        relationshipApiName : 'Contacts',
                        actionName: 'view'
                    },
                });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
    */
}