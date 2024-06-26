import { wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import LightningModal from 'lightning/modal';
import userId from "@salesforce/user/Id";
import userName from '@salesforce/schema/User.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

//Custom labels
import label_save from '@salesforce/label/c.tabLabelSave';
import cancel from '@salesforce/label/c.ButtonCancel';
import schedule from '@salesforce/label/c.Schedule';
//Apex
import getExtraActivityRecType from '@salesforce/apex/FullCalenderV2Controller.getExtraActivityRecTypeId';
import getSubjectValue from '@salesforce/apex/Utility.getPicklistValue';
import addExtraActivity from '@salesforce/apex/FullCalenderV2Controller.addExtraActivity';

export default class ExtraActivityPopup extends LightningModal {
    assignedTo;
    userName;
    userId = userId;
    type;
    isPrivate=false;
    isAllDay=false;
    start;
    end;
    data;
    subject;
    isLoading;
    eventRecTypeId;
    typeOptions;
    subjectOptions;
    isValidationSuccess;
    CustLabel ={label_save,schedule,cancel};
    @wire(getRecord, { recordId: userId, fields: [userName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Name.value != null) {
                this.userName = data.fields.Name.value;
                this.assignedTo = this.userName;
            }
        }
    }
    @wire(getExtraActivityRecType)
    getRecTypeId({data,error}){
        if(data){
            data = JSON.parse(JSON.stringify(data));
            this.eventRecTypeId = data;
            
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(getPicklistValuesByRecordType, {objectApiName : 'Event', recordTypeId: '$eventRecTypeId'})
    STATUS_PICKLIST_VALUE({data,error}){
        if(data){
            this.typeOptions = data.picklistFieldValues.Type.values;
            //this.subjectOptions = data.picklistFieldValues.Subject.values;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }    
    @wire(getSubjectValue, {ObjectApi_name : 'Event', Field_name : 'Subject'})
    SUBJECT_VAL({data, error}){
        if(data){
            let options = [];
            data.forEach(r => {
                options.push({
                  label: r,
                  value: r,
                });
              });   
              this.subjectOptions = options;
            console.log('picklist = > '+JSON.stringify(data));
        }else if(error){
            console.log('Error'+JSON.stringify(error.message));
        }
    }    
    connectedCallback(){
       this.assignedTo = this.userName;
    }
    handlePrivate(event){
        //this.isPrivate = event.detail.value;
    }
    handleAllDay(event){
        this.isAllDay = event.detail.value;
    }
    handleEnd(event){
        this.end = event.detail.value;
    }
    handleStart(event){
        this.start = event.detail.value;
    }
    handleType(event){
        this.type = event.detail.value;
    }
    handleSubject(event){
        this.subject = event.detail.value;
    }
    handleCreateEvent(event){
        event.preventDefault();
        this.isLoading  = false;
        this.isValidationSuccess = true;
        this.template.querySelector('[data-id="formerror"]').setError(null);
        var inputCmp = this.template.querySelector('.Subject');
        var Subject = inputCmp.value;
        if (Subject == '' || Subject == null ) {
            this.template.querySelector('[data-id="formerror"]').setError('Please select Subject');
            this.isValidationSuccess = false;
        }         
        var startDate = this.template.querySelector('.start');
        var start = startDate.value;
        if (start == '' || start == null ) {
            this.template.querySelector('[data-id="formerror"]').setError('Please select Start Date');
            this.isValidationSuccess = false;
        }  
        var endDate = this.template.querySelector('.end');
        var end = endDate.value;
        if (end == '' || end == null ) {
            this.template.querySelector('[data-id="formerror"]').setError('Please select End Date');
            this.isValidationSuccess = false;
        }
        if(this.isValidationSuccess){
            this.isLoading =true; 
            addExtraActivity({
                recTypeId:this.eventRecTypeId,
                userId:this.userId,
                EventType:this.type,
                subject:this.subject,                
                startTime:this.start,
                endTime:this.end,
                allDayEvent:this.isAllDay,
                isPrivate :this.isPrivate
            }).then(result=>{      
                this.isLoading =false;
                this.closePopup();
                setTimeout(
                    this.template.querySelector('c-full-calenderv2').refresh()
                    ,10000);
            }).catch(error=>{
                this.showToast('Error', 'Error', error.message);                
            });
        } 
        console.log('event save');
    }
    closePopup() {
        this.close();
    }
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
}