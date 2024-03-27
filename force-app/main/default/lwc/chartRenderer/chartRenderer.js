import { LightningElement,api } from 'lwc';
import chartJs from '@salesforce/resourceUrl/chartJs'
import chartJsPlugin from '@salesforce/resourceUrl/chartJsPlugin'
import {loadScript} from 'lightning/platformResourceLoader'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ChartRenderer extends LightningElement {
    isChartJsInitialized
    chart
    @api type
    @api chartData
    @api chartHeading
    @api chartLabels
    @api totalCount = 0;
    displayText ='Total'

    renderedCallback(){
        if(this.isChartJsInitialized){
            return;
        }
       
        Promise.all([
            loadScript(this, chartJs+'/chartJs/Chart.js'),
            loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-datalabels.js'),
            loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-doughnutlabel.js'),
            loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-piechart-outlabels.js')            
        ]).then(()=>{
            this.isChartJsInitialized = true
            this.loadCharts()
        }).catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading ChartJS',
                    message: error.message,
                    variant: 'error',
                }),
            );

        })
    }

    loadCharts(){
        window.Chart.platform.disableCSSInjection = true
        const canvas = document.createElement('canvas')
        this.template.querySelector('div.chart').appendChild(canvas)
        const ctx = canvas.getContext('2d')
        this.chart = new window.Chart(ctx, this.config());
    }
    config(){
        return {
            type: this.type,
            data: {
               labels: this.chartLabels ? this.chartLabels:[],
                datasets: [{
                    label: this.chartHeading,
                    data: this.chartData ? this.chartData:[],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.8)',
                        'rgba(54, 162, 235, 0.8)',
                        'rgba(255, 206, 86, 0.8)',
                        'rgba(75, 192, 192, 0.8)',
                        'rgba(153, 102, 255, 0.8)',
                        'rgba(255, 159, 64, 0.8)'
                    ],
                    borderWidth: 1
                }]
            },

            //ChartDataLabels - plugin to display data inside the chart
            //DoughnutLabel  - plugin to dsiplay text inside the chart
            //outlabels - plugin used to display the data outside in the percentage

            plugins: [ChartDataLabels], //registring plugin
            options: {
                responsive: true,
                legend: {
                    position: 'bottom'
                },
                
                plugins: {
                    doughnutlabel: {
                        paddingPercentage: 1,
                        labels: [
                          {
                            text: this.totalCount,
                            font: {
                              size: 20,
                            },
                          },
                        ],
                      },

                      datalabels: {
                        color: "black",
                        font: {
                            size: 9,
                            //weight: 'bold',
                          },
                        formatter: (value) => {
                            return value +'\n' + '(' + ((value/this.totalCount)*100).toFixed(2)+'%' +')';
                          },
                    },
                }
            },

        }
    }
}