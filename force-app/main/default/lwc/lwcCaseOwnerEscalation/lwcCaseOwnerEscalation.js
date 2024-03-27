import { api, LightningElement, track, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import doChangeOwner from '@salesforce/apex/serviceFlow_LwcCaseOwnerEscalation_Ctl.doChangeOwner';
export default class LwcCaseOwnerEscalation extends LightningElement {
    @api recordId;
    isLoading=false;
    async pathHandler(event) {
        this.isLoading=true;
        let targetId = event.currentTarget.id;
        let len = targetId.length;
        let mainTarId = targetId.charAt(4);
        let targatPrefix = targetId.substring(5, len);
        var selectedPath = this.template.querySelector("[id=" + targetId + "]");
        if (selectedPath) {
            this.template.querySelector("[id=" + targetId + "]").className = 'slds-is-active slds-path__item';
        }
        for (let i = 0; i < mainTarId; i++) {
            let selectedPath = this.template.querySelector("[id=pat-" + i + targatPrefix + "]");
            if (selectedPath) {
                this.template.querySelector("[id=pat-" + i + targatPrefix + "]").className = 'slds-is-complete slds-path__item';
            }
        }
        for (let i = mainTarId; i < 8; i++) {
            if (i != mainTarId) {
                let selectedPath = this.template.querySelector("[id=pat-" + i + targatPrefix + "]");
                if (selectedPath) {
                    this.template.querySelector("[id=pat-" + i + targatPrefix + "]").className = 'slds-is-incomplete slds-path__item';
                }
            }
        }
        try {
            const caseOwnerUpdateStatus = await doChangeOwner({
                recordId : this.recordId,
                esclationLevel : mainTarId
            });
            console.log('Method2 result: ' + caseOwnerUpdateStatus);
            this.isLoading=false;
        } catch(error) {
            console.log(error);
            this.isLoading=false;
        } finally {
            console.log('Finally Block');
            this.updateRecordView(this.recordId);
            this.isLoading=false;
        }
    }
    updateRecordView(recordId) {
        updateRecord({fields: { Id: recordId }});
    }
}