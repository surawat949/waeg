import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getChatCases from '@salesforce/apex/serviceFlow_ChatAttachedCases.getChatCases';

export default class ServiceFlowChatAttachedCases extends LightningElement {
    @api recordId;
    @track cases = [];
    @track selectedCaseId;
    @track isButtonDisabled = true;
    @track isModalOpen = false;
    connectedCallback() {
        this.loadCases();
    }

    loadCases() {
        getChatCases({ recordId: this.recordId })
            .then(result => {
                this.cases = result;
                if (this.cases.length > 0) {
                    this.selectedCaseId = this.cases[0].Id;
                    this.isButtonDisabled = false;
                }
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }
    loadCaseDetails() {
        this.isModalOpen = true;
        // Fetch additional details of the selected case
        // For now, just fetching the Description field
        const selectedCase = this.cases.find((caseRecord) => caseRecord.Id === this.selectedCaseId);
        //replace(/[\n\r]/g, '<br/>')
        if (selectedCase) {
            this.selectedCase = {
                CaseNumber: selectedCase.CaseNumber,
                Description: selectedCase.Description.replaceAll('\n', '<br/>') || 'No Description Available'
            };
        }
        console.log(JSON.stringify(this.selectedCase));
    }
    handleRadioChange(event) {
        this.selectedCaseId = event.target.dataset.caseId;
        console.log('Selected Case Id:', this.selectedCaseId);
        this.loadCaseDetails();
    }
    closeModal(){
        this.isModalOpen = false;
    }
    handleAttachClick() {
        // Implement logic to attach the selected case to the LiveChatTranscript
        // You can use this.selectedCaseId for the selected Case Id
        this.showToast('Success', 'Case Attached Successfully!', 'success');
    }

    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}