import { LightningElement, api ,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//custom labels
import NonAdaptationRets12Mo from '@salesforce/label/c.Non_Adaptation_Rets_L12Mo';
import NonAdaptationRets3Mo from '@salesforce/label/c.Non_Adaptation_Rets_L3Mo';
//Apex
import getLensReturns from '@salesforce/apex/TabStatisticsController.getLensReturns';
import getNonAdaptationReturns from '@salesforce/apex/TabStatisticsController.getNonAdaptationReturns';

export default class TabStatisticsReturns extends LightningElement {
    @api receivedId;
    prodcutonLast12Mo;
    productionLast3Mo;
    cutEdgeLast12Mo;
    cutEdgeLast3Mo;
    mountingLast12Mo;
    mountngLast3Mo;
    totalProdLast12Mo;
    totalProdLast3Mo;
    salesAgreementsLast12Mo;
    salesAgreementsLast3Mo;
    orderingMistakesLast12Mo;
    orderingMistakesLast3Mo;
    nonAdaptationLast12Mo;
    nonAdaptationLast3Mo;
    deliveryLast12Mo;
    deliveryLast3Mo;
    otherLast12Mo;
    otherLast3Mo;
    totalNonProdLast12Mo;
    totalNonProdLast3Mo;
    totalRetLast12Mo;
    totalRetLast3Mo;

    prodcutonSalesLast12Mo;
    productionSalesLast3Mo;
    cutEdgeSalesLast12Mo;
    cutEdgeSalesLast3Mo;
    mountingSalesLast12Mo;
    mountngSalesLast3Mo;
    totalProdSalesLast12Mo;
    totalProdSalesLast3Mo;
    salesAgreementsSalesLast12Mo;
    salesAgreementsSalesLast3Mo;
    orderingMistakesSalesLast12Mo;
    orderingMistakesSalesLast3Mo;
    nonAdaptationSalesLast12Mo;
    nonAdaptationSalesLast3Mo;
    deliverySalesLast12Mo;
    deliverySalesLast3Mo;
    otherSalesLast12Mo;
    otherSalesLast3Mo;
    totalNonProdSalesLast12Mo;
    totalNonProdSalesLast3Mo;
    totalRetSalesLast12Mo;
    totalRetSalesLast3Mo;

    nonAdaptationRets3Mo;
    nonAdaptationRets12Mo;
    isNonAdap12MoRetsExist = false;
    isNonAdap3MoRetsExist = false;

    custLabel={NonAdaptationRets12Mo,NonAdaptationRets3Mo}
    connectedCallback() {
        getLensReturns({ recordId: this.receivedId})
        .then(response => {
            var result = JSON.parse(response);
            this.prodcutonLast12Mo = result.ProdRet12;
            this.productionLast3Mo = result.ProdRet3;
            this.cutEdgeLast12Mo = result.CutRet12;
            this.cutEdgeLast3Mo = result.CutRet3;
            this.mountingLast12Mo = result.MountRet12;
            this.mountngLast3Mo = result.MountRet3;
            this.totalProdLast12Mo = result.TotalProdRet12;
            this.totalProdLast3Mo = result.TotalProdRet3;
            this.salesAgreementsLast12Mo = result.SalesRet12;
            this.salesAgreementsLast3Mo = result.SalesRet3;
            this.orderingMistakesLast12Mo = result.OrderMisRet12;
            this.orderingMistakesLast3Mo = result.OrderMisRet3;
            this.nonAdaptationLast12Mo = result.NonAdapRet12;
            this.nonAdaptationLast3Mo = result.NonAdapRet3;
            this.deliveryLast12Mo = result.DeliveryRet12;
            this.deliveryLast3Mo = result.DeliveryRet3;
            this.otherLast12Mo = result.OtherRet12;
            this.otherLast3Mo = result.OtherRet3;
            this.totalNonProdLast12Mo = result.TotalNonProdRet12;
            this.totalNonProdLast3Mo = result.TotalNonProdRet3;
            this.totalRetLast12Mo = result.TotalRet12;
            this.totalRetLast3Mo = result.TotalRet3;

            this.prodcutonSalesLast12Mo = result.ProdRetSales12;
            this.productionSalesLast3Mo = result.ProdRetSales3;
            this.cutEdgeSalesLast12Mo = result.CutRetSales12;
            this.cutEdgeSalesLast3Mo = result.CutRetSales3;
            this.mountingSalesLast12Mo = result.MountRetSales12;
            this.mountngSalesLast3Mo = result.MountRetSales3;
            this.totalProdSalesLast12Mo = result.TotalProdRetSales12;
            this.totalProdSalesLast3Mo = result.TotalProdRetSales3;
            this.salesAgreementsSalesLast12Mo = result.SalesRetSales12;
            this.salesAgreementsSalesLast3Mo = result.SalesRetSales3;
            this.orderingMistakesSalesLast12Mo = result.OrderMisRetSales12;
            this.orderingMistakesSalesLast3Mo = result.OrderMisRetSales3;
            this.nonAdaptationSalesLast12Mo = result.NonAdapRetSales12;
            this.nonAdaptationSalesLast3Mo = result.NonAdapRetSales3;
            this.deliverySalesLast12Mo = result.DeliveryRetSales12;
            this.deliverySalesLast3Mo = result.DeliveryRetSales3;
            this.otherSalesLast12Mo = result.OtherRetSales12;
            this.otherSalesLast3Mo = result.OtherRetSales3;
            this.totalNonProdSalesLast12Mo = result.TotalNonProdRetSales12;
            this.totalNonProdSalesLast3Mo = result.TotalNonProdRetSales3;
            this.totalRetSalesLast12Mo = result.TotalRetSales12;
            this.totalRetSalesLast3Mo = result.TotalRetSales3;
        }).catch(error => {
            this.showToast('Error', 'Error', error.message);
        }) 
        getNonAdaptationReturns({ recordId: this.receivedId})
        .then(response => {
            if(response != undefined && response != null && response.length > 0){
                var result = JSON.parse(JSON.stringify(response));  
                var mon3=result[0];                  
                var mon12= result[1]; 
                if(result[0] != null && result[0].length > 0){
                    this.isNonAdap3MoRetsExist = true;
                    this.nonAdaptationRets3Mo = JSON.parse(JSON.stringify(mon3));
                }                    
                if(result[1] != null && result[1].length > 0 ){
                    this.isNonAdap12MoRetsExist = true;
																			 
                    this.nonAdaptationRets12Mo = JSON.parse(JSON.stringify(mon12));
                }              
            }
        }).catch(error => {
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