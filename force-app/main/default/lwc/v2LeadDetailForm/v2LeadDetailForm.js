import { LightningElement, api, track, wire } from 'lwc';
import { updateRecord } from "lightning/uiRecordApi";
import USER_ID from "@salesforce/user/Id";
import { getRecord } from 'lightning/uiRecordApi';
import LEAD_OBJECT from '@salesforce/schema/Lead';
import { NavigationMixin } from 'lightning/navigation';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import LEAD_COMPANY from '@salesforce/schema/Lead.Company';
import LEAD_PHONE from '@salesforce/schema/Lead.Phone';
import LEAD_WEBSITE from '@salesforce/schema/Lead.Website';
import LEAD_EMAIL from '@salesforce/schema/Lead.Email';
import LEAD_DESCRIPTION from '@salesforce/schema/Lead.Description';
import LEAD_CHANNEL from '@salesforce/schema/Lead.Channel__c';
import LEAD_ADDRESS from '@salesforce/schema/Lead.Address';
import LightningConfirm from 'lightning/confirm';

import LEAD_STATUS from '@salesforce/schema/Lead.Status';
import LEAD_IS_ALREADY_ORDERING_FROM_HVC from '@salesforce/schema/Lead.Is_Already_Ordering_From_HVC__c';
import LEAD_CREDIT_APPLICATION_IS_COMPLETED from '@salesforce/schema/Lead.Credit_Application_Is_Completed__c';

import LEAD_NAME from '@salesforce/schema/Lead.Name';
import LEAD_MOBILE from '@salesforce/schema/Lead.MobilePhone';
import LEAD_CONTACT_ROLE from '@salesforce/schema/Lead.Contact_Role__c';
import LEAD_SUBMIT_TO from '@salesforce/schema/Lead.Submit_To__c';
import LEAD_NEW_CUSTOMER_NUMBER from '@salesforce/schema/Lead.New_Customer_Number__c';
import LEAD_COMMENT from '@salesforce/schema/Lead.Comment__c';
import LEAD_ACCOUNT_ID from '@salesforce/schema/Lead.Account_ID__c';
import LEAD_STRATEGIC_VALUE from '@salesforce/schema/Lead.Strategic_Value__c';
import ID_FIELD from "@salesforce/schema/Lead.Id";

import UpdateCompetitor from '@salesforce/apex/V2LeadDetailController.UpdateCompetitor';
import changeLeadStatus from '@salesforce/apex/V2LeadDetailController.changeLeadStatus';
import changeLeadStatusToAccountCreated from '@salesforce/apex/V2LeadDetailController.changeLeadStatusToAccountCreated';
import convertLead from '@salesforce/apex/V2LeadDetailController.convertLead';
import RejectLeadCloseRelatedTasks from '@salesforce/apex/V2LeadDetailController.RejectLeadCloseRelatedTasks';

//Custom labels 
import Company_Address from '@salesforce/label/c.Company_Address';
import Contact_Section from '@salesforce/label/c.Contact_Section';
import Other_Key_Information from '@salesforce/label/c.Other_Key_Information';
import X1st_Competitor_Local_name from '@salesforce/label/c.X1st_Competitor_Local_name';
import X2nd_Competitor_Local_name from '@salesforce/label/c.X2nd_Competitor_Local_name';
import Submission from '@salesforce/label/c.Submission';
import Submit_To from '@salesforce/label/c.Submit_To';
import Creation_Of_The_New_Account from '@salesforce/label/c.Creation_Of_The_New_Account';
import Export_Contacts_Visit_Reports_To_The_New_Account from '@salesforce/label/c.Export_Contacts_Visit_Reports_To_The_New_Account';
import Account_ID from '@salesforce/label/c.Account_ID';
import Select_Account from '@salesforce/label/c.Select_Account';
import Change_Competitors from '@salesforce/label/c.Change_Competitors';

import User_has_been_updated from '@salesforce/label/c.User_has_been_updated';
import Warning_Submit_To from '@salesforce/label/c.Warning_Submit_To';
import Warning_Credit_Application_Is_Completed from '@salesforce/label/c.Warning_Credit_Application_Is_Completed';
import Warning_New_Customer_Number_is_empty from '@salesforce/label/c.Warning_New_Customer_Number_is_empty';
import Rejection_Comment from '@salesforce/label/c.Rejection_Comment';
import New_Customer_number_should_not_be_empty from '@salesforce/label/c.New_Customer_number_should_not_be_empty';
import Warning_Account_ID_Null from '@salesforce/label/c.Warning_Account_ID_Null';
const FIELDS = [
    'Lead.Status',
    'Lead.Id',
    'Lead.X1st_Competitor_Local_name__c',
    'Lead.X2nd_Competitor_Local_name__c',
    'Lead.Submit_To__c',
    'Lead.Account_ID__c',
    'Lead.Credit_Application_Is_Completed__c',
    'Lead.Is_Already_Ordering_From_HVC__c',
    'Lead.New_Customer_Number__c',
    'Lead.Comment__c',
    'Lead.CreatedById',
    'Lead.Submit_To__r.Name'
];
export default class V2LeadDetailForm extends NavigationMixin(LightningElement) {
    @api recordId;
    @api ObjectApiName = LEAD_OBJECT;
    label ={
        Company_Address,
        Contact_Section,
        Other_Key_Information,
        X1st_Competitor_Local_name,
        X2nd_Competitor_Local_name,
        Submission,
        Submit_To,
        Creation_Of_The_New_Account,
        Export_Contacts_Visit_Reports_To_The_New_Account,
        Account_ID,
        Select_Account,
        Change_Competitors,
        User_has_been_updated,
        Warning_Submit_To,
        Warning_Credit_Application_Is_Completed,
        Warning_New_Customer_Number_is_empty,
        Rejection_Comment,
        New_Customer_number_should_not_be_empty,
        Warning_Account_ID_Null
    };
    @track companyName;
    @track IsInfomationCollectionStatus = false;
    @track IsInfomationSubmittedStatus = false;
    @track IsNewAccountCreatedStatus = false;
    @track IsConvertedStatus = false;
    @track isModalOpen = false;
    @track IsAccountSelectionOpen = false;
    @track FirstCompetitorLocal;
    @track SecondCompetitorLocal;
    @track FirstCompLocalName;
    @track SecondCompLocalName;
    @track SubmittedTo;
    @track selectedAccountId;
    @track showLoading = false;
    @track selectedSubmitToUserId;
    @track selectedAccountRecordId;
    @track fieldSet1 = [LEAD_COMPANY, LEAD_PHONE, LEAD_WEBSITE, LEAD_ADDRESS, LEAD_EMAIL, LEAD_CHANNEL, LEAD_IS_ALREADY_ORDERING_FROM_HVC, LEAD_CREDIT_APPLICATION_IS_COMPLETED, LEAD_STATUS, LEAD_DESCRIPTION];
    @track fieldSet4 = [LEAD_NAME, LEAD_MOBILE, LEAD_CONTACT_ROLE];
    @track fieldSet5 = [LEAD_STRATEGIC_VALUE];
    @track fieldSet7 = [LEAD_NEW_CUSTOMER_NUMBER, LEAD_COMMENT];

    @track showSubmitButton = false;
    @track showConvertConfirmButtons = false;
    @track showConvertButton = false;
    @track IsAlreadyOrderingFromHVC = false;
    @track CreditApplicationIsCompleted = false;
    @track NewCustomerNumber;
    @track Comment;
    @track CreatedByID;
    @track agentMode = "view";
    @track IsAgentMode = true;
    @track SubmitToUserName = '';
    @track IsSubmitToEditable = false;
    @wire(getRecord, {
        recordId: '$recordId',
        fields: FIELDS
    })
    leadRecord({
        error,
        data
    }) {
        if (data) {
            this.showLoading = true;
            let status = data.fields.Status.value;
            this.CreatedByID = data ? data.fields.CreatedById.value : '';
            this.Comment = data ? (data.fields.Comment__c.value != null ? data.fields.Comment__c.value : '') : '';
            this.NewCustomerNumber = data ? (data.fields.New_Customer_Number__c.value != null ? data.fields.New_Customer_Number__c.value : '') : '';
            this.IsAlreadyOrderingFromHVC = data ? data.fields.Is_Already_Ordering_From_HVC__c.value : false;
            this.CreditApplicationIsCompleted = data ? data.fields.Credit_Application_Is_Completed__c.value : false;
            this.FirstCompLocalName = data ? data.fields.X1st_Competitor_Local_name__c.value : '';
            this.SecondCompLocalName = data ? data.fields.X2nd_Competitor_Local_name__c.value : '';
            this.SubmittedTo = data ? (data.fields.Submit_To__c.value != null ? data.fields.Submit_To__c.value : '') : '';
            this.SubmitToUserName = data ? (data.fields.Submit_To__r.displayValue != null ? data.fields.Submit_To__r.displayValue : '') : '';
            this.FirstCompetitorLocal = this.FirstCompLocalName;
            this.SecondCompetitorLocal = this.SecondCompLocalName;
            this.selectedAccountId = data ? (data.fields.Account_ID__c.value != null ? data.fields.Account_ID__c.value : '') : '';
            this.IsInfomationCollectionStatus = (status === 'Information Collection');
            this.IsInfomationSubmittedStatus = (status === 'Information Submitted');
            this.IsNewAccountCreatedStatus = (status === 'New Account Created');
            this.IsConvertedStatus = (status === 'Lead Converted');
            this.showButtonsUtility();
            setTimeout(() => {
                this.showLoading = false;
            }, 500);
        } else if (error) {
            setTimeout(() => {
                this.showLoading = false;
            }, 500);
        }
    }
    handleValueSelectedOnLead(event) {
        this.showLoading = true;
        this.selectedSubmitToUserId = event.detail;
        let selectedUserDetails = event.detail;
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[LEAD_SUBMIT_TO.fieldApiName] = selectedUserDetails.id ? selectedUserDetails.id : null;
        const recordInput = {
            fields: fields
        };
        updateRecord(recordInput).then((record) => {
            this.updateRecordView();
            this.confirmMsg('success', 'Success', 'header', this.label.User_has_been_updated);
        });
        setTimeout(() => {
            this.showLoading = false;
        }, 500);
    }
    handleValueSelectedAccount(event) {
        this.selectedAccountRecordId = event.detail;
    }
    handleAccountChange(event) {
        this.showLoading = true;
        let selectedAccountDetails = this.selectedAccountRecordId
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[LEAD_ACCOUNT_ID.fieldApiName] = selectedAccountDetails.id ? selectedAccountDetails.id : null;
        const recordInput = {
            fields: fields
        };
        updateRecord(recordInput).then((record) => {
            this.IsAccountSelectionOpen = false;
            this.updateRecordView();
        });
        setTimeout(() => {
            this.showLoading = false;
        }, 500);
    }
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    handleAccountModel() {
        this.IsAccountSelectionOpen = true;
    }
    closeHandleAccountModel() {
        this.IsAccountSelectionOpen = false;
    }
    handleLookupSelectCompValue(event) {
        if (event.detail.selectedRecord != undefined) {
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value = event.detail.selectedRecord.Value;
            const queryTemplate = this.template.querySelector('lightning-input[data-my-id=form-input-2]').value;
            if (queryTemplate != null || queryTemplate != '') {
                this.FirstCompetitorLocal = event.detail.selectedRecord.Value;
            } else {
                queryTemplate = '';
                this.FirstCompetitorLocal = '';
            }
        } else {
            this.FirstCompetitorLocal = '';
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value = '';
        }
    }
    hadleLookupSelectCompValue2(event) {
        if (event.detail.selectedRecord != undefined) {
            this.template.querySelector('lightning-input[data-my-id=form-input-3').value = event.detail.selectedRecord.Value;
            const queryTemplate = this.template.querySelector('lightning-input[data-my-id=form-input-3').value;
            if (queryTemplate != null || queryTemplate != '') {
                this.SecondCompetitorLocal = event.detail.selectedRecord.Value;
            } else {
                queryTemplate = '';
                this.SecondCompetitorLocal = '';
            }
        } else {
            this.SecondCompetitorLocal = '';
            this.template.querySelector('lightning-input[data-my-id=form-input-3').value = '';
        }
    }
    handleChangeCompetitor(event) {
        this.FirstCompetitorLocal = event.target.value;
    }
    handleChange2Competitor(event) {
        this.SecondCompetitorLocal = event.target.value;
    }
    handleUpdateCompetitor() {
        this.showLoading = true;
        UpdateCompetitor({
            recordId: this.recordId,
            firstCompetitorName: this.FirstCompetitorLocal,
            secondCompetitorName: this.SecondCompetitorLocal
        }).then(result => {
            this.FirstCompLocalName = this.FirstCompetitorLocal;
            this.SecondCompLocalName = this.SecondCompetitorLocal;
            this.updateRecordView();
            this.isModalOpen = false;
            this.showLoading = false;
        }).catch(error => {
            this.showLoading = false;
        });
    }
    updateRecordView() {
        let RecordstoUpdate = [{
            recordId: this.recordId
        }];
        notifyRecordUpdateAvailable(RecordstoUpdate);
    }
    showButtonsUtility() {
        if (this.IsInfomationCollectionStatus) {
            if (USER_ID === this.CreatedByID) {
                this.showSubmitButton = true;
            } else {
                this.showSubmitButton = false;
            }
            this.showConvertConfirmButtons = false;
            this.showConvertButton = false;

            this.agentMode = (USER_ID === this.CreatedByID) ? 'view' : (USER_ID === this.SubmittedTo) ? 'readonly' : 'readonly';
            this.IsAgentMode = (this.agentMode === 'view') ? true : false;
            this.IsSubmitToEditable = (this.agentMode === 'view') ? true : false;
        } else if (this.IsInfomationSubmittedStatus) {
            this.showSubmitButton = false;

            if (USER_ID === this.SubmittedTo) {
                this.showConvertConfirmButtons = true;
            } else {
                this.showConvertConfirmButtons = false;
            }
            this.showConvertButton = false;
            this.agentMode = (USER_ID === this.CreatedByID) ? 'readonly' : (USER_ID === this.SubmittedTo) ? 'view' : 'readonly';
            this.IsAgentMode = (this.agentMode === 'view') ? true : false;
            this.IsSubmitToEditable = false;
        } else if (this.IsNewAccountCreatedStatus) {
            this.showSubmitButton = false;
            this.showConvertConfirmButtons = false;

            if (USER_ID === this.CreatedByID) {
                this.showConvertButton = true;
            } else {
                this.showConvertButton = false;
            }
            this.agentMode = "readonly";
            this.IsAgentMode = false;
            this.IsSubmitToEditable = false;
        } else if (this.IsConvertedStatus) {
            this.showSubmitButton = false;
            this.showConvertConfirmButtons = false;
            this.showConvertButton = false;
            this.agentMode = (USER_ID === this.CreatedByID) ? 'readonly' : (USER_ID === this.SubmittedTo) ? 'readonly' : 'readonly';
            this.IsAgentMode = (this.agentMode === 'view') ? true : false;
            this.IsSubmitToEditable = false;
        }
    }
    async handleSubmit(event) {
        this.showLoading = true;
        if (this.SubmittedTo && this.CreditApplicationIsCompleted) {
            try {
                const result = await changeLeadStatus({
                    recordId: this.recordId
                });
                this.updateRecordView();
                this.showButtonsUtility();
            } catch (error) {
                console.log(JSON.stringify(error));
            } finally {
                this.showLoading = false;
            }
        } else {
            if (!this.CreditApplicationIsCompleted) {
                this.confirmMsg('warning', 'Warning', 'header', this.label.Warning_Credit_Application_Is_Completed);
            }else if (!this.SubmittedTo) {
                this.confirmMsg('warning', 'Warning', 'header', this.label.Warning_Submit_To);
            }          
            this.showLoading = false;
        }

    }
    async handleReject(event) {
        if (this.NewCustomerNumber) {
            this.confirmMsg('warning', 'Warning', 'header', this.label.Warning_New_Customer_Number_is_empty);
        }else if(this.Comment.trim() === '' || this.Comment.trim() === undefined || this.Comment.trim() === null){
            this.confirmMsg('warning', 'Warning', 'header', this.label.Rejection_Comment);
        }else{
            this.showLoading = true;
            try {
                const result = await RejectLeadCloseRelatedTasks({
                    recordId: this.recordId
                });
                let RecordstoUpdate = [{
                    recordId: this.recordId
                }];
                notifyRecordUpdateAvailable(RecordstoUpdate);
                this.showButtonsUtility();
                this.showLoading = false;
            } catch (error) {
                this.showLoading = false;
            }
        } 
    }

    async handleConfirm(event) {
        if (this.NewCustomerNumber) {
            this.showLoading = true;
            try {
                const result = await changeLeadStatusToAccountCreated({
                    recordId: this.recordId
                });
                let RecordstoUpdate = [{
                    recordId: this.recordId
                }];
                notifyRecordUpdateAvailable(RecordstoUpdate);
                this.showButtonsUtility();
                this.showLoading = false;
            } catch (error) {
                this.showLoading = false;
            }
        } else {
            this.showLoading = false;
            this.confirmMsg('warning', 'Warning', 'header', this.label.New_Customer_number_should_not_be_empty);
        }
    }
    async handleConvert(event) {
        this.showLoading = true;
        if (this.selectedAccountId) {            
            try {                
                const accountId = await convertLead({
                    leadId: this.recordId
                });
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: accountId,
                        objectApiName: 'Account',
                        actionName: 'view'
                    }
                });
                let RecordstoUpdate = [{
                    recordId: this.recordId
                }];                
                notifyRecordUpdateAvailable(RecordstoUpdate);
                this.showButtonsUtility();
                this.showLoading = false;
            } catch (error) {
                this.showLoading = false;
                this.confirmMsg('error', 'Error', 'header', JSON.stringify(error));
            }
        } else {
            this.showLoading = false;
            this.confirmMsg('warning', 'Warning', 'header', this.label.Warning_Account_ID_Null);
        }
    }
    async confirmMsg(theme, label, variant, message) {
        const result = await LightningConfirm.open({
            message: message,
            variant: variant,
            label: label,
            theme: theme,
        }).then((result) => {
            console.log('Lightning Confirm Result', result);
        });
    }
}