import { LightningElement, api ,track ,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

import Account_obj from '@salesforce/schema/Account'; 
import Last_Sales_Statistics_obj from '@salesforce/schema/Last_Sales_Statistics__c'; 
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

//Fields
import Account_First_Global_Name from '@salesforce/schema/Account.First_Competitor_global_name__c';  
import Account_Second_Global_Name from '@salesforce/schema/Account.Second_Competitor_global_name__c';  
import Account_First_Local_Name from '@salesforce/schema/Account.First_Competitor_local_name__c';  
import Account_Second_Local_Name from '@salesforce/schema/Account.Second_Competitor_Local_Name__c';  
import Strategic_Net_Sales from '@salesforce/schema/Account.Strategic_Value_Net_Sales__c'; 
import Strategic_Gross_Sales from '@salesforce/schema/Account.Strategic_Value_Gross_Sales__c';
import First_Competitor_Main_Strength from '@salesforce/schema/Account.First_Competitor_Main_Strength__c';
import First_Competitor_Main_Weakness from '@salesforce/schema/Account.First_Competitor_Main_Weakness__c';
import Second_Competitor_Main_Strength from '@salesforce/schema/Account.Second_Competitor_Main_Strength__c';
import Second_Competitor_Main_Weakness from '@salesforce/schema/Account.Second_Competitor_Main_Weakness__c';
import Competitors_Data_Last_updated from '@salesforce/schema/Account.Competitors_Info_Last_updated_On__c';
import Strategic_Value_Last_Update from '@salesforce/schema/Account.Strategic_Value_Last_Update__c';

import Hoya_Gross_SOW_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Gross_Sales_SOW_Last_3Mo__c';
import Hoya_Gross_SOW_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Gross_Sales_SOW_Last_12Mo__c';
import Hoya_Net_SOW_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Net_Sales_SOW_Last_3Mo__c';
import Hoya_Net_SOW_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Net_Sales_SOW_Last_12Mo__c';
import Hoya_Lens_Net_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Lens_Net_Sales_Last_12Mo__c';
import Hoya_Lens_Net_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Lens_Net_Sales_Last_3Mo__c';
import Hoya_Lens_Gross_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Lens_Gross_Sales_Last_12Mo__c';
import Hoya_Lens_Gross_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Hoya_Lens_Gross_Sales_Last_3Mo__c';
import Seiko_Gross_SOW_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Gross_Sales_SOW_Last_3Mo__c';
import Seiko_Gross_SOW_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Gross_Sales_SOW_Last_12Mo__c';
import Seiko_Net_SOW_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Net_Sales_SOW_Last_3Mo__c';
import Seiko_Net_SOW_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Net_Sales_SOW_Last_12Mo__c';
import Seiko_Lens_Net_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Lens_Net_Sales_Last_12Mo__c';
import Seiko_Lens_Net_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Lens_Net_Sales_Last_3Mo__c';
import Seiko_Lens_Gross_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Lens_Gross_Sales_Last_12Mo__c';
import Seiko_Lens_Gross_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Seiko_Lens_Gross_Sales_Last_3Mo__c';
import H_S_Gross_SOW_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Gross_Sales_SOW_Last_3Mo__c';
import H_S_Gross_SOW_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Gross_Sales_SOW_Last_12Mo__c';
import H_S_Net_SOW_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Net_Sales_SOW_Last_3Mo__c';
import H_S_Net_SOW_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Net_Sales_SOW_Last_12Mo__c';
import H_S_Lens_Net_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Lens_Net_Sales_Last_12Mo__c';
import H_S_Lens_Net_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Lens_Net_Sales_Last_3Mo__c';
import H_S_Lens_Gross_12Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Lens_Gross_Sales_Last_12Mo__c';
import H_S_Lens_Gross_3Mo from '@salesforce/schema/Last_Sales_Statistics__c.H_S_Lens_Gross_Sales_Last_3Mo__c';
import First_Competitor_SOW_Last3Months from '@salesforce/schema/Last_Sales_Statistics__c.First_Competitor_SOW_Last_3_Month__c';
import Second_Competitor_SOW_Last3Months from '@salesforce/schema/Last_Sales_Statistics__c.Second_Competitor_SOW_Last_3_Month__c';

//apex
import getLastSalesId from '@salesforce/apex/TabStatisticsController.getLastSalesStatisticsId';
import wireUpdateRecord from '@salesforce/apex/TabStatisticCompetitorController.UpdateCompetitor';
import CreateTaskRecord from '@salesforce/apex/TabStatisticCompetitorController.CreateNewCompetitorReq';
import SFDC_V2_StandardTask from '@salesforce/apex/Utility.getTaskSFDCStandardTask';
//import FirstCompSOW from '@salesforce/apex/TabStatisticCompetitorController.getFirstCompetitorSOW';

//Custom Labels
import HSLensNetSales from '@salesforce/label/c.H_S_Lens_Net_Sales_Header';
import HSLensGrossSales from '@salesforce/label/c.H_S_Lens_Gross_Sales_Header';
import CompetitorLensSuppliers from '@salesforce/label/c.Competitor_Lens_Suppliers_Header';
import lblErrorAssignTo from '@salesforce/label/c.SFDC_V_2_AccountMembership_AssignErrBody';
import lblErrorSubject from '@salesforce/label/c.SFDC_V_2_AccountMembership_SubjectErrBody';
import lblAccount from '@salesforce/label/c.tabTaskModalAccContact';
import lblAccountError from '@salesforce/label/c.SFDC_V_2_AccountMembership_RelateErrBody';
import getChatterUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';
import lblComment from '@salesforce/label/c.Comment';

// Fields to retrieve
const FIELDS =  [Account_First_Local_Name,Account_Second_Local_Name];

export default class TabStatisticsPotential extends LightningElement {
    @api receivedId;    
    @api isGermanAccount;                       
    showAllTab=false;						
    
    lastSalesId;
    FirstCompLocalName;
    SecondCompLocalName;
    objectApiName=Account_obj;
    LastSalesObjectName = Last_Sales_Statistics_obj;
    //X1stCompetitorSOW;

    FirstCompetitorLocal = this.FirstCompLocalName;
    SecondCompetitorLocal = this.SecondCompLocalName;
    //FirstCompetitorSOW = this.X1stCompetitorSOW;

    field1 = [Account_First_Local_Name, Account_First_Global_Name];
    field3 = [Account_Second_Local_Name, Account_Second_Global_Name];
    FirstCompetitorSOWField = [First_Competitor_SOW_Last3Months];
    SecondCompetitorSOWField = [Second_Competitor_SOW_Last3Months];
    FirstCompetitorWeakness = [First_Competitor_Main_Strength, First_Competitor_Main_Weakness];
    SecondCompetitorWeakness = [Second_Competitor_Main_Strength, Second_Competitor_Main_Weakness];
    
    //fields = [Account_First_Local_Name, Account_First_Global_Name, Account_Second_Local_Name, Account_Second_Global_Name];
    Account_Strategic_Net_Field = [Strategic_Net_Sales];
    Account_Strategic_Gross_Field = [Strategic_Gross_Sales];
    Last_Net_Sales = [Hoya_Lens_Net_12Mo,Seiko_Lens_Net_12Mo,H_S_Lens_Net_12Mo,Hoya_Net_SOW_12Mo,Seiko_Net_SOW_12Mo,H_S_Net_SOW_12Mo];
    Last_Net_Sales_3Mo = [Hoya_Lens_Net_3Mo,Seiko_Lens_Net_3Mo,H_S_Lens_Net_3Mo,Hoya_Net_SOW_3Mo,Seiko_Net_SOW_3Mo,H_S_Net_SOW_3Mo];
    Last_Gross_Sales = [Hoya_Lens_Gross_12Mo,Seiko_Lens_Gross_12Mo,H_S_Lens_Gross_12Mo,Hoya_Gross_SOW_12Mo,Seiko_Gross_SOW_12Mo,H_S_Gross_SOW_12Mo];
    Last_Gross_Sales_3Mo = [Hoya_Lens_Gross_3Mo,Seiko_Lens_Gross_3Mo,H_S_Lens_Gross_3Mo,Hoya_Gross_SOW_3Mo,Seiko_Gross_SOW_3Mo,H_S_Gross_SOW_3Mo];
    isRender = true;
    showLoading = false;
    StrategicValueLastUpdate;
    CompetitorsDataLastupdated
    

    @track isModalOpen = false;
    @track isNewTaskModalOpen = false;
    @track value = 'New';
    @track labelSubject = 'Request to Add New Competitor in SFDC';
    @track labelInstructionDefault = 'Request to change for Competitor';
    @track defaultAccountId = this.receivedId;

    subject = this.labelSubject;
    duedate;
    whomid;
    instruction = this.labelInstructionDefault;
    firstCompetitorLocalName;
    firstCompetitorGlobalName;
    status = this.value;
    whatid = this.receivedId;
    
    @track StatusOptions;
    TaskStatusRecordTypeId;

    custLabel = {
        CompetitorLensSuppliers,
        HSLensGrossSales,
        HSLensNetSales,
        lblErrorAssignTo, lblErrorSubject,
        lblAccount, lblAccountError, lblComment
    }
    constructor() {
        super();
        // passed parameters are not yet received here
        
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

    subjectCH(event){
        this.subject = event.target.value;
    }

    duedatechange(event){
        this.duedate = event.target.value;
    }

    @wire(getRecord, { recordId: '$receivedId', fields: [Strategic_Value_Last_Update,Competitors_Data_Last_updated] })
        accDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Strategic_Value_Last_Update__c.value != null) {
                this.StrategicValueLastUpdate = data.fields.Strategic_Value_Last_Update__c.value;
            }
            if (data.fields.Competitors_Info_Last_updated_On__c.value != null) {
                this.CompetitorsDataLastupdated = data.fields.Competitors_Info_Last_updated_On__c.value;
            }
            
            
        }
    }
    assignedtoChange(event){
        this.whomid = event.target.value;
    }

    instructionChange(event){
        this.instruction = event.target.value;
    }

    statuschange(event){
        this.status = event.target.value;
    }

    accountIdChange(event){
        this.whatid = event.target.value;
    }

    firstCompetitorLocalChange(event){
        this.firstCompetitorLocalName = event.target.value;

        var localcompetitor = this.firstCompetitorLocalName;
        if(this.firstCompetitorLocalName==undefined || this.firstCompetitorLocalName==null){
            localcompetitor = '';
        }

        var globalcompetitor = this.firstCompetitorGlobalName;
        if(this.firstCompetitorGlobalName==undefined || this.firstCompetitorGlobalName==null){
            globalcompetitor = '';
        }
        this.instruction = 'Please reach out to vc-salesforcesupport@hoya.com or raise a freshservice '+
                            'request with global SFDC team to get these values added into SFDC\n'+
                            'First Competitor Local Name : '+localcompetitor+'\n'+
                            'First Competitor Global Name : '+globalcompetitor;
        
    }

    firstCompeitorGlobalChange(event){
        this.firstCompetitorGlobalName = event.target.value;
        var localcompetitor = this.firstCompetitorLocalName;
        if(this.firstCompetitorLocalName==undefined || this.firstCompetitorLocalName==null){
            localcompetitor = '';
        }

        var globalcompetitor = this.firstCompetitorGlobalName;
        if(this.firstCompetitorGlobalName==undefined || this.firstCompetitorGlobalName==null){
            globalcompetitor = '';
        }
        this.instruction = 'Please reach out to vc-salesforcesupport@hoya.com or raise a freshservice '+
                            'request with global SFDC team to get these values added into SFDC\n'+
                            'First Competitor Local Name : '+localcompetitor+'\n'+
                            'First Competitor Global Name : '+globalcompetitor;
        
    }

    handleLookupSelectionOwnerId(event){
        if(event.detail.selectedRecord != undefined){
            this.whomid = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=FormInput7]').value=event.detail.selectedRecord.Id;
        }
    }

    handleLookupSelectAccountId(event){
        if(event.detail.selectedRecord != undefined){
            this.whatid = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=FormInput8]').value=event.detail.selectedRecord.Id;
        }else{
            this.whatid = undefined;
            this.template.querySelector('lightning-input[data-my-id=FormInput8]').value = null;
        }
    }

    handleCreateNewTask(){
        const accountName = this.template.querySelector('lightning-input[data-my-id=FormInput8]').value;
        if(accountName!=null || accountName!=''){
            this.whatid = accountName;
        }
        if(this.subject == '' || this.subject == null){
            this.showToast2('Error', this.custLabel.lblErrorSubject, 'error');
        }else if(this.whatid == '' || this.whatid == null){
            this.showToast2('Error', this.custLabel.lblAccountError, 'error');
        }else if(this.whomid == ''|| this.whomid == null){
            this.showToast2('Error', this.custLabel.lblErrorAssignTo, 'error');
        }else if(this.firstCompetitorLocalName == '' || this.firstCompetitorLocalName == null){
            this.showToast2('Error', 'Please input for First Competitor Local Name', 'error');
        }else if(this.firstCompetitorGlobalName == '' || this.firstCompetitorGlobalName == null){
            this.showToast2('Error', 'Please input for First Competitor Global Name', 'error');
        }else{
            CreateTaskRecord({
                subject : this.subject,
                Instruction : this.instruction,
                assignto : this.whomid,
                duedate : this.duedate,
                sStatus : this.status,
                accountName : this.whatid
            }).then(result=>{
                this.showToast2('Success', 'Create new task done', 'success');
                this.closeTaskModal();
                this.updateRecordView();
                this.instruction = 'Request to change for Competitor';
                this.subject = 'Request to Add New Competitor in SFDC';
                this.whomid = undefined;
                this.whatid = undefined;
                this.firstCompetitorLocalName = '';
                this.firstCompetitorGlobalName = '';
            }).catch(error=>{
                this.showToast2('Error', 'Error during create new task', 'error');
            });
        }
    }

    @wire(getRecord, { recordId: '$receivedId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            this.FirstCompLocalName = data ? data.fields.First_Competitor_local_name__c.value : '';
            this.SecondCompLocalName = data ? data.fields.Second_Competitor_Local_Name__c.value : '';
            this.FirstCompetitorLocal = this.FirstCompLocalName;
            this.SecondCompetitorLocal = this.SecondCompLocalName;
        } else if (error) {
            console.error(error);
             this.showToast2('Error', error, 'error');
        }
    }


    //Get Last Sales Statistics Object Id based current Account Record Id
    @wire(getLastSalesId,{accId:'$receivedId'})
    getInfos({error,data}){
        if(error){
            this.showToast('Error', error, error);
        }else if(data){
            this.lastSalesId = JSON.parse(JSON.stringify(data));
        }
    } 
   
    handleSubmit(event) {
        this.showToast('Success', 'Success', 'The update is success.Please wait a while to get the changes reflected');
        this.showLoading = true;
        this.isRender =false;
        this.updateRecordView();    
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

    showToast2(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
    
    updateRecordView(){
        setTimeout(() => {
            this.showLoading = false;
            this.isRender = true;          
        },2000);
        let RecordstoUpdate = [{recordId: this.receivedId}];  
        if(this.lastSalesId){
            RecordstoUpdate = [...RecordstoUpdate,{recordId: this.lastSalesId}];
        } 
        notifyRecordUpdateAvailable(RecordstoUpdate); 
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

    hadleLookupSelectCompValue2(event){
        if(event.detail.selectedRecord != undefined){
            this.template.querySelector('lightning-input[data-my-id=form-input-3').value = event.detail.selectedRecord.Value;
            const queryTemplate = this.template.querySelector('lightning-input[data-my-id=form-input-3').value;
            if(queryTemplate != null || queryTemplate != ''){
                this.SecondCompetitorLocal = event.detail.selectedRecord.Value;
            }else{
                queryTemplate = '';
                this.SecondCompetitorLocal= '';
            }
        }else{
            this.SecondCompetitorLocal = '';
            this.template.querySelector('lightning-input[data-my-id=form-input-3').value= '';
        }
    }

    handleChangeCompetitor(event){
        this.FirstCompetitorLocal = event.target.value;
        //this.FirstCompetitorLocal = event.detail.selectedRecord.Value;
        //this.showToast2('success', 'sucess', 'success');
    }

    handleChange2Competitor(event){
        this.SecondCompetitorLocal = event.target.value;
    }

    handleUpdateCompetitor(){
            this.showLoading = true;
            wireUpdateRecord({
                recordId : this.receivedId,
                firstCompetitorName : this.FirstCompetitorLocal,
                secondCompetitorName : this.SecondCompetitorLocal
            }).then(result=>{
                this.closeModal();
                this.FirstCompLocalName = this.FirstCompetitorLocal;
                this.SecondCompLocalName = this.SecondCompetitorLocal;
                this.FirstCompetitorSOW = this.X1stCompetitorSOW;
                this.showToast2('Success', '1st Local competitor was updated to '+JSON.stringify(this.FirstCompetitorLocal), 'success');
                this.showToast2('Success', '2nd Local competitor was updated to '+JSON.stringify(this.SecondCompetitorLocal), 'success');
                this.isRender = false;
                this.updateRecordView();
            }).catch(error=>{
                this.showLoading = false;
                this.showToast2('Error', 'Error during update record', 'error');
            });
        
    }

    openModal(){
        this.isModalOpen = true;
    }

    newTaskOpenModal(){
        this.isNewTaskModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
    }

    closeTaskModal(){
        this.isNewTaskModalOpen = false;
        this.instruction = 'Request to change for Competitor';
        this.subject = 'Request to Add New Competitor in SFDC';
        this.whomid = undefined;
        this.whatid = undefined;
    }
    @wire(getChatterUserDetail)
        allStages({data }) {
			if (data) {
				this.showAllTab = data;
			} 
			else{
				this.showAllTab = false;
			}
        }
        renderedCallback() {
            // Check if the style element already exists to prevent duplication
            if (!this.template.querySelector('style[data-id="slds-competitors-css"]')) {
                const style = document.createElement('style');
                style.setAttribute('data-id', 'slds-competitors-css');
                style.innerText = `
                    .slds-competitors-css .slds-form-element__label {
                        color: rgb(188, 188, 190) !important;
                    }
                    .slds-competitors-css .slds-form-element__static {
                        color: rgb(188, 188, 190) !important;
                    }
                `;
                this.template.querySelector('lightning-output-field.slds-competitors-css').appendChild(style);
            }
        }
}