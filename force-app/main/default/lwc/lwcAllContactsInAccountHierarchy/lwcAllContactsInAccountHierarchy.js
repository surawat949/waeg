import { LightningElement, api, track } from 'lwc';
import getAllContactsInHierarchy from '@salesforce/apex/ContactsInAccountHierarchy.getAllContactsInHierarchy';

export default class LwcAllContactsInAccountHierarchy extends LightningElement {
    @api recordId;
    @track mycolumns = [];
    @track contactList = [];
    @track isExpanded = true;
    iconName = 'utility:chevrondown';
    @api inputTitle = 'All associated Active Contacts';

    connectedCallback() {
        this.doInit();
    }

    doInit() {
        if (this.recordId) {
            this.mycolumns = [
                { label: 'Contact', fieldName: 'ContactId', type: 'url', typeAttributes: { label: { fieldName: 'ContactName' }, target: '_blank' },wrapText: true },
                { label: 'Contact Owner', fieldName: 'OwnerId', type: 'url', typeAttributes: { label: { fieldName: 'OwnerName' }, target: '_blank' },wrapText: true },
                { label: 'Account', fieldName: 'AccountId', type: 'url', typeAttributes: { label: { fieldName: 'AccountName' }, target: '_blank' },wrapText: true },
                { label: 'Preferred Place for Visit', fieldName: 'PreferredPlace', type: 'text',wrapText: true },
                { label: 'Street', fieldName: 'Street', type: 'text',wrapText: true },
                { label: 'City', fieldName: 'City', type: 'text',wrapText: true },
                { label: 'State', fieldName: 'State', type: 'text',wrapText: true },
                { label: 'Account Phone', fieldName: 'Phone', type: 'text',wrapText: true },
                { label: 'Contact Role', fieldName: 'Role', type: 'text',wrapText: true }
            ];
            this.getContactList();
        }
    }

    getContactList() {
        getAllContactsInHierarchy({ accountId: this.recordId })
            .then(result => {
                let data = [];
                result.forEach(row => {
                    let obj = {
                        ContactId: '/' + row.contactId,
                        ContactName: row.ContactName,
                        AccountId: '/' + row.AccountId,
                        AccountName: row.AccountName,
                        OwnerId: '/' + row.OwnerId,
                        OwnerName: row.OwnerName,
                        PreferredPlace: row.PreferredPlace,
                        Street: row.Street,
                        City: row.City,
                        State: row.State,
                        Phone: row.Phone,
                        Role: row.Role
                    };
                    data.push(obj);
                });
                this.contactList = data;
            })
            .catch(error => {
                console.error('Error fetching contact list', error);
            });
    }

    toggleSection() {
        this.isExpanded = !this.isExpanded;
        if (this.isExpanded) {
            this.iconName = 'utility:chevrondown';
        } else {
            this.iconName = 'utility:chevronright';
        }
    }
}