import { LightningElement, api ,wire} from 'lwc';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Account_obj from '@salesforce/schema/Account'; 
import Seiko_Data from '@salesforce/schema/Seiko_Data__c'; 
//fields
import Red_Customer_Id from '@salesforce/schema/Seiko_Data__c.Redhab_customer_id__c';
import Red_Service_Id from '@salesforce/schema/Seiko_Data__c.Redhab_service_id__c';
import SVS_FB from '@salesforce/schema/Seiko_Data__c.SVS_FB_Page__c';
import Social_radius from '@salesforce/schema/Seiko_Data__c.SVS_Digital_com_Platform_radius__c';
import Social_Activation from '@salesforce/schema/Seiko_Data__c.SVS_Digital_communication_platform__c';
import Social_Confirmation from '@salesforce/schema/Seiko_Data__c.SVS_Digital_com_platform_activation__c';
import Social_Error_Msg from '@salesforce/schema/Seiko_Data__c.WS_error__c';
import VAT_Number from '@salesforce/schema/Account.VAT_EUROPEAN_NUMBER__c';
//Apex
//import getSeikoDataId from '@salesforce/apex/tabActivationEquipmentsController.getSeikoDataId';
import startEnroll from '@salesforce/apex/tabActivationEquipmentsController.startEnroll';
import getChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

//Custom Labels
import SocialManager from '@salesforce/label/c.AccountSeikoProSocialMediaManagment';
import TrainingDate from '@salesforce/label/c.AccountActivationSocialManagerTrainingDate';
import MonthlyPosts from '@salesforce/label/c.Monthly_Posts';
import MonthlyConsumerViews from '@salesforce/label/c.Monthly_Consumer_Views';
import UniqueConsumers from '@salesforce/label/c.Unique_Consumers';
import MonthlyConsumerClicks from '@salesforce/label/c.Monthly_Consumer_Clicks';
import { RefreshEvent } from 'lightning/refresh';
export default class TabActivationPortalSocialMedia extends LightningElement {
    @api receivedId;
    accountRec;
    @api seikoDataId;
    enrollResult;
    //training = 'SVS Social Media Plateform';
   // lastTrainingDate;
    consumerData;
    objectApiName=Account_obj;
    seikoObjName=Seiko_Data;
    seikoFields=[Social_Activation,Social_Confirmation,SVS_FB,Social_radius,Red_Customer_Id,Red_Service_Id,Social_Error_Msg];
       
    accountFields=[VAT_Number];
    custLabel = {
        SocialManager,TrainingDate,MonthlyPosts,MonthlyConsumerViews,UniqueConsumers,MonthlyConsumerClicks
    }
    @wire(getRecord, { recordId: "$receivedId", fields:[VAT_Number] })
    record( { error, data }){
        if(data){
            this.accountRec = data;
            this.vatNumber = data.fields.VAT_EUROPEAN_NUMBER__c.value;
        }
        else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
    /*//Get Seiko Data Object Id based current Account Record Id
    @wire(getSeikoDataId,{accId:'$receivedId'})
    getInfos({error,data}){
        if(error){
            this.showToast('Error', error, error);
        }else if(data){
            this.seikoDataId = JSON.parse(JSON.stringify(data));
        }
    } */
    /*@wire(getLastTrainingDate,{accountId:'$receivedId',training:'$training'})
    getDate({error,data}){
        if(error){
            this.showToast('Error', error, error);
        }else if(data){
            this.lastTrainingDate = JSON.parse(JSON.stringify(data));
        }
    } */
    
    doEnroll(){      
        const accountId = this.receivedId;
        startEnroll({accountId:accountId})
        .then(result =>{
            this.enrollResult= JSON.stringify(result);
            if(this.enrollResult == 'ok'){
                this.showToast('Success','Activation done successfully', 'Customer activation is done');
            }else{
                this.showToast('Error','error',this.enrollResult);
            } 
            this.updateRecordView();           
        })
        .catch(error =>{
            this.errorMsg = error;
        })
    }
    updateRecordView(){
       // eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new RefreshEvent());
    }
    //get Unique Consumers
    //Consumer data should be retrived first ,so added this outside of connected call back
    @wire(getChart,{recordId : '$receivedId',tool : 'Social Media Manager - Social Media – Monthly Reach',type:'ExactMatch'})
    chartData({error,data}){
        if(data){
            data = JSON.parse(JSON.stringify(data));
            let val = data;
            var avgLabelsSet = new Set();
            var labelset = [];  
            var dataset = [];
            var uniqueConsumerMap = new Map();
            val.forEach(function(key){
                labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                dataset.push(key.qty);
                uniqueConsumerMap.set(key.label.substr(-2)+'/'+key.label.substring(0,4),key.qty);
                avgLabelsSet.add(key.label.substr(-2)+'/'+key.label.substring(0,4));
            });
            this.getLineChart(labelset,dataset, 'Unique Consumer Views','canvas.chartConsumers');
            //Avg Consumers
            var data = this.consumerData;
            var consumerMap = new Map();
            if(data != undefined){
                data.forEach(function(key){
                    consumerMap.set(key.label.substr(-2)+'/'+key.label.substring(0,4),key.qty);                
                    avgLabelsSet.add(key.label.substr(-2)+'/'+key.label.substring(0,4));
                });
            }
            console.log(consumerMap);
            var avgConsumerLabelset = [];  
            var avgConsumerDataset = [];
            for (const value of avgLabelsSet) {
                var consumerVal = 0;
                var uniqueConsumerVal = 0;
                if(consumerMap.has(value)){
                    consumerVal = consumerMap.get(value);
                }
                if(uniqueConsumerMap.has(value)){
                    uniqueConsumerVal = uniqueConsumerMap.get(value);
                }
                var avgConsumerVal = 0;
                if(uniqueConsumerVal != 0){
                    avgConsumerVal = consumerVal/uniqueConsumerVal;
                }
                avgConsumerDataset.push(Math.round(avgConsumerVal * 100) / 100 );  
                avgConsumerLabelset.push(value);
            }
            this.getLineChart(avgConsumerLabelset,avgConsumerDataset, 'Average Views per Unique Consumer','canvas.chartAvg');
        }
        else if(error) {
            this.showToast('Error', 'Error', error.message);
        }
    }
    connectedCallback() {
        //get Social media Posts Chart
        getChart({recordId : this.receivedId,tool : 'Social Media Manager – Number of monthly posts',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            let val = response;
            var labelset = [];  
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                dataset.push(key.qty);
            });
            this.getLineChart(labelset,dataset, 'Monthly Posts','canvas.chartSocialPosts');
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        //get Consumer Views 
        getChart({recordId : this.receivedId,tool : 'Social Media Manager – Social Media - Monthly Impressions',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            let val = response;
            console.log(val);
            this.consumerData = response;
            var labelset = [];  
            var dataset = [];           
            val.forEach(function(key){
                labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                dataset.push(key.qty);           
            });
            this.getLineChart(labelset,dataset, 'Consumer Views','canvas.chartSocialViews');
                   
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })       
        //get Manager Clicks
        getChart({recordId : this.receivedId,tool : 'Social Media Manager - Social Media - Monthly Clicks',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            let val = response;
            var labelset = [];  
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                dataset.push(key.qty);
            });
            this.getLineChart(labelset,dataset, 'Monthly Clicks','canvas.chartClicks');           
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
    }
    getLineChart(labelSet,dataSet,title,chartName){
        var linechart = {
            labels : labelSet,
            datasets : [{
                label : 'Qty',
                backgroundColor: 'rgb(191, 144, 0)',
                borderColor: 'rgb(191, 144, 0)',
                pointBorderColor: "white",
                pointBackgroundColor: "black",
                pointBorderWidth: 1,
                pointHoverRadius: 8,
                pointHoverBackgroundColor: 'rgb(191, 144, 0)',
                pointHoverBorderColor: "yellow",
                pointHoverBorderWidth: 2,
                pointRadius: 4,
                pointHitRadius: 10,
                fill: false,
                data : dataSet
            }]
        };

        var optionLinechart = {
            responsive : false,
            legend :{
                display : false,
                position : 'right'
            },
            title : {
                display : true,
                text : title
            }
        };

        const config = {
            type : 'line',
            data : linechart,
            options : optionLinechart
        };
        Promise.all([            
            loadScript(this, chartjs + '/Chart.bundle.min.js'),
            loadScript(this, chartjs + '/Chart.min.js')
        ]).then(() => {
            var el2 = this.template.querySelector(chartName);
            var ctx2 = el2.getContext('2d');
            var linechart2 = new window.Chart(ctx2, config);                
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.message,
                    message: 'error',
                    variant: 'error',
                }),
            );
        }); 
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