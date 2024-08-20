import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
//Custom Labels
import Identifier from '@salesforce/label/c.AccountActivationIdentifier';
import IdentifierUsage from '@salesforce/label/c.AccountActivationIdentifierUsage';
import IdentifierLastUsage from '@salesforce/label/c.iDentifier_Last_Usage';
import IdentifierLastTraining from '@salesforce/label/c.iDentifier_Last_Training';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getIdentifierChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

export default class TabActivationEquipmentsIdentifier extends LightningElement {
    @api receivedId;
    LastUsageDate;
    LastTraningDate;
    customlabel = {
        Identifier,IdentifierUsage,IdentifierLastUsage,IdentifierLastTraining
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'HOYA Identifier+'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool : 'HoyaiLog orders with Hoya iDentifier',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
         //Identifier chart
         getIdentifierChart({recordId : this.receivedId,tool : 'HoyaiLog orders with Hoya iDentifier',type:'ExactMatch'})
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
                     text : 'HoyaiDentifier'
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
                 var el2 = this.template.querySelector('canvas.chartIdentifier');
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