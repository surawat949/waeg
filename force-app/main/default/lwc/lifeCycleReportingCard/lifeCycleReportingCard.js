import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
export default class LifeCycleReportingCard extends NavigationMixin(LightningElement) {
    @api stage
    @api record

    get isSameStage(){
        return this.stage === this.record.Stage__c
    }
    get negativeClass() {
        return this.value < 0 ? 'negative-value' : '';
    }

    addClass(event){
        let index = event.currentTarget.dataset.rowIndex;
        let flipElement = this.template.querySelector('[data-id="' + index + '"]');
        flipElement.classList.add('class1');
    }

    removeClass(event){
        let index = event.currentTarget.dataset.rowIndex;
        let flipElement = this.template.querySelector('[data-id="' + index + '"]');
        flipElement.classList.remove('class1');
    }

    navigateTALCHandler(event){
        event.preventDefault()
        this.navigateHandler(event.target.dataset.id, 'Account_Life_Cycle__c')
    }
    navigateAccHandler(event){
        event.preventDefault()
        this.navigateHandler(event.target.dataset.id, 'Account')
    }
    navigateHandler(Id, apiName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                objectApiName: apiName,
                actionName: 'view',
            },
        });
    }
}