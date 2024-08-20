import { LightningElement, wire, track } from 'lwc';
import getSalesManagerList from '@salesforce/apex/CustomerReviewFilterHandler.getSalesManagerList';
import getRepresentativeList from '@salesforce/apex/CustomerReviewFilterHandler.getRepresentativeList';
import getASMManager from '@salesforce/apex/CustomerReviewFilterHandler.getASMManager';
import getCompanies from '@salesforce/apex/CustomerReviewFilterHandler.getCompanies';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';

export default class CustomerReviewFilter extends LightningElement {
    @track companyOptions = [];
    @track salesManagerOptions = [];
    @track representativeOptions = [];
    @track isRepresentativeDisabled = true;
    @track isSalesManagerDisabled = true;
    @track isRepresentativeReadonly = false;
    @track isCompanyDisabled = true;
    selectedCompany;
    selectedSalesManagerId;
    currentUserId = USER_ID;
    currentUserName;
    isASM = false;

    @wire(getRecord, { recordId: USER_ID, fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD] })
    userData({ error, data }) {
        if (data) {
            const salesRole = getFieldValue(data, SALES_ROLE_FIELD);
            const profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            if (profileName === 'Local Admin') {
                this.loadSalesManagerOptions();
            } else if (salesRole === 'ASM') {
                this.isASM = true;
                this.setASMManager();
            } else if (profileName === 'System Administrator') {
                this.loadCompanyOptions();
            } else {
                this.loadSalesManagerOptions();
            }
        } else if (error) {
            console.error(error);
        }
    }

    loadCompanyOptions() {
        getCompanies()
            .then(data => {
                this.companyOptions = data.map(company => ({
                    label: company,
                    value: company
                }));
                this.isCompanyDisabled = false;
                this.isSalesManagerDisabled = true; // Ensure Sales Manager is disabled initially for Admin
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
        this.isSalesManagerDisabled = false;
        this.isRepresentativeDisabled = true; // Disable Representative dropdown
        this.representativeOptions = []; // Clear Representative dropdown options
        this.loadSalesManagerOptions();
    }

    loadSalesManagerOptions() {
        getSalesManagerList({ companyName: this.selectedCompany })
            .then(data => {
                this.salesManagerOptions = data.map(user => ({
                    label: user.Name,
                    value: user.Id
                }));
            })
            .catch(error => {
                console.error(error);
            });
    }

    setASMManager() {
        getASMManager()
            .then(manager => {
                this.selectedSalesManagerId = manager.Id;
                this.salesManagerOptions = [{ label: manager.Name, value: manager.Id }];
                this.isSalesManagerDisabled = true;
                this.isRepresentativeDisabled = false;
                this.isRepresentativeReadonly = true;
                this.loadRepresentativeOptionsForASM();
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleSalesManagerChange(event) {
        this.selectedSalesManagerId = event.detail.value;
        this.isRepresentativeDisabled = false;
        this.loadRepresentativeOptions();
    }

    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedSalesManagerId })
            .then(data => {
                this.representativeOptions = data
                    .map(user => ({
                        label: user.Name,
                        value: user.Id
                    }))
                    .sort((a, b) => a.label.localeCompare(b.label)); // Sort alphabetically by name
            })
            .catch(error => {
                console.error(error);
            });
    }

    loadRepresentativeOptionsForASM() {
        // For ASM, the representative should only be the ASM themselves
        this.representativeOptions = [{ label: this.currentUserName, value: this.currentUserId }];
    }
}