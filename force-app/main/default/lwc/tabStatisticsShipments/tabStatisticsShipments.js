import { LightningElement, api ,wire} from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//fields
import ManualOrders from '@salesforce/schema/Last_Sales_Statistics__c.Manual_Orders_L3Mo__c';
import HVCSystems from '@salesforce/schema/Last_Sales_Statistics__c.HVC_Systems_L3Mo__c';
import OtherDigitalOrders from '@salesforce/schema/Last_Sales_Statistics__c.Other_Digital_Orders_L3Mo__c';
import UncutLenses from '@salesforce/schema/Last_Sales_Statistics__c.Uncut_Lenses_L3Mo__c';
import RemoteEdging from '@salesforce/schema/Last_Sales_Statistics__c.Remote_Edging_L3Mo__c';
import Mounting from '@salesforce/schema/Last_Sales_Statistics__c.Mounting_L3Mo__c';
import RealShapePrecal from '@salesforce/schema/Last_Sales_Statistics__c.Real_Shape_Precal_L3Mo__c';
import StandardShapePrecal from '@salesforce/schema/Last_Sales_Statistics__c.Standard_Shape_Precal_L3Mo__c';
import FramesByHVC from '@salesforce/schema/Last_Sales_Statistics__c.Frames_Provided_By_HVC_L3Mo__c';
import BoxingPrecal from '@salesforce/schema/Last_Sales_Statistics__c.Boxing_Precal_L3Mo__c';
//Lenses delays fields
import RxShippedSameDay from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_Same_Day_3Mo__c';
import RxShippedin1Day from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_1_Day_3Mo__c';
import RxShippedin2Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_2_Days_3Mo__c';
import RxShippedin3Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_3_Days_3Mo__c';
import RxShippedin4Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_4_Days_3Mo__c';
import RxShippedin5Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_5_Days_3Mo__c';
import RxShippedin6Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_6_Days_3Mo__c';
import RxShippedin7Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_7_Days_3Mo__c';
import RxShippedin8Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_8_Days_3Mo__c';
import RxShippedin9Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_9_Days_3Mo__c';
import RxShippedin10Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_RX_Shipped_In_Max_10_Days_3Mo__c';
import StockShippedSameDay from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_STOCK_Shipped_Same_Day_3Mo__c';
import StockShippedin1Day from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_STOCK_Shipped_In_Max_1_Day_3Mo__c';
import StockShippedin2Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_STOCK_Shipped_In_Max_2_Days_3M__c';
import StockShippedin3Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_STOCK_Shipped_In_Max_3_Days_3M__c';
import StockShippedin4Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_STOCK_Shipped_In_Max_4_Days_3M__c';
import StockShippedin5Days from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_STOCK_Shipped_In_Max_5_Days_3M__c';
import StockAvgDelay from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Shipment_STOCK_Average_Delay_3Mo__c';
import RxAvgDelay from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Shipment_RX_Average_Delay_3Mo__c';
import AvgDelay from '@salesforce/schema/Last_Sales_Statistics__c.Lenses_Shipment_Avg_Delay_in_Days_3Mo__c';

//custom labels
import AccountLensDelays from '@salesforce/label/c.AccountLensesDelays';
import OrderingHabits from '@salesforce/label/c.Ordering_Habits';
//Apex
import getLastSalesId from '@salesforce/apex/TabStatisticsController.getLastSalesStatisticsId';
const fields = [ManualOrders,HVCSystems,OtherDigitalOrders,UncutLenses,RemoteEdging,Mounting,RealShapePrecal,
    StandardShapePrecal,BoxingPrecal,FramesByHVC,RxShippedSameDay,RxShippedin1Day,RxShippedin2Days,RxShippedin3Days,
    RxShippedin4Days,RxShippedin5Days,RxShippedin6Days,RxShippedin7Days,RxShippedin8Days,RxShippedin9Days,
    RxShippedin10Days,StockShippedSameDay,StockShippedin1Day,StockShippedin2Days,StockShippedin3Days,StockShippedin4Days,
    StockShippedin5Days,StockAvgDelay,RxAvgDelay,AvgDelay];
export default class TabStatisticsReturns extends LightningElement {
    @api receivedId;
    lastSalesStatistics;
    lastSalesId;
    custLabel = {
        AccountLensDelays,OrderingHabits
    }
    //Get Last Sales Statistics Object Id based current Account Record Id
    @wire(getLastSalesId,{accId:'$receivedId'})
    getInfos({error,data}){
        if(error){
            console.log('error == '+JSON.stringify(error));
        }else if(data){
            console.log('data == ', JSON.stringify(data));
            this.lastSalesId = JSON.parse(JSON.stringify(data));
        return;

        }
    } 
    @wire(getRecord, { recordId: "$lastSalesId", fields })
    record( { error, data }){
        if(data){
            this.lastSalesStatistics = data;
            console.log(data);
        }else if(error){
            this.showToast('Error', 'Error',error);
        }
    }
    get ManualOrders(){      
        var value = getFieldValue(this.lastSalesStatistics,ManualOrders); 
        console.log(value);
        if(value == null)
            return 0;
        else
            return value;    
    }
    get HVCSystems(){      
        var value = getFieldValue(this.lastSalesStatistics,HVCSystems); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get OtherDigitalOrders(){      
        var value = getFieldValue(this.lastSalesStatistics,OtherDigitalOrders); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get UncutLenses(){      
        var value = getFieldValue(this.lastSalesStatistics,UncutLenses); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RemoteEdging(){      
        var value = getFieldValue(this.lastSalesStatistics,RemoteEdging); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get Mounting(){      
        var value = getFieldValue(this.lastSalesStatistics,Mounting); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get FramesByHVC(){      
        var value = getFieldValue(this.lastSalesStatistics,FramesByHVC); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RealShapePrecal(){      
        var value = getFieldValue(this.lastSalesStatistics,RealShapePrecal); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StandardShapePrecal(){      
        var value = getFieldValue(this.lastSalesStatistics,StandardShapePrecal); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get BoxingPrecal(){      
        var value = getFieldValue(this.lastSalesStatistics,BoxingPrecal); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedSameDay(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedSameDay); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin1Day(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin1Day); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin2Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin2Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin3Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin3Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin4Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin4Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin5Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin5Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin6Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin6Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin7Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin7Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin8Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin8Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin9Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin9Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxShippedin10Days(){      
        var value = getFieldValue(this.lastSalesStatistics,RxShippedin10Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockShippedSameDay(){      
        var value = getFieldValue(this.lastSalesStatistics,StockShippedSameDay); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockShippedin1Day(){      
        var value = getFieldValue(this.lastSalesStatistics,StockShippedin1Day); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockShippedin2Days(){      
        var value = getFieldValue(this.lastSalesStatistics,StockShippedin2Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockShippedin3Days(){      
        var value = getFieldValue(this.lastSalesStatistics,StockShippedin3Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockShippedin4Days(){      
        var value = getFieldValue(this.lastSalesStatistics,StockShippedin4Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockShippedin5Days(){      
        var value = getFieldValue(this.lastSalesStatistics,StockShippedin5Days); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get StockAvgDelay(){      
        var value = getFieldValue(this.lastSalesStatistics,StockAvgDelay); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get RxAvgDelay(){      
        var value = getFieldValue(this.lastSalesStatistics,RxAvgDelay); 
        if(value == null)
            return 0;
        else
            return value;    
    }
    get AvgDelay(){      
        var value = getFieldValue(this.lastSalesStatistics,AvgDelay); 
        if(value == null)
            return 0;
        else
            return value;    
    }
   
    connectedCallback() {
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