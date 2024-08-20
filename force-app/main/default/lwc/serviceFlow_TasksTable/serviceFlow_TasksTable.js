import { LightningElement } from 'lwc';
import initRecords from '@salesforce/apex/serviceFlow_TasksTableHandler.initRecords';
import getTasks from '@salesforce/apex/serviceFlow_TasksTableHandler.getTasks';
export default class ServiceFlow_TasksTable extends LightningElement {
    status = 'New';
    columns = [];
    _recordCount;
    data = [];
    items = [];
    fieldOptions = [];
    statusAggregate = [];
    error;
    totalNumberOfRows = 100; // stop the infinite load after this threshold count
    recordCount = 100;
    loadMoreStatus;
    totalRecountCount = 0;
    targetDatatable; // capture the loadmore event to fetch data and stop infinite loading
    searchFieldName = 'CallType';
    searchKey = '';
    connectedCallback() {
        //this.getData();
        this.invokeApexMethods();
    }
    async handleSearchOptionChange(event) {
        try {
            const records = await getTasks({
                ObjectName: 'Task',
                status: event.currentTarget.dataset.value
            });
            let result = JSON.parse(JSON.stringify(records));
            this._recordCount = result.length > 0 ? result.length : 0;
            this.totalRecountCount = this._recordCount;

            this.data = [];
            this.items = [];

            if (result.length > 0) {
                this.items = [...this.items, ...result];
                this.data = this.items.slice(0, this.recordCount);
                this.error = undefined;
                console.log('Method result: ' + JSON.stringify(result));
            } else {
                this.data = [];
                this.items = [];
                this.error = undefined;
                console.log('Method result: else ' + JSON.stringify(result));
            }

        } catch (error) {
            console.log(error);
            this.error = error;
            this.data = undefined;
            this.items = undefined;
        } finally {
            console.log('Finally Block');
        }
    }
    searchValue = '';
    getSearchkey(event) {
        this.searchValue = event.detail.value;
    }
    handleSearchKeyChange(event) {
        if (event.keyCode === 13) {
            alert(this.searchValue + "******" + this.searchFieldName)
            this.data = [];
            let allRecords = JSON.parse(JSON.stringify(this.items));
            let selectedFilterField = this.searchFieldName;
            let searchFilter = this.searchValue;
            let tempArray = allRecords.filter(element => {
                if (element[selectedFilterField]) {
                    return element[selectedFilterField].toLowerCase().indexOf(searchFilter.toLowerCase()) != -1;
                }
            });
            this.data = tempArray
            /*this.totalRecountCount = tempArray.length;
            console.log("tempArray******"+JSON.stringify(tempArray));
            this.recordCount = (this.recordCount > this.totalRecountCount) ? this.totalRecountCount : this.recordCount; 
            this.data = tempArray.slice(0, this.recordCount);
            this.loadMoreStatus = '';
            if (this.targetDatatable){
                this.targetDatatable.isLoading = false;
            }*/
        }
    }
    handleFieldChange(event) {
        this.searchFieldName = event.detail.value;
    }
    async invokeApexMethods() {
        try {
            const records = await initRecords({
                ObjectName: 'Task'
            });
            let result = JSON.parse(JSON.stringify(records));
            this.columns = result.ldwList;
            this._recordCount = result.totalCount;
            this.statusAggregate = result.aggregateResult;
            this.totalRecountCount = result.totalCount;
            this.items = [...this.items, ...result.sobList];
            this.data = this.items.slice(0, this.recordCount);
            this.error = undefined;
            let optionsTemp = [];
            if (result.ldwList.length > 0) {
                for (let labelRec of result.ldwList) {
                    optionsTemp.push({ label: labelRec.label, value: labelRec.fieldName });
                }
                console.log(JSON.stringify(optionsTemp));
                this.fieldOptions = optionsTemp;
            }
        } catch (error) {
            console.log(error);
            this.error = error;
            this.data = undefined;
            this.items = undefined;
        } finally {
            console.log('Finally Block');
        }
    }
    getRecords() {
        this.recordCount = (this.recordCount > this.totalRecountCount) ? this.totalRecountCount : this.recordCount;
        this.data = this.items.slice(0, this.recordCount);
        this.loadMoreStatus = '';
        if (this.targetDatatable) {
            this.targetDatatable.isLoading = false;
        }
    }
    // Event to handle onloadmore on lightning datatable markup
    handleLoadMore(event) {
        event.preventDefault();
        // increase the record Count by 20 on every loadmore event
        this.recordCount = this.recordCount + 20;
        //Display a spinner to signal that data is being loaded
        event.target.isLoading = true;
        //Set the onloadmore event taraget to make it visible to imperative call response to apex.
        this.targetDatatable = event.target;
        //Display "Loading" when more data is being loaded
        this.loadMoreStatus = 'Loading';
        // Get new set of records and append to this.data
        this.getRecords();
    }
}