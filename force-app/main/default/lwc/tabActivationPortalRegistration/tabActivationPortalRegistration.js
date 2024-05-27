import { LightningElement, api,track,wire } from 'lwc';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// fields
import PORTAL from '@salesforce/schema/Account.Portal__c';
import LANGUAGE from '@salesforce/schema/Account.Language__c';
import BRAND_VISIBILITY from '@salesforce/schema/Account.Brand_Visibility__c';
import PARENT_ACCOUNT from '@salesforce/schema/Account.ParentId';
import getRegistratedContact from '@salesforce/apex/tabActivationPortalRegistration.getRegistratedContact';
import NumChildAccount from '@salesforce/apex/TabAccountMemberParentId.getNumberOfAllAccount';
import AccountTemplate from '@salesforce/apex/tabActivationPortalRegistration.getAccountTemplateIdFromAccount';
import label_ContactName from '@salesforce/label/c.tabAccContactName';
import label_ContRecType from '@salesforce/label/c.tabAccContactRecType';
import label_email from '@salesforce/label/c.tabAccContactEmail';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_PortalName from '@salesforce/label/c.Portal_Name';
import label_ParentAccount from '@salesforce/label/c.ParentAccount';
import label_NonRegContact from '@salesforce/label/c.NonRegContactsInPortal';
import label_PortalRegContact from '@salesforce/label/c.PortalRegContact';
import { NavigationMixin } from 'lightning/navigation';
import label_EmailInvitationFlag from '@salesforce/label/c.EmailInvitationFlag';
import label_LastLogin from '@salesforce/label/c.LastLogin';
import label_PortalLogin from '@salesforce/label/c.PortalLogin';
import lblNumChild from '@salesforce/label/c.SFDC_V_2_AccountMembership_NumsChild';
import getIndicators from '@salesforce/apex/tabActivationPortalRegistrationIndicator.getAIIndicators';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';

export default class TabActivationPortalRegistration extends NavigationMixin(LightningElement) {
    @api receivedId;
    conCount='0';
    showAllTab=false;
    nonRegContactCount='0';
    objectapiname = ACCOUNT_OBJ;
    labelLastLogin = label_LastLogin;
    labelContactName = label_ContactName;
    labelContactRecType = label_ContRecType;
    labelContactEmail = label_email;
    isDataExists = false;
    labelEmailInvitationFlag=label_EmailInvitationFlag;
    isDataExistsForNonRegContact=false;
    portalAccFields=[PORTAL,LANGUAGE,BRAND_VISIBILITY];
    parentAccount=[PARENT_ACCOUNT];
    isShowViewAllButton=false;
    NumChild;
    errors2;
    isShowViewAllButtonForNonCon=false;

    RegistrationIndicator;
    TrackAndTraceIndicator;
    TrackAndTraceMeaningIndicator
    StoreFinderIndicator;
    InetIndicator;
    PurchaseRegistrationIndicator;
    PurchaseRegistrationMeaningIndicator;
    LoyaltyProIndicator;
    LoyaltyProIndicatorMeaningIndicator;

	
	AccountTemplateId;
    AccountTemplateName;

    @track sortBy='ContactRecordType';
    @track sortDirection='desc';
    @track registratedContactList;
    @track columns = [{
            label: this.labelContactName,fieldName: 'conLink',type: 'url',typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true},
        {
            label: this.labelContactRecType,fieldName: 'ContactRecordType',type: 'text',sortable: true
        },
        {
            label: this.labelEmailInvitationFlag ,fieldName: 'SystemInvitationEmail',type: 'boolean',sortable: true
        },
        {
            label: 'Registered',fieldName: 'Registered',type: 'boolean',sortable: true
        },
        {
            label: this.labelLastLogin,fieldName: 'LastLogin',type: 'text',sortable: true
        },
        {
            label: this.labelContactEmail,fieldName: 'Email',type: 'email',sortable: true
        }
        
    ];
    connectedCallback() {
        this.getRegistratedContact();
       // this.getNonRegistratedContact();

       // load grey indicators tempoprarily for demo
        this.RegistrationIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.StoreFinderIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        this.InetIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        //this.PurchaseRegistrationIndicator = AI_Indicators + '/'+ 'GreyLight.png';
        //this.LoyaltyProIndicator = AI_Indicators + '/'+ 'GreyLight.png';

    }
    @wire(getIndicators, {recordId: '$receivedId'}) 
     getIndicators ({error, data}) {
        if(data){
            // Set the variable value here based on apex response.
            this.TrackAndTraceIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.trackTraceFlag);
            this.TrackAndTraceMeaningIndicator =  data.trackTraceFlagMeaning;
            this.PurchaseRegistrationIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.PurchaseRegFlag);
            this.PurchaseRegistrationMeaningIndicator = data.PurchaseRegFlagMeaning;
            this.LoyaltyProIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.loyaltyFlag);
            this.LoyaltyProIndicatorMeaningIndicator = data.loyaltyFlagMeaning;
        }else if(error){
            this.showToast('Error', 'Error',JSON.stringify(error));
        }
    }

    getIndicatorImage(indicator){
        if(indicator == 'GREY')
            return 'GreyLight.png';
        else if(indicator == 'GREYALERT')
            return 'GreyLightAlert.png';
        else if(indicator == 'RED')
            return 'RedLight.png';
        else if(indicator == 'REDALERT')
            return 'RedLightAlert.png';
        else if(indicator == 'GREEN')
            return 'GreenLight.png';
        else if(indicator == 'GREENALERT')
            return 'GreenLightAlert.png';

    }

    @wire(NumChildAccount, {recordId : '$receivedId'})
    wireNumberOfChild({data, error}){
        if(data){
            this.NumChild = data[0];
            this.errors2 = undefined;
        }else if(error){
            this.NumChild = undefined;
            this.errors2 = error;
        }
    }
    get NumberOfChild(){
        return this.NumChild?.childAccount;
    }
	
	@wire(AccountTemplate, {receivedId : '$receivedId'})
    wireAccountTemplate({data, error}){
        if(data){
            //console.log('Account Template ==> '+JSON.stringify(data[0]));
            if(data.length > 0){
                this.AccountTemplateId = "/" + JSON.parse(JSON.stringify(data[0].Id));
                this.AccountTemplateName = JSON.parse(JSON.stringify(data[0].Name));
                //console.log('Account Template Id = > '+this.AccountTemplateId);
            }else{
                this.AccountTemplateId = null;
                this.AccountTemplateName = null;
                //console.log('Account Template Id = > '+this.AccountTemplateId);
            }
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }
	
    getRegistratedContact() {
        getRegistratedContact({receivedId: this.receivedId})
            .then(data => {
            if(data){
                data = JSON.parse(JSON.stringify(data));
                this.registratedContactList = data;
                if(this.registratedContactList.length>0){
                    this.isDataExists = true;
                    this.conCount= this.registratedContactList.length;
                    this.sortData(this.sortBy, this.sortDirection);
                    this.registratedContactList.forEach(res=>{
                        res.Name=  res.name;
                        res.conLink = '/' + res.Id;
                        res.ContactRecordType = res.RecordTypeName;
                        res.Email = res.Email;
                        res.SystemInvitationEmail = res.EmailFlag;
                        res.LastLogin = res.lastLogin;
                        res.Registered = res.RegistratedFlag;
                        
                    });
                    console.log('>>>registratedContactList',this.registratedContactList);
                    this.isShowDataTable= true; 
                }
                else{
                    this.conCount='0';
                    this.isShowViewAllButton=false;
                    }
                }else{this.isShowDataTable=false;}
            }).catch(error => {
                this.showToast('Error', 'Error', error.message);
            })
    } 
   
    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Contacts',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }
    navigateToRelatedNonRegContactList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Account',
                relationshipApiName : 'Contacts',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        
        let parseData = [...this.registratedContactList];
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'desc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.registratedContactList = parseData;
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
    custLabel = {label_viewall,label_PortalName,label_ParentAccount,
                 label_PortalLogin,label_NonRegContact,label_PortalRegContact,lblNumChild};
    @wire(getChatterUserDetail)
        allStages({data }) {
            if (data) {
                this.showAllTab = data;} 
            else{
                this.showAllTab = false;}
            }             

}