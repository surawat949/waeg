import { LightningElement,track,api,wire } from 'lwc';
import { CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getECPTrainings from '@salesforce/apex/TrainingCertificateController.getECPTrainings';
import getAttendees from '@salesforce/apex/TrainingCertificateController.getAttendees';
import processCertificate from '@salesforce/apex/TrainingCertificateController.generateCertificate';
import selectTraining from '@salesforce/label/c.Select_Training';
import createFor from '@salesforce/label/c.Create_Certificate_For';
import selectAttendee from '@salesforce/label/c.Select_Attendee';
import noAttendeeError from '@salesforce/label/c.No_Attendee_Error';
import sendCertificate from '@salesforce/label/c.Send_Certificate';
import emailSent from '@salesforce/label/c.email_Sent';
import allAttendees from '@salesforce/label/c.All_Attendees';
import indiAttendee from '@salesforce/label/c.Individual_Attendee';
import noTemplateError from '@salesforce/label/c.No_Template_error';

export default class TrainingCertificateModal extends LightningElement {
    custLabel = {
        selectTraining,
        createFor,
        selectAttendee,
        noAttendeeError,
        sendCertificate,
        emailSent,
        allAttendees,
        indiAttendee,
        noTemplateError
    };
    @api recordId; 
    @api showAttendees = false;
    @api showMissingError = false;
    @api showLoading = false;
    @track disableButton = true;
    @track disableRadio = true;
    @track isModalOpen = true;
    @track displayValue;
    @track value1;
    @track selectOptions = [];
    @track attendeeOptions = [];
    @track certificateOptions = [{
        label:this.custLabel.allAttendees, value:'All'
    },{
        label:this.custLabel.indiAttendee, value:'Individual'
    }];
    currentPageReference = null;
    selectedTrainingId = null;
    selectedCertificateOption = null;
    selectedAttendeeId = null;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
    if (currentPageReference) {
    const urlValue = currentPageReference.state.c__recordIdId;
    if (urlValue) {
        this.displayValue = urlValue;
    }
    }}

    connectedCallback () {
        getECPTrainings({accountId: this.displayValue})
        .then(response => {
            console.log(response);
            if (response) {
                for (const eachTraining of response) {
                    const option = {
                        label : eachTraining.Name,
                        value : eachTraining.Id
                    };
                    this.selectOptions = [...this.selectOptions, option];
                }
            }
        }).catch(error => {
            console.log(error);
            this.showToast('Error', 'Error', error.body.message);
        });
        this.isModalOpen = true;
    }

    handleTrainingChange(event) {
        this.reset();
        setTimeout(() => {
            this.value1 = 'All';
        }, 0);
        this.value1 = undefined;
        this.disableButton = false;
        this.disableRadio = false;
        this.selectedTrainingId = event.detail.value;
    }

    handleRadioChange(event) {
        this.reset();
        this.selectedCertificateOption = event.detail.value;
        if (this.selectedCertificateOption != null && this.selectedCertificateOption != undefined) {
            if (this.selectedCertificateOption === 'Individual') {
                this.disableButton = true;
                this.loadAttendees();
            } else {
                this.showMissingError = false;
                this.showAttendees = false;
                this.disableButton = false;
            }
        }
    }

    loadAttendees() {
        this.attendeeOptions = [];
        getAttendees({trainingId:this.selectedTrainingId})
        .then(response => {
            console.log(response);
            if (response) {
                for (const eachAttendee of response) {
                    var key = eachAttendee.Contact__r.Name.concat('-', eachAttendee.Contact__r.RecordType.Name);
                    const option = {
                        label : key,
                        value : eachAttendee.Id
                    };
                    this.attendeeOptions = [...this.attendeeOptions, option];
                }
                if (this.attendeeOptions != undefined && this.attendeeOptions.length != 0) {
                    this.showAttendees = true;
                } else {
                    this.showMissingError = true;
                }
            }
        }).catch (error => {
            console.log(error);
            this.showToast('Error', 'Error', error.body.message);
        });
    }

    handleAttendeeChange(event) {
        this.disableButton = false;
        this.selectedAttendeeId = event.detail.value;
    }

    processCertificateGeneration() {
        this.disableButton = true;
        this.showLoading = true;
        processCertificate({trainingId:this.selectedTrainingId,
                            attendeeId:this.selectedAttendeeId,
                            brand : 'SEIKO'})
        .then(response => {
            this.showLoading = false;
            if (response === 'Success') {
                this.showToast('Success', 'Success', this.custLabel.emailSent);
            } else if (response === 'AttendeeError') {
                this.showToast('Error', 'Error', this.custLabel.noAttendeeError);
            } else if (response === 'templateError') {
                this.showToast('Error', 'Error', this.custLabel.noTemplateError);
            } else {
                this.showToast('Error', 'Error', response);
            }
            this.closeModalWithDelay();
        }).catch(error => {
            console.log(error);
            this.showToast('Error', 'Error', error.body.message);
            this.closeModalWithDelay();
        })
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;       
        setTimeout(
			function() {
				window.history.back();
			},
			0
		);
        setTimeout(
			function() {
				window.location.reload();
			},
			100
		);
        eval("$A.get('e.force:refreshView').fire();");
    }

    closeModalWithDelay() {
        this.isModalOpen = false;
        setTimeout(
			function() {
				window.history.back();
			},
			0
		);
        setTimeout(
			function() {
				window.location.reload();
			},
			1000
		);
        eval("$A.get('e.force:refreshView').fire();");
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

    reset() {
        this.showMissingError = false;
        this.showAttendees = false;
        this.attendeeOptions = [];
        this.selectedAttendeeId = null;
    }
}