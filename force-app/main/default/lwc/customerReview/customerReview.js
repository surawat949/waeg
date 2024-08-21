import { LightningElement,wire,api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import USER_COMPANYNAME_FIELD from '@salesforce/schema/User.CompanyName';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import PROFILE_ID_FIELD from '@salesforce/schema/User.ProfileId';

import getSalesManagerList from '@salesforce/apex/CustomerReviewFilterHandler.getSalesManagerList';
import getRepresentativeList from '@salesforce/apex/CustomerReviewFilterHandler.getRepresentativeList';
import getASMManager from '@salesforce/apex/CustomerReviewFilterHandler.getASMManager';
import getCompanies from '@salesforce/apex/CustomerReviewFilterHandler.getCompanies';

//Custom Labels for Filters
import Filter from '@salesforce/label/c.Filter';
import Select_Company from '@salesforce/label/c.Select_Company';
import Select_Sales_Manager from '@salesforce/label/c.Select_Sales_Manager';
import Representative from '@salesforce/label/c.Representative';
import Company from '@salesforce/label/c.Company';
import Sales_Manager from '@salesforce/label/c.Sales_Manager';
import Select_Representative from '@salesforce/label/c.Select_Representative';


export default class CustomerReview extends LightningElement {
    companyOptions = [];
    salesManagerOptions = [];
    representativeOptions = [];
    currentUserId;
    selectedCompany;
    selectedSalesManagerId;
    selectedRepresentativeId;
    isRepresentativeDisabled = true;
    isSalesManagerDisabled = true;
    isRepresentativeReadonly = false;
    isCompanyDisabled = true;

    custLabel = {
        Filter,Select_Company,Select_Sales_Manager,
        Representative,Company,Sales_Manager,Select_Representative
    }

    @wire(getRecord, { recordId: userId, fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD,USER_COMPANYNAME_FIELD,PROFILE_ID_FIELD] })
    userData({ error, data }) {
        if (data) {
            const salesRole = getFieldValue(data, SALES_ROLE_FIELD);
            const profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            const profileId = getFieldValue(data, PROFILE_ID_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            this.currentUserRole = salesRole;
            // Logic based on user role and profile
            if (profileName === 'SFDC LOCAL ADMIN') {
                this.loadSalesManagerOptions();
            } else if (profileId === '00eb0000000lainAAA') {
                this.loadCompanyOptions();
            } else if (salesRole === 'ASM' || salesRole === 'AMS' || salesRole === 'KAM') {
                this.isASM = true;
                this.setASMManager();
            } else {
                this.loadSalesManagerOptions();
            }
        } else if (error) {
            console.error(error);
        }
    }

    loadSalesManagerOptions() {
        getSalesManagerList({ companyName: this.selectedCompany })
        .then(data => {
            this.isSalesManagerDisabled = false;
            this.salesManagerOptions = data.map(user => ({
                label: user.Name,
                value: user.Id
            }));
        })
        .catch(error => {
            console.error(error);
        });
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

    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedSalesManagerId})
        .then(data => {
            this.representativeOptions = data
                .map(user => ({
                    label: user.Name,
                    value: user.Id
                }))
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

    loadRepresentativeOptionsForASM() {
        // For ASM, the representative should only be the ASM themselves
        this.representativeOptions = [{ label: this.currentUserName, value: userId }];
    }

    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
        this.isSalesManagerDisabled = false;
        this.isRepresentativeDisabled = true; // Disable Representative dropdown
        this.representativeOptions = []; // Clear Representative dropdown options
        this.loadSalesManagerOptions();
        this.currentUserId = null;
    }
    
    handleSalesManagerChange(event) {
        this.selectedSalesManagerId = event.detail.value;
        this.currentUserId = null;
        this.isRepresentativeDisabled = false;
        this.loadRepresentativeOptions();
    }

    handleRepresentativeChange(event) {
        this.showDateFields = true;
        this.selectedRepresentativeId = event.detail.value;
        this.isRepresentativeDisabled = false;
    }

}