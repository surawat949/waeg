import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import chartJs from '@salesforce/resourceUrl/chartjs2';

export default class ChartRenderercmp extends LightningElement {
    isChartJsInitialized = false;
    @api height = '150px'; // Default height
    _chartConfig;
    chart;
    chartjsInitialized = false;

    renderedCallback(){
        if(this.isChartJsInitialized){
            return;
        }
       
        Promise.all([
            loadScript(this, chartJs + '/Chart.bundle.min.js'),
            loadScript(this, chartJs + '/Chart.min.js')     
        ]).then(()=>{
            this.isChartJsInitialized = true
            this.initializeChart();
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

    @api
    refreshChart() {
        if (this.chart) {
            this.chart.destroy();
            this.initializeChart();
        }
    }

    @api 
    set chartConfig(val){
        this._chartConfig = val;
        console.log('set chartconfig',JSON.stringify(val));
        if (this.isChartJsInitialized) {
            this.refreshChart();
        }
    }

    get chartConfig(){
        return this._chartConfig;
    }

    initializeChart() {
        const canvas = this.template.querySelector('canvas');
        console.log('initializeChart canvas',JSON.stringify(canvas));
        console.log('initializeChart chartConfig',JSON.stringify(this.chartConfig));
        if (canvas && this.chartConfig) {
            let config = JSON.parse(JSON.stringify(this.chartConfig));
            console.log('initializeChart Config',config);
            this.chart = new window.Chart(canvas, config);
        }
    }

}