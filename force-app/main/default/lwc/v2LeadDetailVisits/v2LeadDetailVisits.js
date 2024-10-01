import { LightningElement, api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import Visit_Warning_Message from '@salesforce/label/c.Visit_Warning_Message';
import Reports_Visit_ID from '@salesforce/label/c.Reports_Visit_ID';
import Reports_Start from '@salesforce/label/c.Reports_Start';
import VisitType from '@salesforce/label/c.VisitType';
import VisitObj from '@salesforce/label/c.VisitObj';
import VisitStatus from '@salesforce/label/c.VisitStatus';
import Lead_Visit_Account_Discovery from '@salesforce/label/c.Lead_Visit_Account_Discovery';

import Id from "@salesforce/user/Id";
import visits from '@salesforce/label/c.visits';
import label_new from '@salesforce/label/c.NewButtonRelatedList';
import getReportEvents from '@salesforce/apex/V2LeadDetailController.getReportEvents';
import getDefaultRecordTypeForEvents from '@salesforce/apex/V2LeadDetailController.getDefaultRecordTypeForEvents';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
export default class V2LeadDetailVisits extends NavigationMixin(LightningElement) {
    @api recordId;
    @track visitData;
    @track visitCount = 0;
    @track userId = Id;
    @track IsNewVisitCreate = false;
    @api visit = {};
    @track recordTypeId;
    CHANNEL_NAME = '/event/Refresh_Related_List_Events__e';
    label = {
        Reports_Visit_ID,
        Reports_Start,
        VisitType,
        VisitObj,
        VisitStatus,
        Visit_Warning_Message,
        visits,
        label_new,
        Lead_Visit_Account_Discovery
    }
    @track visitColumns = [{
            label: this.label.Reports_Visit_ID,
            fieldName: 'nameLink',
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'VisitId'
                },
                target: '_top'
            },
            sortable: true
        },
        {
            label: this.label.Reports_Start,
            fieldName: 'Start',
            type: 'text',
            sortable: true
        },
        {
            label: this.label.VisitType,
            fieldName: 'VisitType',
            type: 'text',
            sortable: true
        },
        {
            label: this.label.VisitObj,
            fieldName: 'VisitObjective',
            type: 'text',
            sortable: true,
            wrapText: true
        },
        {
            label: this.label.VisitStatus,
            fieldName: 'Status',
            type: 'text',
            sortable: true
        }
    ];
    connectedCallback() {
        this.getDefaultRecordTypeForEvents();
        this.getReportEvents();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
            let triggerAlert = true;
            if (errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none") {
                triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); // 20000 milliseconds = 20 seconds
            }
            if (triggerAlert) {
                this.showToast("Error", JSON.stringify(errorData.error), "error");
            }
        });
    }
    refreshList = event => {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Record_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Record_ID__c === this.recordId) {
            this.getReportEvents();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
    getDefaultRecordTypeForEvents() {
        getDefaultRecordTypeForEvents({
                recordTypeName: "Lead_Visits"
            })
            .then(response => {
                this.recordTypeId = response;
            }).catch(error => {
                this.showToast('Error', 'Error', error.body.message);
            })
    }
    getReportEvents() {
        getReportEvents({
                leadId: this.recordId
            })
            .then(response => {
                response = JSON.parse(JSON.stringify(response));
                response.forEach(res => {
                    res.nameLink = '/' + res.Id;
                });
                this.visitData = response;
                let allVisit = response;
                this.visitData = allVisit;
                if (allVisit.length > 5) {
                    this.visitCount = '5+';
                } else {
                    this.visitCount = allVisit.length;
                }
            }).catch(error => {
                this.showToast('Error', 'Error', error.body.message);
            })
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    navigateVisitCreatePage(event) {
        this.navigateToNewPage('Event');
    }
    navigateToNewPage(objectName) {
        const defaultValues = encodeDefaultFieldValues({
            WhoId: this.recordId,
            OwnerId: this.userId,
            Subject: this.label.Lead_Visit_Account_Discovery
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: objectName,
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                recordTypeId: this.recordTypeId,
                useRecordTypeCheck: 1,
                navigationLocation: 'RELATED_LIST'
            }
        });
    }
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {});
    }
}