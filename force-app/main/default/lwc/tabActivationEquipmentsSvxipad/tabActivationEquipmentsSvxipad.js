import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastMediaUsage from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

//Custom Labels
import Seiko_Vision_Xperience_iPAD from '@salesforce/label/c.Seiko_Vision_Xperience_iPAD';
import AccountActivationMeasurements from '@salesforce/label/c.AccountActivationMeasurements';//SVX iPad Measurement Last Usage
import AccountActivationFrame from '@salesforce/label/c.AccountActivationFrame';//SVX Ipad Frame Demonstration Last Usage
import AccountActivationLensSelection from '@salesforce/label/c.AccountActivationLensSelection';//SVX Ipad Lens Demonstration Last Usage
import AccountActivationVisionTest from '@salesforce/label/c.AccountActivationVisionTest';//SVX Ipad Reading Test Last Usage
import SVX_Ipad_Last_Training from '@salesforce/label/c.SVX_Ipad_Last_Training';
import Seiko_Vision_Xperience_iPAD_Measurement from '@salesforce/label/c.Seiko_Vision_Xperience_iPAD_Measurement';
import Seiko_Vision_Xperience_iPAD_Lens_Demo from '@salesforce/label/c.Seiko_Vision_Xperience_iPAD_Lens_Demo';
import Seiko_Vision_Xperience_iPAD_Reading_Test from '@salesforce/label/c.Seiko_Vision_Xperience_iPAD_Reading_Test';


export default class TabActivationEquipmentsSvxipad extends LightningElement {
    @api receivedId;
    LastUsageLensDemo;
    LastMeasurementDate;
    LastReadingLast;
    LastFrameDemo;
    LastTraningDate;
    CustLabel={
        Seiko_Vision_Xperience_iPAD,AccountActivationMeasurements,AccountActivationFrame,
        AccountActivationLensSelection,AccountActivationVisionTest,SVX_Ipad_Last_Training,Seiko_Vision_Xperience_iPAD_Measurement,
        Seiko_Vision_Xperience_iPAD_Lens_Demo,Seiko_Vision_Xperience_iPAD_Reading_Test
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic : 'SEIKO Vision Xperience iPad'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
         //Reading Last
        getLastMediaUsage({accountId : this.receivedId,tool : 'Vision Test%',type : 'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastReadingLast = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        //Frame
        getLastMediaUsage({accountId : this.receivedId,tool : 'Frame%',type : 'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastFrameDemo = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        //Measurements
        getLastMediaUsage({accountId : this.receivedId,tool : 'Measurements%',type : 'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastMeasurementDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        //Lens Demo
        getLastMediaUsage({accountId : this.receivedId,tool : 'Lens Selection%',type : 'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastUsageLensDemo = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        //svx Lens Demochart
        getChart({recordId : this.receivedId,tool : 'Lens Selection%',type:'LikeMatch'})
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
                responsive : false,
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
        getChart({recordId : this.receivedId,tool : 'Measurements%',type:'LikeMatch'})
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
                responsive : false,
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
         //Reading Test
        getChart({recordId : this.receivedId,tool : 'Vision Test%',type:'LikeMatch'})
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
                responsive : false,
                legend :{
                    display : false,
                    position : 'right'
                },
                title : {
                    display : true,
                    text : 'Reading Test'
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
                var el2 = this.template.querySelector('canvas.chartReadingTest');
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