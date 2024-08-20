import { LightningElement, api, track, wire } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//this section for custom label
import AllContacts from '@salesforce/label/c.SFDC_V_2_tabMVAContactAssociatedContact';
import NoData from '@salesforce/label/c.SFDC_V_2_tabMVAContactAssociatedContactNoData';
import CloseButton from '@salesforce/label/c.CloseButton';
import DeleteButton from '@salesforce/label/c.SFDC_V_2_MVAActivaion_DeleteVal';
import DeleteConfirm from '@salesforce/label/c.SFDC_V_2_MVAActivation_DelVal_Confirm';
import ButtonDel from '@salesforce/label/c.ButtonDelete';
import ButtonCancel from '@salesforce/label/c.ButtonCancel';
import lblButtonEdit from '@salesforce/label/c.ButtonEdit';
import ValidationLabel from '@salesforce/label/c.SFDC_V_2_MVAValidation';
import ViewAll from '@salesforce/label/c.ViewAllRelatedList';
import NewBtn from '@salesforce/label/c.NewButtonRelatedList';
import lblContact from '@salesforce/label/c.SFDC_V2_MVA_Activation_Contact';
import lblAccount from '@salesforce/label/c.SFDC_V2_MVA_Activation_Account';
import lblPrefered from '@salesforce/label/c.SFDC_V2_MVA_Activation_Prefer';
import lblStreet from '@salesforce/label/c.SFDC_V2_MVA_Activation_Street';
import lblCity from '@salesforce/label/c.SFDC_V2_MVA_Activation_City';
import lblState from '@salesforce/label/c.SFDC_V2_MVA_Activation_State';
import lblPhone from '@salesforce/label/c.SFDC_V2_MVA_Activation_Phone';
import lblContactRole from '@salesforce/label/c.SFDC_V2_MVA_Activation_ContactRole';
import lblValidationReqName from '@salesforce/label/c.SFDC_V2_MVA_Activation_ValidationReq';
import lblName from '@salesforce/label/c.SFDC_V2_MVA_Activation_Name';
import lblReqDate from '@salesforce/label/c.SFDC_V_2_MVAActivation_Date';
import lblReqType from '@salesforce/label/c.SFDC_V_2_MVAActivation_Type';
import lblReqStatus from '@salesforce/label/c.SFDC_V_2_MVAActivation_Status';
import lblCreatedBy from '@salesforce/label/c.SFDC_V_2_MVAActivation_Created';
//end

//import ContactRelated from '@salesforce/apex/tabAccountAddressLWCController.getContactsRelatedAccount';
//import ContactRelated from '@salesforce/apex/TabMVAActivationContactController.getContactsRelatedAccount';
//import ContactRelatedList from '@salesforce/apex/tabMVAAccountController.getContactRelatedList';
//import AllAssociatedContact from '@salesforce/apex/tabMVAAccountController.getAllContactsHierarchy';
import AllAssociatedContact from '@salesforce/apex/TabMVAActivationContactController.getAllContactsHierarchy';
import getValidationList from '@salesforce/apex/TabMVAAccountClinicValidation.getValidationNameByAccountId';
import getValidationAll from '@salesforce/apex/TabMVAAccountClinicValidation.getValidationNameByAccountIdAll';
import ContactOpthalRecId from '@salesforce/apex/TabMVAAccountClinicValidation.getContactOpthalmologistRecTypeId';
import { deleteRecord } from 'lightning/uiRecordApi';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { subscribe, onError,unsubscribe } from 'lightning/empApi';

const actions = [
    { label: lblButtonEdit, name: 'edit' },
    { label: ButtonDel, name: 'delete'},
];


const columns2 = [
    {label : lblValidationReqName, fieldName : 'ValidationId', type : 'url', typeAttributes : {label : {fieldName : 'ValidationName'}, target : '_blank'}, sortable : 'true'},
    {label : lblName, fieldName : 'WorkPlaceName', type : 'text', sortable : 'true'},
    {label : lblReqDate, fieldName : 'ReqDate', type : 'date', typeAttributes : {year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute : '2-digit'}},
    {label : lblReqType, fieldName : 'RequestType', type : 'text', sortable : 'true'},
    {label : lblReqStatus, fieldName : 'Status', type : 'text', sortable : 'true'},
    {label : lblCreatedBy, fieldName : 'CreatedBy', type : 'text', sortable : 'true'},
    {label : '', type : 'action', initialWidth:'50px', typeAttributes: { rowActions: actions },},
];

const columns = [   { label: lblContact, fieldName: 'ContactLink', type: 'url', typeAttributes: {label: {fieldName: 'ContactName'}, target: '_top'}, sortable: 'true', wrapText: 'true'},
					{ label: 'Contact Owner', fieldName: 'contactownerLink', type: 'url', typeAttributes: {label: {fieldName : 'OwnerName'}, target: '_top'}, sortable: 'true', wrapText: 'true'},
                    { label: lblAccount, fieldName: 'AccountLink', type: 'url', typeAttributes: {label: {fieldName : 'AccountName'}, target: '_top'}, sortable: 'true', wrapText: 'true'},
                    { label: lblPrefered, fieldName: 'PreferedPlace', type: 'text', sortable: 'true', wrapText: 'true',cellAttributes: { alignment: 'center' }},
                    { label: lblStreet, fieldName: 'Street', type: 'text', sortable: 'true', wrapText: 'true' },
                    { label: lblCity, fieldName: 'City', type: 'text', sortable: 'true', wrapText: 'true'},
                    { label: lblState, fieldName: 'State', type: 'text', sortable: 'true', wrapText: 'true'},
                    { label: lblPhone, fieldName: 'Phone', type: 'phone', sortable: 'true', wrapText: 'true'},
                    { label: lblContactRole, fieldName: 'Role', type: 'text', sortable: 'true', wrapText: 'true'},
                ];

export default class TabMVAActivationContacts extends NavigationMixin(LightningElement) {
    @api receivedId;
    @api objectApiName;
    isAssociatedConsExist = false;
    isValidationReqsExist = false;
    ValidationCount;
    ValidCount = 0;
    isContactLstLoading = true;
    @track isModalOpen = false;
    @track isLoading = false;
    @track data;
    @track error;
    @track columns = columns;
    @track columns2 = columns2;
    @track sortBy;
    @track sortDirection;
    @track rowId;
    @track rowName;

    contactRecs;
    contactRecRelatd;
    contactCount;
    errors;
    contactOpthalogistRecId;
    
    CHANNEL_NAME = '/event/Refresh_Related_List_Contact__e';

    constructor() {
        super();
    }
    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.getAllContactData();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
    connectedCallback() {
        this.getAllContactData();
        this.showObjectiveNotesPopup = false;
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
			let triggerAlert = true;
			if(errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none"){
				triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); // 20000 milliseconds = 20 seconds
			}
			if(triggerAlert){
                this.showToast('Error',JSON.stringify(errorData.error),'error','dismissable');
			}
        });        
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
            this.errors = error;
            this.showToast('Error',JSON.stringify(this.errors),'error','dismissable');
        }
    }
    
    @wire(getValidationList, {recordId : '$recordId'})
    validation(result){
        if(result.data){
            this.data = JSON.parse(JSON.stringify(result.data));
            if(this.data.length > 0)
                this.isValidationReqsExist = true;
            this.data.forEach(res=>{
                res.ValidationId = '/'+res.Id;
                res.ValidationName = res.Name;
                res.ReqDate = res.QIDC__Request_Date_ims__c;
                res.WorkPlaceName = res.QIDC__Workplace_ims__r.Name;
                res.WorkPlaceId = res.QIDC__Workplace_ims__c;
                res.RequestType = res.QIDC__Request_Type_ims__c;
                res.Status = res.QIDC__Status_ims__c;
                res.CreatedBy = res.CreatedBy.Name;
            });
            this.error = undefined;
        }else if(result.error){
            //this.errors = error;
            this.error = result.error;
            this.data = undefined;
            this.showToast('Error',JSON.stringify(this.errors),'error','dismissable');
        }
    }
    /*
    @wire(AllAssociatedContact, {recordId: '$receivedId'})
    contactRelate(result){
        this.isContactLstLoading = false;
        if(result.data){
            this.data = JSON.parse(JSON.stringify(result.data));
            if(this.data.length > 0)
              this.isAssociatedConsExist = true;
            this.data.forEach(res=>{
                res.ContactLink = '/' + res.ContactId;
                res.AccountLink = '/' + res.AccountId;
				res.contactownerLink='/'+res.CreatedById;
            });
            this.error = undefined;
        }else if(result.error){
            this.data = undefined;
            this.errors = error;
            this.showToast('Error',JSON.stringify(this.errors),'error','dismissable');
        }
    }*/
    
    getAllContactData(){
        AllAssociatedContact({recordId : this.receivedId}).then(response=>{
            console.log('>>>');
            this.isContactLstLoading = false;
            if(response){
                this.data = JSON.parse(JSON.stringify(response));
                console.log('>>>',this.data);
                if(response.length > 0){
                    this.isAssociatedConsExist = true;
                    this.data.forEach(res=>{
                        res.ContactLink = '/' + res.ContactId;
                        res.AccountLink = '/' + res.AccountId;
                        res.contactownerLink = '/' + res.CreatedById;
                    });
                }
            }
        }).catch(error=>{
            debugger;
            console.log('>>>error',this.error);
            this.data = undefined;
            this.showToast('Error',JSON.stringify(error.message),'error','dismissable');
        });
    }

    @wire(ContactOpthalRecId)
    CONTACT_OPTHAL_RECID({data,error}){
        if(data){
            this.contactOpthalogistRecId = data;
        }else if(error){
            this.showToast('Error',JSON.stringify(error.message),'error','dismissable');
        }
    }
    /*
    @wire(ContactRelatedList, {receivedId: '$receivedId'})
    contacts(result) {
        if (result.data) {
            this.data = JSON.parse(JSON.stringify(result.data));
            this.data.forEach(res=>{
                res.conLink1 = '/' + res.Id;
                res.conLink2 = '/' + res.AccountId;
            });
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }*/
    /*
    @wire(ContactRelated, {receivedId: '$receivedId'})
    wiredContactRelated({error, data}){
        if(data){
            this.contactRecs = data;
            this.contactCount = data.length;
            this.errors = undefined;
        }else if(error){
            this.errors = error;
            this.contactRecs = undefined;
        }
    }*/

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
    
    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Contacts',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
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
    
    showToast(title,message,variant,mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
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
            this.showToast('Error', 'error', error);
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

    createNewContactRecord(){
        this.navigateCreateNewContactOpthal('Contact');
    }

    navigateCreateNewContactOpthal(objectName){
        const defaultValues = encodeDefaultFieldValues({
            AccountId : this.receivedId
        });

        this[ NavigationMixin.Navigate]({
            type : 'standard__objectPage',
            attributes : {
                objectApiName : objectName,
                actionName : 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                navigationLocation: 'RELATED_LIST',  //to avoid prevention of moving to newly created record
                recordTypeId : this.contactOpthalogistRecId
            }
        });
    }
    
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });   
    }

    label = {AllContacts, NoData, CloseButton, DeleteButton, DeleteConfirm, ButtonDel, ButtonCancel, ValidationLabel, ViewAll, NewBtn};
     
}