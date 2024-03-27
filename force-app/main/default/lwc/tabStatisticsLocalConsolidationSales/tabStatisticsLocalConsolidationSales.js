import { LightningElement,api,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
//Custom Labels
import NetSalesCFY from '@salesforce/label/c.AccountNetSalesCFY';
import NetSalesLFYYTD from '@salesforce/label/c.AccountNetSalesLFYYTD';
import GrossSalesCFY from '@salesforce/label/c.AccountGrossSalesCFY';
import GrossSalesLFYYTD from '@salesforce/label/c.AccountGrossSalesLFY';
import VolumeCFY from '@salesforce/label/c.AccountVolumesCFY';
import RelatedVolumesYTD from '@salesforce/label/c.AccountRelatedVolumesYTD';
import RelatedVariation from '@salesforce/label/c.AccountRealtedVariation';
import AccountLensesOnly from '@salesforce/label/c.AccountLensesOnly';
import Save from '@salesforce/label/c.Save_Button';
import LocalKeyNet from '@salesforce/label/c.Local_Key_Consolidation_Net';
import LocalKeyGross from '@salesforce/label/c.Local_Key_Consolidation_Gross';
//Object
import Account_obj from '@salesforce/schema/Account';
//Fields
import LocalConsolidationKey from '@salesforce/schema/Account.Local_Consolidation_Key__c';
//Apex
import getConsolidatedAccountsList from '@salesforce/apex/TabStatisticsController.getConsolidatedAccountsList';
export default class TabStatisticsLocalConsolidationSales extends LightningElement {
    @api receivedId;
    @api type;
    isTypeNet =true;
    relatedSales;
    isDataExists = true;
    ObjectApiName = Account_obj;
    field =LocalConsolidationKey;
    wiredResults;
   
    NetColumns = [NetSalesCFY,NetSalesLFYYTD,RelatedVariation,VolumeCFY,RelatedVolumesYTD,RelatedVariation];
    GrossColumns = [GrossSalesCFY,GrossSalesLFYYTD,RelatedVariation,VolumeCFY,RelatedVolumesYTD,RelatedVariation];

    custLabel = {
        AccountLensesOnly,Save,LocalKeyNet,LocalKeyGross
    }
    @wire(getConsolidatedAccountsList,{recordId: "$receivedId",type:"$type"})
    getConsolidatedAccs(result){     
        this.wiredResults =  result;
        if(result.data){
          this.relatedSales = JSON.parse(JSON.stringify(result.data));
          if(this.relatedSales.length == 0)
            this.isDataExists = false;   
          this.relatedSales.forEach(res=>{   
            if(res.AccountId != null) {  
                res.accountLink = '/' + res.AccountId;
                res.HoyaAccountId = res.hoyaAccountId;
            }
            else{
                res.accountLink = '#';
                res.HoyaAccountId= 'Total';  
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
    doRefresh(event) {
        return refreshApex(this.wiredResults);
    }
}