import { LightningElement, api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'
export default class LifeCycleReportingCard extends NavigationMixin(LightningElement) {
    @api stage
    @api record
    @api accountstats
    @api taskstats
    @track linkClass = '';
    @api lensesnetsalesl12mo;
    @api addnewiconflag

    showDecreasingSalesFlag = false;
    showVisionaryFlag = false;
    isFollowUpRatelessthan80 = false;
    isFollowUpRatemorethan120 = false;
    isAlert = false;
    L12Mo_Vs_LFY = 0;
    isTaskOverDue = false;
    isSVDisplay = false;
    taskStatus = '';
    svStatus = '';
    strategicValue = 0;
    lensesNetSales = 0;
    addNew = false;
    banFlag = false;

    get isSameStage(){
        return this.stage === this.record.Stage__c
    }
    get negativeClass() {
        return this.L12Mo_Vs_LFY < 0 ? 'zoom-negative' : 'zoom';
    }
    connectedCallback() {
        this.statValue();
        this.addnewicon();
        this.taskStatusUpdate();
        if(this.L12Mo_Vs_LFY < 0){
            this.showDecreasingSalesFlag = true;
        }
        if(this.record.Account__r.Seiko_Network__c == 'Seiko Vision Specialist' || this.record.Account__r.Seiko_Network__c == 'Hoya Center'){
            this.showVisionaryFlag = true;
        }
        if(this.record.Total_Visits_Achieved__c < 80 || this.record.Total_Visits_Achieved__c == undefined){
            this.isFollowUpRatelessthan80 = true;
        }
        if(this.record.Total_Visits_Achieved__c > 120){
            this.isFollowUpRatemorethan120 = true;
        }
        if(this.record.Retain_Stage__c){
            this.isAlert = true;
        }
        if(this.record.Account__r.Strategic_Value_Net_Sales__c == undefined || this.record.Account__r.Strategic_Value_Net_Sales__c == 0){
            this.svStatus = 'Missing Strategic Value';
            this.isSVDisplay = true;
        }
        else if(this.lensesnetsalesl12mo[this.record.Account__c] > 100){
            this.svStatus = 'SOW > 100%, review Strategic Value';
            this.isSVDisplay = true;
        }
        if(this.record.Account__r.TACTICOM_SOF__c == 'Not Selected'){
           this.banFlag = true;
        }
        const userLocale = navigator.language || 'en-US';
        const currencyFormatter = new Intl.NumberFormat(userLocale);
        this.strategicValue = currencyFormatter.format(this.record.Strategic_Value__c);
        this.lensesNetSales = currencyFormatter.format(parseFloat(this.record.Lenses_Net_Sales_Last_12Mo__c));
    }


    statValue() {
        if (this.accountstats[this.record.Account__c] !== undefined) {
            this.L12Mo_Vs_LFY = this.accountstats[this.record.Account__c];
        }
    }
    addnewicon(){
            if(this.addnewiconflag[this.record.Account__c]){
                this.addNew = true;
            }
    }
    
    taskStatusUpdate(){
        if (this.taskstats[this.record.Id] !== undefined) {
            this.taskStatus = this.taskstats[this.record.Id];
            this.isTaskOverDue = true;
        }
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
        this.linkClass = 'visited';
        this.navigateHandler(event.target.dataset.id, 'Account_Life_Cycle__c')
    }
    navigateAccHandler(event){
        event.preventDefault()
        this.linkClass = 'visited';
        this.navigateHandler(event.target.dataset.id, 'Account')
    }
    navigateHandler(Id, apiName) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                objectApiName: apiName,
                actionName: 'view',
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }
}