import { LightningElement, api, wire } from 'lwc';

import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';

//apex
import getCompInfo from '@salesforce/apex/TabStatisticCompetitorController.getFirstLocalCompetitorName';

export default class TabActivationMedicalProgramTest extends LightningElement {
    @api receivedId;
    @api defaultRecordId;

    FirstCompLocalName;

    FirstCompetitorLocal = this.FirstCompLocalName;

    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback(){
        this.FirstCompetitorLocal = this.FirstCompLocalName;
        console.log('Coneect Child Call back =>'+this.receivedId);
    }

    @wire(getCompInfo, {recordId : '$receivedId'})
    getCompetitorInfo({error, data}){
        if(error){
            console.log('There was error =>'+error);
        }else if(data){
            console.log('First comp local name =>'+JSON.stringify(data));
            this.FirstCompLocalName = JSON.parse(JSON.stringify(data));
        }
    }

    renderedCallback(){
        refreshApex(this.getCompetitorInfo);
        this.dispatchEvent(new RefreshEvent());
        this.FirstCompetitorLocal = this.FirstCompLocalName;
    }

    handleLookupSelectCompValue(event){
        if(event.detail.selectedRecord != undefined){
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value = event.detail.selectedRecord.Value;
            const queryTemplate = this.template.querySelector('lightning-input[data-my-id=form-input-2]').value;
            if(queryTemplate !=null || queryTemplate != ''){
                this.FirstCompetitorLocal = event.detail.selectedRecord.Value;
            }else{
                queryTemplate = '';
                this.FirstCompetitorLocal = '';
            }
            //this.showToast2('success', this.FirstCompetitorLocal, 'success');
        }else{
            this.FirstCompetitorLocal = '';
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value = '';
        }
    }

    handleChangeCompetitor(event){
        this.FirstCompetitorLocal = event.target.value;
        //this.FirstCompetitorLocal = event.detail.selectedRecord.Value;
        //this.showToast2('success', 'sucess', 'success');
    }
}