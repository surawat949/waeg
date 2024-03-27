import { LightningElement,api, track, wire } from 'lwc';
import getDynamicTableDataList from '@salesforce/apex/serviceFlow_ServicesOperations.GetWrapperOfSObjectFieldColumnActionValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { NavigationMixin } from 'lightning/navigation';
export default class ServiceFlow_ServicesOpenationsOpen extends NavigationMixin(LightningElement) {

    pageSizeOptions = [50, 75, 100, 200]; 
    records = []; 
    columns = []; 
    totalRecords = 0; 
    pageSize; 
    totalPages; 
    pageNumber = 1; 
    recordsToDisplay = []; 
    sortedBy = "CaseNumber";
    sortedDirection = "asc";
    isLoading = false;
    searchOptions = [];
    @api recordId;
    @api eventType;
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
    handleRefresh(event){
        this.searchKey = '';
        this.invokeApexMethods();
    }
    async invokeApexMethods() {
        this.isLoading = true;
        try {
            const result = await getDynamicTableDataList({
                TableName: 'Case_List',
                recordId : this.recordId,
                orderBy: this.sortedBy,
                direction: this.sortedDirection,
                eventType : this.eventType
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
                    { label: 'View in salesforce', name: 'View_in_salesforce' },
                    { label: 'Edit', name: 'edit' }
                ];
                let buttons = [{
                    type: 'action',
                    sortable: false,
                    typeAttributes: {
                        rowActions: actions,
                        menuAlignment: 'left'
                    }
                }/*,{ label: 'CASE NUMBER', fieldName: 'caseNumberLink', type: 'url',
                    typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_blank'} },*/
                ]

                //result.lstDataTableColumns.push(buttons);

                this.columns = buttons.concat(result.lstDataTableColumns);
                //this.columns = result.lstDataTableColumns;
                let searchOptions = [];
                result.lstDataTableColumns.forEach(function (item) {
                    searchOptions.push({ label: item.label, value: item.fieldName });
                });

                //this.sortedBy = this.columns[1].fieldName;
                let sObjectRelatedFieldListValuesTemp = [];
                sObjectRelatedFieldListValues.forEach( ( record ) => {
                    let tempRec = Object.assign( {}, record );  
                    tempRec.caseNumberLink = '/lightning/r/Case/' +tempRec.Id+'/view';
                    sObjectRelatedFieldListValuesTemp.push( tempRec );                    
                });

                this.searchOptions = searchOptions;
                this.records = sObjectRelatedFieldListValuesTemp;
                this.totalRecords = sObjectRelatedFieldListValuesTemp.length;
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
    caseRecordId;
    viewFieldsHistory = false;
    handleRowActions(event) {
        debugger;
        this.isLoading = false;
        const actionName = event.detail.action.name;        
        const row = event.detail.row;
        this.caseRecordId = row.Id;
        switch (actionName) {
            case 'view':
                this.viewFieldsHistory = true;
                this.isLoading = false;
                break;                
            case 'View_in_salesforce':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });
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
}