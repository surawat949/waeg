import { LightningElement,api,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Custom Labels
import AverageSalesPriceNet from '@salesforce/label/c.AverageSalesPrice';
import AverageSalesPriceGross from '@salesforce/label/c.AverageSalesPriceGross';
import AverageSalesPrice from '@salesforce/label/c.AverageSalesPriceColHeader';
import CurrencyIn from '@salesforce/label/c.Currency_In';
//Apex
import getAverageSales from '@salesforce/apex/TabStatisticsController.getAverageSalesList';
import getMonthWithSales from '@salesforce/apex/TabStatisticsController.getMonthWithSales';
import getCurrency from '@salesforce/apex/TabStatisticsController.getCurrency';
export default class TabStatisticsAverageSalesPrice extends LightningElement {
    @api receivedId;
    @api type;
    CurrencyCode;
    lensesDataLst;
    lensesCFYMap=[];
    lensesCFYQtyMap=[];
    lensesLFYMap=[];
    lensesLFYQtyMap=[];
    avgSalesLFY=[];
    avgSalesCFY=[];
    cFYvsLFY=[];
    test;
    maxMonth;
    colName='Average Sales Price (Net)';
    averageSalesLFY = [];
    totalVar;
    custLabel = {
        AverageSalesPrice,AverageSalesPriceGross,AverageSalesPriceNet,CurrencyIn
    }
    MonthColumns = ['APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC','JAN','FEB','MAR','TOTAL'];   
    
    @wire(getAverageSales,{recordId : "$receivedId"})
    getAverageSales(result){  
        if(result.data){
           this.lensesDataLst = JSON.parse(JSON.stringify(result.data)); 
           var lensesDataCY = this.lensesDataLst[0];
           var lensesDataLY = this.lensesDataLst[1];
           var totalLensesSalesCFY = 0;
           var totalLensesSalesLFY = 0;
           var totalLensesQtyCFY = 0;
           var totalLensesQtyLFY = 0;
           var totalLensesSalesLFYYTD = 0;
           var totalLensesQtyLFYYTD = 0;
           for(let i=1; i<=12; i++){
                if(lensesDataCY[i] != undefined){
                    if(this.type == 'Net'){
                        this.lensesCFYMap.push({value:lensesDataCY[i].lensNetSales,key:i});
                        totalLensesSalesCFY += lensesDataCY[i].lensNetSales;
                    }      
                    else{
                        this.lensesCFYMap.push({value:lensesDataCY[i].lensGrossSales,key:i});
                        totalLensesSalesCFY += lensesDataCY[i].lensGrossSales;
                    }              
                    this.lensesCFYQtyMap.push({value:lensesDataCY[i].lensQty,key:i}); 
                    totalLensesQtyCFY += lensesDataCY[i].lensQty;
                }                  
                else{
                    this.lensesCFYMap.push({value:0,key:i});
                    this.lensesCFYQtyMap.push({value:0,key:i});
                }
                if(lensesDataLY[i] != undefined){
                    if(this.type == 'Net'){
                        this.lensesLFYMap.push({value:lensesDataLY[i].lensNetSales,key:i}); 
                        totalLensesSalesLFY += lensesDataLY[i].lensNetSales;
                    }
                    else{
                        this.lensesLFYMap.push({value:lensesDataLY[i].lensGrossSales,key:i}); 
                        totalLensesSalesLFY += lensesDataLY[i].lensGrossSales;
                    }
                    this.lensesLFYQtyMap.push({value:lensesDataLY[i].lensQty,key:i});  
                    totalLensesQtyLFY += lensesDataLY[i].lensQty;
                  
                }                  
                else{
                    this.lensesLFYMap.push({value:0,key:i});
                    this.lensesLFYQtyMap.push({value:0,key:i});
                }    
            }
            //For Total Sales and Qtd YTD LFY
            let month = this.maxMonth;
            switch (month){                
                case 4:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value;
                    break;
                case 5:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value;
                    break;
                case 6:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value;
                    break;
                case 7:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value;
                    break;
                case 8:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value;
                    break;
                case 9:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value;
                    break;
                case 10:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value+this.lensesLFYMap[9].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value+this.lensesLFYQtyMap[9].value;
                    break;
                case 11:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value+this.lensesLFYMap[9].value+this.lensesLFYMap[10].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value+this.lensesLFYQtyMap[9].value+this.lensesLFYQtyMap[10].value;
                    break;
                case 12:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value+this.lensesLFYMap[9].value+this.lensesLFYMap[10].value+this.lensesLFYMap[11].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value+this.lensesLFYQtyMap[9].value+this.lensesLFYQtyMap[10].value+this.lensesLFYQtyMap[11].value;
                    break;
                case 1:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value+this.lensesLFYMap[9].value+this.lensesLFYMap[10].value+this.lensesLFYMap[11].value+this.lensesLFYMap[0].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value+this.lensesLFYQtyMap[9].value+this.lensesLFYQtyMap[10].value+this.lensesLFYQtyMap[11].value+this.lensesLFYQtyMap[0].value;
                    break;
                case 2:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value+this.lensesLFYMap[9].value+this.lensesLFYMap[10].value+this.lensesLFYMap[11].value+this.lensesLFYMap[0].value+this.lensesLFYMap[1].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value+this.lensesLFYQtyMap[9].value+this.lensesLFYQtyMap[10].value+this.lensesLFYQtyMap[11].value+this.lensesLFYQtyMap[0].value+this.lensesLFYQtyMap[1].value;
                    break;
                case 3:
                    totalLensesSalesLFYYTD = this.lensesLFYMap[3].value+this.lensesLFYMap[4].value+this.lensesLFYMap[5].value+this.lensesLFYMap[6].value+this.lensesLFYMap[7].value+this.lensesLFYMap[8].value+this.lensesLFYMap[9].value+this.lensesLFYMap[10].value+this.lensesLFYMap[11].value+this.lensesLFYMap[0].value+this.lensesLFYMap[1].value+this.lensesLFYMap[2].value;
                    totalLensesQtyLFYYTD = this.lensesLFYQtyMap[3].value+this.lensesLFYQtyMap[4].value+this.lensesLFYQtyMap[5].value+this.lensesLFYQtyMap[6].value+this.lensesLFYQtyMap[7].value+this.lensesLFYQtyMap[8].value+this.lensesLFYQtyMap[9].value+this.lensesLFYQtyMap[10].value+this.lensesLFYQtyMap[11].value+this.lensesLFYQtyMap[0].value+this.lensesLFYQtyMap[1].value+this.lensesLFYQtyMap[2].value;
                    break;

            }
            var lensesSalesCFY = [];
            var lensesQtyCFY = [];
            var lensesSalesLFY = [];
            var lensesQtyLFY = [];
            lensesSalesCFY.push(this.lensesCFYMap[3].value,this.lensesCFYMap[4].value,this.lensesCFYMap[5].value,this.lensesCFYMap[6].value,this.lensesCFYMap[7].value,this.lensesCFYMap[8].value,this.lensesCFYMap[9].value,this.lensesCFYMap[10].value,this.lensesCFYMap[11].value,this.lensesCFYMap[0].value,this.lensesCFYMap[1].value,this.lensesCFYMap[2].value,totalLensesSalesCFY);
            lensesQtyCFY.push(this.lensesCFYQtyMap[3].value,this.lensesCFYQtyMap[4].value,this.lensesCFYQtyMap[5].value,this.lensesCFYQtyMap[6].value,this.lensesCFYQtyMap[7].value,this.lensesCFYQtyMap[8].value,this.lensesCFYQtyMap[9].value,this.lensesCFYQtyMap[10].value,this.lensesCFYQtyMap[11].value,this.lensesCFYQtyMap[0].value,this.lensesCFYQtyMap[1].value,this.lensesCFYQtyMap[2].value,totalLensesQtyCFY);
            lensesSalesLFY.push(this.lensesLFYMap[3].value,this.lensesLFYMap[4].value,this.lensesLFYMap[5].value,this.lensesLFYMap[6].value,this.lensesLFYMap[7].value,this.lensesLFYMap[8].value,this.lensesLFYMap[9].value,this.lensesLFYMap[10].value,this.lensesLFYMap[11].value,this.lensesLFYMap[0].value,this.lensesLFYMap[1].value,this.lensesLFYMap[2].value,totalLensesSalesLFY);
            lensesQtyLFY.push(this.lensesLFYQtyMap[3].value,this.lensesLFYQtyMap[4].value,this.lensesLFYQtyMap[5].value,this.lensesLFYQtyMap[6].value,this.lensesLFYQtyMap[7].value,this.lensesLFYQtyMap[8].value,this.lensesLFYQtyMap[9].value,this.lensesLFYQtyMap[10].value,this.lensesLFYQtyMap[11].value,this.lensesLFYQtyMap[0].value,this.lensesLFYQtyMap[1].value,this.lensesLFYQtyMap[2].value,totalLensesQtyLFY);
            for(let i=0; i<=12; i++){
                var avgSalesCY= 0;
                var avgSalesLY = 0;
                var variation = 0;
                if(lensesQtyCFY[i] != 0)
                    avgSalesCY = lensesSalesCFY[i]/lensesQtyCFY[i];
                if(lensesQtyLFY[i] != 0)
                    avgSalesLY = lensesSalesLFY[i]/lensesQtyLFY[i];
                if(avgSalesCY != 0 && avgSalesLY != 0)
                    variation = ((avgSalesCY-avgSalesLY)/avgSalesLY)*100; 
                this.avgSalesLFY.push(avgSalesLY);
                this.avgSalesCFY.push(avgSalesCY);
                if(i < 12){
                    this.cFYvsLFY.push(variation);
                }
            }
            var avgSalesCYTotal = 0;
            var avgSalesLYTotal = 0 ;
            var variationTotal = 0;
            if(lensesQtyCFY[12] != 0)
                avgSalesCYTotal = lensesSalesCFY[12]/lensesQtyCFY[12];
            if(totalLensesQtyLFYYTD != 0)
                avgSalesLYTotal = totalLensesSalesLFYYTD/totalLensesQtyLFYYTD;

            if(avgSalesCYTotal != 0 && avgSalesLYTotal != 0)
            variationTotal = ((avgSalesCYTotal-avgSalesLYTotal)/avgSalesLYTotal)*100; 
            this.totalVar = variationTotal;
            this.cFYvsLFY.push(this.totalVar);
            this.averageSalesLFY = this.avgSalesLFY;
            this.test = this.avgSalesLFY[0];
        }        
        else if(result.error){
            this.showToast('Error', 'Error', result.error);
        }
    }
    @wire(getCurrency,{recordId: "$receivedId"})
    checkCurrency(result){
        if(result.data){
            this.CurrencyCode = JSON.parse(JSON.stringify(result.data));
        }
        else if(result.error){
            this.showToast('Error', 'Error', result.error);
        }
    }     
    connectedCallback() {
        if(this.type == 'Net')
            this.colName = this.custLabel.AverageSalesPriceNet;
        else
            this.colName = this.custLabel.AverageSalesPriceGross;
        getMonthWithSales({ recordId: this.receivedId})
        .then(response => {
           this.maxMonth = response;
        }).catch(error => {
            this.showToast('Error', error.message, error.message);
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