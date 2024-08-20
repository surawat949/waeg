/**
 * @filename : tabAccountMemberShips
 * @description : tabAccountMemberShips to support Account Address in SFDC V.2.0 Project
 * @DevsOppId : Tab Account Membership | Task-561
 * @Author : Surawat Sakulmontreechai
 * @Group : Account Tab
 * @CreatedBy : Surawat Sakulmontreechai
 * @CreatedDate : 2023-06-28
 * @LastModifiedBy : Surawat Sakulmontreechai
 * @LastModifiedDate : 2023-08-21
 * @Email : surawat.sakulmontreechai@hoya.com
 * @NotedAndDescription : reder detail for membership, parent account
 * 
 */
import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

//apex class import start here
import AccList from '@salesforce/apex/TabAccountMemberParentId.getAccountNameId';
import wireCreateTask from '@salesforce/apex/TabAccountMemberParentId.CreateTask';
import NumChildAccount from '@salesforce/apex/TabAccountMemberParentId.getNumberOfAllAccount';
import SFDC_V2_StandardTask from '@salesforce/apex/Utility.getTaskSFDCStandardTask';
//end

//fields import start here
import Acc_ParentId from '@salesforce/schema/Account.ParentId';
import AccObj from '@salesforce/schema/Account';
import Acc_PrimaryBuyingGrp from '@salesforce/schema/Account.Primary_Buying_Group__c';
import Acc_BuyingGrpName from '@salesforce/schema/Account.Buying_Group_Name__c';
import Acc_HVC_InterCode from '@salesforce/schema/Account.CHINTERNATIONALGROUP__c';
import Acc_Membership from '@salesforce/schema/Account.Buying_Group_Membership_Code__c';
import Acc_Door from '@salesforce/schema/Account.Door__c';
import Acc_DoorId from '@salesforce/schema/Account.Door_ID__c';

//end

//custom label start here
import lblBuyingGroup from '@salesforce/label/c.SFDC_V_2_Account_MemberShip_BuyingGroup';
import lblDoor from '@salesforce/label/c.SFDC_V_2_Account_MemberShip_Door';
import lblParent from '@salesforce/label/c.SFDC_V_2_AccountMembership_ParentAccount';
import lblrelatedTo from '@salesforce/label/c.tabTaskModalRelatedTo';
import lblAccContact from '@salesforce/label/c.tabTaskModalAccContact';
import lblsearchContact from '@salesforce/label/c.tabLabelSearchContact';
import lblSubject from '@salesforce/label/c.Subject';
import lblComment from '@salesforce/label/c.Comment';
import lblassignedTo from '@salesforce/label/c.AssignTo';
import lblSearchUsr from '@salesforce/label/c.tabLabelSearchUser';
import lblDuedate from '@salesforce/label/c.tabTaskModalDueDate';
import lblCopyTo from '@salesforce/label/c.tabTaskModalCopyTo';
import lblStatus from '@salesforce/label/c.tabTaskModalStatus';
import lblSave from '@salesforce/label/c.tabLabelSave';
import lblClose from '@salesforce/label/c.tabLabelClose';
import lblNext from '@salesforce/label/c.tabLabelNext';
import lblBack from '@salesforce/label/c.BackButton';
import lblAddParent from '@salesforce/label/c.SFDC_V_2_AccountMembership_AddParent';
import lblCreateTask from '@salesforce/label/c.SFDC_V_2_AccountMembershipCreateTask';
import lblSelParentErr from '@salesforce/label/c.SFDC_V_2_AccountMembership_SelAccErr';             //Select Parent Error
import lblSelParentErrBody from '@salesforce/label/c.SFDC_V_2_AccountMembership_SelAccErrBody';     //Select Parent Error Body
import lblSubjectErr from '@salesforce/label/c.SFDC_V_2_AccountMembership_SubjectErr';              //select subject error
import lblSubjectErrBody from '@salesforce/label/c.SFDC_V_2_AccountMembership_SubjectErrBody';      //select subject error body
import lblAssignErr from '@salesforce/label/c.SFDC_V_2_AccountMembership_AssignErr';                //select assign to error
import lblAssignErrBody from '@salesforce/label/c.SFDC_V_2_AccountMembership_AssignErrBody';
import lblRelateToErr from '@salesforce/label/c.SFDC_V_2_AccountMembership_RelateErr';
import lblRelateToErrBody from '@salesforce/label/c.SFDC_V_2_AccountMembership_RelateErrBody';
import lblTaskCreated from '@salesforce/label/c.SFDC_V_2_AccountMembership_TaskCreate';
import lblTaskCreatedBody from '@salesforce/label/c.SFDC_V_2_AccountMembership_TaskCreateBody';
import lblNumChild from '@salesforce/label/c.SFDC_V_2_AccountMembership_NumsChild';
import lblInstruction from '@salesforce/label/c.SFDC_V_2_Account_Membership_Instruction';
import lblCustomerChannel from '@salesforce/label/c.SFDC_V_2_Account_Sales_Channel';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
//end

//lightning api importing
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import strusrId from '@salesforce/user/Id';
import copytoId from '@salesforce/user/Id';
import { RefreshEvent } from 'lightning/refresh';
//end

export default class TabAccountMemberships extends LightningElement {
    @api receivedId;
    @track isLoading = false;
    @track isModalOpen = false;
    @track currentStep = '1';
    @track defaultSubjectValue = 'Request To Change Parent Account Value';
    @track defaultComment;
    @track value='In Progress';
    showAllTab=false;

    Subject = this.defaultSubjectValue;
    Status = this.value;
    whatid = this.receivedId;
    ContactName;
    hoya_account_id;
    acc_name;
    Description = this.defaultComment;
    Instruction = this.defaultComment;
    default_hoya_account_id;
    default_acc_name;
    record;
    errors1;
    NumChild;
    errors2;
    userId = strusrId;
    copiedtoId = copytoId;
    OwnerId;
    duedate;
    CopyTo = this.copiedtoId;

    buyingGrpFields = [Acc_PrimaryBuyingGrp, Acc_BuyingGrpName, Acc_HVC_InterCode, Acc_Membership];
    DoorFields = [Acc_Door, Acc_DoorId];
    //byuingGrpFields2 = [Acc_HVC_InterCode, Acc_Membership];
	
	@track StatusOptions;
    TaskStatusRecordTypeId;

    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }
	
	@wire(SFDC_V2_StandardTask)
    standard_sfdcv2_task({data,error}){
        if(data){
            data = JSON.parse(JSON.stringify(data));
            this.TaskStatusRecordTypeId = data;
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(getPicklistValuesByRecordType, {objectApiName : 'Task', recordTypeId: '$TaskStatusRecordTypeId'})
    STATUS_PICKLIST_VALUE({data,error}){
        if(data){
            this.StatusOptions = data.picklistFieldValues.Status.values;
            //console.log(data);
        }else if(error){
            this.showToast('Error', JSON.stringify(error.message), 'error');
        }
    }

    @wire(NumChildAccount, {recordId : '$receivedId'})
    wireNumberOfChild({data, error}){
        if(data){
            this.NumChild = data[0];
            this.errors2 = undefined;
        }else if(error){
            this.NumChild = undefined;
            this.errors2 = error;
            this.showToast('Error', JSON.stringify(this.errors2), 'error');
        }
    }

    @wire(AccList, {recordId : '$receivedId'})
    wireAccountList({data, error}){
        if(data){
            this.record = data[0];
            this.errors1 = undefined;
            
        }else if(error){
            this.record = undefined;
            this.errors1 = error;
        }
    }

    get myHoyaAccountId(){
        return this.record?.Hoya_Account_ID__c;
    }

    get myAccName(){
        return this.record?.Name;
    }

    get NumberOfChild(){
        return this.NumChild?.childAccount;
    }

    Account_Obj = AccObj;

    fields1 = [Acc_ParentId];

    subjectCH(event){
        this.Subject = event.target.value;
    }

    HoyaAccountIdCH(event){
        this.hoya_account_id = event.target.value;
        
    }

    AccNameCH(event){
        this.acc_name = event.target.value;
    }

    ownerIdCH(event){
        this.OwnerId = event.target.value;
    }

    copyToCH(event){
        this.CopyTo = event.target.value;
        
    }

    duedateCH(event){
        
        this.duedate = event.target.value;
    }

    contactCH(event){
        this.ContactName = event.target.value;
        
    }

    whatIdCH(event){
        this.whatid = event.target.value;
    }

    statusCH(event){
        this.Status = event.target.value;
        this.Status = event.detail.value;
        
    }

    descriptionCH(event){
        this.Description = event.target.value;
    }

    openModal(){
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
    }

    gotoStepTwo(){
        if((this.hoya_account_id==null) || (this.acc_name==null)){
            this.showToast(lblSelParentErr, lblSelParentErrBody, 'error');
        }else{
            this.currentStep = '2';
            this.template.querySelector('div.stepOne').classList.add('slds-hide');
            this.template.querySelector('div.stepTwo').classList.remove('slds-hide');
        }
    }

    goBackToStepOne() {
        this.currentStep = '1';

        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepOne')
            .classList.remove('slds-hide');
    }

    handleLookupSelectionWhatId(event){
        if(event.detail.selectedRecord != undefined){
            console.log('Selected Record Value on Parent Component is ' +  
            JSON.stringify(event.detail.selectedRecord));
            this.hoya_account_id = event.detail.selectedRecord.Hoya_Account_ID__c;
            this.acc_name = event.detail.selectedRecord.Name;
            this.defaultComment = 'Please change/add Parent Account field value for '+this.myHoyaAccountId+' ('+this.myAccName+') '
                    +'to following detail : '+'\n'+'New Parent Account Name : '+this.acc_name + '\n'
                    +'New Parent Account to Hoya Account ID : '+this.hoya_account_id;
            this.Description = this.defaultComment;
            this.whatid = this.receivedId;
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value=event.detail.selectedRecord.Hoya_Account_ID__c;
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value=event.detail.selectedRecord.Name;

        }else{
            this.hoya_account_id = null;
            this.acc_name = null;
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value=null;
            this.template.querySelector('lightning-input[data-my-id=form-input-2]').value=null;
        }
    }

    handleLookupSelectionOwnerId(event){
        if(event.detail.selectedRecord != undefined){
            
            this.OwnerId = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-8]').value=event.detail.selectedRecord.Id;
        }
    }

    handleLookupSelectionCopiedTo(event){
        if(event.detail.selectedRecord != undefined){
           
            this.CopyTo = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-10]').value=event.detail.selectedRecord.Id;
        }
    }

    handleLookupSelectionAccounContact(event){
        if(event.detail.selectedRecord != undefined){
            
            this.ContactName = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-11]').value=event.detail.selectedRecord.Id;
        }
    }

    handleLookupRelatedTo(event){
        if(event.detail.selectedRecord != undefined){
            this.whatid = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-6]').value=event.detail.selectedRecord.Id;
        }else{
            this.whatid = undefined;
            this.template.querySelector('lightning-input[data-my-id=form-input-6]').value = null;
        }
    }

    handledCreateTask(){
        if(this.Subject==null || this.Subject==''){
            this.showToast(lblSubjectErr, lblSubjectErrBody, 'error');
        }else if(this.OwnerId==null || this.OwnerId==''){
            this.showToast(lblAssignErr, lblAssignErrBody, 'error');
        }else if(this.whatid==null || this.whatid==''){
            this.showToast(lblRelateToErr, lblRelateToErrBody, 'error');
        }else{
            wireCreateTask({
                subject : this.Subject,
                relatedTo : this.whatid,
                Instruction : this.Description,
                assignTo : this.OwnerId,
                DueDate : this.duedate,
                sStatus : this.Status,
                sFlowContact : this.ContactName,
                CopyTo : this.CopyTo,
                AccountId : this.receivedId

            }).then(result=>{
                this.showToast(lblTaskCreated, lblTaskCreatedBody, 'success');
                this.closeModal();
                this.updateRecordView();
                this.OwnerId = undefined;
                this.whatid = undefined;
                this.hoya_account_id = undefined;
                this.acc_name = undefined;
            }).catch(error=>{
                this.showToast('Error', 'Error during created task', 'error');
            });
        }
    }

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }

    handleIsLoading(isLoading){
        this.isLoading = isLoading;
    }

    updateRecordView(){
        setTimeout(() => {
            
        },1000);
        this.dispatchEvent(new RefreshEvent());
    }

    custLbl = {lblBuyingGroup, 
        lblDoor, 
        lblParent, 
        lblrelatedTo, 
        lblsearchContact,
        lblAccContact,
        lblSubject,
        lblComment,
        lblassignedTo,
        lblSearchUsr,
        lblDuedate,
        lblCopyTo,
        lblStatus,
        lblSave,
        lblClose,
        lblNext,
        lblBack,
        lblAddParent,
        lblCreateTask,
        lblNumChild,
        lblInstruction,
        lblCustomerChannel};
    @wire(getChatterUserDetail)
        allStages({data }) {
            if (data) {
                this.showAllTab = data;
            } 
            else{
                this.showAllTab = false;
            }
    }    
}