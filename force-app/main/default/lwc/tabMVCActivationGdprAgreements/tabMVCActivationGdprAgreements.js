import { LightningElement, api } from 'lwc';
import HoyaiLog_Allowed from '@salesforce/schema/Contact.HoyaIlog_Allowed__c'; 
import Marketing_Info from '@salesforce/schema/Contact.Marketing_Material__c'; 
import Eye_Doctor_Locator from '@salesforce/schema/Contact.Eye_Doctor_Locator__c'; 
import GDPR_Collector from '@salesforce/schema/Contact.GDPR_Collected__c'; 
//labels
import GDPR from '@salesforce/label/c.tabActivationPotentialGDPR';
//object
import Contact_obj from '@salesforce/schema/Contact';
export default class TabMVCActivationGdprAgreements extends LightningElement {
    @api receivedId;
    contractsRelatedLst;
    recCount = 0;
    ObjectApiName = Contact_obj;
   
    GDPR_Fields2=[Eye_Doctor_Locator];
    GDPR_Fields3=[HoyaiLog_Allowed];
    GDPR_Fields1=[GDPR_Collector,Marketing_Info];
    custLabel = {        
        GDPR
    }
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    
    connectedCallback(){
       // console.log('XXX Received Id = > '+this.receivedId);
    }
}