import { LightningElement,api,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Apex
import getRelatedSalesList from '@salesforce/apex/TabStatisticsController.getRelatedSalesList';
import getCurrency from '@salesforce/apex/TabStatisticsController.getCurrency';
//Custom Labels
import NetSalesCFY from '@salesforce/label/c.AccountNetSalesCFY';
import NetSalesLFYYTD from '@salesforce/label/c.AccountNetSalesLFYYTD';
import GrossSalesCFY from '@salesforce/label/c.AccountGrossSalesCFY';
import GrossSalesLFYYTD from '@salesforce/label/c.AccountGrossSalesLFY';
import VolumeCFY from '@salesforce/label/c.AccountVolumesCFY';
import RelatedVolumesYTD from '@salesforce/label/c.AccountRelatedVolumesYTD';
import RelatedVariation from '@salesforce/label/c.AccountRealtedVariation';
import ParentNetSales from '@salesforce/label/c.AccountParentNetSales';
import AccountLensesOnly from '@salesforce/label/c.AccountLensesOnly';
import ParentGrossSales from '@salesforce/label/c.AccountParentAccSales';

export default class TabStatisticsRelatedNetSales extends LightningElement {
    @api receivedId;
    @api type;
    isTypeNet =true;
    relatedSales;
    CurrencyCode;
    isLoading = true;
    custLabel = {
        ParentGrossSales,ParentNetSales,AccountLensesOnly
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

    NetColumns = [NetSalesCFY,NetSalesLFYYTD,RelatedVariation,VolumeCFY,RelatedVolumesYTD,RelatedVariation];
    GrossColumns = [GrossSalesCFY,GrossSalesLFYYTD,RelatedVariation,VolumeCFY,RelatedVolumesYTD,RelatedVariation];

    @wire(getRelatedSalesList,{recordId: "$receivedId",type:"$type"})
    getRelatedSales(result){        
        if(result.data){
          this.relatedSales = JSON.parse(JSON.stringify(result.data));
          if(this.relatedSales.length > 0)
             this.relatedSales.forEach(res=>{
                if(res.AccountId != null) {  
                    res.accountLink = '/' + res.AccountId;
                    res.HoyaAccountId = res.hoyaAccountId;
                }
                else{
                    res.HoyaAccountId= 'Total';  
                    res.accountLink = '#';
                }      
            });
            this.error = undefined;
        }
        else if(result.error){
            this.showToast('Error', 'Error', result.error);
        }
        if(this.type == 'Net')
            this.isTypeNet = true;
        else
        this.isTypeNet = false;
    }
    connectedCallback() {}
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