import { api} from 'lwc';
import LightningModal from 'lightning/modal';
import { loadScript } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import label_save from '@salesforce/label/c.tabLabelSave';
import visitPopup from '@salesforce/label/c.New_Visit';
import visitDetail from '@salesforce/label/c.Visit_Detail';
import schedule from '@salesforce/label/c.Schedule';
import visit_Preparation from '@salesforce/label/c.Visit_Preparation';
import cancel from '@salesforce/label/c.ButtonCancel';
//Apex
import getContacts from '@salesforce/apex/FullCalenderV2Controller.getContactsForAccount';
import createVisit from '@salesforce/apex/FullCalenderV2Controller.createVisit';
import getRecordTypeId from '@salesforce/apex/EyeDoctorVisitPlanningController.getRecordTypeId'; // Apex method import

export default class VisitCreatePopup extends LightningModal{
    @api visit;
    @api disableContact = false;
    isValidationSuccess =true;
    isLoading;
    assignedTo;
    accountId;
    start;
    contact;
    end;
    visitReason;
    contactList = [];
    isAllDay =false;
    visitType;
    coachingVisit =false;
    notes;
    recordTypeId = '';
    CustLabel ={label_save,visitPopup,visitDetail,schedule,visit_Preparation,cancel};
    connectedCallback(){
        loadScript(this, FullCalendarJS + '/moment.min.js')
        .then(()=>{
           loadScript(this, FullCalendarJS + '/moment-timezone-with-data.min.js')
           .then(()=>{
               console.log('All moment loaded');
           });
        });
        console.log('this.visit'+JSON.stringify(this.visit));
        this.assignedTo = this.visit.Assigned_to__c;
        this.accountId = this.visit.Account__c;
        this.start = this.visit.Start_Time__c;
        this.end = this.visit.End_Time__c;
        this.visitType = 'Visit';
        if(this.visit.recordTypeId){
            this.recordTypeId = this.visit.recordTypeId;
        }else{
            this.fetchStandardRecordTypeId();
        }
                console.log('Record type check completed');
        if(this.visit.Contact__c){
                            console.log('inside visit contact');
            this.contactList = [{ label: this.visit.AccountName, value: this.visit.Contact__c },...this.contactList];
            console.log('inside visit contact2'+JSON.stringify(this.contactList));
            this.contact = this.visit.Contact__c;
            console.log('inside visit contact3'+this.contact);
        }else{
            getContacts({ accountId: this.accountId})
            .then(response => {
                var result = response;
                this.contactList = result;
                if(this.contact && this.contactList.length>0){
                    const contactExists = this.contactList.find(item => item.value === this.contact);
                    if(!contactExists){
                        const conExisting = { label: this.visit.AccountName, value: this.contact };
                        this.contactList = [conExisting,...this.contactList];
                    }
                }

            }).catch(error => {
                this.showToast('Error', 'Error', error.message);
            }) 
        }
    }  
    
    fetchStandardRecordTypeId() {
        getRecordTypeId({ objectName: 'Visits__c', developerName: 'Standard_Visit' })
        .then((result) => {
            this.recordTypeId = result;
        })
        .catch((error) => {
            console.error('Error fetching record type ID:', error);
        });
    }
    closePopup() {
        this.close();
    }   
    handleContactChange(event){
        this.contact = event.detail.value;
    }
    handleVisitType(event){
        this.visitType = event.detail.value;
    }
    handleStart(event){
        var startChange = event.detail.value;
        this.start = moment(startChange).utc(false).format();
    }
    handleEnd(event){
        var endChange = event.detail.value;
        this.end = moment(endChange).utc(false).format();
    }
    handleAllDayEvent(event){
        this.isAllDay = event.target.value;
    }
    handleVisitReason(event){
        this.visitReason = event.detail.value;
    }
    handleCoachingVisit(event){
        this.coachingVisit = event.target.value;
    }
    handleNotes(event){
        this.notes = event.detail.value;
    }
    handleCreateVisit(event){
        event.preventDefault();
        this.isValidationSuccess = true;
        this.template.querySelector('[data-id="formerror"]').setError(null);
        var inputCmp = this.template.querySelector('.visitType');
        var visitType = inputCmp.value;
        if (visitType == '' || visitType == null ) {
            this.template.querySelector('[data-id="formerror"]').setError('Please select Visit Type');
            this.isValidationSuccess = false;
        }         
        var reason = this.template.querySelector('.reason');
        var reasonVal = reason.value;
        if (reasonVal == '' || reasonVal == null ) {
            this.template.querySelector('[data-id="formerror"]').setError('Please select Visit Main Objective');
            this.isValidationSuccess = false;
        }  
        if(this.isValidationSuccess){
            this.isLoading =true; 
            if(this.visit && this.visit.recordTypeId){
                this.recordTypeId = this.visit.recordTypeId;
            }
            createVisit({
                accId:this.accountId,
                visitType:this.visitType,
                conId:this.contact,
                assignedTo:this.assignedTo,
                coachingEvent:this.coachingVisit,
                startTime:this.start,
                endTime:this.end,
                isAllDay:this.isAllDay,
                visitReason :this.visitReason,
                notes:this.notes,
                recordTypeId : this.recordTypeId
            }).then(result=>{      
                this.isLoading =false;
                this.closePopup();
            }).catch(error=>{               
                var errorMessage=''; 
                var msg=error.body.message;
                if(msg.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                    const index = msg.indexOf("EXCEPTION,");
                    errorMessage = msg.substring(index + 10);
                } 
                this.showToast('Error', 'Error', errorMessage); 
                this.isLoading =false;              
            });
        }
    }   
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: 'dismissable'
            }),
        );
    }   
}