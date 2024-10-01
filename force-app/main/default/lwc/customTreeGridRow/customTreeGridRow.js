import { LightningElement, api, track } from 'lwc';

export default class CustomTreeGridRow extends LightningElement {
    @api rowData;
    @api columns;
    @api level;

    @track isExpanded = false;

    get columnValues() {
        // Process columns to get cell values
        return this.columns.map(col => ({
            fieldName: col.fieldName,
            value: this.rowData[col.fieldName] || ''  // Handle missing fields gracefully
        }));
    }

    get nextLevel() {
        return this.level + 1;
    }

    get isDraggable() {
        return this.columns.some(col => col.type === 'text');
    }

    get isExpandable() {
        return this.rowData.contacts && this.rowData.contacts.length > 0;
    }

    get toggleButtonLabel() {
        return this.isExpanded ? '-' : '+';
    }

    handleDragStart(event) {
        event.dataTransfer.setData('text/plain', this.rowData.accountId);
    }

    toggleRow() {
        this.isExpanded = !this.isExpanded;
        const eventDetail = { id: this.rowData.accountId };
        const customEvent = new CustomEvent(this.isExpanded ? 'rowexpanded' : 'rowcollapsed', { detail: eventDetail });
        this.dispatchEvent(customEvent);
    }
}