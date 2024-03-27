import { LightningElement, wire ,track} from 'lwc';
import {getObjectInfo,getPicklistValues } from 'lightning/uiObjectInfoApi';
import LIFECYCLE_OBJECT from '@salesforce/schema/Account_Life_Cycle__c'
import STAGE_FIELD from '@salesforce/schema/Account_Life_Cycle__c.Stage__c'
import ID_FIELD from '@salesforce/schema/Account_Life_Cycle__c.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLifeCycleRecords from '@salesforce/apex/LifeCycleReportingController.getAccountLifeCycleRecords';

export default class LifeCycleReporting extends LightningElement {
    @track isChartsVisible = false;
    @track containerClass = 'container';
    @track firstComponentClass = 'full-width';
    @track secondComponentClass = 'hidden';

    records;
    stageList;
    pickVals;
    stageMap;
    recordId;
    /** Fetch metadata abaout the Account_Life_Cycle__c object**/
    @wire(getObjectInfo, {objectApiName:LIFECYCLE_OBJECT})
    objectInfo
    /*** fetching Stage Picklist ***/

    @wire(getPicklistValues, {
        recordTypeId:'$objectInfo.data.defaultRecordTypeId',
        fieldApiName:STAGE_FIELD
    })stagePicklistValues({ data, error}){
        if(data){
            console.log("Stage Picklist", data)
            this.pickVals = data.values.map(item => item.value)
            console.log(this.pickVals)
        }
        if(error){
            console.error(error)
        }
    }

    connectedCallback() {
        getLifeCycleRecords()
        .then(result => {
            this.records = result.lifeCycleWrapperList;
            this.pickVals = result.pickVals;
            console.log(this.records);
        })
        .catch(error => {
            console.log('getLifeCycleRecords error==>',JSON.stringify(error));
            
        });
    }

    toggleChartsVisibility() {
        if(this.firstComponentClass != 'seventy-width'){
            this.firstComponentClass = 'seventy-width';
            this.secondComponentClass = 'thirty-width';
        }else{
            this.firstComponentClass = 'full-width';
            this.secondComponentClass = 'hidden';
        }
        
    }

    get equalwidthHorizontalAndVertical(){
        let len = this.pickVals.length
        return `width: calc(100vw/ ${len})`
    }
}