import { LightningElement, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { NavigationMixin } from 'lightning/navigation';


// labels
import LoyaltyPointProgram from '@salesforce/label/c.loyalty_points_program';
import LoyaltyPointRelatedList from '@salesforce/label/c.loyalty_points';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

// apex
import getRelatedLoyaltyPoints from '@salesforce/apex/tabActivationBusinessProgramController.getRelatedLoyaltyPoints';

export default class TabActivationBusinessProgramLoyaltyPoints extends  NavigationMixin(LightningElement) {
    @api receivedId;
    _points;
    _isHoyaAccount = false;
    isDataExist;
    loyaltyPointsList;
    recCount = 0;
    CHANNEL_NAME = '/event/Refresh_Related_List__e';

    columns = [
        {label: 'Transaction ID',fieldName: 'loyalLink',
         type: 'url', typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
         sortable: true},
        {label: 'YearMonth (YYYYMM)',fieldName: 'MonthYear__c',type: 'text',sortable: true},
        {label: 'Transaction Date',fieldName: 'Date_of_transaction__c',type: 'text',sortable: true},
        {label: 'Decription', fieldName: 'Description__c',type: 'text',sortable: true },
        {label: 'Points', fieldName: 'Points__c', type: 'text', sortable: true}
    ];

    @api
    set loyaltyPoints (value) {
        this._points = value;
    }
    get loyaltyPoints() {
        return this._points;
    }

    @api 
    set accBrand(value){
        if (value != undefined) {
            this.isHoyaAccount = false;
        }
    }
    get accBrand() {
        return this.isHoyaAccount;
    }

    custLabel = {
        LoyaltyPointProgram,
        LoyaltyPointRelatedList
    }
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.getRelatedLoyaltyPoints();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            this.showToast('Error', 'Error', error.body.message);
        });
    }

    startNewProcessLP(event){
        this.navigateToNewPage('Loyalty_Points__c');
    }
    refreshList = ()=> {
        this.getRelatedLoyaltyPoints();
    } 
    getRelatedLoyaltyPoints(){
        getRelatedLoyaltyPoints({accountId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            response.forEach(res=>{
                res.loyalLink = '/' + res.Id;
            });
            let allPoints = response;
            this.loyaltyPointsList = (allPoints.length <= 5) ? [...allPoints] : [...allPoints].splice(0,5);

                if(allPoints.length>5){
                    this.recCount='5+';
                }
                else{
                    this.recCount=allPoints.length;
                }
                if(this.recCount > 0)
                this.isDataExist =true;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.body.message);
        })
    }
    navigateToNewPage(objectName){
        const defaultValues = encodeDefaultFieldValues({
            Account__c : this.receivedId
         });
 
         this[ NavigationMixin.Navigate]({
             type : 'standard__objectPage',
             attributes : {
                 objectApiName : objectName,
                 actionName : 'new'
             },
             state: {
                 defaultFieldValues: defaultValues,
                 useRecordTypeCheck : 1,
                 navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
             }
         });
    }

    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Loyalty_Points__r',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }

    generateStatement() {
        this.template.querySelector('c-loyalty-points-statement').displayModal();
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
    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });   
    }  
}