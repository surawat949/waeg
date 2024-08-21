import { LightningElement, wire, track,api } from 'lwc';
import getSalesManagerList from '@salesforce/apex/CustomerReviewFilterHandler.getSalesManagerList';
import getRepresentativeList from '@salesforce/apex/CustomerReviewFilterHandler.getRepresentativeList';
import getASMManager from '@salesforce/apex/CustomerReviewFilterHandler.getASMManager';
import getCompanies from '@salesforce/apex/CustomerReviewFilterHandler.getCompanies';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import SALES_ROLE_FIELD from '@salesforce/schema/User.Sales_Role__c';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import getVisitsForRepresentative from '@salesforce/apex/CustomerReviewFilterHandler.getVisitsForRepresentative';
import USER_COMPANYNAME_FIELD from '@salesforce/schema/User.CompanyName';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import PROFILE_ID_FIELD from '@salesforce/schema/User.ProfileId';
import getTranslations from '@salesforce/apex/visitZonesMapController.getTranslations';

//custom Labels
import Filter from '@salesforce/label/c.Filter';
import Select_Company from '@salesforce/label/c.Select_Company';
import Select_Sales_Manager from '@salesforce/label/c.Select_Sales_Manager';
import Representative from '@salesforce/label/c.Representative';
import Company from '@salesforce/label/c.Company';
import Sales_Manager from '@salesforce/label/c.Sales_Manager';
import Select_Representative from '@salesforce/label/c.Select_Representative';
import Monday from '@salesforce/label/c.Monday';
import Tuesday from '@salesforce/label/c.Tuesday';
import Wednesday from '@salesforce/label/c.Wednesday';
import Thursday from '@salesforce/label/c.Thursday';
import Friday from '@salesforce/label/c.Friday';
import Saturday from '@salesforce/label/c.Saturday';
import Sunday from '@salesforce/label/c.Sunday';
import Show_Visit_Days from '@salesforce/label/c.Show_Visit_Days';
import Show_Visit_Zones from '@salesforce/label/c.Show_Visit_Zones';
import Start_Date from '@salesforce/label/c.Start_Date';
import End_Date from '@salesforce/label/c.End_Date';
import Display_list from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Display';
import Hide_list from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Hide';
import Visit_Planning_Map from '@salesforce/label/c.Visit_Planning_Map';
import No_Visit_Error from '@salesforce/label/c.No_Visit_Error';

import Hoya_Account_ID from '@salesforce/label/c.Hoya_Account_ID';
import Visit_Zone from '@salesforce/label/c.Tacticom';
import Segmentation from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import Total_Visits_Planned from '@salesforce/label/c.Total_Visits_Planned';
import Address from '@salesforce/label/c.Address';
import Last_Direct_Visit_Date from '@salesforce/label/c.Last_Direct_Visit_Date';

//import lwc funtions start here
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomerReviewFilter extends LightningElement {
    @track companyOptions = [];
    @track salesManagerOptions = [];
    @track representativeOptions = [];
    @track isRepresentativeDisabled = true;
    @track isSalesManagerDisabled = true;
    @track isRepresentativeReadonly = false;
    @track isCompanyDisabled = true;
    @track startDate;
    @track endDate;
    @track isASM = false;
    @track showDateFields = false;
    @track showVisitZone = true;
    @track showVisitDays = false;
    @track showLegendtoggle = false;
    @track visitViewButtonLabel = Show_Visit_Days;
    @track visits = [];
    @track translations = [];
    
    selectedCompany;
    selectedSalesManagerId;
    selectedRepresentativeId;
    currentUserId = USER_ID;
    currentUserName;
    currentUserRole;
    selectedFilter = '';

    subArea1;
    subArea2;
    subArea3;
    subArea4;
    subArea5;
    notSelected;

    connectedCallback() {
        getTranslations()
            .then(result => {
                this.translations = result;
                console.log('Method1 result: ' + JSON.stringify(this.translations));
                if (this.translations) {
                    this.subArea1 = this.translations["Sub-area 1"];
                    this.subArea2 = this.translations["Sub-area 2"];
                    this.subArea3 = this.translations["Sub-area 3"];
                    this.subArea4 = this.translations["Sub-area 4"];
                    this.subArea5 = this.translations["Sub-area 5"];
                    this.notSelected = this.translations["Not Selected"];
                }
                this.setStartAndEndDate(new Date());
            })
            .catch(error => {
                this.showToast('Error','An error occurred during fetching Translations==>'+error.message,'error');
            });
    }

    custLabel ={
        Filter,Select_Company,Select_Sales_Manager,Representative,Company,
        Sales_Manager,Select_Representative,Monday,Tuesday,
        Wednesday,Thursday,Friday,Saturday,Sunday,Show_Visit_Days,Show_Visit_Zones,
        Start_Date,End_Date,Display_list,Hide_list,No_Visit_Error,Visit_Planning_Map

    }

    // Wire service to get current user data
    @wire(getRecord, { recordId: USER_ID, fields: [SALES_ROLE_FIELD, USER_NAME_FIELD, PROFILE_NAME_FIELD, USER_COMPANYNAME_FIELD, PROFILE_ID_FIELD] })
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
            this.showToast('Error','An error occurred during fetching user details==>'+error.message,'error');
        }
    }

    // Load company options for System Administrator profile
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
                this.showToast('Error','An error occurred during loading Companies==>'+error.message,'error');
            });
    }

    // Handle change in selected company
    handleCompanyChange(event) {
        this.selectedCompany = event.detail.value;
        this.updateClassNames('');
        this.selectedSalesManagerId = '';
        this.visits = [];
        this.mapMaker = [];
        this.zoomLevel = 6;
        this.isSalesManagerDisabled = false;
        this.selectedRepresentativeId = '';
        this.isRepresentativeDisabled = true; // Disable Representative dropdown
        this.representativeOptions = []; // Clear Representative dropdown options
        this.loadSalesManagerOptions();
    }

    // Load sales manager options based on selected company
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
                this.showToast('Error','An error occurred during fetching manager ==>'+error.message,'error');
            });
    }

    // Set ASM manager details
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
                this.showToast('Error','An error occurred during fetching manager ==>'+error.message,'error');
            });
    }

    // Handle change in selected sales manager
    handleSalesManagerChange(event) {
        this.updateClassNames('');
        this.selectedSalesManagerId = event.detail.value;
        this.selectedRepresentativeId = '';
        this.isRepresentativeDisabled = false;
        this.visits = [];
        this.mapMaker = [];
        this.loadRepresentativeOptions();
        this.zoomLevel = 6;
    }

    // Handle change in selected representative
    handleRepresentativeChange(event) {
        this.updateClassNames('');
        this.showDateFields = true;
        this.selectedRepresentativeId = event.detail.value;
        this.isRepresentativeDisabled = false;
        this.showLegendtoggle = true;
        this.fetchVisits();
    }


    @api 
    set representativeId(val){
        this.selectedRepresentativeId = val;
        if(val){
            this.updateClassNames('');
            this.showDateFields = true;
            this.showLegendtoggle = true;
        }else{
            this.showDateFields = false;
            this.showLegendtoggle = false;
        }
         this.fetchVisits();
    }

    get representativeId(){
        return this.selectedRepresentativeId;
    }
    
    // Load representative options based on selected sales manager
    loadRepresentativeOptions() {
        getRepresentativeList({ selectedManagerId: this.selectedSalesManagerId })
            .then(data => {
                this.representativeOptions = data
                    .map(user => ({
                        label: user.Name,
                        value: user.Id
                    }))
            })
            .catch(error => {
                this.showToast('Error','An error occurred during fetching representatives==>'+error.message,'error');
            });
    }

    // Load representative options for ASM role
    loadRepresentativeOptionsForASM() {
        // For ASM, the representative should only be the ASM themselves
        this.representativeOptions = [{ label: this.currentUserName, value: this.currentUserId }];
    }

    // Get start date of the week
    getStartOfWeek(date) {
        const day = date.getDay();
        const diff = date.getDate() - day + (day === 0 ? -6 : 1); // Adjust when day is Sunday
        return new Date(date.setDate(diff));
    }
    
    // Set start and end date for the week
    setStartAndEndDate(date) {
        const startOfWeek = this.getStartOfWeek(new Date(date));
        const endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6);
        this.startDate = startOfWeek.toISOString().slice(0,10);
        this.endDate = endOfWeek.toISOString().slice(0,10);
    }
    
    // Handle next week button click
    handleNextWeek() {
        this.zoomLevel = 6;
        const nextWeek = new Date(this.startDate);
        nextWeek.setDate(nextWeek.getDate() + 7);
        this.setStartAndEndDate(nextWeek);
        this.fetchVisits();
    }

    // Handle previous week button click
    handlePreviousWeek() {
        this.zoomLevel = 6;
        const previousWeek = new Date(this.startDate);
        previousWeek.setDate(previousWeek.getDate() - 7);
        this.setStartAndEndDate(previousWeek);
        this.fetchVisits();
    }

    // Toggle visit view between days and zones
    toggleVisitView() {
        if (this.visitViewButtonLabel === Show_Visit_Days) {
            if(this.selectedRepresentativeId !=''){
                this.fetchVisits();
            }
            this.zoomLevel = 6;
            this.visitViewButtonLabel = Show_Visit_Zones;
            this.showVisitZone = false;
            this.showVisitDays = true;
        } else {
            if(this.selectedRepresentativeId !=''){
                this.fetchVisits();
            }
            this.zoomLevel = 6;
            this.visitViewButtonLabel = Show_Visit_Days;
            this.showVisitDays = false;
            this.showVisitZone = true;
        }
    }

    @track isSlideVisible = false;

    // Get class for button container based on slide visibility
    get buttonContainerClass() {
        return this.isSlideVisible ? 'button-container slide-in' : 'button-container slide-out';
    }

    // Toggle slide visibility
    toggleSlide() {
        this.isSlideVisible = !this.isSlideVisible;
    }

    @track mapMaker = [];
    @track vCenter;
    @track mapMakerTitle = Visit_Planning_Map;
    @track isDisplayList = true;
    @track zoomLevel = 6;
    @track displayListView = 'hidden';

    // Show list view of visits
    handleListViewShow() {
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }

    // Hide list view of visits
    handleListViewHide() {
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }

    // Fetch visits for the selected representative
    fetchVisits() {
        getVisitsForRepresentative({ representativeId: this.selectedRepresentativeId, startDate: this.startDate, endDate: this.endDate })
            .then(data => {
                this.visits = data;
                this.updateClassNames('');
                if (this.visitViewButtonLabel === Show_Visit_Days) {
                    this.handleKeyMapChangeForZones('');
                } else {
                    this.handleKeyMapChangeForDays('');
                }
                console.log(this.visits);
            })
            .catch(error => {
                this.showToast('Error','An error occurred during fetching visits ==>'+error.message,'error');
            });
    }
        
    // Replace undefined or null values with an empty string
    replaceUndefined(value) {
        return value === undefined || value === null ? '' : value;
    }
    replaceUndefinedForTacticom(value) {
        return value === undefined || value === null ? 'Not Selected' : value;
    }

    // Handle click on subarea for visit zones
    handleClickSubarea(event) {
        event.preventDefault(); // Prevents the default anchor behavior
        const dataId = event.currentTarget.getAttribute('data-id');
        this.zoomLevel = 6;
        if(this.selectedFilter === ''){
            this.selectedFilter = dataId;
            this.updateClassNames(dataId);
            this.handleKeyMapChangeForZones(dataId);
        }else{
            if(this.selectedFilter === dataId){
                this.selectedFilter = '';
                this.updateClassNames('');
                this.handleKeyMapChangeForZones('');
            }else{
                this.selectedFilter = dataId;
                this.updateClassNames(dataId);
                this.handleKeyMapChangeForZones(dataId);
            }
        }
    }
    updateClassNames(dataId) {
        const elements = this.template.querySelectorAll('[data-id]');
        elements.forEach(element => {
            if (element.getAttribute('data-id') === dataId) {
                element.className = 'selected';
            } else {
                element.className = 'notSelected';
            }
        });
    }
    // Handle map change for visit zones
    handleKeyMapChangeForZones(areaName) {
        const result = this.visits;
        this.mapMaker = [];
    
        // Filter logic based on areaName
        let filteredResult;
        if (areaName === 'not_Selected') {
            filteredResult = result.filter(r => !r.Account__r.TACTICOM_SOF__c || r.Account__r.TACTICOM_SOF__c === 'Not Selected');
        } else if (areaName) {
            filteredResult = result.filter(r => r.Account__r.TACTICOM_SOF__c === this.translations[areaName]);
        } else {
            filteredResult = result;
        }
    
        if (filteredResult.length > 0) {
            for (var i = 0; i < filteredResult.length; i++) {
                let fillColor;
                switch (filteredResult[i].Account__r.TACTICOM_SOF__c) {
                    case this.translations["Sub-area 1"]:
                        fillColor = 'yellow';
                        break;
                    case this.translations["Sub-area 2"]:
                        fillColor = '#fcb207';
                        break;
                    case this.translations["Sub-area 3"]:
                        fillColor = '#ec1717';
                        break;
                    case this.translations["Sub-area 4"]:
                        fillColor = '#13cddc';
                        break;
                    case this.translations["Sub-area 5"]:
                        fillColor = '#58bd08';
                        break;
                    default:
                        fillColor = '#000F2E';
                        break;
                }
    
                let descriptionVal ='<b>'+Hoya_Account_ID+' : </b>' + filteredResult[i].Account__r.Hoya_Account_ID__c +
                                    '<br><b>'+Visit_Zone+' : </b>' + this.replaceUndefinedForTacticom(filteredResult[i].Account__r.TACTICOM_SOF__c) +
                                    '<br><b>'+Segmentation+' : </b>' + filteredResult[i].Account__r.Segmentation_Net__c +
                                    '<br><b>'+Total_Visits_Planned+' : </b>' + filteredResult[i].Account__r.Total_Visits_Planned__c +
                                    '<br><b>'+Last_Direct_Visit_Date+' : </b>' + filteredResult[i].Account__r.Last_Visit_date__c +
                                    '<br><b>'+Address+' : </b>' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_Street__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_City__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_State__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_Postal_Code__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_Country__c);
    
                this.mapMaker = [...this.mapMaker,
                    {
                        location: {
                            Street: filteredResult[i].Account__r.Shop_Street__c,
                            City: filteredResult[i].Account__r.Shop_City__c,
                            State: filteredResult[i].Account__r.Shop_State__c,
                            PostalCode: filteredResult[i].Account__r.Shop_Postal_Code__c,
                            Country: filteredResult[i].Account__r.Shop_Country__c,
                        },
                        mapIcon: {
                            path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                            fillColor: fillColor,
                            fillOpacity: .7,
                            strokeWeight: 1,
                            scale: 1.6, // this is no.1
                        },
                        icon: 'standard:account',
                        title: filteredResult[i].Account__r.Name,
                        value: filteredResult[i].Id,
                        description: descriptionVal
                    }
                ];
            }
            this.vCenter = {
                location: {
                    Street: filteredResult[0].Account__r.Shop_Street__c,
                    City: filteredResult[0].Account__r.Shop_City__c,
                    State: filteredResult[0].Account__r.Shop_State__c,
                    PostalCode: filteredResult[0].Account__r.Shop_Postal_Code__c,
                    Country: filteredResult[0].Account__r.Shop_Country__c,
                },
            };
        } else {
            this.showToast('Warning', 'Warning', 'Could not find any planned visits for selected period');
            this.mapMaker = [];
        }
        this.isLoading = false;
    }
    // Handle click on subarea for visit days
    handleClickOnDays(event){
        event.preventDefault(); // Prevents the default anchor behavior
        const dataId = event.currentTarget.getAttribute('data-id');
        if(this.selectedFilter === ''){
            this.selectedFilter = dataId;
            this.handleKeyMapChangeForDays(dataId);
            this.updateClassNames(dataId);
        }else{
            if(this.selectedFilter === dataId){
                this.selectedFilter = '';
                this.handleKeyMapChangeForDays('');
                this.updateClassNames('');
            }else{
                this.selectedFilter = dataId;
                this.handleKeyMapChangeForDays(dataId);
                this.updateClassNames(dataId);
            }
        }
        this.zoomLevel = 6;
    }
    // Handle map change for visit days
    handleKeyMapChangeForDays(areaName){
        console.log(areaName);
        const result = this.visits;
        this.mapMaker = [];
    
        const filteredResult = areaName ? result.filter(r => r.Visit_Start_Day_Tracker__c === areaName) : result;

        if (filteredResult.length > 0) {
            //console.log('Record = > '+result.length);
            for(var i=0;i<filteredResult.length;i++){
                console.log(' '+filteredResult[i].Visit_Start_Day_Tracker__c);
                let fillColor;
                switch(filteredResult[i].Visit_Start_Day_Tracker__c){
                    case Monday:
                        fillColor = 'yellow';
                        break;
                    case Tuesday:
                        fillColor = '#fcb207';
                        break;
                    case Wednesday:
                        fillColor = '#ec1717';
                        break;
                    case Thursday:
                        fillColor = '#13cddc';
                        break;
                    case Friday:
                        fillColor = '#58bd08';
                        break;
                    case Saturday:
                        fillColor = '#e412cc';
                        break;
                    case Sunday:
                        fillColor = '#000F2E';
                        break;
                    default:
                        fillColor = '#000F2E';
                        break;
                }

                let descriptionVal ='<b>'+Hoya_Account_ID+' : </b>' + filteredResult[i].Account__r.Hoya_Account_ID__c +
                                    '<br><b>'+Visit_Zone+' : </b>' + this.replaceUndefinedForTacticom(filteredResult[i].Account__r.TACTICOM_SOF__c) +
                                    '<br><b>'+Segmentation+' : </b>' + filteredResult[i].Account__r.Segmentation_Net__c +
                                    '<br><b>'+Total_Visits_Planned+' : </b>' + filteredResult[i].Account__r.Total_Visits_Planned__c +
                                    '<br><b>'+Last_Direct_Visit_Date+' : </b>' + filteredResult[i].Account__r.Last_Visit_date__c +
                                    '<br><b>'+Address+' : </b>' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_Street__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_City__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_State__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_Postal_Code__c) + ' ' +
                                    this.replaceUndefined(filteredResult[i].Account__r.Shop_Country__c);
                
                
                this.mapMaker = [...this.mapMaker,
                    {
                        location : {
                            //Latitude : result[i].Account__r.sf_latitude__c,
                            //Longitude : result[i].Account__r.sf_longitude__c,
                            Street : filteredResult[i].Account__r.Shop_Street__c,
                            City : filteredResult[i].Account__r.Shop_City__c,
                            State : filteredResult[i].Account__r.Shop_State__c,
                            PostalCode : filteredResult[i].Account__r.Shop_Postal_Code__c,
                            Country : filteredResult[i].Account__r.Shop_Country__c,
                        },
                            mapIcon : {
                            path : 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                            fillColor : fillColor,
                            fillOpacity : .7,
                            strokeWeight: 1,
                            scale : 1.6,     //this is no.1
                                
                        },
                        icon : 'standard:account',
                        title : filteredResult[i].Account__r.Name,
                        value : filteredResult[i].Id,
                        description : descriptionVal
                    }

                ];
                
            }
            this.vCenter = {
                location : {
                    //Latitude : result[0].Account__r.sf_latitude__c,
                    //Longitude : result[0].Account__r.sf_longitude__c,
                    Street : filteredResult[0].Account__r.Shop_Street__c,
                    City : filteredResult[0].Account__r.Shop_City__c,
                    State : filteredResult[0].Account__r.Shop_State__c,
                    PostalCode : filteredResult[0].Account__r.Shop_Postal_Code__c,
                    Country : filteredResult[0].Account__r.Shop_Country__c,
                },
            };
        }else{
            this.showToast('Warning', 'Warning', No_Visit_Error);
            this.mapMaker = [];
        }
        this.isLoading = false;
    }

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: variant,
                }),
        );
    }
}