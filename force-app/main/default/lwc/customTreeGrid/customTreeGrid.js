import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendar5';

export default class CustomTreeGrid extends  NavigationMixin(LightningElement) {
    isJQueryUIInitialized = false;
    initialisedCalendar = false;
    @api columns;
    @api 
    set tabledata(val){
        this._tabledata = val;
        this.initializeData();
    } 

    get tabledata(){
        return this._tabledata;
    } 

    get firstRowCells() {
        return this.rowsWithIcons.length > 0 ? this.tabledata[0].cells : [];
    }

    isFirstRecord(index) {
        return index === 0;
    }


    @api width = '100%';

    @track rowsWithIcons = [];

    @track sortedBy = 'contactName';  // Default sorted column
    @track sortedDirection = 'asc';  // Default sorted direction

    handleSort(event) {
        const fieldName = event.currentTarget.dataset.field;
        let fieldstoExclude = ['preferredContactDayTime','contactCount']
        if(!fieldstoExclude.includes(fieldName)){
            // Toggle sorting direction or set a new sorting field
            if (this.sortedBy === fieldName) {
                this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
            } else {
                this.sortedBy = fieldName;
                this.sortedDirection = 'asc'; // Default to ascending
            }

            // Update the columns to reflect the current sorting state
            this.updateColumnSortingState();

            // Trigger the sorting logic
            this.sortData();
        }
    }

    handleRowAction(event) {
        event.preventDefault();
        console.log('row called');
        const row = event.currentTarget.dataset.recordId;
        console.log('row'+row);
        this.navigateToRecordPage(row);
        //this.selectedListView = this.listViewName;
    }

     sortData() {
        this.dispatchEvent(new CustomEvent('sortchange', {
            detail: {
                fieldName: this.sortedBy,
                direction: this.sortedDirection
            }
        }));
    }

     updateColumnSortingState() {
        this.columns = this.columns.map(col => {
            return {
                ...col,
                isSortedAsc: this.sortedBy === col.fieldName && this.sortedDirection === 'asc',
                isSortedDesc: this.sortedBy === col.fieldName && this.sortedDirection === 'desc'
            };
        });
    }
    renderedCallback(){
         if (this.isJQueryUIInitialized) {
            return;
        }
        Promise.allSettled([
            loadScript(this, FullCalendarJS + '/lib/main.js'),
            loadStyle(this, FullCalendarJS + '/lib/main.css')
        ])
        .then(() => {
            let that = this;
            this.isJQueryUIInitialized = true;
            setTimeout(function(){
                that.initializeData();
            },1000)
        })
        .catch(error => {
            this.showToast('Error','Error loading jQuery and jQuery UI: ==>'+error.message,'error');
        });
    }

    initializeDraggable() {
        console.log('initializeDraggable');
        var allElements = this.template.querySelectorAll('.accheadersection');
        allElements.forEach(element => {
            if (FullCalendar && element && !element.dataset.draggableInitialized) {
                FullCalendar.Draggable(element, {
                    itemSelector: '.draggable-row',
                    eventData: function(eventEl) {
                        return {
                            title: eventEl.dataset.name,
                            contactId: eventEl.dataset.id,
                            accountId: eventEl.dataset.accountId
                        };
                    }
                });
                element.setAttribute('data-draggable-initialized', 'true');
            }   
        });
    }

    initializeData() {
        console.log('initializzee'+JSON.stringify(this.tabledata));
        this.rowsWithIcons = this.tabledata.map(item => ({
            id: item.accountId,
            acrId: item.acrId,
            isExpanded: false,
            iconName: 'utility:chevronright',
            children: (item._children || []).map(child => ({
                    id: child.contactId,
                    contactName:child.contactName ? child.contactName : '',
                    accountId: item.accountId,
                    accountName: item.accountName,
                    childAcrId: child.childAcrId,
                    recordUrl: '/lightning/r/Contact/'+child.contactId+'/view',
                    cells: this.columns.map((col, index) => ({
                        fieldName: col.fieldName,
                        value: ['shopStreet', 'shopCity', 'shopPostalCode', 'shopState', 'accountName', 'contactCount'].includes(col.fieldName)
                            ? (item[col.fieldName] !== undefined && item[col.fieldName] !== null) ? item[col.fieldName].toString() : ''
                            : ((child[col.fieldName] !== undefined && child[col.fieldName] !== null) ? child[col.fieldName].toString() : ''),
                        cssClass: col.fieldName === 'contactName' ? 'slds-text-left sticky-column' : 'slds-text-left',
                        nameField : col.fieldName === 'contactName' ? true : false,
                    }))
                }))
        }));
        console.log('rowsWithIcons'+JSON.stringify(this.rowsWithIcons));
        let that = this;
        setTimeout(function(){
            that.initializeDraggable();
        },100);
    }
    navigateToRecordPage(recordId) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Contact',
                actionName: 'view',
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }

    get containerStyle() {
        return `width: ${this.width}; overflow: auto;`;
    }

    handleExpandCollapse(event) {   
        const index = event.target.dataset.index;
        console.log('indexnew'+index);         
        this.rowsWithIcons = this.rowsWithIcons.map(item => {
            if (item.acrId === index) {
                return {
                    ...item,
                    isExpanded: !item.isExpanded,
                    iconName: !item.isExpanded ? 'utility:chevrondown' : 'utility:chevronright'
                };
            }
            return item;
        });

       let that = this;
        setTimeout(function(){
          that.initializeDraggable();
        },100);
        
    }









    /*handleExpandCollapse(event) {
    try {
        const index = event.target.dataset.index;
        console.log('async index:', index);
        const rowIndex = parseInt(index, 10);

        // Validate the index
        if (isNaN(rowIndex) || rowIndex < 0 || rowIndex >= this.rowsWithIcons.length) {
            console.error('Invalid row index:', rowIndex);
            return; // Stop if index is invalid
        }



        console.log('this.rowsWithIcons[index]:', JSON.stringify(this.rowsWithIcons[index]));
        let rowtoUpdate = this.rowsWithIcons[index];
        rowtoUpdate.isExpanded = !rowtoUpdate.isExpanded;
        rowtoUpdate.iconName = !rowtoUpdate.isExpanded ? 'utility:chevrondown' : 'utility:chevronright'
        this.rowsWithIcons[index] = { ...this.rowsWithIcons[index], ...rowtoUpdate };
        this.rowsWithIcons = [... this.rowsWithIcons ];
        console.log('this.rowsWithIcons[index]: Updated', JSON.stringify(this.rowsWithIcons[index]));
            // Reassign the array to trigger reactivity
        // Use async/await pattern
        //await this.updateRowsWithIcons(rowIndex);

        // Use setTimeout wrapped in a Promise for asynchronous delay
        //await this.delay(100);

        // Call the initializeDraggable method asynchronously
        //await this.initializeDraggable();

    } catch (error) {
        console.error('Error in handleExpandCollapse:', error);
    }
    }*/

// Async helper to update rowsWithIcons
updateRowsWithIcons(rowIndex) {
    return new Promise((resolve) => {
        this.rowsWithIcons = this.rowsWithIcons.map((item, idx) => {
            console.log(`Processing row at index: ${idx}`); // Log the index being processed
            if (idx === rowIndex) {
                console.log(`Toggling expansion for row at index: ${rowIndex}`); // Log when the match is found
                console.log(`Current state isExpanded: ${item.isExpanded}, iconName: ${item.iconName}`); // Log current state
                const updatedItem = {
                    ...item,
                    isExpanded: !item.isExpanded,
                    iconName: !item.isExpanded ? 'utility:chevrondown' : 'utility:chevronright'
                };
                console.log(`Updated state isExpanded: ${updatedItem.isExpanded}, iconName: ${updatedItem.iconName}`); // Log updated state
                return updatedItem;
            }
            return item;
        });

        resolve(); // Resolve the promise once the mapping is done
    });
}

// Helper to introduce a delay (simulating setTimeout in async/await)
delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

}