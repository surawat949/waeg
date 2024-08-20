import { LightningElement,api,wire} from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
//Custom Labels
import SalesTarget from '@salesforce/label/c.AccountVisitTabSalesTarget';
import MonthlyGrossSales from '@salesforce/label/c.AccountMonthlySalesFigures';
import LensesGrossSales from '@salesforce/label/c.Gross_Sales';
import FiscalYear from '@salesforce/label/c.Fiscal_Year';
import MonthlyObjective from '@salesforce/label/c.AccountVisitTabMonthlyVsSeiko';
import Last12MoVsObjective from '@salesforce/label/c.AccountVisitTabAnnualVsSeiko';
import Lenses from '@salesforce/label/c.AccountLenses';
import Frames from '@salesforce/label/c.AccountFrames';
import ContactLenses from '@salesforce/label/c.AccountContactLenses';
import Instruments from '@salesforce/label/c.AccountInstruments';
import Others from '@salesforce/label/c.AccountOther';
import CurrencyIn from '@salesforce/label/c.Currency_In';
import TotalFY from '@salesforce/label/c.AccountTotalFy';
import TotalLFY from '@salesforce/label/c.AccountTotalLfy';
import Variation from '@salesforce/label/c.AccountVariation';
import LensesLFY from '@salesforce/label/c.AccountLensesSalesLFY';
import LensesVariation from '@salesforce/label/c.AccountLensesVariation';
import Save from '@salesforce/label/c.Save_Button';
import LensSalesForecast from '@salesforce/label/c.Lens_Sales_Forecast_Header_Gross';
import Volumes from '@salesforce/label/c.Volumes';
//Object
import Account_obj from '@salesforce/schema/Account';
//Fields
import AnnualObjEcpAgreement from '@salesforce/schema/Account.Seiko_objective_ECP_agr__c';
//Apex
import getStatisticsSales from '@salesforce/apex/TabStatisticsController.getStatisticsSales';
import getLensesAnnualRevenue from '@salesforce/apex/TabStatisticsController.getLensesAnnualRevenue';
import getCurrency from '@salesforce/apex/TabStatisticsController.getCurrency';
import getMonthWithSales from '@salesforce/apex/TabStatisticsController.getMonthWithSales';
export default class TabStatisticsGrossSales extends LightningElement {
    @api receivedId;
    LensesCFYMap=[];
    FramesCFYMap=[];
    InstrumentsCFYMap = [];
    ContactLensCFYMap = [];
    OthersCFYMap = [];
    TotalSalesCFYMap = [];
    TotalSalesLFYMap = [];
    LensesCFYQtyMap=[];
    LensesLFYQtyMap=[];
    FramesCFYQtyMap=[];
    InstrumentsCFYQtyMap = [];
    ContactLensCFYQtyMap = [];
    OthersCFYQtyMap = [];
    TotalQtyCFYMap = [];
    TotalQtyLFYMap = [];
    LensesLFYMap=[];
    LensesSalesLFY = [];
    LensesSalesCFY = [];
    FramesSalesCFY = [];
    InstrumentsSalesCFY = [];
    ContactLensesSalesCFY = [];
    OthersSalesCFY = []; 
    TotalSalesCFY = [];
    TotalSalesLFY = [];
    LensesCFYQty = [];
    LensesLFYQty = [];
    FramesCFYQty = [];
    InstrumentsCFYQty = [];
    ContactLensesCFYQty = [];
    OthersCFYQty = []; 
    TotalQtyCFY = [];
    TotalQtyLFY = [];
    ObjectApiName = Account_obj;
    AnnualValue;      
    MonthlyObjective =0 ;
    Last12MoVsObjective = 0;
    LensesAnnualSales = 0;
    TotalVariation = [];
    LensesVariation = [];
    TotalQtyVaraition = [];
    TotalLensQtyVariation = [];
    dataNetSales;dataVolume;
    config;
    configVol;
    totalSalesLFYTD = 0;
    totalQtyLFYTD = 0;
    lensesSalesLFYYTD = 0;
    lensesQtyLFYYTD = 0;   
    wiredResults;
    salesObjective;
    Revenue;
    CurrencyCode;    
    field = [AnnualObjEcpAgreement];
    forecastCFY = [];
    CFYvsForecastVariation =[];
    ForecastvsLFY = [];
    maxMonth;
    custLabel = {
        SalesTarget,MonthlyGrossSales,LensesGrossSales,Volumes,CurrencyIn,FiscalYear,
        MonthlyObjective,Last12MoVsObjective,Save,LensSalesForecast,
        Lenses,Frames,ContactLenses,Instruments,Others,TotalFY,TotalLFY,Variation,LensesLFY,LensesVariation
    }
    MonthColumns = ['APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC','JAN','FEB','MAR','TOTAL'];   
    Labels = ['Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec','Jan','Feb','Mar'];
    
    set AnnualRevenue(value) {
        this.Last12MoVsObjective = ((value-this.AnnualValue)/this.AnnualValue)*100;
    }
    
    get AnnualRevenue(){
        return this.Revenue;
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
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    @wire(getRecord, { recordId: "$receivedId", fields:[AnnualObjEcpAgreement] })
    record( { error, data }){
        if(data){
            this.AccountRec = data;
            this.AnnualValue = data.fields.Seiko_objective_ECP_agr__c.value;
            this.MonthlyObjective = this.AnnualValue/12; 
            if(this.Revenue != undefined){
                this.Last12MoVsObjective = ((this.Revenue-this.AnnualValue)/this.AnnualValue)*100;
            }
           }
        else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
    
    connectedCallback() { 
        getLensesAnnualRevenue({recordId: this.receivedId,type : "Gross"})
        .then(response => {
            this.AnnualRevenue = response;
            this.Revenue = response;
         }).catch(error => {
             this.showToast('Error', error.message, error.message);
         
        }) 

        getMonthWithSales({ recordId: this.receivedId})
        .then(response => {
           this.maxMonth = response;
        }).catch(error => {
            this.showToast('Error', error.message, error.message);
        })   
        
        getStatisticsSales({ recordId: this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response));
            var LensesDataCY = [];
            var LensesDataLY = [];      
            var AllSalesDataCY = [];
            var AllSalesDataLY = [];      
            var forecastData = [];
            LensesDataCY = response[0];
            LensesDataLY = response[1];
            AllSalesDataCY = response[3];
            AllSalesDataLY =  response[4];
            if(response[5] != null)
                forecastData = response[5];
            var totalFramesSalesCFY = 0;
            var totalLensesSalesCFY = 0;
            var totalLensesSalesLFY = 0;
            var totalLensesQtyCFY = 0;
            var totalLensesQtyLFY = 0;
            var totalInstrumentsSalesCFY = 0;
            var totalContactLensSalesCFY = 0;
            var totalOthersSalesCFY = 0;
            var totalFramesQtyCFY = 0;
            var totalInstrumentsQtyCFY = 0;
            var totalContactLensQtyCFY = 0;
            var totalOthersQtyCFY = 0;
            var totalSalesCFY = 0;
            var totalQtyCFY = 0;
            var totalLFYSales = 0;
            var totalLFYQty= 0;
            for(let i=1; i<=12; i++){
                if(LensesDataCY[i] != undefined){
                    this.LensesCFYMap.push({value:LensesDataCY[i].lensGrossSales,key:i}); 
                    this.LensesCFYQtyMap.push({value:LensesDataCY[i].lensQty,key:i});                     
                    totalLensesSalesCFY += LensesDataCY[i].lensGrossSales;
                    totalLensesQtyCFY += LensesDataCY[i].lensQty;
                }                  
                else{
                    this.LensesCFYMap.push({value:0,key:i});
                    this.LensesCFYQtyMap.push({value:0,key:i});
                }
                if(AllSalesDataCY[i] != undefined){
                    this.FramesCFYMap.push({value:AllSalesDataCY[i].framesGrossSales,key:i}); 
                    this.InstrumentsCFYMap.push({value:AllSalesDataCY[i].instrumentsGrossSales,key:i}); 
                    this.ContactLensCFYMap.push({value:AllSalesDataCY[i].contactLensGrossSales,key:i}); 
                    this.OthersCFYMap.push({value:AllSalesDataCY[i].otherGrossSales,key:i});
                    this.TotalSalesCFYMap.push({value:AllSalesDataCY[i].totalGrossSales,key:i});
                    
                    this.FramesCFYQtyMap.push({value:AllSalesDataCY[i].framesQty,key:i}); 
                    this.InstrumentsCFYQtyMap.push({value:AllSalesDataCY[i].instrumentsQty,key:i}); 
                    this.ContactLensCFYQtyMap.push({value:AllSalesDataCY[i].contactLensQty,key:i}); 
                    this.OthersCFYQtyMap.push({value:AllSalesDataCY[i].OthersQty,key:i});
                    this.TotalQtyCFYMap.push({value:AllSalesDataCY[i].totalQty,key:i});
                                       
                    totalFramesSalesCFY += AllSalesDataCY[i].framesGrossSales;
                    totalInstrumentsSalesCFY += AllSalesDataCY[i].instrumentsGrossSales;
                    totalContactLensSalesCFY += AllSalesDataCY[i].contactLensGrossSales;
                    totalOthersSalesCFY += AllSalesDataCY[i].otherGrossSales;
                    totalSalesCFY += AllSalesDataCY[i].totalGrossSales;

                    totalFramesQtyCFY += AllSalesDataCY[i].framesQty;
                    totalInstrumentsQtyCFY += AllSalesDataCY[i].instrumentsQty;
                    totalContactLensQtyCFY += AllSalesDataCY[i].contactLensQty;
                    totalOthersQtyCFY += AllSalesDataCY[i].OthersQty;
                    totalQtyCFY += AllSalesDataCY[i].totalQty;

                }                  
                else{
                    this.FramesCFYMap.push({value:0,key:i});
                    this.InstrumentsCFYMap.push({value:0,key:i});
                    this.ContactLensCFYMap.push({value:0,key:i});
                    this.OthersCFYMap.push({value:0,key:i});
                    this.TotalSalesCFYMap.push({value:0,key:i});

                    this.FramesCFYQtyMap.push({value:0,key:i});
                    this.InstrumentsCFYQtyMap.push({value:0,key:i});
                    this.ContactLensCFYQtyMap.push({value:0,key:i});
                    this.OthersCFYQtyMap.push({value:0,key:i});
                    this.TotalQtyCFYMap.push({value:0,key:i});
                }
                if(LensesDataLY[i] != undefined){
                    this.LensesLFYMap.push({value:LensesDataLY[i].lensGrossSales,key:i}); 
                    this.LensesLFYQtyMap.push({value:LensesDataLY[i].lensQty,key:i});                     
                    totalLensesSalesLFY += LensesDataLY[i].lensGrossSales;
                    totalLensesQtyLFY += LensesDataLY[i].lensQty;
                }                  
                else{
                    this.LensesLFYMap.push({value:0,key:i});
                    this.LensesLFYQtyMap.push({value:0,key:i});
                }    
                if(AllSalesDataLY[i] != undefined){
                    this.TotalSalesLFYMap.push({value:AllSalesDataLY[i].totalGrossSales,key:i});
                    this.TotalQtyLFYMap.push({value:AllSalesDataLY[i].totalQty,key:i});
                    totalLFYSales += AllSalesDataLY[i].totalGrossSales;
                    totalLFYQty += AllSalesDataLY[i].totalQty;
                }
                else{
                    this.TotalSalesLFYMap.push({value:0,key:i});
                    this.TotalQtyLFYMap.push({value:0,key:i});
                }
            }
            var LensesSalesCFYTemp =[];
            var FramesSalesCFYTemp = [];
            var InstrumentsSalesCFYTemp = [];
            var ContactLensesSalesCFYTemp = [];
            var OthersSalesCFYTemp = [];
            var TotalSalesCFYTemp = [];
            //creating arrays to display data from April to March
            LensesSalesCFYTemp.push(this.LensesCFYMap[3].value,this.LensesCFYMap[4].value,this.LensesCFYMap[5].value,this.LensesCFYMap[6].value,this.LensesCFYMap[7].value,this.LensesCFYMap[8].value,this.LensesCFYMap[9].value,this.LensesCFYMap[10].value,this.LensesCFYMap[11].value,this.LensesCFYMap[0].value,this.LensesCFYMap[1].value,this.LensesCFYMap[2].value,totalLensesSalesCFY);
            FramesSalesCFYTemp.push(this.FramesCFYMap[3].value,this.FramesCFYMap[4].value,this.FramesCFYMap[5].value,this.FramesCFYMap[6].value,this.FramesCFYMap[7].value,this.FramesCFYMap[8].value,this.FramesCFYMap[9].value,this.FramesCFYMap[10].value,this.FramesCFYMap[11].value,this.FramesCFYMap[0].value,this.FramesCFYMap[1].value,this.FramesCFYMap[2].value,totalFramesSalesCFY);
            InstrumentsSalesCFYTemp.push(this.InstrumentsCFYMap[3].value,this.InstrumentsCFYMap[4].value,this.InstrumentsCFYMap[5].value,this.InstrumentsCFYMap[6].value,this.InstrumentsCFYMap[7].value,this.InstrumentsCFYMap[8].value,this.InstrumentsCFYMap[9].value,this.InstrumentsCFYMap[10].value,this.InstrumentsCFYMap[11].value,this.InstrumentsCFYMap[0].value,this.InstrumentsCFYMap[1].value,this.InstrumentsCFYMap[2].value,totalInstrumentsSalesCFY);
            ContactLensesSalesCFYTemp.push(this.ContactLensCFYMap[3].value,this.ContactLensCFYMap[4].value,this.ContactLensCFYMap[5].value,this.ContactLensCFYMap[6].value,this.ContactLensCFYMap[7].value,this.ContactLensCFYMap[8].value,this.ContactLensCFYMap[9].value,this.ContactLensCFYMap[10].value,this.ContactLensCFYMap[11].value,this.ContactLensCFYMap[0].value,this.ContactLensCFYMap[1].value,this.ContactLensCFYMap[2].value,totalContactLensSalesCFY);
            OthersSalesCFYTemp.push(this.OthersCFYMap[3].value,this.OthersCFYMap[4].value,this.OthersCFYMap[5].value,this.OthersCFYMap[6].value,this.OthersCFYMap[7].value,this.OthersCFYMap[8].value,this.OthersCFYMap[9].value,this.OthersCFYMap[10].value,this.OthersCFYMap[11].value,this.OthersCFYMap[0].value,this.OthersCFYMap[1].value,this.OthersCFYMap[2].value,totalOthersSalesCFY);
            TotalSalesCFYTemp.push(this.TotalSalesCFYMap[3].value,this.TotalSalesCFYMap[4].value,this.TotalSalesCFYMap[5].value,this.TotalSalesCFYMap[6].value,this.TotalSalesCFYMap[7].value,this.TotalSalesCFYMap[8].value,this.TotalSalesCFYMap[9].value,this.TotalSalesCFYMap[10].value,this.TotalSalesCFYMap[11].value,this.TotalSalesCFYMap[0].value,this.TotalSalesCFYMap[1].value,this.TotalSalesCFYMap[2].value,totalSalesCFY);

            //copying this to another array to avoid the loading issues 
            this.LensesSalesCFY = LensesSalesCFYTemp;
            this.FramesSalesCFY = FramesSalesCFYTemp;
            this.InstrumentsSalesCFY = InstrumentsSalesCFYTemp;
            this.ContactLensesSalesCFY = ContactLensesSalesCFYTemp;
            this.OthersSalesCFY = OthersSalesCFYTemp;
            this.TotalSalesCFY = TotalSalesCFYTemp;

            this.LensesCFYQty.push(this.LensesCFYQtyMap[3].value,this.LensesCFYQtyMap[4].value,this.LensesCFYQtyMap[5].value,this.LensesCFYQtyMap[6].value,this.LensesCFYQtyMap[7].value,this.LensesCFYQtyMap[8].value,this.LensesCFYQtyMap[9].value,this.LensesCFYQtyMap[10].value,this.LensesCFYQtyMap[11].value,this.LensesCFYQtyMap[0].value,this.LensesCFYQtyMap[1].value,this.LensesCFYQtyMap[2].value,totalLensesQtyCFY);
            this.FramesCFYQty.push(this.FramesCFYQtyMap[3].value,this.FramesCFYQtyMap[4].value,this.FramesCFYQtyMap[5].value,this.FramesCFYQtyMap[6].value,this.FramesCFYQtyMap[7].value,this.FramesCFYQtyMap[8].value,this.FramesCFYQtyMap[9].value,this.FramesCFYQtyMap[10].value,this.FramesCFYQtyMap[11].value,this.FramesCFYQtyMap[0].value,this.FramesCFYQtyMap[1].value,this.FramesCFYQtyMap[2].value,totalFramesQtyCFY);
            this.InstrumentsCFYQty.push(this.InstrumentsCFYQtyMap[3].value,this.InstrumentsCFYQtyMap[4].value,this.InstrumentsCFYQtyMap[5].value,this.InstrumentsCFYQtyMap[6].value,this.InstrumentsCFYQtyMap[7].value,this.InstrumentsCFYQtyMap[8].value,this.InstrumentsCFYQtyMap[9].value,this.InstrumentsCFYQtyMap[10].value,this.InstrumentsCFYQtyMap[11].value,this.InstrumentsCFYQtyMap[0].value,this.InstrumentsCFYQtyMap[1].value,this.InstrumentsCFYQtyMap[2].value,totalInstrumentsQtyCFY);
            this.ContactLensesCFYQty.push(this.ContactLensCFYQtyMap[3].value,this.ContactLensCFYQtyMap[4].value,this.ContactLensCFYQtyMap[5].value,this.ContactLensCFYQtyMap[6].value,this.ContactLensCFYQtyMap[7].value,this.ContactLensCFYQtyMap[8].value,this.ContactLensCFYQtyMap[9].value,this.ContactLensCFYQtyMap[10].value,this.ContactLensCFYQtyMap[11].value,this.ContactLensCFYQtyMap[0].value,this.ContactLensCFYQtyMap[1].value,this.ContactLensCFYQtyMap[2].value,totalContactLensQtyCFY);
            this.OthersCFYQty.push(this.OthersCFYQtyMap[3].value,this.OthersCFYQtyMap[4].value,this.OthersCFYQtyMap[5].value,this.OthersCFYQtyMap[6].value,this.OthersCFYQtyMap[7].value,this.OthersCFYQtyMap[8].value,this.OthersCFYQtyMap[9].value,this.OthersCFYQtyMap[10].value,this.OthersCFYQtyMap[11].value,this.OthersCFYQtyMap[0].value,this.OthersCFYQtyMap[1].value,this.OthersCFYQtyMap[2].value,totalOthersQtyCFY);
            this.TotalQtyCFY.push(this.TotalQtyCFYMap[3].value,this.TotalQtyCFYMap[4].value,this.TotalQtyCFYMap[5].value,this.TotalQtyCFYMap[6].value,this.TotalQtyCFYMap[7].value,this.TotalQtyCFYMap[8].value,this.TotalQtyCFYMap[9].value,this.TotalQtyCFYMap[10].value,this.TotalQtyCFYMap[11].value,this.TotalQtyCFYMap[0].value,this.TotalQtyCFYMap[1].value,this.TotalQtyCFYMap[2].value,totalQtyCFY);
         
            this.LensesSalesLFY.push(this.LensesLFYMap[3].value,this.LensesLFYMap[4].value,this.LensesLFYMap[5].value,this.LensesLFYMap[6].value,this.LensesLFYMap[7].value,this.LensesLFYMap[8].value,this.LensesLFYMap[9].value,this.LensesLFYMap[10].value,this.LensesLFYMap[11].value,this.LensesLFYMap[0].value,this.LensesLFYMap[1].value,this.LensesLFYMap[2].value,totalLensesSalesLFY);
            this.LensesLFYQty.push(this.LensesLFYQtyMap[3].value,this.LensesLFYQtyMap[4].value,this.LensesLFYQtyMap[5].value,this.LensesLFYQtyMap[6].value,this.LensesLFYQtyMap[7].value,this.LensesLFYQtyMap[8].value,this.LensesLFYQtyMap[9].value,this.LensesLFYQtyMap[10].value,this.LensesLFYQtyMap[11].value,this.LensesLFYQtyMap[0].value,this.LensesLFYQtyMap[1].value,this.LensesLFYQtyMap[2].value,totalLensesQtyLFY);
            this.TotalSalesLFY.push(this.TotalSalesLFYMap[3].value,this.TotalSalesLFYMap[4].value,this.TotalSalesLFYMap[5].value,this.TotalSalesLFYMap[6].value,this.TotalSalesLFYMap[7].value,this.TotalSalesLFYMap[8].value,this.TotalSalesLFYMap[9].value,this.TotalSalesLFYMap[10].value,this.TotalSalesLFYMap[11].value,this.TotalSalesLFYMap[0].value,this.TotalSalesLFYMap[1].value,this.TotalSalesLFYMap[2].value,totalLFYSales);
            this.TotalQtyLFY.push(this.TotalQtyLFYMap[3].value,this.TotalQtyLFYMap[4].value,this.TotalQtyLFYMap[5].value,this.TotalQtyLFYMap[6].value,this.TotalQtyLFYMap[7].value,this.TotalQtyLFYMap[8].value,this.TotalQtyLFYMap[9].value,this.TotalQtyLFYMap[10].value,this.TotalQtyLFYMap[11].value,this.TotalQtyLFYMap[0].value,this.TotalQtyLFYMap[1].value,this.TotalQtyLFYMap[2].value,totalLFYQty);
           
            if(forecastData != null){
                this.forecastCFY.push(forecastData.Forecast_Gross_April_current_FY__c != null ? forecastData.Forecast_Gross_April_current_FY__c : 0,forecastData.Forecast_Gross_May_current_FY__c != null ? forecastData.Forecast_Gross_May_current_FY__c : 0 ,forecastData.Forecast_Gross_June_current_FY__c != null ? forecastData.Forecast_Gross_June_current_FY__c : 0,forecastData.Forecast_Gross_July_current_FY__c != null ?forecastData.Forecast_Gross_July_current_FY__c : 0,forecastData.Forecast_Gross_August_current_FY__c != null ? forecastData.Forecast_Gross_August_current_FY__c : 0,
                forecastData.Forecast_Gross_September_current_FY__c != null ? forecastData.Forecast_Gross_September_current_FY__c : 0 ,forecastData.Budget_October_Current_Year__c != null ?forecastData.Forecast_Gross_October_current_FY__c : 0,forecastData.Forecast_Gross_November_current_FY__c != null ?forecastData.Forecast_Gross_November_current_FY__c : 0 ,forecastData.Forecast_Gross_December_current_FY__c != null ? forecastData.Forecast_Gross_December_current_FY__c : 0,forecastData.Forecast_Gross_January_current_FY__c != null ? forecastData.Forecast_Gross_January_current_FY__c : 0,
                forecastData.Forecast_Gross_February_current_FY__c != null ? forecastData.Forecast_Gross_February_current_FY__c : 0,forecastData.Forecast_Gross_March_current_FY__c != null ? forecastData.Forecast_Gross_March_current_FY__c : 0,forecastData.Forecast_Gross_Current_Year__c != null ? forecastData.Forecast_Gross_Current_Year__c : 0);
            }
            var forecastCFYTD = 0;            
            //const d = new Date();
            //let month = d.getMonth();
            let month = this.maxMonth;
            switch (month){
                case 3:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value+this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value+this.TotalSalesLFYMap[9].value+this.TotalSalesLFYMap[10].value+this.TotalSalesLFYMap[11].value+this.TotalSalesLFYMap[0].value+this.TotalSalesLFYMap[1].value+this.TotalSalesLFYMap[2].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value+this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value+this.TotalQtyLFYMap[9].value+this.TotalQtyLFYMap[10].value+this.TotalQtyLFYMap[11].value+this.TotalQtyLFYMap[0].value+this.TotalQtyLFYMap[1].value+this.TotalQtyLFYMap[2].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value+this.LensesLFYMap[9].value+this.LensesLFYMap[10].value+this.LensesLFYMap[11].value+this.LensesLFYMap[0].value+this.LensesLFYMap[1].value+this.LensesLFYMap[2].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value+this.LensesLFYQtyMap[9].value+this.LensesLFYQtyMap[10].value+this.LensesLFYQtyMap[11].value+this.LensesLFYQtyMap[0].value+this.LensesLFYQtyMap[1].value+this.LensesLFYQtyMap[2].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5]+this.forecastCFY[6]+this.forecastCFY[7]+this.forecastCFY[8]+this.forecastCFY[9]+this.forecastCFY[10]+this.forecastCFY[11];
                        else
                            forecastCFYTD = 0;
                        break;
                case 4:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0];
                        else
                            forecastCFYTD = 0;
                        break;
                case 5:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value+this.TotalSalesLFYMap[4].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value+this.TotalQtyLFYMap[4].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1];
                        else
                            forecastCFYTD = 0;
                        break;
                case 6:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2];
                        else
                            forecastCFYTD = 0;
                        break;
                case 7:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3];
                        else
                            forecastCFYTD = 0;
                        break;
                case 8:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4];
                        else
                            forecastCFYTD = 0;
                        break;
                case 9:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5];
                        else
                            forecastCFYTD = 0;
                        break;
                case 10:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value+this.TotalSalesLFYMap[9].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value+this.TotalQtyLFYMap[9].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value+this.LensesLFYMap[9].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value+this.LensesLFYQtyMap[9].value;
                        if(this.forecastCFY != null)
                             forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5]+this.forecastCFY[6];
                        else
                            forecastCFYTD = 0;
                        break;
                case 11:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value+this.TotalSalesLFYMap[9].value+this.TotalSalesLFYMap[10].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value+this.TotalQtyLFYMap[9].value+this.TotalQtyLFYMap[10].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value+this.LensesLFYMap[9].value+this.LensesLFYMap[10].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value+this.LensesLFYQtyMap[9].value+this.LensesLFYQtyMap[10].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5]+this.forecastCFY[6]+this.forecastCFY[7];
                        else
                            forecastCFYTD = 0;
                        break;
                case 12:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value+this.TotalSalesLFYMap[9].value+this.TotalSalesLFYMap[10].value+this.TotalSalesLFYMap[11].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value+this.TotalQtyLFYMap[9].value+this.TotalQtyLFYMap[10].value+this.TotalQtyLFYMap[11].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value+this.LensesLFYMap[9].value+this.LensesLFYMap[10].value+this.LensesLFYMap[11].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value+this.LensesLFYQtyMap[9].value+this.LensesLFYQtyMap[10].value+this.LensesLFYQtyMap[11].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5]+this.forecastCFY[6]+this.forecastCFY[7]+this.forecastCFY[8];
                        else
                            forecastCFYTD = 0;
                        break;
                case 1:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value+this.TotalSalesLFYMap[9].value+this.TotalSalesLFYMap[10].value+this.TotalSalesLFYMap[11].value+this.TotalSalesLFYMap[0].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value+this.TotalQtyLFYMap[9].value+this.TotalQtyLFYMap[10].value+this.TotalQtyLFYMap[11].value+this.TotalQtyLFYMap[0].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value+this.LensesLFYMap[9].value+this.LensesLFYMap[10].value+this.LensesLFYMap[11].value+this.LensesLFYMap[0].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value+this.LensesLFYQtyMap[9].value+this.LensesLFYQtyMap[10].value+this.LensesLFYQtyMap[11].value+this.LensesLFYQtyMap[0].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5]+this.forecastCFY[6]+this.forecastCFY[7]+this.forecastCFY[8]+this.forecastCFY[9];
                        else
                            forecastCFYTD = 0;
                        break;
                case 2:
                        this.totalSalesLFYTD = this.TotalSalesLFYMap[3].value + this.TotalSalesLFYMap[4].value+this.TotalSalesLFYMap[5].value+this.TotalSalesLFYMap[6].value+this.TotalSalesLFYMap[7].value+this.TotalSalesLFYMap[8].value+this.TotalSalesLFYMap[9].value+this.TotalSalesLFYMap[10].value+this.TotalSalesLFYMap[11].value+this.TotalSalesLFYMap[0].value+this.TotalSalesLFYMap[1].value;
                        this.totalQtyLFYTD = this.TotalQtyLFYMap[3].value + this.TotalQtyLFYMap[4].value+this.TotalQtyLFYMap[5].value+this.TotalQtyLFYMap[6].value+this.TotalQtyLFYMap[7].value+this.TotalQtyLFYMap[8].value+this.TotalQtyLFYMap[9].value+this.TotalQtyLFYMap[10].value+this.TotalQtyLFYMap[11].value+this.TotalQtyLFYMap[0].value+this.TotalQtyLFYMap[1].value;
                        this.lensesSalesLFYYTD = this.LensesLFYMap[3].value+this.LensesLFYMap[4].value+this.LensesLFYMap[5].value+this.LensesLFYMap[6].value+this.LensesLFYMap[7].value+this.LensesLFYMap[8].value+this.LensesLFYMap[9].value+this.LensesLFYMap[10].value+this.LensesLFYMap[11].value+this.LensesLFYMap[0].value+this.LensesLFYMap[1].value;
                        this.lensesQtyLFYYTD = this.LensesLFYQtyMap[3].value+this.LensesLFYQtyMap[4].value+this.LensesLFYQtyMap[5].value+this.LensesLFYQtyMap[6].value+this.LensesLFYQtyMap[7].value+this.LensesLFYQtyMap[8].value+this.LensesLFYQtyMap[9].value+this.LensesLFYQtyMap[10].value+this.LensesLFYQtyMap[11].value+this.LensesLFYQtyMap[0].value+this.LensesLFYQtyMap[1].value;
                        if(this.forecastCFY != null)
                            forecastCFYTD =  this.forecastCFY[0]+this.forecastCFY[1]+this.forecastCFY[2]+this.forecastCFY[3]+this.forecastCFY[4]+this.forecastCFY[5]+this.forecastCFY[6]+this.forecastCFY[7]+this.forecastCFY[8]+this.forecastCFY[9]+this.forecastCFY[10];
                        else
                            forecastCFYTD = 0;
                        break;               
            }
            //Calculate variation
            for(let i=0; i<=11; i++){
                var totalSalesVariation = 0;                
                if(this.TotalSalesLFY[i] != 0 && this.TotalSalesCFY[i] != 0 && this.TotalSalesLFY[i] != null && this.TotalSalesCFY[i] != null)
                    totalSalesVariation = ((this.TotalSalesCFY[i] - this.TotalSalesLFY[i])/this.TotalSalesLFY[i]) * 100;
                this.TotalVariation.push(totalSalesVariation);
                var lensesVariation = 0;
                if(this.LensesSalesLFY[i] != 0 && this.LensesSalesCFY[i] != 0 && this.LensesSalesLFY[i] != null && this.LensesSalesCFY[i] != null)
                    lensesVariation = ((this.LensesSalesCFY[i] - this.LensesSalesLFY[i])/this.LensesSalesLFY[i]) * 100;
                this.LensesVariation.push(lensesVariation);
                var totalQtyVariation = 0;
                if(this.TotalQtyLFY[i] != 0 && this.TotalQtyCFY[i] != 0 && this.TotalQtyLFY[i] > null && this.TotalQtyCFY[i] != null )
                    totalQtyVariation = ((this.TotalQtyCFY[i] - this.TotalQtyLFY[i])/this.TotalQtyLFY[i]) * 100;
                this.TotalQtyVaraition.push(totalQtyVariation);
                var lensesQtyVariation = 0;
                if(this.LensesLFYQty[i] != 0 && this.LensesCFYQty[i] != 0 && this.LensesLFYQty[i] != null && this.LensesCFYQty[i] != null)
                    lensesQtyVariation = ((this.LensesCFYQty[i] - this.LensesLFYQty[i])/this.LensesLFYQty[i]) * 100;
                this.TotalLensQtyVariation.push(lensesQtyVariation);      
                   
                var variation = 0;                
                if(this.LensesSalesCFY[i] != 0 && this.LensesSalesCFY[i] != null && this.forecastCFY[i] != 0 && this.forecastCFY[i] != null)
                    variation = ((this.LensesSalesCFY[i] - this.forecastCFY[i])/this.forecastCFY[i]) * 100;
                this.CFYvsForecastVariation.push(variation);       
            }
            for(let i=0; i <= 12; i++){
                //Forecast
                var lFYVariation =0;
                if(this.LensesSalesLFY[i] != 0 && this.LensesSalesLFY[i] != null && this.forecastCFY[i] != 0 && this.forecastCFY[i] != null)
                lFYVariation = ((this.forecastCFY[i] - this.LensesSalesLFY[i])/this.LensesSalesLFY[i]) * 100;
                this.ForecastvsLFY.push(lFYVariation);   
            }
            //Total Variation
            //total values are at index 12
            var totalSalesVariation = 0;                
            if(this.totalSalesLFYTD > 0 && this.TotalSalesCFY[12] != 0)
                totalSalesVariation = ((this.TotalSalesCFY[12] - this.totalSalesLFYTD)/this.totalSalesLFYTD) * 100;
            this.TotalVariation.push(totalSalesVariation);
            var totalQtyVariation = 0;
            if(this.totalQtyLFYTD > 0 && this.TotalQtyCFY[12] != 0)
                totalQtyVariation = ((this.TotalQtyCFY[12] - this.totalQtyLFYTD)/this.totalQtyLFYTD) * 100;
            this.TotalQtyVaraition.push(totalQtyVariation);    
            
            var lensesVariation = 0;
            if(this.lensesSalesLFYYTD > 0 && this.LensesSalesCFY[12] != 0)
                lensesVariation = ((this.LensesSalesCFY[12] - this.lensesSalesLFYYTD)/this.lensesSalesLFYYTD) * 100;
            this.LensesVariation.push(lensesVariation);
            var lensesQtyVariation = 0;
            if(this.lensesQtyLFYYTD > 0 && this.LensesCFYQty[12] != 0)
                lensesQtyVariation = ((this.LensesCFYQty[12] - this.lensesQtyLFYYTD)/this.lensesQtyLFYYTD) * 100;
            this.TotalLensQtyVariation.push(lensesQtyVariation);   
            
            var salesVariation = 0;                
                if(this.LensesSalesCFY[12] != 0 && this.LensesSalesCFY[12] != null && forecastCFYTD != 0 )
                    salesVariation = ((this.LensesSalesCFY[12] - forecastCFYTD)/forecastCFYTD) * 100;
                this.CFYvsForecastVariation.push(salesVariation);
            //Chart 
            this.dataGrossSales = {
                labels: this.Labels,
                datasets: [{
                  label: 'Current Fiscal Year',
                  backgroundColor: 'rgb(99,255,  132)',
                  borderColor: 'rgb(99, 255, 132)',
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
                  data: [this.TotalSalesCFY[0],this.TotalSalesCFY[1],this.TotalSalesCFY[2],this.TotalSalesCFY[3],this.TotalSalesCFY[4],this.TotalSalesCFY[5],this.TotalSalesCFY[6],this.TotalSalesCFY[7],this.TotalSalesCFY[8],this.TotalSalesCFY[9],this.TotalSalesCFY[10],this.TotalSalesCFY[11]]
                },{
                    label: 'Last Fiscal Year',
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
                    data: [this.TotalSalesLFY[0],this.TotalSalesLFY[1],this.TotalSalesLFY[2],this.TotalSalesLFY[3],this.TotalSalesLFY[4],this.TotalSalesLFY[5],this.TotalSalesLFY[6],this.TotalSalesLFY[7],this.TotalSalesLFY[8],this.TotalSalesLFY[9],this.TotalSalesLFY[10],this.TotalSalesLFY[11]]
                }]                
            };
            this.dataVolume = {
                labels: this.Labels,
                datasets: [{
                  label: 'Current Fiscal Year',
                  backgroundColor: 'rgb(99,255,  132)',
                  borderColor: 'rgb(99, 255, 132)',
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
                  data: [this.TotalQtyCFY[0],this.TotalQtyCFY[1],this.TotalQtyCFY[2],this.TotalQtyCFY[3],this.TotalQtyCFY[4],this.TotalQtyCFY[5],this.TotalQtyCFY[6],this.TotalQtyCFY[7],this.TotalQtyCFY[8],this.TotalQtyCFY[9],this.TotalQtyCFY[10],this.TotalQtyCFY[11]]
                },{
                    label: 'Last Fiscal Year',
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
                    data: [this.TotalQtyLFY[0],this.TotalQtyLFY[1],this.TotalQtyLFY[2],this.TotalQtyLFY[3],this.TotalQtyLFY[4],this.TotalQtyLFY[5],this.TotalQtyLFY[6],this.TotalQtyLFY[7],this.TotalQtyLFY[8],this.TotalQtyLFY[9],this.TotalQtyLFY[10],this.TotalQtyLFY[11]]
                  }]
            };
                         
            //fiscal year chart
            var optionSales={
                responsive: true,
                legend:{
                    display:true,
                    position:'bottom',
                    labels: {
                        boxWidth: 15
                    }
                },
                title:{
                    display:true,
                    text: 'LFY / CFY sales'
                },
                scales: {
                    xAxes: [{
                        ticks: {
                            autoSkip: false,
                            maxRotation: 70,
                            minRotation: 70
                        }
                    }]
                }
            };
            var optionVolume={
                responsive: true,
                legend:{
                    labels: {
                        boxWidth: 15
                    },
                    display:true,
                    position:'bottom'
                },
                title:{
                    display:true,
                    text: 'LFY / CFY Volumes'
                },
                scales: {
                    xAxes: [{
                        ticks: {
                            autoSkip: false,
                            maxRotation: 70,
                            minRotation: 70
                        }
                    }]
                }
            };
            this.config = {
                type: 'line',
                data: this.dataGrossSales,
                options: optionSales
            };
            this.configVol = {
                type: 'line',
                data: this.dataVolume,
                options: optionVolume
            };
           /* Promise.all([            
                loadScript(this, chartjs + '/Chart.bundle.min.js'),
                loadScript(this, chartjs + '/Chart.min.js')
            ]).then(() => {
                const ctx = this.template.querySelector('canvas.chartGrossSales').getContext('2d');
                this.chart = new window.Chart(ctx,this.config);
                const ctx1 = this.template.querySelector('canvas.volumeChart').getContext('2d');
                this.chart = new window.Chart(ctx1,this.configVol);
                
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.message,
                        variant: 'Error',
                    }),
                );
            });*/
        })
        .catch(error => {
            this.showToast('Error', 'Error',error.message );
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
    doRefresh() {
        refreshApex( this.AccountRec );     
    }
  
}