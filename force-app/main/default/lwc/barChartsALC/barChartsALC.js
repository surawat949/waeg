import { LightningElement, api } from 'lwc';
import chartJs from '@salesforce/resourceUrl/chartJs'
import chartJsPlugin from '@salesforce/resourceUrl/chartJsPlugin'
import {loadScript} from 'lightning/platformResourceLoader'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BarCharts extends LightningElement {
    isChartJsInitialized
    chart
    @api netsaleslast12mosum;
    @api netsaleslfysum;
    @api ownerName;
    chartData = [];
    myLabel = [];
    barOne = [];
    barTwo = [];
    netsaleslast12mosumTemp;
    netsaleslfysumTemp;
    @api
    checkIfUpdated(){
        setTimeout(() => {
            this.chartData.datasets[0].data = [];
            this.chartData.datasets[0].data.push(this.netsaleslfysum);
            this.chartData.datasets[1].data = [];
            this.chartData.datasets[1].data.push(this.netsaleslast12mosum);
            this.chart.data.datasets.forEach((dataset, index) => {
            dataset.data = this.chartData.datasets[index].data;
        });
        this.chart.update();
        }, 500);
        
    }
    
    connectedCallback(){
        if(this.isChartJsInitialized){
            return;
        }

        Promise.all([
            loadScript(this, chartJs+'/chartJs/Chart.js')
           // loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-piechart-outlabels.js')    
        ]).then(()=>{
            console.log("chartJs loaded succesfully")
            this.setupDataForCharts();
        }).catch(error=>{
            this.showToast('Error','Error while loading the chartJS ==>'+error,'error');
        })
    }

    setupDataForCharts(){
        this.myLabel = [];
        this.barOne = [];
        this.barTwo = [];
        this.isChartJsInitialized = true
        this.myLabel.push('Total Selection');
        this.barOne.push(this.netsaleslast12mosum);
        this.barTwo.push(this.netsaleslfysum);
        this.netsaleslast12mosum= JSON.parse(JSON.stringify(this.barOne));
        this.netsaleslfysum= JSON.parse(JSON.stringify(this.barTwo));
        this.netsaleslast12mosumTemp = this.netsaleslast12mosum;
        this.netsaleslfysum = this.netsaleslfysum;
        this.setupChart()
    }

    setupChart() {
        window.Chart.platform.disableCSSInjection = true
        const canvas = document.createElement('canvas')
        this.template.querySelector('div.chart').appendChild(canvas)
        const ctx = canvas.getContext('2d')
        canvas.style.width = '26rem';
        this.chartData = {
            labels: this.myLabel,
            datasets: [{
                label: 'Lenses Net Sales LFY',
                backgroundColor: 'rgba(255, 159, 64, 0.2)',
                borderColor: 'rgb(255, 159, 64)',
                borderWidth: 1,
                data: this.netsaleslfysum
            }, {
                label: 'Lenses Net Sales L12Mo',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgb(75, 192, 192)',
                borderWidth: 1,
                data: this.netsaleslast12mosum
            }]
        };
        
        var options = {
            title: {
                display: true,
                text: 'Lens Net Sales (LFY/L12Mo)',
                fontSize: 12,
                fontColor: '#333', // You can specify a color using HEX, RGB or CSS color names
                fontStyle: 'bold',
                padding: 6, // Padding between title and chart area
                position: 'top' // Position of the title relative to the chart ('top', 'bottom', 'left', 'right')
            },
            legend: {
                display: false
            },
            scales: {
                xAxes: [{
                    barPercentage: 0.75
                }],
                yAxes: [{
                    ticks: {
                        beginAtZero: true,
                        stepSize: 200000
                    }
                }]
            }
        };
        
        this.chart = new Chart(ctx, {
            type: 'bar',
            data: this.chartData,
            options: options
        });
    }
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        });
        this.dispatchEvent(event);
    }
}