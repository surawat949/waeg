import { LightningElement,api,wire} from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Object
import LastSalesStatistics_obj from '@salesforce/schema/Last_Sales_Statistics__c';
//fields
import LensesNetSales12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Last_12Mo__c';
import LensesNetSalesLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_LFY__c';
import LensesNetSales12MoVsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Last_12Mo_vs_LFY__c';
import LensesNetSOWlast12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_SoW_Last_12Mo__c';
import LensesQtyLast12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_Last_12Mo__c';
import LensesQtyLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_LFY__c';
import LensesQtyLast12MoVsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_Last_12Mo_vs_LFY__c';

import LensesGrossSales12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Last_12Mo__c';
import LensesGrossSalesLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_LFY__c';
import LensesGrossSales12MoVsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Last_12Mo_vs_LFY__c';
import LensesGrossSOWlast12Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_SoW_Last_12Mo__c';

import LensesNetSalesCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_CFY__c';
import LensesQtyCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_CFY__c';
import LensesSalesLFYYTD from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_LFY_YTD__c';
import LensesQtyLFYYTD from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_LFY_YTD__c';
import LensesSalesCFYvsLFYYTD from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_CFY_vs_LFY_YTD__c';
import LensesQtyCFYvsLFYYTD from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_CFY_vs_LFY_YTD__c';

import LensesGrossSalesCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_CFY__c';
import LensesGrossSalesLFYYTD from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_LFY_YTD__c';
import LensesGrossSalesCFYvsLFYYTD from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_CFY_vs_LFY_YTD__c';
import LensesGrossSales3MoCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Last_3Mo_CFY__c';
import LensesGrossSales3MoLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Last_3Mo_LFY__c';
import LensesGrossSales3MoCFYvsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Last_3Mo_CFY_vs_LFY__c';
import LensesGrossSOW3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_SoW_Last_3Mo__c';

import LensesSales3MoCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Last_3Mo_CFY__c';
import LensesSales3MoLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Last_3Mo_LFY__c';
import LensesSales3MoCFYvsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c';
import LensesQty3MoCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_Last_3Mo_CFY__c';
import LensesQty3MoLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_Last_3Mo_LFY__c';
import LensesQty3MoCFYvsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Qty_Last_3Mo_CFY_vs_LFY__c';
import LensesSOW3Mo from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_SoW_Last_3Mo__c';

import LensesSalesForecastCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Forecast_CFY__c';
import LensesSalesForecastCFYvsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Forecast_CFY_vs_LFY__c';
import LensesSalesForecastvsECP from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Net_Sales_Forecast_vs_ECP__c';

import LensesGSalesForecastCFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Forecast_CFY__c';
import LensesGSalesForecastCFYvsLFY from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Forecast_CFY_vs_LFY__c';
import LensesGSalesForecastvsECP from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Gross_Sales_Forecast_vs_ECP_Agree__c';
//custom labels
import LensesNetSales from '@salesforce/label/c.AccountLensesNetSales';
import LensesGrossSales from '@salesforce/label/c.AccountLensesGrossSales';

//Apex
import getLastSalesId from '@salesforce/apex/TabStatisticsController.getLastSalesStatisticsId';
import getCurrency from '@salesforce/apex/TabStatisticsController.getCurrency';
const fields = [LensesNetSales12Mo,LensesNetSalesLFY,LensesNetSales12MoVsLFY,LensesNetSOWlast12Mo,LensesQtyLast12Mo,
    LensesQtyLFY,LensesQtyLast12MoVsLFY,LensesNetSalesCFY,LensesQtyCFY,LensesSalesLFYYTD,LensesQtyLFYYTD,LensesSalesCFYvsLFYYTD,LensesQtyCFYvsLFYYTD,
    LensesSales3MoCFY,LensesSales3MoLFY,LensesSales3MoCFYvsLFY,LensesQty3MoCFY,LensesQty3MoLFY,LensesQty3MoCFYvsLFY,LensesSOW3Mo,
    LensesSalesForecastCFY,LensesSalesForecastCFYvsLFY,LensesSalesForecastvsECP,
    LensesGrossSales12Mo,LensesGrossSalesLFY,LensesGrossSales12MoVsLFY,LensesGrossSOWlast12Mo,
    LensesGrossSalesCFY,LensesGrossSalesLFYYTD,LensesGrossSalesCFYvsLFYYTD,LensesGrossSales3MoCFY,LensesGrossSales3MoLFY,LensesGrossSales3MoCFYvsLFY,
    LensesGrossSOW3Mo,LensesGSalesForecastCFY,LensesGSalesForecastCFYvsLFY,LensesGSalesForecastvsECP];
export default class TabStatisticsLensesNetSales extends LightningElement {
    @api receivedId;
    @api type;
    isTypeNet =true;
    lastSalesId;
    CurrencyCode;
    objectApiName = LastSalesStatistics_obj;
    lastSalesStatistics;
    custLabel = {
        LensesNetSales,LensesGrossSales
    }
    constructor() {
       /* */
        super();
        // passed parameters are not yet received here
        
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
    //Get Last Sales Statistics Object Id based current Account Record Id
    @wire(getLastSalesId,{accId:'$receivedId'})
    getInfos({error,data}){
        console.log(this.receivedId);
        if(error){
            this.showToast('Error', 'Error',error);
        }else if(data){
            this.lastSalesId = JSON.parse(JSON.stringify(data));
           
        }
        if(this.type == 'Net')
            this.isTypeNet = true;
        else
            this.isTypeNet = false;
        return;
    } 
    @wire(getRecord, { recordId: "$lastSalesId", fields })
    record( { error, data }){
        if(data){
            this.lastSalesStatistics = data;
           
        }else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
    get LensesSalesLast12Mo(){  
        var value; 
        if(this.type == 'Net') {
            value = getFieldValue(this.lastSalesStatistics,LensesNetSales12Mo);
        } 
        else{
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSales12Mo);
        }
        if(value == null)
            return 0;
        else
            return value;    
    }
    get LensesQtyLast12Mo(){       
        var value = getFieldValue(this.lastSalesStatistics,LensesQtyLast12Mo);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesLFY(){       
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesNetSalesLFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSalesLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQtyLFY(){       
        var value = getFieldValue(this.lastSalesStatistics,LensesQtyLFY);
        if(value == null)
            return 0;
        else
           return value; 
    }
    get LensesSales12MovsLFY(){       
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesNetSales12MoVsLFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSales12MoVsLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQty12MovsLFY(){       
        var value = getFieldValue(this.lastSalesStatistics,LensesQtyLast12MoVsLFY);
        if(value == null)
        return 0;
    else
        return value; 
    }
    get LensesSowLast12Mo(){       
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesNetSOWlast12Mo);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSOWlast12Mo);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesCFY(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesNetSalesCFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSalesCFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQtyCFY(){
        var value = getFieldValue(this.lastSalesStatistics,LensesQtyCFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesLFYYTD(){
        var value;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSalesLFYYTD);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSalesLFYYTD);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQtyLFYYTD(){
        var value = getFieldValue(this.lastSalesStatistics,LensesQtyLFYYTD);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesCFYvsLFYYTD(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSalesCFYvsLFYYTD);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSalesCFYvsLFYYTD);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQtyCFYvsLFYYTD(){
        var value = getFieldValue(this.lastSalesStatistics,LensesQtyCFYvsLFYYTD);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSales3MoCFY(){       
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSales3MoCFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSales3MoCFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSales3MoLFY(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSales3MoLFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSales3MoLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSales3MoCFYvsLFY(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSales3MoCFYvsLFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSales3MoCFYvsLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQty3MoCFY(){
        var value = getFieldValue(this.lastSalesStatistics,LensesQty3MoCFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQty3MoLFY(){
        var value = getFieldValue(this.lastSalesStatistics,LensesQty3MoLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesQty3MoCFYvsLFY(){
        var value = getFieldValue(this.lastSalesStatistics,LensesQty3MoCFYvsLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSOW3Mo(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSOW3Mo);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGrossSOW3Mo);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesForecastCFY(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSalesForecastCFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGSalesForecastCFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesForecastCFYvsLFY(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSalesForecastCFYvsLFY);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGSalesForecastCFYvsLFY);
        if(value == null)
            return 0;
        else
            return value; 
    }
    get LensesSalesForecastvsECP(){
        var value ;
        if(this.type == 'Net')
            value = getFieldValue(this.lastSalesStatistics,LensesSalesForecastvsECP);
        else
            value = getFieldValue(this.lastSalesStatistics,LensesGSalesForecastvsECP);
        if(value == null)
            return 0;
        else
            return value; 
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