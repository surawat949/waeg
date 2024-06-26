import { LightningElement, api } from 'lwc';
import chartJs from '@salesforce/resourceUrl/chartJs'
import chartJsPlugin from '@salesforce/resourceUrl/chartJsPlugin'
import {loadScript} from 'lightning/platformResourceLoader'
export default class Charts extends LightningElement {
    isChartJsInitialized
    chart
    @api type
    @api chartData
    @api chartHeading
    @api chartLabels
    @api totalCount=0;
    displayText='Total'
    pieChartDataTemp = [];
    pieChartLablesTemp = [];
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
            console.log("chartJs loaded succesfully")
            this.isChartJsInitialized = true
            this.pieChartDataTemp = this.chartData;
            this.pieChartLablesTemp = this.chartLabels;
            this.chartData= JSON.parse(JSON.stringify(this.pieChartDataTemp));
            this.chartLabels= JSON.parse(JSON.stringify(this.pieChartLablesTemp));
            this.loadCharts()
        }).catch(error=>{
            console.error('Error while loading the chartJS'+error);
            this.isSpinner=false;
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

            options: {
                responsive: true,
                legend: {
                    position: 'bottom'
                },

                plugins: {
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
                    outlabels: {
                        display : false
                    }
                }
            }
        }
    }
}