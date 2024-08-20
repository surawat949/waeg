import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getPurchaseChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';
//import getLoyaltyChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

//Custom Labels
import purchaseRegistrationTrainingDate from '@salesforce/label/c.purchaseRegistrationTrainingDate';
import loyaltyProgramLastTraining from '@salesforce/label/c.loyaltyProgramLastTraining';
import AccountSeikoProPurchaseReg from '@salesforce/label/c.AccountSeikoProPurchaseReg';
import Loyalty_Program_Registration from '@salesforce/label/c.Loyalty_Program_Registration';
import Seiko_Purchase_Registration_Consumer_Loyalty_Program from '@salesforce/label/c.Seiko_Purchase_Registration_Consumer_Loyalty_Program';

import SEIKO_DATA_OBJ from '@salesforce/schema/Seiko_Data__c';
export default class TabActivationPortalLoyaltyProgram extends LightningElement {
    @api receivedId;
    @api seikoData;

    seikoDataObjapiName = SEIKO_DATA_OBJ;

    LastPurchaseTraningDate;
    LastLoyalityUsageDate;
    CustLabel={
        purchaseRegistrationTrainingDate,loyaltyProgramLastTraining,AccountSeikoProPurchaseReg,
        Loyalty_Program_Registration,Seiko_Purchase_Registration_Consumer_Loyalty_Program
    };

    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'SVS Purchase registration'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastPurchaseTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })

        getLastTrainingDate({accountId : this.receivedId,topic : 'SVS Loyalty Program Emails'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastLoyalityUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        //Purchase Registration chart
        getPurchaseChart({recordId : this.receivedId,tool : 'Purchase Registrations',type : 'ExactMatch'})
        .then(response => {
             response = JSON.parse(JSON.stringify(response));
             console.log(response);
             let val = response;
             var labelset = [];
             var dataset = [];
 
             val.forEach(function(key){
                 labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                 dataset.push(key.qty);
             });
             var linechart = {
                 labels : labelset,
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
                    data : dataset
                 }]
             };
 
             var optionLinechart = {
                 responsive : true,
                 legend :{
                     display : false,
                     position : 'right'
                 },
                 title : {
                     display : true,
                     text : 'Purchase Registration'
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
                 var el2 = this.template.querySelector('canvas.purchaseChart');
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
         })
         .catch(error => {
             this.showToast('Error', 'Error', error.message);
         })
       
        /*getPurchaseLastTrainingDate({accountId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastPurchaseTraningDate = response.purchaseRegTraining;
            this.LastLoyalityUsageDate = response.loyaltyProTraining;
            console.log('>>>>LastPurchaseTraningDate',this.LastPurchaseTraningDate);
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.body.message);
        })*/
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