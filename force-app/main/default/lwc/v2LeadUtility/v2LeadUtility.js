import { LightningElement, api } from 'lwc';
import fetchRecords from '@salesforce/apex/V2LeadDetailController.fetchRecords';
const DELAY = 500;

export default class V2LeadUtility extends LightningElement {
    @api label = "";
    @api required;
    @api recordId;
    @api selectedIconName = "";
    @api objectLabel = "";
    recordsList = [];
    selectedRecordName;
    @api objectApiName = "";
    @api fieldApiName = "";
    @api searchString = "";
    @api selectedRecordId = "";
    preventClosingOfSerachPanel = false;

    get methodInput() {
        return {
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            searchString: this.searchString,
            selectedRecordId: this.selectedRecordId,
            recordId: this.recordId
        };
    }

    get showRecentRecords() {
        if (!this.recordsList) {
            return false;
        }
        return this.recordsList.length > 0;
    }
    connectedCallback() {
        if (this.selectedRecordId || this.recordId) {
            this.fetchSobjectRecords(true);
        }
    }
    fetchSobjectRecords(loadEvent) {
        fetchRecords({
            inputWrapper: this.methodInput
        }).then(result => {
            if (loadEvent && result) {
                this.selectedRecordName = result[0].sObjectRecord.Name;
            } else if (result) {
                this.recordsList = JSON.parse(JSON.stringify(result));
            } else {
                this.recordsList = [];
            }
        }).catch(error => {
            console.log(error);
        })
    }

    get isValueSelected() {
        return this.selectedRecordId;
    }
    handleChange(event) {
        this.searchString = event.target.value;
        this.fetchSobjectRecords(false);
    }
    handleBlur() {
        this.recordsList = [];
        this.preventClosingOfSerachPanel = false;
    }
    handleDivClick() {
        this.preventClosingOfSerachPanel = true;
    }
    handleCommit() {
        let selectedRecord = {
            mainField: "",
            subField: "",
            id: ""
        };
        this.selectedRecordId = "";
        this.selectedRecordName = "";
        const selectedEvent = new CustomEvent('valueselected', {
            detail: selectedRecord
        });
        this.dispatchEvent(selectedEvent);
    }
    handleSelect(event) {
        let selectedRecord = {
            mainField: event.currentTarget.dataset.mainfield,
            subField: event.currentTarget.dataset.subfield,
            id: event.currentTarget.dataset.id
        };
        this.selectedRecordId = selectedRecord.id;
        this.selectedRecordName = selectedRecord.mainField;
        this.recordsList = [];
        const selectedEvent = new CustomEvent('valueselected', {
            detail: selectedRecord
        });
        this.dispatchEvent(selectedEvent);
    }
    handleInputBlur(event) {
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            if (!this.preventClosingOfSerachPanel) {
                this.recordsList = [];
            }
            this.preventClosingOfSerachPanel = false;
        }, DELAY);
    }
}