import { LightningElement,wire,api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import PROFILE_ID_FIELD from '@salesforce/schema/User.ProfileId';
import USER_REGION from '@salesforce/schema/User.User_Region__c';
import CURRENCYISOCODE from '@salesforce/schema/User.DefaultCurrencyIsoCode';
import COMPANYNAME from '@salesforce/schema/User.CompanyName';

import getSalesManagerList from '@salesforce/apex/CustomerReviewFilterHandler.getSalesManagerList';
import getRepresentativeList from '@salesforce/apex/CustomerReviewFilterHandler.getRepresentativeList';
import getASMManager from '@salesforce/apex/CustomerReviewFilterHandler.getASMManager';
import getCompanies from '@salesforce/apex/CustomerReviewFilterHandler.getCompanies';

//Custom Labels for Filters
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
    selectedRepresentativeUserObject = {};
    isRepresentativeDisabled = true;
    isSalesManagerDisabled = true;
    isRepresentativeReadonly = false;
    isCompanyDisabled = true;
    isTeamPerformanceDisabled = true;
    persistantRepData = [];
    custLabel = {
        Select_Company,Select_Sales_Manager,
        Representative,Company,Sales_Manager,Select_Representative
    }
    activityTab = true;
    agendaTab = false;
    weeklyvisitsTab = false;
    visitzonesTab = false;
    performanceTab = false;
    allTabs = ['activityTab','agendaTab','weeklyvisitsTab','visitzonesTab','performanceTab'];

    @wire(getRecord, { recordId: userId, fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD,COMPANYNAME,PROFILE_ID_FIELD,USER_REGION,CURRENCYISOCODE] })
    userData({ error, data }) {
        if (data) {
            const salesRole = getFieldValue(data, SALES_ROLE_FIELD);
            const profileName = getFieldValue(data, PROFILE_NAME_FIELD);
            const profileId = getFieldValue(data, PROFILE_ID_FIELD);
            this.currentUserName = getFieldValue(data, USER_NAME_FIELD);
            this.currentUserRole = salesRole;
            this.currentUserRegion = getFieldValue(data, USER_REGION);
            this.currentUserCurrency = getFieldValue(data, CURRENCYISOCODE);
            this.companyName =  getFieldValue(data, COMPANYNAME);
            // Logic based on user role and profile
            if (profileName === 'SFDC LOCAL ADMIN') {
                this.loadCompanyOptions();
                this.loadSalesManagerOptions();
            } else if (profileId === '00eb0000000lainAAA') {
                this.loadCompanyOptions();
            } else if (salesRole === 'ASM' || salesRole === 'AMS' || salesRole === 'KAM') {
                this.isASM = true;
                this.setASMManager();
            } else {
                this.loadCompanyOptions();
                this.loadSalesManagerOptions();
            }
        } else if (error) {
            this.showToast('Error','Error ==>'+error,'error');
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
            this.showToast('Error','Error ==>'+error,'error');
        });
    }

    loadCompanyOptions() {
        getCompanies()
            .then(data => {
                this.companyOptions = data.map(company => ({
                    label: company,
                    value: company
                }));
                // Check if there are more than one company options
                if (this.companyOptions.length > 1) {
                    
                    this.isCompanyDisabled = false; // Enable company combobox
                    this.isSalesManagerDisabled = true; // Disable Sales Manager combobox initially for Admin
                } else {
                    this.isCompanyDisabled = true; // Keep company combobox disabled if only one option
                    // If there's only one company, handle the next logic (like auto-selecting)
                    this.handleCompanyChange({ detail: { value: this.companyOptions[0].value } });
                }
            })
            .catch(error => {
                this.showToast('Error','Error ==>'+error,'error');
            });
    }

    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedSalesManagerId})
        .then(data => {
            this.persistantRepData = data;
            this.representativeOptions = data
                .map(user => ({
                    label: user.Name,
                    value: user.Id
                }))
        })
        .catch(error => {
                this.showToast('Error','Error ==>'+error,'error');
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
                this.showToast('Error','Error ==>'+error,'error');
            });
    }

    loadRepresentativeOptionsForASM() {
        // For ASM, the representative should only be the ASM themselves
        this.representativeOptions = [{ label: this.currentUserName, value: userId }];
         this.persistantRepData =  [{
            "Id": userId,
            "Name": this.currentUserName,
            "Sales_Role__c": this.currentUserRole,
            "User_Region__c": this.currentUserRegion,
            "defaultCurrencyISOcode": this.currentUserCurrency,
            "CompanyName" : this.companyName
        }];
    }

    handleCompanyChange(event) {
        console.log(event.detail.value);
        this.selectedCompany = event.detail.value;
        this.isSalesManagerDisabled = false;
        this.isRepresentativeDisabled = true; // Disable Representative dropdown
        this.representativeOptions = []; // Clear Representative dropdown options
        this.loadSalesManagerOptions();
        this.selectedSalesManagerId = null;
        this.selectedRepresentativeId = null;
        this.selectedRepresentativeUserObject = {};
        this.isTeamPerformanceDisabled = true;
    }
    
    handleSalesManagerChange(event) {
        this.selectedSalesManagerId = event.detail.value;
        this.selectedRepresentativeId = null;
        this.selectedRepresentativeUserObject = {};
        this.isRepresentativeDisabled = false;
        this.loadRepresentativeOptions();
        this.isTeamPerformanceDisabled = true;
    }

    handleRepresentativeChange(event) {
        this.isRepresentativeDisabled = false;
        let matchingRecord = this.persistantRepData.find(record => record.Id === event.detail.value); 
        this.selectedRepresentativeUserObject = matchingRecord;
        let representativeRole = matchingRecord.Sales_Role__c;
        this.selectedRepresentativeId = event.detail.value;
        if((representativeRole === 'NSM' || representativeRole === 'RSM' || representativeRole === 'RMS' || representativeRole === 'NMS') && this.selectedRepresentativeId){
            this.isTeamPerformanceDisabled = false;
        }else{
            this.isTeamPerformanceDisabled = true;
        }
    }

    handleActiveTab(event){
        this.updateTabs(event.target.value);
    }

    updateTabs(activeTab){
        this.allTabs.forEach(tab => {
            if(tab == activeTab){
                this[tab] = true;
            }else{
                this[tab] = false;
            }
        });
    }

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }

}