import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastMediaUsage from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

//Custom Labels
import Seiko_Vision_Xperience_Column from '@salesforce/label/c.Seiko_Vision_Xperience_Column';
import SVX_Column_Lens_Demo_Last_Usage from '@salesforce/label/c.SVX_Column_Lens_Demo_Last_Usage';
import AccountActivationecolonneMeasurements from '@salesforce/label/c.AccountActivationecolonneMeasurements';//SVX Column Measurement last usage
import AccountActivationEColonneTrainingDate from '@salesforce/label/c.AccountActivationEColonneTrainingDate';//SVX Column last training
import Seiko_Vision_Xperience_Column_Measurement from '@salesforce/label/c.Seiko_Vision_Xperience_Column_Measurement';
import Seiko_Vision_Xperience_Column_Lens_Demo from '@salesforce/label/c.Seiko_Vision_Xperience_Column_Lens_Demo';

export default class TabActivationEquipmentsSvxeColumn extends LightningElement {
    @api receivedId;
    LastTraningDate;
    LastUsageDate;
    LastMeasurementDate;
    CustLabel={
        Seiko_Vision_Xperience_Column,SVX_Column_Lens_Demo_Last_Usage,AccountActivationecolonneMeasurements,
        AccountActivationEColonneTrainingDate,AccountActivationEColonneTrainingDate,Seiko_Vision_Xperience_Column_Measurement,Seiko_Vision_Xperience_Column_Lens_Demo
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'SEIKO Vision Xperience eColonne'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
         //Lens Demo
        getLastMediaUsage({accountId : this.receivedId,tool : 'eColumn Lens Selection%',type : 'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        //Measurements
        getLastMediaUsage({accountId : this.receivedId,tool : 'eColumn Measurements%',type : 'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastMeasurementDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        //Lens Demochart
        getChart({recordId : this.receivedId,tool : 'eColumn Lens Selection%',type:'LikeMatch'})
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
                    text : 'Lens Demonstration'
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
                var el2 = this.template.querySelector('canvas.chartLensDemo');
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
        //measurement
        getChart({recordId : this.receivedId,tool : 'eColumn Measurements%',type:'LikeMatch'})
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
                    text : 'Measurements'
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
                var el2 = this.template.querySelector('canvas.chartMeasurement');
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