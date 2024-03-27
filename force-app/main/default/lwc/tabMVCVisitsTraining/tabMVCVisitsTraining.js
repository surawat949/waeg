import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//labels
import InstoreTrainingandWebinars from '@salesforce/label/c.tabClinicVisitsTraining';
import Hoya_Faculty_section from '@salesforce/label/c.Hoya_Faculty';
import ECPTrainingName from '@salesforce/label/c.tabVisitECPTrainingName';
import TrainingTopics from '@salesforce/label/c.tabVisitTrainingTopics';
import Date from '@salesforce/label/c.tabVisitDate';
import Trainer from '@salesforce/label/c.tabVisitTrainer';
import TrainingStatus from '@salesforce/label/c.tabVisitTrainingStatus';
//Apex
import getInStoreTrainingRelatedList from '@salesforce/apex/TabMVCVisitsController.getInStoreTrainingRelatedList';
export default class TabMVCVisitsTraining extends LightningElement {
    @api receivedId;
    inStoreTrainingLst;
    isDataExist;
    recCount = 0;
    showTrainingCertificate = false;
    custLabel = {
        InstoreTrainingandWebinars,
        Hoya_Faculty_section
    }
    constructor() {
        super();
        // passed parameters are not yet received here
    }    
    generateCertificate(event){
        this.showTrainingCertificate = true;
    }    
    columns = [
        {label: ECPTrainingName ,fieldName: 'TrainingLink',
        type: 'url', typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},},       
        {label: TrainingTopics ,fieldName: 'Training__c'},
        {label: Date, fieldName: 'start__c'}, 
        {label: Trainer, fieldName: 'AssignedLink',
        type :'url', typeAttributes: {label: {fieldName: 'AssignedUser'}, target:'_top'},},         
        {label: TrainingStatus, fieldName: 'Training_status__c'}
    ];
    connectedCallback(){   
        getInStoreTrainingRelatedList({contactId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            response.forEach(res=>{              
                res.TrainingLink = '/' + res.Id;
                if(res.hasOwnProperty('Assigned_to__c'))
                    res.AssignedLink = '/' + res.Assigned_to__c; 
                else
                    res.AssignedLink ='';
                if(res.hasOwnProperty('Assigned_to__r'))
                    res.AssignedUser = res.Assigned_to__r.Name;
                else
                    res.AssignedUser = '';
            });                
            let trainingLst = response;
            this.inStoreTrainingLst = response; 
            this.recCount=trainingLst.length;
            if(this.recCount > 0){
                this.isDataExist = true;
            }             
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
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