import { LightningElement, api, wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
// fields
import ACCNUMBERILOG from '@salesforce/schema/Account.Account_Number_ILog__c';
import CATALOGNAME from '@salesforce/schema/Account.Catalog_name__c';
import BRAND from '@salesforce/schema/Account.Brand__c';
import SHOP_COUNTRY from '@salesforce/schema/Account.Shop_Country__c';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getHoyaIlogForChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';
//Custom Labels
import HoyaIlog from '@salesforce/label/c.AccountActivationHoyaIlog';
import HoyaIlogOrders from '@salesforce/label/c.AccountActivationHoyaIlogOrders';
import HoyaiLog_Last_Usage from '@salesforce/label/c.HoyaiLog_Last_Usage';
import HoyaiLog_Last_Training from '@salesforce/label/c.HoyaiLog_Last_Training';



export default class TabActivationPortalHoyailog extends LightningElement {
    @api receivedId;
    objectapiname = ACCOUNT_OBJ;
    hoyaILogFields=[ACCNUMBERILOG,CATALOGNAME,BRAND,SHOP_COUNTRY];
    LastTraningDate;
    LastUsageDate;
    CustLabel={
        HoyaIlog,HoyaIlogOrders,HoyaiLog_Last_Usage,HoyaiLog_Last_Training
    };

    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic :'Hoya iLog'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool :'HoyaiLog orders',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        const curr = new Date();
        //get Last 24 months based on current date
        function getPrevMonth(_,i){
            const prev = new Date(curr.getFullYear(), curr.getMonth()-i, 0);
            var mon ;
            if(prev.getMonth()+1  > 9)
                mon = prev.getMonth()+1;
            else
                mon = String(prev.getMonth() + 1).padStart(2, '0');
            return [mon, prev.getFullYear()].join('/')// format as desired
        }
        const months = Array.from({length:24}, getPrevMonth);
        const monthLabels = months.reverse();
         //HoyaIlog Order chart
         var visuRealDataSet =[] ;
         getHoyaIlogForChart({recordId : this.receivedId,tool : 'Hoyailog orders with Visureal',type:'ExactMatch'})
         .then(response => {
            response = JSON.parse(JSON.stringify(response));
            let res = response;
            var dataMap = new Map();
            res.forEach(function(key){
                dataMap.set(key.label.substr(-2)+'/'+key.label.substring(0,4),key.qty);
            });
            for(var i = 0;i < monthLabels.length;i++){
               if(dataMap.has(monthLabels[i])){
                  visuRealDataSet.push(dataMap.get(monthLabels[i]));
               }
               else{
                   visuRealDataSet.push(0);
               }
            }
         })
         .catch(error => {
            this.showToast('Error', 'Error', error.message);
         })
        //HoyaIlog Order chart
        getHoyaIlogForChart({recordId : this.receivedId,tool : 'HoyaiLog orders',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            let val = response;
            var labelset = [];
            var dataset = [];

            val.forEach(function(key){
                var labelDate = key.label.substr(-2)+'/'+key.label.substring(0,4);
                if(months.includes(labelDate))
                    dataset.push(key.qty);
                else
                    dataset.push(0);
            });
            var linechart = {
                labels : monthLabels,
                datasets : [{
                    label : 'HoyaiLOG Orders',
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
                },
                {
                    label : 'HoyaiLOG Orders with visuReal',
                    backgroundColor: 'rgb(255, 99, 132)',
                    borderColor: 'rgb(255, 99, 132)',
                    pointBorderColor: "white",
                    pointBackgroundColor: "black",
                    pointBorderWidth: 1,
                    pointHoverRadius: 8,
                    pointHoverBackgroundColor: "brown",
                    pointHoverBorderColor: "yellow",
                    pointHoverBorderWidth: 2,
                    pointRadius: 4,
                    pointHitRadius: 10,
                    fill: false,
                    data : visuRealDataSet
                }]
            };

            var optionLinechart = {
                responsive : false,
                legend:{
                    display:true,
                    position:'bottom',
                    labels: {
                        boxWidth: 15
                    }
                },
                title : {
                    display : true,
                    text : 'HoyaiLOG Orders'
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
                var el2 = this.template.querySelector('canvas.chartHoyaIlog');
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