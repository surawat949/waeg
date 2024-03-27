import { LightningElement, track, wire } from 'lwc';
import getDynamicTableDataList from '@salesforce/apex/serviceFlow_GenericUtility.GetWrapperOfSObjectFieldColumnActionValues';
import getRecordDetails from '@salesforce/apex/serviceFlow_GenericUtility.getRecordTaskDetails';
import upsertContactRecord from '@salesforce/apex/serviceFlow_GenericUtility.upsertContactRecord';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { NavigationMixin } from 'lightning/navigation';
export default class ServiceFlowTasks extends NavigationMixin(LightningElement) {

    pageSizeOptions = [50, 75, 100, 200]; //Page size options
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page
    sortedBy = "TaskSubtype";
    sortedDirection = "asc";
    isLoading = false;
    searchOptions = [];

    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
    }
    // JS function to handel pagination logic 
    paginationHelperTemp() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.recordsTemp[i]);
        }
    }

    connectedCallback() {
        this.invokeApexMethods();
    }
    handleRefresh(event) {
        this.searchKey = '';
        this.invokeApexMethods();
    }
    async invokeApexMethods() {
        this.isLoading = true;
        try {
            const result = await getDynamicTableDataList({
                TableName: 'My_Tasks',
                orderBy: this.sortedBy,
                direction: this.sortedDirection
            });
            if (result != null) {
                let sObjectRelatedFieldListValues = [];
                for (let row of result.lstDataTableData) {
                    const finalSobjectRow = {}
                    let rowIndexes = Object.keys(row);
                    rowIndexes.forEach((rowIndex) => {
                        const relatedFieldValue = row[rowIndex];
                        if (relatedFieldValue.constructor === Object) {
                            this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)
                        }
                        else {
                            finalSobjectRow[rowIndex] = relatedFieldValue;
                        }

                    });
                    sObjectRelatedFieldListValues.push(finalSobjectRow);
                }
                let actions = [
                    { label: 'View', name: 'view' },
                    { label: 'View in salesforce', name: 'view_in_salesforce' },
                    { label: 'Edit', name: 'edit' },
                    { label: 'Delete', name: 'delete' }
                ];
                let buttons = [{
                    type: 'action',
                    sortable: false,
                    typeAttributes: {
                        rowActions: actions,
                        menuAlignment: 'left'
                    }
                }/*,{ label: 'SUBJECT', fieldName: 'subjectLinkName', type: 'url',
                    typeAttributes: { label: { fieldName: 'Subject' }, target: '_blank'} },*/
                ]

                //result.lstDataTableColumns.push(buttons);

                this.columns = buttons.concat(result.lstDataTableColumns);
                //this.columns = result.lstDataTableColumns;
                let searchOptions = [];
                result.lstDataTableColumns.forEach(function (item) {
                    searchOptions.push({ label: item.label, value: item.fieldName });
                });

                /*this.sortedBy = this.columns[1].fieldName;
                let sObjectRelatedFieldListValuesTemp = [];
                sObjectRelatedFieldListValues.forEach( ( record ) => {
                    let tempRec = Object.assign( {}, record );  
                    tempRec.subjectLinkName = '/lightning/r/Task/' +tempRec.Id+'/view';
                    sObjectRelatedFieldListValuesTemp.push( tempRec );                    
                });
                */
                this.searchOptions = searchOptions;
                console.log("****" + JSON.stringify(sObjectRelatedFieldListValues));
                this.records = sObjectRelatedFieldListValues;
                this.totalRecords = sObjectRelatedFieldListValues.length;
                this.pageSize = this.pageSizeOptions[0];
                this.paginationHelper();
                this.isLoading = false;
            }
        } catch (error) {
            console.log(error);
        } finally {
            console.log('Finally Block');
        }
    }
    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => {
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => {
            let finalKey = fieldName + '.' + key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }
    onSort(event) {
        this.isLoading = true;
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.invokeApexMethods();
        this.isLoading = false;
    }
    searchKey = '';
    searchField = 'None';
    searchResult = [];
    handleSearchFieldChange(event) {
        this.isLoading = true;
        this.searchKey = '';
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'search') {
                element.value = null;
            }
        });
        this.searchField = event.detail.value;
        if (this.searchField == 'None') {
            this.handleSearchKeyChange();
        }
        this.searchResult = [];
        this.isLoading = false;
    }
    recordsTemp = [];
    handleSearchKeyChange(event) {
        this.isLoading = true;
        let allRecords = this.records;
        let tempArray = [];
        if (event != undefined) {
            this.searchKey = event.target.value;
            let upperCaseSearchKey = this.searchKey.toUpperCase();
            let i;
            for (i = 0; i < allRecords.length; i++) {
                if (allRecords[i][this.searchField] && allRecords[i][this.searchField].toUpperCase().indexOf(upperCaseSearchKey) != -1) {
                    tempArray.push(allRecords[i]);
                }
            }
        }
        if (this.searchField == 'None') {
            tempArray = allRecords;
        }
        this.recordsTemp = tempArray;
        this.totalRecords = tempArray.length;
        this.pageSize = this.pageSizeOptions[0];
        this.paginationHelperTemp();
        this.isLoading = false;
    }
    recordId;
    viewFieldsHistory = false;
    handleRowActions(event) {
        this.isLoading = true;
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.recordId = row.Id;
        switch (actionName) {
            case 'view':
                /*this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });*/
                this.getRecordDetailsUtility();
                this.viewFieldsHistory = true;
                this.isLoading = false;
                break;
            case 'view_in_salesforce':
                //this.getRecordDetailsUtility();
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });
                //this.viewFieldsHistory = true;
                this.isLoading = false;
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'Case',
                        actionName: 'edit'
                    }
                });
                this.isLoading = false;
                break;
            case 'delete':
                //this.delAccount(row);
                this.isLoading = false;
                break;
        }
    }
    showModalBox() {
        this.viewFieldsHistory = true;
    }

    hideModalBox() {
        this.viewFieldsHistory = false;
    }
    recordDetails = [];
    ContactId;
    selectedTaskId;
    async getRecordDetailsUtility() {
        const result = await getRecordDetails({
            recordId: this.recordId
        });
        if (result != null) {
            this.ContactId = result.ContactId;
            this.selectedTaskId = result.Id;
            let detailedDetails = [];
            for (const [key, value] of Object.entries(result)) {
                if (!key.includes('Id')) {
                    detailedDetails.push({ label: key.replaceAll('_', ' ').toUpperCase(), value: value });
                }
            }
            console.log(JSON.stringify(detailedDetails));
            this.recordDetails = detailedDetails;
        }
    }
    async handleSubmit(event) {
        event.preventDefault();   
        const fields = event.detail.fields;   
        fields.sobjectType = "Contact";    
        if(this.ContactId){
            fields.Id = this.ContactId;
        }
        this.isLoading = true;
        try {
            const result = await upsertContactRecord({
                record : fields,
                taskId : this.selectedTaskId
            });
            this.isLoading = false;
        } catch (error) {
            console.log(error);
        } finally {
            console.log('Finally Block');
            this.viewFieldsHistory = false;
            this.invokeApexMethods();
        }
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    handleSuccess( event ) {        
        this.dispatchEvent(
            new ShowToastEvent( {
                title: 'Contact Information',
                message: 'Contact submitted successfully',
                variant: 'success',
                mode: 'sticky'
            } )
        );

    }
}