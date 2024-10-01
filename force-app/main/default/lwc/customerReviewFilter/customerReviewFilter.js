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
    profileName;
    currentUserName;
    isASM = false;

    @wire(getRecord, { recordId: USER_ID, fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD] })
    userData({ error, data }) {
        if (data) {
            const salesRole = getFieldValue(data, SALES_ROLE_FIELD);
            this.profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            if (this.profileName === 'Local Admin') {
                this.loadCompanyOptions();
                this.loadSalesManagerOptions();
            } else if (salesRole === 'ASM') {
                this.isASM = true;
                this.setASMManager();
            } else if (this.profileName === 'System Administrator') {
                this.loadCompanyOptions();
            } else {
                this.loadCompanyOptions();
                this.loadSalesManagerOptions();
            }
        } else if (error) {
            console.error(error);
        }
    }

    loadCompanyOptions() {
        getCompanies()
            .then(data => {
                console.log('loadCompanyOptions called');
                this.companyOptions = data.map(company => ({
                    label: company,
                    value: company
                }));
                alert(this.companyOptions.length );
                // Check if there are more than one company options
                if (this.companyOptions.length > 0) {
                    
                    this.isCompanyDisabled = false; // Enable company combobox
                    this.isSalesManagerDisabled = true; // Disable Sales Manager combobox initially for Admin
                } else {
                    this.isCompanyDisabled = true; // Keep company combobox disabled if only one option
                    // If there's only one company, handle the next logic (like auto-selecting)
                    this.handleCompanyChange({ detail: { value: this.companyOptions[0].value } });
                }
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
                console.log('loadSalesManagerOptions called');
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