import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
//Custom Labels
import myStyle from '@salesforce/label/c.AccountActivationMyStyle';
import myStyleUsage from '@salesforce/label/c.AccountActivationMyStyleUsage';
import myStyleLastUsage from '@salesforce/label/c.MyStyle_V_Consultations_Last_Usage';
import myStyleLastTraining from '@salesforce/label/c.MyStyle_V_Consultations_Last_Training';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

export default class TabActivationEquipmentsMystyle extends LightningElement {
    @api receivedId;
    lastUsageDate;
    lastTraningDate;
    customlabel = {
        myStyle,myStyleUsage,myStyleLastUsage,myStyleLastTraining
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'HOYA MyStyle V+ Consultations'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.lastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool : 'MyStyle V+ consultations',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.lastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        //MyStyle chart
        getChart({recordId : this.receivedId,tool : 'MyStyle V+ consultations',type:'ExactMatch'})
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
                     text : 'MyStyle V+ Consultations'
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
                 var el2 = this.template.querySelector('canvas.chartMyStyle');
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
    showToast(title, message, variant, mode){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant,
            mode : mode
        });
        this.dispatchEvent(event);
    }
}