import { LightningElement, api } from 'lwc';
import chartJs from '@salesforce/resourceUrl/chartJs'
import chartJsPlugin from '@salesforce/resourceUrl/chartJsPlugin'
import {loadScript} from 'lightning/platformResourceLoader'
import Recommended_Visits from '@salesforce/label/c.Recommended_Visits';
import Recommended_Visits_per_Sub_Area from '@salesforce/label/c.Recommended_Visits_per_Sub_Area';

export default class BarCharts extends LightningElement {
    isChartJsInitialized
    chart
    @api recommendedVisitsData;
    @api recommendedVisitsPerSubArea;
    @api ownerName;
    myLabel;
    recommendedVisitsDataTemp = [];
    recommendedVisitsPerSubAreaTemp = [];
    label={
        Recommended_Visits,Recommended_Visits_per_Sub_Area
    }

    renderedCallback(){
        if(this.isChartJsInitialized){
            return;
        }
       

        Promise.all([
            loadScript(this, chartJs+'/chartJs/Chart.js'),
            loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-datalabels.js'),
            loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-doughnutlabel.js')
           // loadScript(this, chartJsPlugin+'/chartJsPlugin/chartjs-plugin-piechart-outlabels.js')
                      
        ]).then(()=>{
            console.log("chartJs loaded succesfully")
            this.isChartJsInitialized = true
            this.recommendedVisitsDataTemp = this.recommendedVisitsData;
            this.recommendedVisitsPerSubAreaTemp = this.recommendedVisitsPerSubArea;
            this.recommendedVisitsData= JSON.parse(JSON.stringify(this.recommendedVisitsDataTemp));
            this.recommendedVisitsPerSubArea= JSON.parse(JSON.stringify(this.recommendedVisitsPerSubAreaTemp));
            this.loadCharts()
        }).catch(error=>{
            console.error('Error while loading the chartJS'+error)
        })
    }

    loadCharts(){
        window.Chart.platform.disableCSSInjection = true
        const canvas = document.createElement('canvas')
        this.template.querySelector('div.chart').appendChild(canvas)
        const ctx = canvas.getContext('2d')
        this.myLabel='Account Owner'+'\n'+ this.ownerName
        this.chart = new window.Chart(ctx, this.config())
    }

    config(){
        return {
            type: 'bar',
            data: {
               labels: [this.myLabel],
                datasets: [{
                    label: this.label.Recommended_Visits +'\n'+ '(Recommended Number Of Visits)',
                    data: this.recommendedVisitsData ? this.recommendedVisitsData:[],
                    backgroundColor: [
                        'rgba(0, 99, 132, 0.6)'
                    ],
                    borderColor: 'rgba(0, 99, 132, 1)',
                    yAxisID: "y-axis-density",
                    borderWidth: 1
                },{

                    label:this.label.Recommended_Visits_per_Sub_Area,
                    data: this.recommendedVisitsPerSubArea ? this.recommendedVisitsPerSubArea:[],
                    backgroundColor: [
                        'rgba(99, 132, 0, 0.6)'
                    ],
                    borderColor: 'rgba(99, 132, 0, 1)',
                   // yAxisID: "y-axis-gravity",
                    borderWidth: 1
                }
            ]
            },
            options: {
                responsive: true,
                legend: {
                    position: 'bottom'
                },
                scales: {
                    xAxes: [{
                      barPercentage: 0.5,
                      categoryPercentage: 0.3
                    }],
                    yAxes: [{
                      id: "y-axis-density"
                    }
                    /*, {
                      id: "y-axis-gravity"
                    }*/]
                  },

                  plugins: {
                    datalabels: {
                        anchor: 'end',
                        align: 'top',
                        formatter: Math.round,
                        font: {
                            //weight: 'bold',
                            size: 9
                        }
                    },
                  }
            }
        
            }
        }
    }