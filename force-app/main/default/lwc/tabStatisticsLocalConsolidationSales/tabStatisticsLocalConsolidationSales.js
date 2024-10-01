import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';


import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';

//Custom Labels
import NetSalesCFY from '@salesforce/label/c.AccountNetSalesCFY';
import NetSalesLFYYTD from '@salesforce/label/c.AccountNetSalesLFYYTD';
import GrossSalesCFY from '@salesforce/label/c.AccountGrossSalesCFY';
import GrossSalesLFYYTD from '@salesforce/label/c.AccountGrossSalesLFY';
import VolumeCFY from '@salesforce/label/c.AccountVolumesCFY';
import RelatedVolumesYTD from '@salesforce/label/c.AccountRelatedVolumesYTD';
import RelatedVariation from '@salesforce/label/c.AccountRealtedVariation';
import AccountLensesOnly from '@salesforce/label/c.AccountLensesOnly';
import Save from '@salesforce/label/c.Save_Button';
import LocalKeyNet from '@salesforce/label/c.Local_Key_Consolidation_Net';
import LocalKeyGross from '@salesforce/label/c.Local_Key_Consolidation_Gross';
import lblClose from '@salesforce/label/c.tabLabelClose';
import lblComment from '@salesforce/label/c.Comment';
//Object
import Account_obj from '@salesforce/schema/Account';
//Fields
import LocalConsolidationKey from '@salesforce/schema/Account.Local_Consolidation_Key__c';
import AccountName from '@salesforce/schema/Account.Name';
import HoyaAccountId from '@salesforce/schema/Account.Hoya_Account_ID__c';
import AccountOwnerName from '@salesforce/schema/Account.Account_Owner_Name__c';
import AccountOwnerCompany from '@salesforce/schema/Account.Account_Owner_Company__c';
//Apex
import getConsolidatedAccountsList from '@salesforce/apex/Utility.getConsolidatedAccountsList';
import getMonthlyStatisticsSales from '@salesforce/apex/TabStatisticsController.getMonthlyStatisticsSales';


import getAccountList from '@salesforce/apex/TabStatisticsController.getAccountDataPillList';
import SFDC_V2_StandardTask from '@salesforce/apex/Utility.getTaskSFDCStandardTask';
import CreateNewTask from '@salesforce/apex/TabStatisticsController.CreateSFDCV2Task';
//import WhatId from '@salesforce/schema/Task.WhatId';
const DELAY = 300; //mili second

export default class TabStatisticsLocalConsolidationSales extends LightningElement {
    @api receivedId;
    @api type;
    @api objectApiName = 'Account';
    @api label = 'Select One Or More Accounts';
    @api placeHolder = 'Search';
    
    @track isModalOpen = false;
    @track defaultSubjectValue = 'Please add a unique Local Consolidation Key value (SFDC V2/Statistics/Net Sales tab)';
    @track defaultInstructionValue = 'Please check additional details in Comments fields above section.';
    @track statusOption;
    @track value='New';
    @track defaultComment = '';
    @track commentData;
    @track OwnerNameData;
    @track AccountNameField;
    @track HoyaAccountIdField;
    @track AccountOwnerNameField;
    @track isLoading = false;
    
    isTypeNet =true;
    relatedSales;
    isDataExists = true;
    ObjectApiName = Account_obj;
    field =LocalConsolidationKey;
    wiredResults;
    searchKey;
    hasRecord = false;
    iconName = 'standard:account';
    searchOutput = [];
    selectRecord = [];
    delayTimeout;
    NetColumns = [NetSalesCFY,NetSalesLFYYTD,RelatedVariation,VolumeCFY,RelatedVolumesYTD,RelatedVariation];
    GrossColumns = [GrossSalesCFY,GrossSalesLFYYTD,RelatedVariation,VolumeCFY,RelatedVolumesYTD,RelatedVariation];
    whatId = this.receivedId;
    subject = this.defaultSubjectValue;
    instruction;
    OwnerId;
    ActivityDate;
    status = this.value;
    TaskStatusRecordTypeId;
    consolidatedAccounts = [];
    monthlyStatsData;

    @wire(getRecord, {recordId : "$receivedId", fields : [AccountName, HoyaAccountId, AccountOwnerName]})
    currectAccountName({data, error}){
        if(data){
            this.AccountNameField = data.fields.Name.value;
            this.HoyaAccountIdField = data.fields.Hoya_Account_ID__c.value;
            this.AccountOwnerNameField = data.fields.Account_Owner_Name__c.value;
            this.defaultSubjectValue = this.defaultSubjectValue;
        }else if(error){
            this.showToast('Error', 'error', JSON.stringify(error));
        }
    }
    
    @wire(getRecord, { recordId:'$receivedId', fields: [LocalConsolidationKey,AccountOwnerCompany]})
    AccountDetails

    get localConsolidationKey() {
        return getFieldValue(this.AccountDetails.data, LocalConsolidationKey);
    }

    get AccountOwnerCompany() { 
        return getFieldValue(this.AccountDetails.data, AccountOwnerCompany);
    }

    @wire(getConsolidatedAccountsList,{localConsolidationKey: "$localConsolidationKey",ownerCompany:"$AccountOwnerCompany",type:"$type"})
    getConsolidatedAccs(result){     
        this.wiredResults =  result;
        if(result.data){
          var accountList = [];
          this.relatedSales = JSON.parse(JSON.stringify(result.data));
          if(this.relatedSales.length == 0)
            this.isDataExists = false; 
            this.relatedSales.forEach(res=>{   
                if(res.AccountId != null) {  
                    res.accountLink = '/' + res.AccountId;
                    res.HoyaAccountId = res.hoyaAccountId;
                }
                else{
                    res.accountLink = '#';
                    res.HoyaAccountId= 'Total';  
                }   
            });
            this.error = undefined;
            const accountIds = this.relatedSales.map(account => account.AccountId).filter(accountId => accountId != null && accountId !== '');
            this.consolidatedAccounts = [...accountIds]; 
            console.log('consolidatedAccounts',JSON.stringify(this.consolidatedAccounts));
        }
        else if(result.error){
            this.showToast('Error', 'Error', result.error);
        }
        if(this.type == 'Net')
            this.isTypeNet = true;
        else
            this.isTypeNet = false;
    }

    @wire(getMonthlyStatisticsSales,{accountList: '$consolidatedAccounts',type:'$type'})
    updateMonthlyStatisticsSales(result){
        console.log('Monthly Sales',JSON.stringify(result));
        this.monthlyStatsData = result;
         if(result.data && !this.isEmpty(result.data)){
           this.processSalesData(result.data);
         }
    }

    isEmpty(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }

    processSalesData(salesData) {
        const monthNames = salesData.map(item => item.monthName);
        const salesCFY = salesData.map(item => item.salesCFY);
        const salesLFY = salesData.map(item => item.salesLFY);
        const volumeCFY = salesData.map(item => item.volumeCFY);
        const volumeLFY = salesData.map(item => item.volumeLFY);
        this.salesconfigData = {
            type: 'line',
            data: {
                labels: monthNames,
                datasets: [
                    {
                        label: 'Current Fiscal Year',
                        backgroundColor: 'rgb(99, 255, 132)',
                        borderColor: 'rgb(99, 255, 132)',
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data: salesCFY
                    },
                    {
                        label: 'Last Fiscal Year',
                        backgroundColor: 'rgb(255, 99, 132)',
                        borderColor: 'rgb(255, 99, 132)',
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data: salesLFY
                    }
                ]
            },
            options: {
                responsive: true,
                title: {
                    display: true,
                    text: 'Sales Data'
                },
                tooltips: {
                    mode: 'index',
                    intersect: false
                },
                hover: {
                    mode: 'nearest',
                    intersect: true
                },
                legend:{
                    labels: {
                        boxWidth: 15
                    },
                    display:true,
                    position:'bottom'
                },
                scales: {
                    xAxes: [{
                        ticks: {
                            autoSkip: false,
                            maxRotation: 70,
                            minRotation: 70
                        }
                    }]
                }
            }
        };
        this.volumeConfigData = {
            type: 'line',
            data: {
                labels: monthNames,
                datasets: [
                    {
                        label: 'Current Fiscal Year',
                        backgroundColor: 'rgb(99, 255, 132)',
                        borderColor: 'rgb(99, 255, 132)',
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data: volumeCFY
                    },
                    {
                        label: 'Last Fiscal Year',
                        backgroundColor: 'rgb(255, 99, 132)',
                        borderColor: 'rgb(255, 99, 132)',
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data: volumeLFY
                    }
                ]
            },
            options: {
                responsive: true,
                title: {
                    display: true,
                    text: 'Volume Data'
                },
                legend:{
                    labels: {
                        boxWidth: 15
                    },
                    display:true,
                    position:'bottom'
                },
                tooltips: {
                    mode: 'index',
                    intersect: false
                },
                hover: {
                    mode: 'nearest',
                    intersect: true
                },
                scales: {
                    xAxes: [{
                        ticks: {
                            autoSkip: false,
                            maxRotation: 70,
                            minRotation: 70
                        }
                    }]
                }
            }
        };
    }

    @wire(getAccountList, {searchKey : "$searchKey", objectApiName : "$objectApiName"})
    searchResult({data, error}){
        if(data){
            //console.log(data);
            this.hasRecord = data.length > 0 ? true : false;
            this.searchOutput = data;
            //console.log('@Wire Search is => '+JSON.stringify(data));
        }else if(error){
            this.showToast('Error', 'error', JSON.stringify(error.message));
        }
    }

    @wire(SFDC_V2_StandardTask)
    standard_sfdcv2_task({data,error}){
        if(data){
            data = JSON.parse(JSON.stringify(data));
            this.TaskStatusRecordTypeId = data;
        }else if(error){
            this.showToast('Error', 'Error', JSON.stringify(error.message));
        }
    }

    @wire(getPicklistValuesByRecordType, {objectApiName : 'Task', recordTypeId: '$TaskStatusRecordTypeId'})
    STATUS_PICKLIST_VALUE({data,error}){
        if(data){
            this.statusOption = data.picklistFieldValues.Status.values;
        }else if(error){
            this.showToast('Error', 'Error', JSON.stringify(error.message));
        }
    }
    /*
    getsalesConfig(){ 
        return {
            type: 'bar',
            data: {
                labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
                datasets: [{
                    label: '# of Votes',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        }
    };
    getvolumeConfigData(){
        return{
            type: 'line',
            data: {
                labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                datasets: [{
                    label: 'My First dataset',
                    backgroundColor: 'rgba(75,192,192,0.2)',
                    borderColor: 'rgba(75,192,192,1)',
                    data: [65, 59, 80, 81, 56, 55, 40]
                }]
            },
            options: {}
        }
    };
    */
    volumeConfigData;
    salesconfigData;

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
    doRefresh(event) {
        setTimeout(()=>{
            return refreshApex(this.wiredResults);
        }, 1000)       
    }

    openModal(){
        this.isModalOpen = true;
    }

    closeModal(){
        this.isModalOpen = false;
        this.selectRecord = [];
        this.defaultComment = '';
        this.whatId = this.receivedId;
        this.OwnerId = '';
        this.ActivityDate = '';
        this.status = this.value;
        this.defaultSubjectValue = '';
        this.defaultSubjectValue = 'Please add a unique Local Consolidation Key value';
        this.commentData = '';
        this.defaultInstructionValue = 'Please check additional details in Comments fields under Follow up section below.';
        this.OwnerNameData = '';
        this.searchKey = '';
        this.searchOutput = [];

    }

    changeHandler(event){
        clearTimeout(this.delayTimeout);
        let value = event.target.value;
        this.delayTimeout = setTimeout(()=>{
            this.searchKey = value;
        }, DELAY)
    }

    clickHandler(event){
        let recId = event.target.getAttribute("data-recid");
        let selectsRecord = [];
        if(this.validateDuplicateReocrd(recId)){
            let selectedRecord = this.searchOutput.find(
                (currItem) => currItem.Id === recId
            );
            let pill = {
                type : 'icon',
                label : selectedRecord.Name,
                name : recId,
                iconName : this.iconName,
                alternativeText : selectedRecord.Name,
                HoyaAccountId : selectedRecord.Hoya_Account_ID__c,
                OwnerName : selectedRecord.Owner.Name
                
            };
            this.selectRecord = [...this.selectRecord, pill];
            let copy = [];
            let comments = [];
            let Owner_name = [];
            selectsRecord = this.selectRecord.forEach((ele)=>{
                if(ele.HoyaAccountId!=undefined){
                    copy.push(ele.label + ' | ' + ele.HoyaAccountId + ' | Owner : ' + ele.OwnerName + '\n');
                    comments.push(ele.label + ' | ' + ele.HoyaAccountId +'\n');
                    Owner_name.push(ele.OwnerName + '\n');
                    let unique_OwnerName = [...new Set(Owner_name)].sort();
                    this.OwnerNameData = unique_OwnerName.join('- ');

                    this.defaultComment = 'Please add a unique Local Consolidation Key value for all following accounts : \n- '+ this.AccountNameField + ' | ' +this.HoyaAccountIdField + ' | ' +this.AccountOwnerNameField + '\n' + '- '+copy.join('- ') + '\n' +
                    'Please pay attention that the accounts selected above can belong to different account owners.';

                    this.commentData = 'Please add a unique Local Consolidation Key value for all following accounts : \n- ' + this.AccountNameField + ' | ' +this.HoyaAccountIdField + '\n- '+comments.join('- ') + '\n' + 
                    'Please pay attention that the accounts selected above can belong to different account owners : \n- ' + this.OwnerNameData;

                }else{
                    copy.push(ele.label + ' | Onwer : ' + ele.OwnerName + '\n');
                    comments.push(ele.label + '\n');
                    Owner_name.push(ele.OwnerName +'\n');
                    let unique_OwnerName = [...new Set(Owner_name)].sort();
                    this.OwnerNameData = unique_OwnerName.join('- ');

                    this.defaultComment = 'Please add a unique Local Consolidation Key value for all following accounts : \n- '+ this.AccountNameField + ' | ' + this.HoyaAccountIdField + ' | ' +this.AccountOwnerNameField + '\n' + '- '+copy.join('- ') + '\n' +
                    'Please pay attention that the accounts selected above can belong to different account owners.';

                    this.commentData = 'Please add a unique Local Consolidation Key value for all following accounts : \n- ' + this.AccountNameField + ' | ' + this.HoyaAccountIdField + '\n- '+comments.join('- ') + '\n' +
                    'Please pay attention that the accounts selected above can belong to different account owners : \n- ' + this.OwnerNameData;

                }
            });
            this.searchOutput = '';
            this.searchKey = '';
            this.template.querySelector('lightning-input[data-my-id=form-input-search]').value = '';
        }
    }

    handleRemoveEvent(event){
        const index = event.detail.index;
        this.selectRecord.splice(index, 1);
        let record = [];
        let commments = [];
        let Owner_name = [];
        var datalength = this.selectRecord.length;
        if(datalength == 0){
            this.defaultComment = '';
            this.commentData = '';
            this.OwnerNameData = '';
        }else{
            record = this.selectRecord.forEach((item)=>{
                if(item.HoyaAccountId != undefined){
                    record.push(item.label + ' | ' + item.HoyaAccountId + ' | Owner : ' + item.OwnerName + '\n');
                    commments.push(item.label + ' | '+item.HoyaAccountId + '\n');
                    Owner_name.push(item.OwnerName + '\n');
                    let unique_OwnerName = [...new Set(Owner_name)].sort();
                    this.OwnerNameData = unique_OwnerName.join('- ');

                    this.defaultComment = 'Please add a unique Local Consolidation Key value for all following accounts : \n- ' + this.AccountNameField + ' | ' + this.HoyaAccountIdField + ' | ' + this.AccountOwnerNameField + '\n' + '- '+record.join('- ') + '\n' +
                    'Please pay attention that the accounts selected above can belong to different account owners.';

                    this.commentData = 'Please add a unique Local Consolidation Key value for all following accounts :\n- ' + this.AccountNameField + ' | ' + this.HoyaAccountIdField + '\n- '+ commments.join('- ') + '\n' +
                    'Please pay attention that the accounts selected above can belong to different account owners : \n- ' + this.OwnerNameData;

                    
                }else{
                    record.push(item.label + ' | Owner : ' +item.OwnerName + '\n');
                    commments.push(item.label + '\n');
                    Owner_name.push(item.OwnerName + '\n');
                    let unique_OnwerName = [...new Set(Owner_name)].sort();
                    this.OwnerNameData = unique_OnwerName.join('- ');

                    this.defaultComment = 'Please add a unique Local Consolidation Key value for all following accounts : \n- ' + this.AccountNameField + ' | ' + this.HoyaAccountIdField + ' | ' + this.AccountOwnerNameField + '\n' + '- '+record.join('- ') + '\n' + 
                    'Please pay attention that the accounts selected above can belong to different account owners.';

                    this.commentData = 'Please add a unique Local Consolidation Key value for all following accounts : \n- ' + this.AccountNameField + ' | ' + this.HoyaAccountIdField + '\n- ' + commments.join('- ') + '\n' + 
                    'Please pay attention that the accounts selected above can belong to different account owners : \n- ' + this.OwnerNameData;

                }
            });
        }
    }

    get showPillContainer(){
        return this.selectRecord.length > 0 ? true : false;
    }

    whatIdChange(event){
        this.whatId = event.target.value;
        this.whatId = this.receivedId;
    }

    subjectChange(event){
        this.subject = event.target.value;
    }

    instructionChange(event){
        this.instruction = event.target.value;
    }

    AssignedToChange(event){
        this.OwnerId = event.target.value;
    }

    duedateChange(event){
        this.ActivityDate = event.target.value;
    }

    optionChange(event){
        this.status = event.target.value;
        this.status = event.detail.value;
    }

    handleLookupAccountChange(event){
        if(event.detail.selectedRecord != undefined){
            this.whatId = event.detail.selectedRecord.Id;
            this.whatId = this.receivedId;
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value = event.detail.selectedRecord.Id;
        }else{
            this.whatId = undefined;
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value = null;
        }
    }

    handleLookupOwnerChange(event){
        if(event.detail.selectedRecord != undefined){
            this.OwnerId = event.detail.selectedRecord.Id;
            this.template.querySelector('lightning-input[data-my-id=form-input-5]').value = event.detail.selectedRecord.Id;
        }else{
            this.OwnerId = undefined;
            this.template.querySelector('lightning-input[data-my-id=form-input-5]').value = null;
        }
    }

    validateDuplicateReocrd(selectedRecord){
        let isValid = true;
        let hasRecordSelected = this.selectRecord.find(
            (currItem) => currItem.name === selectedRecord
        );
        if(hasRecordSelected){
            isValid = false;
            this.showToast('Error', 'error', 'You selected duplicate record');
        }else{
            isValid = true;
        }
        return isValid;
    }

    handleCreateTask(){
        this.whatId = this.template.querySelector('lightning-input[data-my-id=form-input-1').value;
        if(this.subject == null || this.subject == ''){
            this.showToast('Error', 'error', 'Subject field is mandatory field');
        }else if(this.OwnerId == null || this.OwnerId == ''){
            this.showToast('Error', 'error', 'Assigned to field is mandatory field');
        }else if(this.whatId == null || this.whatId == ''){
            this.showToast('Error', 'error', 'WhatId field is mandatory field');
        }else if(this.defaultComment.length > 32000){
            this.showToast('Error', 'error', 'Comments field is too long. Please remove some accounts, or some texts here');
        }else{
            this.isLoading = true;
            //this is for after click on save button and values should be following

            CreateNewTask({
                subject : this.defaultSubjectValue,
                whatid : this.whatId,
                instruction : this.commentData,
                assignedTo : this.OwnerId,
                duedate : this.ActivityDate,
                status : this.status,
                suggestion : this.defaultInstructionValue
            }).then(result=>{
                this.showToast('Success', 'success', 'Saved Successfully');
                this.closeModal();
                this.updateRecordView();
                this.doRefresh();
                this.isLoading = false;
            }).catch(error=>{
                this.showToast('Error', 'Error', 'An error was occurred : '+JSON.stringify(error));
                this.isLoading = false;
            });
        }
    }

    updateRecordView(){
        setTimeout(() => {
            
        },1000);
        this.dispatchEvent(new RefreshEvent());
    }

    //array for custom label here
    custLabel = {
        AccountLensesOnly,
        Save,
        LocalKeyNet,
        LocalKeyGross,
        lblClose,
        lblComment
    };
}