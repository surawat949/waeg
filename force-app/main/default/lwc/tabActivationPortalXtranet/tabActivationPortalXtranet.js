import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import chartjs from '@salesforce/resourceUrl/chartjs2';
import { loadScript } from 'lightning/platformResourceLoader';
import ACCOUNT_NUMBER_ILOG from '@salesforce/schema/Account.Account_Number_ILog__c';
import CATALOG_NAME from '@salesforce/schema/Account.Catalog_name__c';
import BRAND from '@salesforce/schema/Account.Brand__c';
import SHOP_COUNTRY from '@salesforce/schema/Account.Shop_Country__c';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';
import getXtranetChart from '@salesforce/apex/tabActivationEquipmentsController.getEquipmentsChart';

//Custom Labels
import AccountActivationSnxOrder from '@salesforce/label/c.AccountActivationSnxOrder';//Seiko Xtranet Last Usage
import AccountActivationSeikoXTranetTrainingDate from '@salesforce/label/c.AccountActivationSeikoXTranetTrainingDate';//SEIKO XTranet last training
import Seiko_Xtranet_Orders from '@salesforce/label/c.Seiko_Xtranet_Orders';
import Seiko_Xtranet from '@salesforce/label/c.Seiko_Xtranet';

export default class TabActivationPortalXtranet extends LightningElement {
    @api receivedId;
    objectapiname = ACCOUNT_OBJ;
    portalXtranet=[ACCOUNT_NUMBER_ILOG,CATALOG_NAME,BRAND,SHOP_COUNTRY];
    LastTraningDate;
    LastUsageDate;
    CustLabel={
        AccountActivationSnxOrder,AccountActivationSeikoXTranetTrainingDate,Seiko_Xtranet_Orders,Seiko_Xtranet
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic:'SEIKO Xtranet'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool :'SXN orders',type:'ExactMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
         //Xtranet Order chart
        getXtranetChart({recordId : this.receivedId,tool : 'SXN orders',type:'ExactMatch'})
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
                    text : 'Xtranet Orders'
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
                var el2 = this.template.querySelector('canvas.chartXtranet');
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