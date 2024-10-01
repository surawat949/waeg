import { LightningElement,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordTypeId from '@salesforce/apex/EyeDoctorVisitPlanningController.getRecordTypeId'; // Apex method import
import getContactList from '@salesforce/apex/EyeDoctorVisitPlanningController.getAccountVisitPlanningData';
import filterAccounts from '@salesforce/apex/EyeDoctorVisitPlanningController.filterAccounts';
import getPicklistValues from '@salesforce/apex/EyeDoctorVisitPlanningController.getPicklistValues';
import QuickFilterHelpText from '@salesforce/label/c.QuickFilterHelpTextEyeDoctor';

import Show_Calender from '@salesforce/label/c.Show_Calender';
import Hide_Calender from '@salesforce/label/c.Hide_Calender';
import Show_Filters from '@salesforce/label/c.Show_Filters';
import Hide_Filters from '@salesforce/label/c.Hide_Filters';
import removeFilters from '@salesforce/label/c.Remove_Filters';
import clinicList from '@salesforce/label/c.tab_Clinic_List';
import clinicMap from '@salesforce/label/c.tab_Clinics_Selection_on_Map';
import campaignOverview from '@salesforce/label/c.tab_Campaign_Overview';
import plannedVisitsMap from '@salesforce/label/c.tab_Planned_Visits_Map';
import listView from '@salesforce/label/c.tabListView';
import location from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_Location';
import page from '@salesforce/label/c.Page';
import of from '@salesforce/label/c.of';
import Accounts from '@salesforce/label/c.Accounts';
import DoctorName from '@salesforce/label/c.Doctor_Name';
import ContactONEKEYID from '@salesforce/label/c.Doctor_ONEKEY_ID';
import ContactOWNER from '@salesforce/label/c.Contact_Owner';
import IndividualStatus from '@salesforce/label/c.Individual_Status';
import CurrentState from '@salesforce/label/c.Current_State';
import LastVisitDate from '@salesforce/label/c.Last_Doctor_Visit_Date';
import PrescriberClinic from '@salesforce/label/c.Total_Number_of_prescribers_in_the_clinic';
import ClinicName from '@salesforce/label/c.Clinic_Name';
import PlaceforVisit from '@salesforce/label/c.Preferred_Place_for_Visit';
import PreferredContactDayTime from '@salesforce/label/c.Preferred_Contact_day_time';
import Street from '@salesforce/label/c.SFDC_V2_MVA_Activation_Street';
import City from '@salesforce/label/c.ShopCity';
import Zip from '@salesforce/label/c.ZIP';
import State from '@salesforce/label/c.State';
import Tacticom from '@salesforce/label/c.Tacticom';
import Miyosmart_Segmentation from '@salesforce/label/c.Miyosmart_Segmentation';
import Miyosmart_Attitude from '@salesforce/label/c.Miyosmart_Attitude';
import Local_Specialization from '@salesforce/label/c.Local_Specialization';
import Vist_Day_Time from '@salesforce/label/c.Vist_Day_Time';
import Eye_Doctor_Details from '@salesforce/label/c.Eye_Doctor_Details';
import Search from '@salesforce/label/c.Search';
import Target_Contact from '@salesforce/label/c.Target_Contact';
import QuickFilterLabel from '@salesforce/label/c.QuickFilter';
import listViewLabel from '@salesforce/label/c.Select_List_View';

const PAGE_SIZE = 15; // Define the page size

export default class EyeDoctorVisitPlanning extends NavigationMixin(LightningElement) {
    custLabel = {DoctorName,ContactOWNER,ContactONEKEYID,IndividualStatus,CurrentState,PrescriberClinic,
                LastVisitDate,ClinicName,PlaceforVisit,PreferredContactDayTime,Street,City,Zip,State,clinicList,clinicMap,
                campaignOverview,QuickFilterHelpText,plannedVisitsMap,Hide_Filters,Show_Filters,Show_Calender,Hide_Calender,
                removeFilters,listView,location,page,of,Accounts,
                Miyosmart_Attitude,Miyosmart_Segmentation,Tacticom,Local_Specialization,Vist_Day_Time,
                Eye_Doctor_Details,Search,Target_Contact,QuickFilterLabel,listViewLabel};
    @track showCalender = true;
    @track firstComponentClass = 'slds-size--1-of-2';
    @track secondComponentClass = 'slds-size--1-of-2';
    recordTypeId;
    initialisedCalendar = false;

    @wire(getRecordTypeId, { objectName: 'Visits__c', developerName: 'Eye_Doctor_Visit' })
    wiredRecordTypeId({ error, data }) {
        if (data) {
            this.recordTypeId = data;
            console.log('Eye Doctor Visit Record Type ID: ', this.recordTypeId);
        } else if (error) {
            console.error('Error fetching record type ID:', error);
        }
    }

    handleCalenderView(){
        this.showCalender = !this.showCalender;
        if(this.showCalender == false){
            this.firstComponentClass = 'slds-size--2-of-2';
            this.secondComponentClass = 'slds-hide';
            this.toggleCalenderViewText = this.custLabel.Show_Calender;
        }else{
            this.firstComponentClass = 'slds-size--1-of-2';
            this.secondComponentClass = 'slds-size--1-of-2';
            this.toggleCalenderViewText = this.custLabel.Hide_Calender;
        }
    }

    toggleButtonText = this.custLabel.Hide_Filters;
    toggleCalenderViewText = this.custLabel.Hide_Calender;
    isLoading = false;
    @track displayedRecords = []; // Records displayed on the current page
    @track recordCount = 0; //Total number of records
    @track currentPage = 1; // Current page number
    @track records = {};
    totalPages = 0;
    disablePrev = true;
    disableNext = false;
    @track contactData = [];
    @track paginatedData = [];
    @track isLoading = true;
    visitZoneOptions;
    @track gridData = []; // Data for the tree grid
    @track selectedPreferredContact = [];
    @track isDropdownOpen = false;
    miyoSegmentationOptions = [
        { label: 'No Filter', value: 'No Filter' },
        { label: 'UNCATEGORIZED', value: 'UNCATEGORIZED' },
        { label: 'A1', value: 'A1' },
        { label: 'A2', value: 'A2' },
        { label: 'A3', value: 'A3' },
        { label: 'B1', value: 'B1' },
        { label: 'B2', value: 'B2' },
        { label: 'B3', value: 'B3' },
        { label: 'C1', value: 'C1' },
        { label: 'C2', value: 'C2' },
        { label: 'C3', value: 'C3' }
    ];
    @track columns = [
        { label: this.custLabel.DoctorName, fieldName: 'contactName', type: 'text',isSortedAsc: true, isSortedDesc: false },
        { label: this.custLabel.ClinicName, fieldName: 'accountName', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.City, fieldName: 'shopCity', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.PlaceforVisit, fieldName: 'preferredPlace', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.PreferredContactDayTime, fieldName: 'preferredContactDayTime', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.PrescriberClinic, fieldName: 'contactCount', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.Miyosmart_Segmentation, fieldName: 'miyoSmartSegmentation', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.Miyosmart_Attitude, fieldName: 'miyoSmartAttitude', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.LastVisitDate, fieldName: 'lastContactVisitDate', type: 'date' ,isSortedAsc: false, isSortedDesc: false},
        { label: this.custLabel.ContactOWNER, fieldName: 'ownerName', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.ContactONEKEYID, fieldName: 'onekeyId', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.Street, fieldName: 'shopStreet', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.Zip, fieldName: 'shopPostalCode', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.State, fieldName: 'shopState', type: 'text',isSortedAsc: false, isSortedDesc: false },
        { label: this.custLabel.IndividualStatus, fieldName: 'individualStatus', type: 'text' ,isSortedAsc: false, isSortedDesc: false},
        { label: this.custLabel.CurrentState, fieldName: 'currentState', type: 'text' ,isSortedAsc: false, isSortedDesc: false}
    ];

    sortedFieldName = 'contactName';
    sortedDirection = 'asc';
    @wire(getContactList)
    wiredContacts({ error, data }) {
        if (data) {
            this.contactData = data;
            this.gridData = this.transformData(data);
            console.log('gridData',JSON.stringify(this.gridData));
            this.isLoading = false;
            this.totalPages = Math.ceil(data.length / PAGE_SIZE);
            this.setPaginatedData();
        } else if (error) {
            // Handle error
            this.showToast('Error','Error fetching contact data: ==>'+error.message,'error');
        }
    }
    // Wire Apex method to fetch picklist values
    @wire(getPicklistValues)
    wiredPicklistValues({ error, data }) {
        if (data) {
            // Assign picklist values to the respective combobox options

            const specializationMap = data.specialization;
            const attitudeMap = data.attitude;
            const visitZoneMap = data.visitZone;
            const preferredDayMap = data.preferredDay;

            this.localSpecializationOptions = [
                { label: 'No filter', value: '' },  // Adding 'No filter' option at first
                ...Object.keys(specializationMap).map(key => {
                    return { label: specializationMap[key], value: key };
                })
            ];
            this.miyoAttitudeOptions = [
                { label: 'No filter', value: '' },  // Adding 'No filter' option at first
                ...Object.keys(attitudeMap).map(key => {
                    return { label: attitudeMap[key], value: key };
                })
            ];
            this.visitZoneOptions = [
                { label: 'No filter', value: '' },  // Adding 'No filter' option at first
                ...Object.keys(visitZoneMap).map(key => {
                    return { label: visitZoneMap[key], value: key };
                })
            ];

            this.preferredContactOptions = Object.keys(data.preferredDay).map(key => {
                return { label: preferredDayMap[key], value: key, selected: false };
            });

        } else if (error) {
            this.showToast('Error','Error fetching picklist data: ==>'+error.message,'error');
        }
    }

    handleSorting(event){
        this.isLoading = true;
        const { fieldName, direction } = event.detail;
        this.sortedFieldName = fieldName;
        this.sortedDirection = direction;
        this.filters.sortCondition = fieldName + ' ' + direction;
        this.callApexFilter();  
        this.isLoading = false;
    }

    toggleFilterVisibility() {
        this.showFilters = !this.showFilters; // Toggle filter visibility
        if (this.showFilters) {
            this.toggleButtonText = this.custLabel.Show_Filters;;
        } else {
            this.toggleButtonText = this.custLabel.Hide_Filters;;
        }
    }

    handleRemoveFilters() {
        //To remove selected filters.
        this.isLoading = true;
        this.filters = {};
        this.selectedVisitZone = '';
        this.city = '';
        this.zip = '';
        this.state = '';
        this.selectedSegmentation = '';
        this.selectedAttitude = '';
        this.selectedSpecialization = '';
        this.selectedQuickFilter = '';
        if(this.filters.sortCondition == null || this.filters.sortCondition == undefined){
            this.filters.sortCondition = this.sortedFieldName+' '+this.sortedDirection;
        }
        const inputField = this.template.querySelector('[data-id="quickFilter"]');
        if (inputField) {
            inputField.value = '';  // Clear the input field
        }
        this.callOnLoadFilter();    
    }
    
    callOnLoadFilter(){
        getContactList()
        .then((data) => {
            this.contactData = data;
            this.gridData = this.transformData(data);
            console.log('gridData',JSON.stringify(this.gridData));
            this.isLoading = false;
            this.totalPages = Math.ceil(data.length / PAGE_SIZE);
            this.setPaginatedData();
        })
        .catch((error) => {
            // Handle any errors from the Apex call
            this.showToast('Error','Error fetching contact data: ==>'+error.message,'error');
        })
    }

    // Set data for the current page
    setPaginatedData() {
        const start = (this.currentPage - 1) * PAGE_SIZE;
        const end = this.currentPage * PAGE_SIZE;
        this.paginatedData = this.gridData.slice(start, end);

        // Disable Previous/Next buttons based on the current page
        this.disablePrev = this.currentPage === 1;
        this.disableNext = this.currentPage === this.totalPages;
    }

    // Handle Previous button click
    handlePrevPage() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this.setPaginatedData();
        }
    }

    // Handle Next button click
    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;
            this.setPaginatedData();
        }
    }

    showToast(title,message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }

    // Transform the data to match the lightning-tree-grid format
    transformData(accounts) {
        return accounts.map(account => {
            return {
                acrId: account.acrId,
                accountId: account.accountId,
                accountName: account.accountName,
                shopStreet: account.shopStreet,
                shopCity: account.shopCity,
                shopPostalCode: account.shopPostalCode,
                shopState: account.shopState,
                visitZone: account.visitZone,
                contactCount: account.contacts.length,
                _children: account.contacts.map(contact => {
                    return {
                        childAcrId: contact.childAcrId,
                        contactId: contact.contactId,
                        contactName: contact.contactName,
                        onekeyId: contact.onekeyId,
                        ownerName: contact.ownerName,
                        individualStatus: contact.individualStatus,
                        currentState: contact.currentState,
                        miyoSmartSegmentation: contact.miyoSmartSegmentation,
                        miyoSmartAttitude: contact.miyoSmartAttitude,
                        lastContactVisitDate: contact.lastContactVisitDate,
                        mainStructureName: contact.mainStructureName,
                        specialization: contact.specialization,
                        preferredContactDayTime: contact.preferredContactDayTime,
                        preferredPlace : contact.preferredPlace,
                    };
                })
            };
        });
    }

    //Filter portion
    @track filters = {};  // Store all filters in a single object
    selectedQuickFilter = '';
    connectedCallback() {
        this.filters.sortCondition = this.sortedFieldName + ' ' + this.sortedDirection;
    }
    handleQuickFilterChange(event){
        this.selectedQuickFilter = event.target.value;
    }
    handleSearch(){
        if(this.selectedQuickFilter != ''){
            this.filters.quickFilter = this.selectedQuickFilter;
        }else{
            delete this.filters['quickFilter'];
        }
        this.isLoading = true;
        this.callApexFilter();
    }
    handleCityChange(event) {
        clearTimeout(this.delayTimeout);
        this.filters.city = event.target.value;  // Update city in the filters object
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.callApexFilter();                   // Call Apex with updated filters
        }, 500);
        
    }

    handleZipChange(event) {
        clearTimeout(this.delayTimeout);
        this.filters.zip = event.target.value;   // Update zip in the filters object
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.callApexFilter();
        }, 500);
    }

    handleStateChange(event) {
        clearTimeout(this.delayTimeout);
        this.filters.state = event.target.value; // Update state in the filters object
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.callApexFilter();
        }, 500);
    }

    handleZoneChange(event) {
        clearTimeout(this.delayTimeout);
        this.filters.visitZone = event.target.value; // Update state in the filters object
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.callApexFilter();
        }, 500);
    }

    handleSegChange(event) {
        this.isLoading = true;
        this.selectedSegmentation =  event.target.value; 
        this.filters.miyoSegmentation = event.target.value; // Update state in the filters object
        this.callApexFilter();
    }

    handleTargetContactChange(event) {
        this.isLoading = true;
        this.filters.targetFlag = event.target.checked ; // Update state in the filters object
        this.callApexFilter();
    }

    handleAttitudeChange(event) {
        this.isLoading = true;
        this.selectedAttitude =  event.target.value; 
        this.filters.miyoAttitude = event.target.value; // Update state in the filters object
        this.callApexFilter();
    }

    handleSpecializationChange(event) {
        this.isLoading = true;
        this.selectedSpecialization =  event.target.value; 
        this.filters.localSpecialization = event.target.value; // Update state in the filters object
        this.callApexFilter();
    }

    // This method handles the change in the combobox
    handleComboboxChange(event) {
        const value = event.target.value;
        const selected = event.target.checked;
        this.preferredContactOptions = this.preferredContactOptions.map(option => 
            option.value === value ? { ...option, selected } : option
        );
        // If the value is already selected, remove it (unselect it)
        if (this.selectedPreferredContact.includes(value)) {
            this.selectedPreferredContact = this.selectedPreferredContact.filter(
                (item) => item !== value
            );
        } else {
            // If the value is not selected, add it
            this.selectedPreferredContact = [...this.selectedPreferredContact, value];
        }
        clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.filters.preferredDayTime = JSON.stringify(this.selectedPreferredContact); // Update state in the filters object
            this.callApexFilter();
        }, 1000);

    }
    
    get selectedValues() {
        if (!this.preferredContactOptions) {
            return [];
        }
        return this.preferredContactOptions.filter(option => option.selected).map(option => option.value);
    }

    toggleDropdown() {
        this.isDropdownOpen = !this.isDropdownOpen;
    }
    handleMouseLeave(event) {
        // Only close the dropdown if mouse actually leaves the dropdown area
        const dropdown = this.template.querySelector('.slds-dropdown');
        if (dropdown && !dropdown.contains(event.relatedTarget)) {
            this.isDropdownOpen = false;
        }
    }
    callApexFilter() {
        const filtersList = Object.entries(this.filters).map(([key, value]) => {
            return { key, value };  // Convert filters object to list of key-value pairs
        });

        // Call the Apex method and pass the list of filters
        filterAccounts({ filters: filtersList })
            .then((data) => {
                // Handle the returned account data
                this.contactData = data;
                this.gridData = this.transformData(data);
                this.isLoading = false;
                this.totalPages = Math.ceil(data.length / PAGE_SIZE);
                this.setPaginatedData();
            })
            .catch((error) => {
                // Handle any errors
                this.showToast('Error','Error while  filtering data: ==>'+error.message,'error');
            });
    }
}