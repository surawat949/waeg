import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
//Custom Labels
import VisurealPortable from '@salesforce/label/c.AccountActivationVisuRealPortable';
import VisurealPortableUsage from '@salesforce/label/c.AccountActivationVisuRealPortableUsage';
import VisurealPortableLastUsage from '@salesforce/label/c.visuReal_Portable_Last_Usage';
import VisurealPortableLastTraining from '@salesforce/label/c.visuReal_Portable_Last_Training';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getVisurealChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

export default class TabActivationEquipmentsVisureal extends LightningElement {
    @api receivedId;
    portableLastUsageDate;
    portableLastTraningDate;
    customlabel = {
        VisurealPortable,VisurealPortableUsage,VisurealPortableLastUsage,VisurealPortableLastTraining
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'HOYA VisuReal Portable'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.portableLastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool : 'visuReal portable measurements',type :'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.portableLastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })      
        //Visureal Portable chart
        getVisurealChart({recordId : this.receivedId,tool : 'visuReal portable measurements',type :'ExactMatch'})
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
                     text : 'visuReal Portable Measurements'
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
                 var el2 = this.template.querySelector('canvas.chartVisureal');
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