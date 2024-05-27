import { api} from 'lwc';
import LightningModal from 'lightning/modal';
import { loadScript } from 'lightning/platformResourceLoader';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendar';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import label_save from '@salesforce/label/c.tabLabelSave';
import visitPopup from '@salesforce/label/c.Visit_Popup';
import visitDetail from '@salesforce/label/c.Visit_Detail';
import schedule from '@salesforce/label/c.Schedule';
import visit_Preparation from '@salesforce/label/c.Visit_Preparation';
import cancel from '@salesforce/label/c.ButtonCancel';
//Apex
import getContacts from '@salesforce/apex/FullCalenderV2Controller.getContactsForAccount';
import createVisit from '@salesforce/apex/FullCalenderV2Controller.createVisit';
export default class VisitCreatePopup extends LightningModal{
    @api visit;
    isValidationSuccess =true;
    isLoading;
    assignedTo;
    accountId;
    start;
    contact;
    end;
    visitReason;
    contactList;
    isAllDay =false;
    visitType;
    coachingVisit =false;
    notes;
    CustLabel ={label_save,visitPopup,visitDetail,schedule,visit_Preparation,cancel};
    connectedCallback(){
        loadScript(this, FullCalendarJS + '/moment.min.js')
        .then(()=>{
           loadScript(this, FullCalendarJS + '/moment-timezone-with-data.min.js')
           .then(()=>{
               console.log('All moment loaded');
           });
        });
        this.assignedTo = this.visit.Assigned_to__c;
        this.accountId = this.visit.Account__c;
        this.start = this.visit.Start_Time__c;
        this.end = this.visit.End_Time__c;
        this.visitType = 'Visit';
        getContacts({ accountId: this.accountId})
        .then(response => {
            var result = response;
            console.log(result);
            this.contactList = result;
        }).catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
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
                notes:this.notes 
            }).then(result=>{      
                this.isLoading =false;
                this.closePopup();
            }).catch(error=>{
                this.showToast('Error', 'Error', error.message);                
            });
        }
    }   
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}