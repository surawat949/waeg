import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import LOYALTY_POINT_STATUS from '@salesforce/schema/Account.Loyalty_Point_Status__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getHoyaNetForChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

//Custom Labels
import Hoyanet from '@salesforce/label/c.Hoyanet';
import Hoyanet_Last_Usage from '@salesforce/label/c.Hoyanet_Last_Usage';
import Hoyanet_Last_Training from '@salesforce/label/c.Hoyanet_Last_Training';
import Hoyanet_Login from '@salesforce/label/c.Hoyanet_Login';

export default class TabActivationPortalHoyanet extends LightningElement {
    @api receivedId;
    LastTraningDate;
    LastUsageDate;
    objectapiname = ACCOUNT_OBJ;
    loyaltyPointStatus = [LOYALTY_POINT_STATUS];
    CustLabel={
        Hoyanet,Hoyanet_Last_Usage,Hoyanet_Last_Training,Hoyanet_Login
    };

    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'Hoyanet'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.portableLastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool : 'Hoyanet',type :'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.portableLastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })      
        //HoyaNet chart
        getHoyaNetForChart({recordId : this.receivedId,tool : 'Hoyanet login',type :'ExactMatch'})
        .then(response => {
             response = JSON.parse(JSON.stringify(response));
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
                    backgroundColor: 'rgb(0, 85, 196)',
                    borderColor: 'rgb(0, 85, 196)',
                    pointBorderColor: "white",
                    pointBackgroundColor: "black",
                    pointBorderWidth: 1,
                    pointHoverRadius: 8,
                    pointHoverBackgroundColor: 'rgb(0, 85, 196)',
                    pointHoverBorderColor: "yellow",
                    pointHoverBorderWidth: 2,
                    pointRadius: 4,
                    pointHitRadius: 10,
                    fill: false,
                    data : dataset
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
                     text : 'Hoyanet login'
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
                 var el2 = this.template.querySelector('canvas.chartHoyaNet');
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