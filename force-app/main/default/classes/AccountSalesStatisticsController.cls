public class AccountSalesStatisticsController {
    public static Integer testMonth{get;set;}  
    //Wrapper class to store Rx ans Stock details
    public class RxAndStockSales{        
        public Integer rxQty{get;set;}
        public Integer stockQty{get;set;}
        public Integer stockShippedonSameDay{get;set;}
        public Integer stockShippedin1Day{get;set;}
        public Integer stockShippedin2Days{get;set;}
        public Integer stockShippedin3Days{get;set;}
        public Integer stockShippedin4Days{get;set;}
        public Integer stockShippedin5Days{get;set;}
        public Integer rxShippedonSameDay{get;set;}
        public Integer rxShippedin1Day{get;set;}
        public Integer rxShippedin2Days{get;set;}
        public Integer rxShippedin3Days{get;set;}
        public Integer rxShippedin4Days{get;set;}
        public Integer rxShippedin5Days{get;set;}
        public Integer rxShippedin6Days{get;set;}
        public Integer rxShippedin7Days{get;set;}
        public Integer rxShippedin8Days{get;set;}
        public Integer rxShippedin9Days{get;set;}
        public Integer rxShippedin10Days{get;set;}
        public Integer remoteEdgingQty{get;set;}
        public RxAndStockSales(){
            rxQty=0;
            stockQty=0;
            rxShippedonSameDay = 0;
            stockShippedonSameDay=0;
            stockShippedin1Day=0;
            stockShippedin2Days=0;
            stockShippedin3Days=0;
            stockShippedin4Days=0;
            stockShippedin5Days=0;
            rxShippedin1Day=0;
            rxShippedin2Days=0;
            rxShippedin3Days=0;
            rxShippedin4Days=0;
            rxShippedin5Days=0;
            rxShippedin6Days=0;
            rxShippedin7Days=0;
            rxShippedin8Days=0;
            rxShippedin9Days=0;
            rxShippedin10Days=0;
            remoteEdgingQty=0;
        }
    }
    //Wrapper class to store lens(Rx+Stock) sales
    public class LensSales{
        public LensSales(){}
        public double lensGrossSales{get;set;}
        public double lensNetSales{get;set;}
        public Integer lensQty{get;set;}
        public Integer remoteEdgingQty{get;set;}     
    }  
    //Wrapper class to store Related Account details 
    public class AccountRelatedSales{
        public AccountRelatedSales(){}
        @AuraEnabled public double netSalesCFY{get;set;}
        @AuraEnabled public double netSalesLFYYTD{get;set;}
        @AuraEnabled public double variationSales{get;set;}
        @AuraEnabled public double volumesCFY{get;set;}        
        @AuraEnabled public double volumesLFYYTD{get;set;}
        @AuraEnabled public double variationVolumes{get;set;}
        @AuraEnabled public Id AccountId{get;set;}
        @AuraEnabled public String hoyaAccountId{get;set;}
    }
    
  //Wrapper class used to display in statistics page
    public class AccountSales {
        public AccountSales(){
            janQtyN2 = 0;
            febQtyN2 = 0;
            marQtyN2 = 0;
            janSalesN2 =0;
            febSalesN2 = 0;
            marSalesN2 = 0;
            janNetSalesN2 =0;
            febNetSalesN2 = 0;
            marNetSalesN2 = 0;
            isGermanyAccount=false;
            isSOSAorSONLAccount=false;
            isOtherCountryAccount=false;
            salesLast12Months=0;
            shareOfWallet=0;
            sowLast12Mo=0;
        }  
        @AuraEnabled public Double AccountConversionRate{get;set;} 
        @AuraEnabled public Boolean isCurrencySame{get;set;}
        @AuraEnabled public Boolean isGermanyAccount{get;set;}
        @AuraEnabled public Boolean isSOSAorSONLAccount{get;set;}
        @AuraEnabled public Boolean isOtherCountryAccount{get;set;}
        @AuraEnabled public Double shareOfWallet{get;set;}
        @AuraEnabled public Double sowLast12Mo{get;set;} 
        @AuraEnabled public Account account{get;set;}
        @AuraEnabled public Decimal salesLast12Months{get;set;}
        //Total Sales including all types
        @AuraEnabled public Double aprSales{get;set;}
        @AuraEnabled public Double maySales{get;set;}
        @AuraEnabled public Double junSales{get;set;}
        @AuraEnabled public Double julSales{get;set;}
        @AuraEnabled public Double augSales{get;set;}
        @AuraEnabled public Double sepSales{get;set;}
        @AuraEnabled public Double octSales{get;set;}
        @AuraEnabled public Double novSales{get;set;}
        @AuraEnabled public Double decSales{get;set;}
        @AuraEnabled public Double janSales{get;set;}
        @AuraEnabled public Double febSales{get;set;}
        @AuraEnabled public Double marSales{get;set;}
        @AuraEnabled public Double totalSales{get; set;}  
        
        //Net Sales
        @AuraEnabled public Double aprNetSales{get;set;}
        @AuraEnabled public Double mayNetSales{get;set;}
        @AuraEnabled public Double junNetSales{get;set;}
        @AuraEnabled public Double julNetSales{get;set;}
        @AuraEnabled public Double augNetSales{get;set;}
        @AuraEnabled public Double sepNetSales{get;set;}
        @AuraEnabled public Double octNetSales{get;set;}
        @AuraEnabled public Double novNetSales{get;set;}
        @AuraEnabled public Double decNetSales{get;set;}
        @AuraEnabled public Double janNetSales{get;set;}
        @AuraEnabled public Double febNetSales{get;set;}
        @AuraEnabled public Double marNetSales{get;set;}
        @AuraEnabled public Double totalNetSales{get; set;} 
        @AuraEnabled public Double totalNetSalesYTD{get; set;}
        
        //Total Qty for all types
        @AuraEnabled public Double aprQty{get;set;}
        @AuraEnabled public Double mayQty{get;set;}
        @AuraEnabled public Double junQty{get;set;}
        @AuraEnabled public Double julQty{get;set;}
        @AuraEnabled public Double augQty{get;set;}
        @AuraEnabled public Double sepQty{get;set;}
        @AuraEnabled public Double octQty{get;set;}
        @AuraEnabled public Double novQty{get;set;}
        @AuraEnabled public Double decQty{get;set;}
        @AuraEnabled public Double janQty{get;set;}
        @AuraEnabled public Double febQty{get;set;}
        @AuraEnabled public Double marQty{get;set;}
        @AuraEnabled public Double totalQty{get; set;} 
        
        @AuraEnabled public Double aprLensSales{get;set;}
        @AuraEnabled public Double mayLensSales{get;set;}
        @AuraEnabled public Double junLensSales{get;set;}
        @AuraEnabled public Double julLensSales{get;set;}
        @AuraEnabled public Double augLensSales{get;set;}
        @AuraEnabled public Double sepLensSales{get;set;}
        @AuraEnabled public Double octLensSales{get;set;}
        @AuraEnabled public Double novLensSales{get;set;}
        @AuraEnabled public Double decLensSales{get;set;}
        @AuraEnabled public Double janLensSales{get;set;}
        @AuraEnabled public Double febLensSales{get;set;}
        @AuraEnabled public Double marLensSales{get;set;}        
        @AuraEnabled public Double totalLensSales{get;set;}
        @AuraEnabled public Double totalLensSalesYTD{get;set;}
        
        @AuraEnabled public Double aprLensNetSales{get;set;}
        @AuraEnabled public Double mayLensNetSales{get;set;}
        @AuraEnabled public Double junLensNetSales{get;set;}
        @AuraEnabled public Double julLensNetSales{get;set;}
        @AuraEnabled public Double augLensNetSales{get;set;}
        @AuraEnabled public Double sepLensNetSales{get;set;}
        @AuraEnabled public Double octLensNetSales{get;set;}
        @AuraEnabled public Double novLensNetSales{get;set;}
        @AuraEnabled public Double decLensNetSales{get;set;}
        @AuraEnabled public Double janLensNetSales{get;set;}
        @AuraEnabled public Double febLensNetSales{get;set;}
        @AuraEnabled public Double marLensNetSales{get;set;}        
        @AuraEnabled public Double totalLensNetSales{get; set;}
         @AuraEnabled public Double totalLensNetSalesYTD{get; set;}
              
        @AuraEnabled public Double aprLensNetSalesLY{get;set;}
        @AuraEnabled public Double mayLensNetSalesLY{get;set;}
        @AuraEnabled public Double junLensNetSalesLY{get;set;}
        @AuraEnabled public Double julLensNetSalesLY{get;set;}
        @AuraEnabled public Double augLensNetSalesLY{get;set;}
        @AuraEnabled public Double sepLensNetSalesLY{get;set;}
        @AuraEnabled public Double octLensNetSalesLY{get;set;}
        @AuraEnabled public Double novLensNetSalesLY{get;set;}
        @AuraEnabled public Double decLensNetSalesLY{get;set;}
        @AuraEnabled public Double janLensNetSalesLY{get;set;}
        @AuraEnabled public Double febLensNetSalesLY{get;set;}
        @AuraEnabled public Double marLensNetSalesLY{get;set;} 
        
        @AuraEnabled public Double aprLensQty{get;set;}
        @AuraEnabled public Double mayLensQty{get;set;}
        @AuraEnabled public Double junLensQty{get;set;}
        @AuraEnabled public Double julLensQty{get;set;}
        @AuraEnabled public Double augLensQty{get;set;}
        @AuraEnabled public Double sepLensQty{get;set;}
        @AuraEnabled public Double octLensQty{get;set;}
        @AuraEnabled public Double novLensQty{get;set;}
        @AuraEnabled public Double decLensQty{get;set;}
        @AuraEnabled public Double janLensQty{get;set;}
        @AuraEnabled public Double febLensQty{get;set;}
        @AuraEnabled public Double marLensQty{get;set;}
        @AuraEnabled public Double totalLensQty{get; set;}  
        @AuraEnabled public Double totalLensQtyYTD{get; set;}
        
        @AuraEnabled public Double aprFramesSales{get;set;}
        @AuraEnabled public Double mayFramesSales{get;set;}
        @AuraEnabled public Double junFramesSales{get;set;}
        @AuraEnabled public Double julFramesSales{get;set;}
        @AuraEnabled public Double augFramesSales{get;set;}
        @AuraEnabled public Double sepFramesSales{get;set;}
        @AuraEnabled public Double octFramesSales{get;set;}
        @AuraEnabled public Double novFramesSales{get;set;}
        @AuraEnabled public Double decFramesSales{get;set;}
        @AuraEnabled public Double janFramesSales{get;set;}
        @AuraEnabled public Double febFramesSales{get;set;}
        @AuraEnabled public Double marFramesSales{get;set;}
        @AuraEnabled public Double totalFramesSales{get; set;}
        
        @AuraEnabled public Double aprFramesNetSales{get;set;}
        @AuraEnabled public Double mayFramesNetSales{get;set;}
        @AuraEnabled public Double junFramesNetSales{get;set;}
        @AuraEnabled public Double julFramesNetSales{get;set;}
        @AuraEnabled public Double augFramesNetSales{get;set;}
        @AuraEnabled public Double sepFramesNetSales{get;set;}
        @AuraEnabled public Double octFramesNetSales{get;set;}
        @AuraEnabled public Double novFramesNetSales{get;set;}
        @AuraEnabled public Double decFramesNetSales{get;set;}
        @AuraEnabled public Double janFramesNetSales{get;set;}
        @AuraEnabled public Double febFramesNetSales{get;set;}
        @AuraEnabled public Double marFramesNetSales{get;set;}
        @AuraEnabled public Double totalFramesNetSales{get; set;}
        
        @AuraEnabled public Double aprFramesQty{get;set;}
        @AuraEnabled public Double mayFramesQty{get;set;}
        @AuraEnabled public Double junFramesQty{get;set;}
        @AuraEnabled public Double julFramesQty{get;set;}
        @AuraEnabled public Double augFramesQty{get;set;}
        @AuraEnabled public Double sepFramesQty{get;set;}
        @AuraEnabled public Double octFramesQty{get;set;}
        @AuraEnabled public Double novFramesQty{get;set;}
        @AuraEnabled public Double decFramesQty{get;set;}
        @AuraEnabled public Double janFramesQty{get;set;}
        @AuraEnabled public Double febFramesQty{get;set;}
        @AuraEnabled public Double marFramesQty{get;set;}
        @AuraEnabled public Double totalFramesQty{get; set;}
        
        @AuraEnabled public Double aprInstSales{get;set;}
        @AuraEnabled public Double mayInstSales{get;set;}
        @AuraEnabled public Double junInstSales{get;set;}
        @AuraEnabled public Double julInstSales{get;set;}
        @AuraEnabled public Double augInstSales{get;set;}
        @AuraEnabled public Double sepInstSales{get;set;}
        @AuraEnabled public Double octInstSales{get;set;}
        @AuraEnabled public Double novInstSales{get;set;}
        @AuraEnabled public Double decInstSales{get;set;}
        @AuraEnabled public Double janInstSales{get;set;}
        @AuraEnabled public Double febInstSales{get;set;}
        @AuraEnabled public Double marInstSales{get;set;}
        @AuraEnabled public Double totalInstSales{get; set;}
        
        @AuraEnabled public Double aprInstNetSales{get;set;}
        @AuraEnabled public Double mayInstNetSales{get;set;}
        @AuraEnabled public Double junInstNetSales{get;set;}
        @AuraEnabled public Double julInstNetSales{get;set;}
        @AuraEnabled public Double augInstNetSales{get;set;}
        @AuraEnabled public Double sepInstNetSales{get;set;}
        @AuraEnabled public Double octInstNetSales{get;set;}
        @AuraEnabled public Double novInstNetSales{get;set;}
        @AuraEnabled public Double decInstNetSales{get;set;}
        @AuraEnabled public Double janInstNetSales{get;set;}
        @AuraEnabled public Double febInstNetSales{get;set;}
        @AuraEnabled public Double marInstNetSales{get;set;}
        @AuraEnabled public Double totalInstNetSales{get; set;}
        
        @AuraEnabled public Double aprInstQty{get;set;}
        @AuraEnabled public Double mayInstQty{get;set;}
        @AuraEnabled public Double junInstQty{get;set;}
        @AuraEnabled public Double julInstQty{get;set;}
        @AuraEnabled public Double augInstQty{get;set;}
        @AuraEnabled public Double sepInstQty{get;set;}
        @AuraEnabled public Double octInstQty{get;set;}
        @AuraEnabled public Double novInstQty{get;set;}
        @AuraEnabled public Double decInstQty{get;set;}
        @AuraEnabled public Double janInstQty{get;set;}
        @AuraEnabled public Double febInstQty{get;set;}
        @AuraEnabled public Double marInstQty{get;set;}
        @AuraEnabled public Double totalInstQty{get; set;}
        
        @AuraEnabled public Double aprOtherSales{get;set;}
        @AuraEnabled public Double mayOtherSales{get;set;}
        @AuraEnabled public Double junOtherSales{get;set;}
        @AuraEnabled public Double julOtherSales{get;set;}
        @AuraEnabled public Double augOtherSales{get;set;}
        @AuraEnabled public Double sepOtherSales{get;set;}
        @AuraEnabled public Double octOtherSales{get;set;}
        @AuraEnabled public Double novOtherSales{get;set;}
        @AuraEnabled public Double decOtherSales{get;set;}
        @AuraEnabled public Double janOtherSales{get;set;}
        @AuraEnabled public Double febOtherSales{get;set;}
        @AuraEnabled public Double marOtherSales{get;set;}
        @AuraEnabled public Double totalOtherSales{get; set;}
        
        @AuraEnabled public Double aprOtherNetSales{get;set;}
        @AuraEnabled public Double mayOtherNetSales{get;set;}
        @AuraEnabled public Double junOtherNetSales{get;set;}
        @AuraEnabled public Double julOtherNetSales{get;set;}
        @AuraEnabled public Double augOtherNetSales{get;set;}
        @AuraEnabled public Double sepOtherNetSales{get;set;}
        @AuraEnabled public Double octOtherNetSales{get;set;}
        @AuraEnabled public Double novOtherNetSales{get;set;}
        @AuraEnabled public Double decOtherNetSales{get;set;}
        @AuraEnabled public Double janOtherNetSales{get;set;}
        @AuraEnabled public Double febOtherNetSales{get;set;}
        @AuraEnabled public Double marOtherNetSales{get;set;}
        @AuraEnabled public Double totalOtherNetSales{get; set;}
        
        @AuraEnabled public Double aprOtherQty{get;set;}
        @AuraEnabled public Double mayOtherQty{get;set;}
        @AuraEnabled public Double junOtherQty{get;set;}
        @AuraEnabled public Double julOtherQty{get;set;}
        @AuraEnabled public Double augOtherQty{get;set;}
        @AuraEnabled public Double sepOtherQty{get;set;}
        @AuraEnabled public Double octOtherQty{get;set;}
        @AuraEnabled public Double novOtherQty{get;set;}
        @AuraEnabled public Double decOtherQty{get;set;}
        @AuraEnabled public Double janOtherQty{get;set;}
        @AuraEnabled public Double febOtherQty{get;set;}
        @AuraEnabled public Double marOtherQty{get;set;}
        @AuraEnabled public Double totalOtherQty{get;set;}
        
        @AuraEnabled public Double aprVariation{get;set;}
        @AuraEnabled public Double mayVariation{get;set;}
        @AuraEnabled public Double junVariation{get;set;}
        @AuraEnabled public Double julVariation{get;set;}
        @AuraEnabled public Double augVariation{get;set;}
        @AuraEnabled public Double sepVariation{get;set;}
        @AuraEnabled public Double octVariation{get;set;}
        @AuraEnabled public Double novVariation{get;set;}
        @AuraEnabled public Double decVariation{get;set;}
        @AuraEnabled public Double janVariation{get;set;}
        @AuraEnabled public Double febVariation{get;set;}
        @AuraEnabled public Double marVariation{get;set;}
        @AuraEnabled public Double totalVariation{get; set;}
        
        @AuraEnabled public Double aprLensesNetVariation{get;set;}
        @AuraEnabled public Double mayLensesNetVariation{get;set;}
        @AuraEnabled public Double junLensesNetVariation{get;set;}
        @AuraEnabled public Double julLensesNetVariation{get;set;}
        @AuraEnabled public Double augLensesNetVariation{get;set;}
        @AuraEnabled public Double sepLensesNetVariation{get;set;}
        @AuraEnabled public Double octLensesNetVariation{get;set;}
        @AuraEnabled public Double novLensesNetVariation{get;set;}
        @AuraEnabled public Double decLensesNetVariation{get;set;}
        @AuraEnabled public Double janLensesNetVariation{get;set;}
        @AuraEnabled public Double febLensesNetVariation{get;set;}
        @AuraEnabled public Double marLensesNetVariation{get;set;}
        @AuraEnabled public Double totalLensesNetVariation{get; set;}
        
        @AuraEnabled public Double aprLensesGrossVariation{get;set;}
        @AuraEnabled public Double mayLensesGrossVariation{get;set;}
        @AuraEnabled public Double junLensesGrossVariation{get;set;}
        @AuraEnabled public Double julLensesGrossVariation{get;set;}
        @AuraEnabled public Double augLensesGrossVariation{get;set;}
        @AuraEnabled public Double sepLensesGrossVariation{get;set;}
        @AuraEnabled public Double octLensesGrossVariation{get;set;}
        @AuraEnabled public Double novLensesGrossVariation{get;set;}
        @AuraEnabled public Double decLensesGrossVariation{get;set;}
        @AuraEnabled public Double janLensesGrossVariation{get;set;}
        @AuraEnabled public Double febLensesGrossVariation{get;set;}
        @AuraEnabled public Double marLensesGrossVariation{get;set;}
        @AuraEnabled public Double totalLensesGrossVariation{get; set;}
        
        @AuraEnabled public Double aprNetVariation{get;set;}
        @AuraEnabled public Double mayNetVariation{get;set;}
        @AuraEnabled public Double junNetVariation{get;set;}
        @AuraEnabled public Double julNetVariation{get;set;}
        @AuraEnabled public Double augNetVariation{get;set;}
        @AuraEnabled public Double sepNetVariation{get;set;}
        @AuraEnabled public Double octNetVariation{get;set;}
        @AuraEnabled public Double novNetVariation{get;set;}
        @AuraEnabled public Double decNetVariation{get;set;}
        @AuraEnabled public Double janNetVariation{get;set;}
        @AuraEnabled public Double febNetVariation{get;set;}
        @AuraEnabled public Double marNetVariation{get;set;}
        @AuraEnabled public Double totalNetVariation{get; set;} 
        
        @AuraEnabled public Double aprVariationQty{get;set;}
        @AuraEnabled public Double mayVariationQty{get;set;}
        @AuraEnabled public Double junVariationQty{get;set;}
        @AuraEnabled public Double julVariationQty{get;set;}
        @AuraEnabled public Double augVariationQty{get;set;}
        @AuraEnabled public Double sepVariationQty{get;set;}
        @AuraEnabled public Double octVariationQty{get;set;}
        @AuraEnabled public Double novVariationQty{get;set;}
        @AuraEnabled public Double decVariationQty{get;set;}
        @AuraEnabled public Double janVariationQty{get;set;}
        @AuraEnabled public Double febVariationQty{get;set;}
        @AuraEnabled public Double marVariationQty{get;set;}
        @AuraEnabled public Double totalVariationQty{get; set;} 
        
        @AuraEnabled public Double aprLensesVariationQty{get;set;}
        @AuraEnabled public Double mayLensesVariationQty{get;set;}
        @AuraEnabled public Double junLensesVariationQty{get;set;}
        @AuraEnabled public Double julLensesVariationQty{get;set;}
        @AuraEnabled public Double augLensesVariationQty{get;set;}
        @AuraEnabled public Double sepLensesVariationQty{get;set;}
        @AuraEnabled public Double octLensesVariationQty{get;set;}
        @AuraEnabled public Double novLensesVariationQty{get;set;}
        @AuraEnabled public Double decLensesVariationQty{get;set;}
        @AuraEnabled public Double janLensesVariationQty{get;set;}
        @AuraEnabled public Double febLensesVariationQty{get;set;}
        @AuraEnabled public Double marLensesVariationQty{get;set;}
        @AuraEnabled public Double totalLensesVariationQty{get; set;} 
     
        @AuraEnabled public Double aprSalesLY{get; set;}
        @AuraEnabled public Double maySalesLY{get; set;}
        @AuraEnabled public Double junSalesLY{get; set;}
        @AuraEnabled public Double julSalesLY{get; set;}
        @AuraEnabled public Double augSalesLY{get; set;}
        @AuraEnabled public Double sepSalesLY{get; set;}
        @AuraEnabled public Double octSalesLY{get; set;}
        @AuraEnabled public Double novSalesLY{get; set;}
        @AuraEnabled public Double decSalesLY{get; set;}
        @AuraEnabled public Double janSalesLY{get; set;}
        @AuraEnabled public Double febSalesLY{get; set;}
        @AuraEnabled public Double marSalesLY{get; set;}
        @AuraEnabled public Double totalSalesLY{get; set;}
        @AuraEnabled public Double totalSalesLYYTD{get; set;}
        
        @AuraEnabled public Double aprNetSalesLY{get; set;}
        @AuraEnabled public Double mayNetSalesLY{get; set;}
        @AuraEnabled public Double junNetSalesLY{get; set;}
        @AuraEnabled public Double julNetSalesLY{get; set;}
        @AuraEnabled public Double augNetSalesLY{get; set;}
        @AuraEnabled public Double sepNetSalesLY{get; set;}
        @AuraEnabled public Double octNetSalesLY{get; set;}
        @AuraEnabled public Double novNetSalesLY{get; set;}
        @AuraEnabled public Double decNetSalesLY{get; set;}
        @AuraEnabled public Double janNetSalesLY{get; set;}
        @AuraEnabled public Double febNetSalesLY{get; set;}
        @AuraEnabled public Double marNetSalesLY{get; set;}  
        @AuraEnabled public Double totalNetSalesLY{get; set;}
        @AuraEnabled public Double totalNetSalesLYYTD{get; set;}

        @AuraEnabled public Double aprQtyLY{get; set;}
        @AuraEnabled public Double mayQtyLY{get; set;}
        @AuraEnabled public Double junQtyLY{get; set;}
        @AuraEnabled public Double julQtyLY{get; set;}
        @AuraEnabled public Double augQtyLY{get; set;}
        @AuraEnabled public Double sepQtyLY{get; set;}
        @AuraEnabled public Double octQtyLY{get; set;}
        @AuraEnabled public Double novQtyLY{get; set;}
        @AuraEnabled public Double decQtyLY{get; set;}
        @AuraEnabled public Double janQtyLY{get; set;}
        @AuraEnabled public Double febQtyLY{get; set;}
        @AuraEnabled public Double marQtyLY{get; set;}
        @AuraEnabled public Double totalQtyLY{get; set;}
        @AuraEnabled public Double totalQtyLYYTD{get; set;}        
        
        @AuraEnabled public Double aprLensesQtyLY{get; set;}
        @AuraEnabled public Double mayLensesQtyLY{get; set;}
        @AuraEnabled public Double junLensesQtyLY{get; set;}
        @AuraEnabled public Double julLensesQtyLY{get; set;}
        @AuraEnabled public Double augLensesQtyLY{get; set;}
        @AuraEnabled public Double sepLensesQtyLY{get; set;}
        @AuraEnabled public Double octLensesQtyLY{get; set;}
        @AuraEnabled public Double novLensesQtyLY{get; set;}
        @AuraEnabled public Double decLensesQtyLY{get; set;}
        @AuraEnabled public Double janLensesQtyLY{get; set;}
        @AuraEnabled public Double febLensesQtyLY{get; set;}
        @AuraEnabled public Double marLensesQtyLY{get; set;}
        @AuraEnabled public Double totalLensesQtyLY{get; set;}
        
        @AuraEnabled public Double aprLensesSalesLY{get; set;}
        @AuraEnabled public Double mayLensesSalesLY{get; set;}
        @AuraEnabled public Double junLensesSalesLY{get; set;}
        @AuraEnabled public Double julLensesSalesLY{get; set;}
        @AuraEnabled public Double augLensesSalesLY{get; set;}
        @AuraEnabled public Double sepLensesSalesLY{get; set;}
        @AuraEnabled public Double octLensesSalesLY{get; set;}
        @AuraEnabled public Double novLensesSalesLY{get; set;}
        @AuraEnabled public Double decLensesSalesLY{get; set;}
        @AuraEnabled public Double janLensesSalesLY{get; set;}
        @AuraEnabled public Double febLensesSalesLY{get; set;}
        @AuraEnabled public Double marLensesSalesLY{get; set;}
        @AuraEnabled public Double totalLensesSalesLY{get; set;}
        
        @AuraEnabled public Double aprLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double mayLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double junLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double julLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double augLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double sepLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double octLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double novLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double decLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double janLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double febLensremoteEdgeQty{get;set;}
        @AuraEnabled public Double marLensremoteEdgeQty{get;set;} 
        @AuraEnabled public Double janLensremoteEdgeQtyLy{get;set;}
        @AuraEnabled public Double febLensremoteEdgeQtyLy{get;set;}
        @AuraEnabled public Double marLensremoteEdgeQtyLy{get;set;} 
        @AuraEnabled public Double totalLensremoteEdgeQty{get;set;} 
        @AuraEnabled public Double remoteEdgeQtyPercenatge{get;set;}
        
        //Lenses Gross Sales & Volume trends      
        @AuraEnabled public Double lensesAnnualSales{get;set;}
        @AuraEnabled public Double lensesAnnualQty{get;set;}
        @AuraEnabled public Double lensesAnnualSalesVsLFY{get;set;}
        @AuraEnabled public Double lensesAnnualQtytrendvsLFY{get;set;}
        @AuraEnabled public Double totalLensesSalesLFYYTD{get;set;}
        @AuraEnabled public Double totalLensesQtyLFYYTD{get;set;}
        @AuraEnabled public Double lensesSalesCFYvsLFYYTD{get; set;}
        @AuraEnabled public Double lensesQtyCFYvsLFYYTD{get; set;}
        @AuraEnabled public Double lensesSales3monthsCFY{get; set;}
        @AuraEnabled public Double lensesQty3monthsCFY{get; set;}
        @AuraEnabled public Double lensesSales3monthsLFY{get; set;}
        @AuraEnabled public Double lensesQty3monthsLFY{get; set;}
        @AuraEnabled public Double lensesSales3monthsCFYvsLFY{get; set;}
        @AuraEnabled public Double lensesQty3monthsCFYvsLFY{get; set;}
        @AuraEnabled public Double lensesSalesForecastCFY{get;set;}
        @AuraEnabled public Double lensesSalesForecastCFYvsLFY{get;set;}
        @AuraEnabled public Double lensesForecastvsECPAgreement{get;set;}
      //  @AuraEnabled public Double remoteEdgingqty3months{get;set;}
       // @AuraEnabled public Double remoteEdgingpercentage3months{get;set;}
        
        //Lenses delays
        @AuraEnabled public Double rxShippedSameDay{get;set;}
        @AuraEnabled public Double rxShippedMax1Day{get;set;}
        @AuraEnabled public Double rxShippedMax2Days{get;set;}
        @AuraEnabled public Double rxShippedMax3Days{get;set;}
        @AuraEnabled public Double rxShippedMax4Days{get;set;}
        @AuraEnabled public Double rxShippedMax5Days{get;set;}
        @AuraEnabled public Double rxShippedMax6Days{get;set;}
        @AuraEnabled public Double rxShippedMax7Days{get;set;}
        @AuraEnabled public Double rxShippedMax8Days{get;set;}
        @AuraEnabled public Double rxShippedMax9Days{get;set;}
        @AuraEnabled public Double rxShippedMax10Days{get;set;}
        @AuraEnabled public Double stockShippedSameDay{get;set;}
        @AuraEnabled public Double stockShippedMax1Day{get;set;}
        @AuraEnabled public Double stockShippedMax2Days{get;set;}
        @AuraEnabled public Double stockShippedMax3Days{get;set;}
        @AuraEnabled public Double stockShippedMax4Days{get;set;}
        @AuraEnabled public Double stockShippedMax5Days{get;set;}
        @AuraEnabled public Double shipmentAvgDelay{get;set;}
        @AuraEnabled public Double shipmentStockAvgDelay{get;set;}
        @AuraEnabled public Double shipmentRxAvgDelay{get;set;}

        @AuraEnabled public Double janSalesN2{get;set;}
        @AuraEnabled public Double febSalesN2{get;set;}
        @AuraEnabled public Double marSalesN2{get;set;}
        @AuraEnabled public Double janNetSalesN2{get;set;}
        @AuraEnabled public Double febNetSalesN2{get;set;}
        @AuraEnabled public Double marNetSalesN2{get;set;}
        @AuraEnabled public Double janQtyN2{get;set;}
        @AuraEnabled public Double febQtyN2{get;set;}
        @AuraEnabled public Double marQtyN2{get;set;}   
    }
    
    //Wrapper class to store all Hoya Item types sales & Qty
    public class SalesData{
        @AuraEnabled public Double lensNetSales{get;set;}
        @AuraEnabled public Double lensGrossSales{get;set;}
        @AuraEnabled public Double framesNetSales{get;set;}
        @AuraEnabled public Double framesGrossSales{get;set;}
        @AuraEnabled public Double instrumentsNetSales{get;set;}
        @AuraEnabled public Double instrumentsGrossSales{get;set;}
        @AuraEnabled public Double otherNetSales{get;set;}
        @AuraEnabled public Double otherGrossSales{get;set;}
        @AuraEnabled public Double totalNetSales{get;set;}
        @AuraEnabled public Double totalGrossSales{get;set;}
        @AuraEnabled public Integer lensQty{get;set;}
        @AuraEnabled public Integer framesQty{get;set;}
        @AuraEnabled public Integer instrumentsQty{get;set;}
        @AuraEnabled public Integer OthersQty{get;set;}
        @AuraEnabled public Integer totalQty{get;set;}
        @AuraEnabled public Integer rxQty{get;set;}
        @AuraEnabled public Integer stockQty{get;set;}
        @AuraEnabled public Integer remoteEdgingQty{get;set;}
        @AuraEnabled public Double contactLensNetSales{get;set;}
        @AuraEnabled public Double contactLensGrossSales{get;set;}
        @AuraEnabled public Integer contactLensQty{get;set;}
        
        public SalesData(){
            lensNetSales=0;
            lensGrossSales=0;
            framesNetSales=0;
            framesGrossSales=0;
            instrumentsNetSales=0;
            instrumentsGrossSales=0;
            otherNetSales=0;
            otherGrossSales=0;  
            totalNetSales=0;
            totalGrossSales=0;
            lensQty=0;
            framesQty=0;
            instrumentsQty=0;
            OthersQty=0;
            totalQty=0;
            rxQty=0;
            stockQty=0;
            remoteEdgingQty=0;      
            contactLensNetSales = 0;
            contactLensGrossSales = 0;
            contactLensQty = 0;
         }
    }
    private static Map<Integer,SalesData> MonthlyCYData{get;set;}
    private static Map<Integer,SalesData> MonthlyLYData{get;set;}


    @AuraEnabled
    public static Account getAccount(Id recordId){
        Account acc = null;
        try {
            acc = [select ID, Hoya_Account_ID__c,annualRevenue, currencyIsoCode,Brand__c, parentId,Potential__c
            , Seiko_objective_ECP_agr__c from account where id=:recordId];
            return acc;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
 
    @AuraEnabled
    public static List<Object> initSales(Id recordId){
        	List<Object> accountSalesLst;
            AccountSales accountSales = new AccountSales();
            accountSales.account =  [select ID, Hoya_Account_ID__c,currencyIsoCode,Brand__c, parentId,Shop_country__c
                                	from account where id=:recordId];
            String userCurrency = UserInfo.getDefaultCurrency();
            String accountCurrency = [select currencyisocode from Account where id=:recordId].currencyIsoCode;
            accountSales.isCurrencySame =false;
            if(userCurrency == accountCurrency)
            { 
                accountSales.isCurrencySame =true;
            }
              /*
             * determine the current fiscal year
             */
            Integer CurrentFiscalyear = Date.today().year();
            Integer month = Date.today().month();
            if(Test.isRunningTest())
                month=testMonth;
            //fiscal year is current year-1 from january to april, year from april to december   
            //April is considering as previous fiscal year till it enters to May         
            if(month <= 4){               
                CurrentFiscalyear=CurrentFiscalyear-1;
            }
            
            Map<Integer,LensSales> MonthlyCYLensMap=new Map<Integer,LensSales>();
            Map<Integer,LensSales> MonthlyLYLensMap=new Map<Integer,LensSales>();
            Map<Integer,LensSales> MonthlyNYLensMap=new Map<Integer,LensSales>();
            Map<Integer,RxAndStockSales> RxMapCY=new Map<Integer,RxAndStockSales>();
            Map<Integer,RxAndStockSales> StockMapCY=new Map<Integer,RxAndStockSales>();
            Map<Integer,RxAndStockSales> RxMapLY=new Map<Integer,RxAndStockSales>();
            Map<Integer,RxAndStockSales> StockMapLY=new Map<Integer,RxAndStockSales>();
           
            List<Sales_Statistics__c> salesLensCY=[SELECT Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                 ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                 ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                                   Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                                   ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                 from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear ];
                     
            //Prepare Rx and Stock data maps
            for(Sales_Statistics__c sales:salesLensCY){ 
                if(sales.Type__c == '0'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
                    rxSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
                    rxSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);
                    rxSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
                    rxSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
                    rxSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
                    rxSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
                    StockMapCY.put((Integer)sales.Month__c,rxSales);
                }
                if(sales.Type__c == '1'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.rxQty=(Integer)sales.RX_lenses_qty__c;
                    rxSales.rxShippedonSameDay=parseNullInt((Integer)sales.Total_RX_qty_shipped_same_day__c);
                    rxSales.rxShippedin1Day=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_1_day__c);
                    rxSales.rxShippedin2Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_2_days__c);
                    rxSales.rxShippedin3Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_3_days__c);
                    rxSales.rxShippedin4Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_4_days__c);
                    rxSales.rxShippedin5Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_5_days__c);
                    rxSales.rxShippedin6Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_6_days__c);
                    rxSales.rxShippedin7Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_7_days__c);
                    rxSales.rxShippedin8Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_8_days__c);
                    rxSales.rxShippedin9Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_9_days__c);
                    rxSales.rxShippedin10Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_10_days__c);
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
                    RxMapCY.put((Integer)sales.Month__c,rxSales);
                }
            }
            
            List<Sales_Statistics__c> salesLensLY=[SELECT Month__c,Fiscal_Year__c,Type__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                 ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                 ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_in_6_days__c,Total_RX_qty_shipped_in_7_days__c,Total_RX_qty_shipped_in_8_days__c,Total_RX_qty_shipped_in_9_days__c,
                                                   Total_RX_qty_shipped_in_10_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c,Total_STOCK_qty_shipped_in_2_days__c,Total_STOCK_qty_shipped_in_3_days__c,Total_STOCK_qty_shipped_in_4_days__c
                                                   ,Total_STOCK_qty_shipped_in_5_days__c,Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                 from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear-1 ];
         
            for(Sales_Statistics__c sales:salesLensLY){
                if(sales.Type__c == '1'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.rxQty=parseNullInt((Integer)sales.RX_lenses_qty__c);
                    rxSales.rxShippedonSameDay=parseNullInt((Integer)sales.Total_RX_qty_shipped_same_day__c);
                    rxSales.rxShippedin1Day=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_1_day__c);
                    rxSales.rxShippedin2Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_2_days__c);
                    rxSales.rxShippedin3Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_3_days__c);
                    rxSales.rxShippedin4Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_4_days__c);
                    rxSales.rxShippedin5Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_5_days__c); 
                    rxSales.rxShippedin6Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_6_days__c);
                    rxSales.rxShippedin7Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_7_days__c);
                    rxSales.rxShippedin8Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_8_days__c);
                    rxSales.rxShippedin9Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_9_days__c);
                    rxSales.rxShippedin10Days=parseNullInt((Integer)sales.Total_RX_qty_shipped_in_10_days__c);
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
                    RxMapLY.put((Integer)sales.Month__c,rxSales);
                }
                if(sales.Type__c == '0'){ 
                    RxAndStockSales rxSales=new RxAndStockSales();
                    rxSales.stockQty=parseNullInt((Integer)sales.Stock_lenses_Qty__c);
                    rxSales.stockShippedonSameDay=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_same_day__c);
                    rxSales.stockShippedin1Day=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_1_day__c);                                
                    rxSales.stockShippedin2Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_2_days__c);
                    rxSales.stockShippedin3Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_3_days__c);
                    rxSales.stockShippedin4Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_4_days__c);
                    rxSales.stockShippedin5Days=parseNullInt((Integer)sales.Total_STOCK_qty_shipped_in_5_days__c);
                    rxSales.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c);
                    StockMapLY.put((Integer)sales.Month__c,rxSales);
                }
            }
            
            //prepare lens(sum of Rx and Stock) sales maps for each month 
            for(Sales_Statistics__c sales:salesLensCY){ 
                if(MonthlyCYLensMap.size() > 0 && MonthlyCYLensMap.containsKey((Integer)sales.Month__c))
                {
                    LensSales lens = MonthlyCYLensMap.get((Integer)sales.Month__c);
                    lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty += parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyCYLensMap.put((Integer)sales.Month__c,lens);
                }
                else{
                    LensSales lens = new LensSales();
                    lens.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty = parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyCYLensMap.put((Integer)sales.Month__c,lens);
                }
            }
          
            //prepare the Lens Map for last fy
            for(Sales_Statistics__c sales:salesLensLY){ 
                if(MonthlyLYLensMap.size() > 0 && MonthlyLYLensMap.containsKey((Integer)sales.Month__c))
                {
                    LensSales lens = MonthlyLYLensMap.get((Integer)sales.Month__c);
                    lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty += parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyLYLensMap.put((Integer)sales.Month__c,lens); 
                }
                else{
                    LensSales lens = new LensSales();
                    lens.lensGrossSales = parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales = parseNull((double)sales.Lenses_Net_Sales__c); 
                    lens.lensQty = parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty = parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyLYLensMap.put((Integer)sales.Month__c,lens);
                }
            }
            List<Sales_Statistics__c> salesLensNY=[SELECT Month__c,Fiscal_Year__c,Lenses_Gross_Sales__c,Lenses_Net_Sales__c,Lenses_Qty__c,RX_lenses_qty__c,Stock_lenses_Qty__c
                                                 ,Total_RX_qty_shipped_in_1_day__c,Total_RX_qty_shipped_in_2_days__c,Total_RX_qty_shipped_in_3_days__c,Total_RX_qty_shipped_in_4_days__c
                                                 ,  Total_RX_qty_shipped_in_5_days__c,Total_RX_qty_shipped_same_day__c,Total_STOCK_qty_shipped_in_1_day__c, Total_STOCK_qty_shipped_same_day__c,Remote_edging_Qty__c
                                                 from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c =:CurrentFiscalyear-2 ];
            
            //prepare lens map for N2FY
           
            for(Sales_Statistics__c sales:salesLensNY){  
                if(MonthlyNYLensMap.size() > 0 && MonthlyNYLensMap.containsKey((Integer)sales.Month__c))
                {
                    LensSales lens = MonthlyNYLensMap.get((Integer)sales.Month__c);
                    lens.lensGrossSales += parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales += parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty +=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty += parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyNYLensMap.put((Integer)sales.Month__c,lens); 
                }
                else{
                    LensSales lens=new LensSales();
                    lens.lensGrossSales=parseNull((double)sales.Lenses_Gross_Sales__c);
                    lens.lensNetSales=parseNull((double)sales.Lenses_Net_Sales__c);
                    lens.lensQty=parseNullInt((Integer)sales.Lenses_Qty__c);   
                    lens.remoteEdgingQty=parseNullInt((Integer)sales.Remote_edging_Qty__c); 
                    MonthlyNYLensMap.put((Integer)sales.Month__c,lens);
                }
            }
            system.debug(MonthlyCYLensMap.size()+'   '+MonthlyCYLensMap);
            system.debug(MonthlyLYLensMap.size()+'   '+MonthlyLYLensMap);
               
      
            List<Account> accs=[select Hoya_Account_ID__c,Potential__c,Seiko_objective_ECP_agr__c from Account where id=:recordId];
            String HoyaAccountID = accs[0].Hoya_Account_ID__c;
            Double StrategicVal = accs[0].Potential__c;
            Double ecpAggrement = accs[0].Seiko_objective_ECP_agr__c;
            if( HoyaAccountID.startsWith('SO4900') ||  HoyaAccountID.startsWith('SO4990'))
                accountSales.isGermanyAccount=true;
            else if(HoyaAccountID.startsWith('SO2700') || (HoyaAccountID.startsWith('SO3200') && accountSales.account.Shop_country__c == 'NL') || (HoyaAccountID.startsWith('SO3200') && accountSales.account.Shop_country__c != 'BE'))
                accountSales.isSOSAorSONLAccount=true;
            else
                accountSales.isOtherCountryAccount=true;

           
            accountSales.aprSales = 0;
            accountSales.maySales = 0;
            accountSales.junSales = 0;
            accountSales.julSales = 0;
            accountSales.augSales = 0;
            accountSales.sepSales = 0;
            accountSales.octSales = 0;
            accountSales.novSales = 0;
            accountSales.decSales = 0;
            accountSales.janSales = 0;
            accountSales.febSales = 0;
            accountSales.marSales = 0;
            accountSales.totalSales = 0;
            accountSales.totalSalesLY = 0;
            
            accountSales.aprNetSales = 0;
            accountSales.mayNetSales = 0;
            accountSales.junNetSales = 0;
            accountSales.julNetSales = 0;
            accountSales.augNetSales = 0;
            accountSales.sepNetSales = 0;
            accountSales.octNetSales = 0;
            accountSales.novNetSales = 0;
            accountSales.decNetSales = 0;
            accountSales.janNetSales = 0;
            accountSales.febNetSales = 0;
            accountSales.marNetSales = 0;
            accountSales.totalNetSales = 0;
            accountSales.totalNetSalesYTD = 0;
        
            accountSales.aprQty = 0;
            accountSales.mayQty = 0;
            accountSales.junQty = 0;
            accountSales.julQty = 0;
            accountSales.augQty = 0;
            accountSales.sepQty = 0;
            accountSales.octQty = 0;
            accountSales.novQty = 0;
            accountSales.decQty = 0;
            accountSales.janQty = 0;
            accountSales.febQty = 0;
            accountSales.marQty = 0;
            accountSales.totalQty = 0;
            accountSales.totalQtyLY = 0;
            accountSales.totalQtyLYYTD = 0;
            
            accountSales.aprLensSales = 0;
            accountSales.mayLensSales = 0;
            accountSales.junLensSales = 0;
            accountSales.julLensSales = 0;
            accountSales.augLensSales = 0;
            accountSales.sepLensSales = 0;
            accountSales.octLensSales = 0;
            accountSales.novLensSales = 0;
            accountSales.decLensSales = 0;
            accountSales.janLensSales = 0;
            accountSales.febLensSales = 0;
            accountSales.marLensSales = 0;
            accountSales.totalLensSales = 0;
            accountSales.totalLensSalesYTD = 0;
        
            accountSales.aprLensNetSales = 0;
            accountSales.mayLensNetSales = 0;
            accountSales.junLensNetSales = 0;
            accountSales.julLensNetSales = 0;
            accountSales.augLensNetSales = 0;
            accountSales.sepLensNetSales = 0;
            accountSales.octLensNetSales = 0;
            accountSales.novLensNetSales = 0;
            accountSales.decLensNetSales = 0;
            accountSales.janLensNetSales = 0;
            accountSales.febLensNetSales = 0;
            accountSales.marLensNetSales = 0;
            accountSales.totalLensNetSales = 0;
            accountSales.totalLensNetSalesYTD = 0;
            
            accountSales.aprLensQty = 0;
            accountSales.mayLensQty = 0;
            accountSales.junLensQty = 0;
            accountSales.julLensQty = 0;
            accountSales.augLensQty = 0;
            accountSales.sepLensQty = 0;
            accountSales.octLensQty = 0;
            accountSales.novLensQty = 0;
            accountSales.decLensQty = 0;
            accountSales.janLensQty = 0;
            accountSales.febLensQty = 0;
            accountSales.marLensQty = 0;
            accountSales.totalLensQty = 0;
            accountSales.totalLensQtyYTD = 0;
        
            accountSales.aprFramesSales = 0;
            accountSales.mayFramesSales = 0;
            accountSales.junFramesSales = 0;
            accountSales.julFramesSales = 0;
            accountSales.augFramesSales = 0;
            accountSales.sepFramesSales = 0;
            accountSales.octFramesSales = 0;
            accountSales.novFramesSales = 0;
            accountSales.decFramesSales = 0;
            accountSales.janFramesSales = 0;
            accountSales.febFramesSales = 0;
            accountSales.marFramesSales = 0;
            accountSales.totalFramesSales = 0;
        
            accountSales.aprFramesNetSales = 0;
            accountSales.mayFramesNetSales = 0;
            accountSales.junFramesNetSales = 0;
            accountSales.julFramesNetSales = 0;
            accountSales.augFramesNetSales = 0;
            accountSales.sepFramesNetSales = 0;
            accountSales.octFramesNetSales = 0;
            accountSales.novFramesNetSales = 0;
            accountSales.decFramesNetSales = 0;
            accountSales.janFramesNetSales = 0;
            accountSales.febFramesNetSales = 0;
            accountSales.marFramesNetSales = 0;
            accountSales.totalFramesNetSales = 0;
                    
            accountSales.aprFramesQty = 0;
            accountSales.mayFramesQty = 0;
            accountSales.junFramesQty = 0;
            accountSales.julFramesQty = 0;
            accountSales.augFramesQty = 0;
            accountSales.sepFramesQty = 0;
            accountSales.octFramesQty = 0;
            accountSales.novFramesQty = 0;
            accountSales.decFramesQty = 0;
            accountSales.janFramesQty = 0;
            accountSales.febFramesQty = 0;
            accountSales.marFramesQty = 0;
            accountSales.totalFramesQty = 0;
        
            accountSales.aprInstSales = 0;
            accountSales.mayInstSales = 0;
            accountSales.junInstSales = 0;
            accountSales.julInstSales = 0;
            accountSales.augInstSales = 0;
            accountSales.sepInstSales = 0;
            accountSales.octInstSales = 0;
            accountSales.novInstSales = 0;
            accountSales.decInstSales = 0;
            accountSales.janInstSales = 0;
            accountSales.febInstSales = 0;
            accountSales.marInstSales = 0;
            accountSales.totalInstSales = 0;
        
            accountSales.aprInstNetSales = 0;
            accountSales.mayInstNetSales = 0;
            accountSales.junInstNetSales = 0;
            accountSales.julInstNetSales = 0;
            accountSales.augInstNetSales = 0;
            accountSales.sepInstNetSales = 0;
            accountSales.octInstNetSales = 0;
            accountSales.novInstNetSales = 0;
            accountSales.decInstNetSales = 0;
            accountSales.janInstNetSales = 0;
            accountSales.febInstNetSales = 0;
            accountSales.marInstNetSales = 0;
            accountSales.totalInstNetSales = 0;
            
            accountSales.aprInstQty = 0;
            accountSales.mayInstQty = 0;
            accountSales.junInstQty = 0;
            accountSales.julInstQty = 0;
            accountSales.augInstQty = 0;
            accountSales.sepInstQty = 0;
            accountSales.octInstQty = 0;
            accountSales.novInstQty = 0;
            accountSales.decInstQty = 0;
            accountSales.janInstQty = 0;
            accountSales.febInstQty = 0;
            accountSales.marInstQty = 0;
            accountSales.totalInstQty = 0;
            
            accountSales.aprOtherSales = 0;
            accountSales.mayOtherSales = 0;
            accountSales.junOtherSales = 0;
            accountSales.julOtherSales = 0;
            accountSales.augOtherSales = 0;
            accountSales.sepOtherSales = 0;
            accountSales.octOtherSales = 0;
            accountSales.novOtherSales = 0;
            accountSales.decOtherSales = 0;
            accountSales.janOtherSales = 0;
            accountSales.febOtherSales = 0;
            accountSales.marOtherSales = 0;
            accountSales.totalOtherSales = 0;
            
            accountSales.aprOtherNetSales = 0;
            accountSales.mayOtherNetSales = 0;
            accountSales.junOtherNetSales = 0;
            accountSales.julOtherNetSales = 0;
            accountSales.augOtherNetSales = 0;
            accountSales.sepOtherNetSales = 0;
            accountSales.octOtherNetSales = 0;
            accountSales.novOtherNetSales = 0;
            accountSales.decOtherNetSales = 0;
            accountSales.janOtherNetSales = 0;
            accountSales.febOtherNetSales = 0;
            accountSales.marOtherNetSales = 0;
            accountSales.totalOtherNetSales = 0;
        
            accountSales.aprOtherQty = 0;
            accountSales.mayOtherQty = 0;
            accountSales.junOtherQty = 0;
            accountSales.julOtherQty = 0;
            accountSales.augOtherQty = 0;
            accountSales.sepOtherQty = 0;
            accountSales.octOtherQty = 0;
            accountSales.novOtherQty = 0;
            accountSales.decOtherQty = 0;
            accountSales.janOtherQty = 0;
            accountSales.febOtherQty = 0;
            accountSales.marOtherQty = 0;
            accountSales.totalOtherQty = 0;
        
            accountSales.aprLensremoteEdgeQty = 0;
            accountSales.mayLensremoteEdgeQty =0;
            accountSales.junLensremoteEdgeQty=0;
            accountSales.julLensremoteEdgeQty=0;
            accountSales.augLensremoteEdgeQty=0;
            accountSales.sepLensremoteEdgeQty=0;
            accountSales.octLensremoteEdgeQty=0;
            accountSales.novLensremoteEdgeQty=0;
            accountSales.decLensremoteEdgeQty=0;
            accountSales.janLensremoteEdgeQty=0;
            accountSales.febLensremoteEdgeQty=0;
            accountSales.marLensremoteEdgeQty=0;
            accountSales.totalLensremoteEdgeQty=0;
            accountSales.remoteEdgeQtyPercenatge= 0;
            
            /*
             * compute data other than lens
             */
            List<Sales_Statistics__c> AllSalesData=[SELECT Type__c,Month__c,Fiscal_Year__c,Frames_Gross_Sales__c,Frames_Net_Sales__c,Frames_Qty__c,Instrument_Gross_Sales__c,Instrument_Net_Sales__c,
                                                   Instruments_Qty__c,Other_Gross_Sales__c,Other_Net_Sales__c,Other_Qty__c,Remote_edging_Qty__c,Contact_Lenses_Qty__c,Contact_Lenses_Net_Sales__c,Contact_Lenses_Gross_Sales__c
                                                   from Sales_Statistics__c
                                                   where Account__c=:recordId and Type__c != '0' and Type__c != '1'and (Fiscal_Year__c =: CurrentFiscalyear OR Fiscal_Year__c =: CurrentFiscalyear-1) order by Month__c asc ]; 
            List<Sales_Statistics__c> AllSalesDataCY=new List<Sales_Statistics__c>();
            List<Sales_Statistics__c> AllSalesDataLY=new List<Sales_Statistics__c>();
           
            if(AllSalesData.size() > 0){
                 for(Sales_Statistics__c salesStat:AllSalesData){
                      if((Integer)salesStat.Fiscal_Year__c == CurrentFiscalyear){ 
                          AllSalesDataCY.add(salesStat);
                      }
                      if((Integer)salesStat.Fiscal_Year__c == CurrentFiscalyear-1){ 
                          AllSalesDataLY.add(salesStat);
                      }
                 }
            }        
            //loop through the result and get the individual sales & qty and total sales & qty
            MonthlyCYData=new Map<Integer,SalesData>();
            MonthlyLYData=new Map<Integer,SalesData>();
            List<SalesData> SalesListCy=new List<SalesData>();
            List<SalesData> SalesListLy=new List<SalesData>();
             //prepare the data for Cy  
            for(Integer i = 1; i <= 12; i++){
                SalesData salesDataObj=new SalesData();       
                if(MonthlyCYLensMap.containsKey(i)){
                    LensSales lensObj = MonthlyCYLensMap.get(i);
                    salesDataObj.lensNetSales = parseNull(lensObj.lensNetSales); 
                    salesDataObj.lensGrossSales = parseNull(lensObj.lensGrossSales);
                    salesDataObj.lensQty = parseNullInt(lensObj.lensQty);
                    salesDataObj.remoteEdgingQty = parseNullInt(lensObj.remoteEdgingQty);
                } 
                if(AllSalesDataCY.size() > 0){                    
                    for(Sales_Statistics__c salesStat:AllSalesDataCY){ 
                        if(salesStat.Month__c == (double)i){
                            if(salesStat.Type__c == '3'){
                                salesDataObj.framesGrossSales = parseNull((double)salesStat.Frames_Gross_Sales__c);
                                salesDataObj.framesNetSales = parseNull((double)salesStat.Frames_Net_Sales__c);
                                salesDataObj.framesQty = parseNullInt((Integer)salesStat.Frames_Qty__c);
                            }
                            else if(salesStat.Type__c == '4'){
                                salesDataObj.instrumentsGrossSales = parseNull((double)salesStat.Instrument_Gross_Sales__c);
                                salesDataObj.instrumentsNetSales = parseNull((double)salesStat.Instrument_Net_Sales__c);
                                salesDataObj.instrumentsQty = parseNullInt((Integer)salesStat.Instruments_Qty__c);
                            }
                            else if(salesStat.Type__c == '9'){
                                salesDataObj.contactLensGrossSales = parseNull((double)salesStat.Contact_Lenses_Gross_Sales__c);
                                salesDataObj.contactLensNetSales = parseNull((double)salesStat.Contact_Lenses_Net_Sales__c);
                                salesDataObj.contactLensQty = parseNullInt((Integer)salesStat.Contact_Lenses_Qty__c);
                            }
                            else{
                                salesDataObj.otherGrossSales = parseNull((double)salesStat.Other_Gross_Sales__c);
                                salesDataObj.otherNetSales = parseNull((double)salesStat.Other_Net_Sales__c);
                                salesDataObj.OthersQty = parseNullInt((Integer)salesStat.Other_Qty__c);
                            }
                        } 
                    }
                }
                salesDataObj.totalNetSales=salesDataObj.framesNetSales+salesDataObj.instrumentsNetSales+salesDataObj.otherNetSales+salesDataObj.lensNetSales+salesDataObj.contactLensNetSales;
                salesDataObj.totalGrossSales=salesDataObj.framesGrossSales+salesDataObj.instrumentsGrossSales+salesDataObj.otherGrossSales+salesDataObj.lensGrossSales+salesDataObj.contactLensGrossSales;
                salesDataObj.totalQty=salesDataObj.framesQty+salesDataObj.instrumentsQty+salesDataObj.OthersQty+salesDataObj.lensQty+salesDataObj.contactLensQty;
                             
                MonthlyCYData.put(i,salesDataObj);
                system.debug(MonthlyCYData.size());
            }        
            //prepare the data for Ly
          
            for(Integer i = 1; i <= 12; i++){
                SalesData salesDataObj=new SalesData();                       
                if(MonthlyLYLensMap.containsKey(i)){
                    LensSales lensObj=MonthlyLYLensMap.get(i);
                    salesDataObj.lensNetSales=lensObj.lensNetSales; 
                    salesDataObj.lensGrossSales=lensObj.lensGrossSales;
                    salesDataObj.lensQty=lensObj.lensQty;
                }  
                if(AllSalesDataLY.size() > 0){
                    for(Sales_Statistics__c salesStat:AllSalesDataLY){  
                        if(salesStat.Month__c == (double)i){
                            if(salesStat.Type__c == '3'){
                                salesDataObj.framesGrossSales = parseNull((double)salesStat.Frames_Gross_Sales__c);
                                salesDataObj.framesNetSales = parseNull((double)salesStat.Frames_Net_Sales__c);
                                salesDataObj.framesQty = parseNullInt((Integer)salesStat.Frames_Qty__c);
                            }
                            else if(salesStat.Type__c == '4'){
                                salesDataObj.instrumentsGrossSales = parseNull((double)salesStat.Instrument_Gross_Sales__c);
                                salesDataObj.instrumentsNetSales = parseNull((double)salesStat.Instrument_Net_Sales__c);
                                salesDataObj.instrumentsQty = parseNullInt((Integer)salesStat.Instruments_Qty__c);
                            }
                            else if(salesStat.Type__c == '9'){
                                salesDataObj.contactLensGrossSales = parseNull((double)salesStat.Contact_Lenses_Gross_Sales__c);
                                salesDataObj.contactLensNetSales = parseNull((double)salesStat.Contact_Lenses_Net_Sales__c);
                                salesDataObj.contactLensQty = parseNullInt((Integer)salesStat.Contact_Lenses_Qty__c);
                            }
                            else{
                                salesDataObj.otherGrossSales = parseNull((double)salesStat.Other_Gross_Sales__c);
                                salesDataObj.otherNetSales = parseNull((double)salesStat.Other_Net_Sales__c);
                                salesDataObj.OthersQty = parseNullInt((Integer)salesStat.Other_Qty__c);
                            }
                        }    
                    }
                }
                salesDataObj.totalNetSales=salesDataObj.framesNetSales+salesDataObj.instrumentsNetSales+salesDataObj.otherNetSales+salesDataObj.lensNetSales+salesDataObj.contactLensNetSales;
                salesDataObj.totalGrossSales=salesDataObj.framesGrossSales+salesDataObj.instrumentsGrossSales+salesDataObj.otherGrossSales+salesDataObj.lensGrossSales+salesDataObj.contactLensGrossSales;
                salesDataObj.totalQty=salesDataObj.framesQty+salesDataObj.instrumentsQty+salesDataObj.OthersQty+salesDataObj.lensQty+salesDataObj.contactLensQty;
                
                MonthlyLYData.put(i,salesDataObj);
            } 
            //Filter each month sales
            if(MonthlyCYData.size() > 0){
                if(MonthlyCYData.ContainsKey(4)){                    
                    SalesData data=MonthlyCYData.get(4);                  
                    accountSales.aprSales += data.totalGrossSales ;
                    accountSales.aprNetSales += data.totalNetSales ;
                    accountSales.aprQty += data.totalQty;
                    accountSales.aprLensSales += data.lensGrossSales ;
                    accountSales.aprLensNetSales += data.lensNetSales ;
                    accountSales.aprLensQty += data.lensQty;
                    accountSales.aprFramesSales += data.framesGrossSales ;
                    accountSales.aprFramesNetSales +=  data.framesNetSales ;
                    accountSales.aprFramesQty += data.framesQty;
                    accountSales.aprInstSales += data.instrumentsGrossSales ;
                    accountSales.aprInstNetSales += data.instrumentsNetSales ;
                    accountSales.aprInstQty += data.instrumentsQty;
                    accountSales.aprOtherSales +=  data.otherGrossSales ;
                    accountSales.aprOtherNetSales += data.otherNetSales ;
                    accountSales.aprOtherQty += data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.aprLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.aprFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.aprInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.aprOtherNetSales;
                    accountSales.totalLensSales += accountSales.aprLensSales;
                    accountSales.totalFramesSales += accountSales.aprFramesSales;
                    accountSales.totalInstSales += accountSales.aprInstSales;
                    accountSales.totalOtherSales += accountSales.aprOtherSales;
                    accountSales.totalLensQty += accountSales.aprLensQty;
                    accountSales.totalFramesQty += accountSales.aprFramesQty;
                    accountSales.totalInstQty += accountSales.aprInstQty;
                    accountSales.totalOtherQty += accountSales.aprOtherQty;
                    accountSales.totalSales += accountSales.aprSales ;
                    accountSales.totalNetSales += accountSales.aprNetSales;
                    accountSales.totalQty += accountSales.aprQty;
                    accountSales.aprLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.aprLensremoteEdgeQty;
                  
                }
                if(MonthlyCYData.ContainsKey(5)){
                    SalesData data=MonthlyCYData.get(5);                   
                    accountSales.maySales += data.totalGrossSales ;
                    accountSales.mayNetSales +=  data.totalNetSales ;
                    accountSales.mayQty += data.totalQty;
                    accountSales.mayLensSales +=  data.lensGrossSales ;
                    accountSales.mayLensNetSales += data.lensNetSales ;
                    accountSales.mayLensQty += data.lensQty;
                    accountSales.mayFramesSales += data.framesGrossSales ;
                    accountSales.mayFramesNetSales += data.framesNetSales ;
                    accountSales.mayFramesQty += data.framesQty;
                    accountSales.mayInstSales +=  data.instrumentsGrossSales ;
                    accountSales.mayInstNetSales += data.instrumentsNetSales ;
                    accountSales.mayInstQty += data.instrumentsQty;
                    accountSales.mayOtherSales +=  data.otherGrossSales ;
                    accountSales.mayOtherNetSales += data.otherNetSales ;
                    accountSales.mayOtherQty += data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.mayLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.mayFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.mayInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.mayOtherNetSales;
                    accountSales.totalLensSales += accountSales.mayLensSales;
                    accountSales.totalFramesSales += accountSales.mayFramesSales;
                    accountSales.totalInstSales += accountSales.mayInstSales;
                    accountSales.totalOtherSales += accountSales.mayOtherSales;
                    accountSales.totalLensQty += accountSales.mayLensQty;
                    accountSales.totalFramesQty += accountSales.mayFramesQty;
                    accountSales.totalInstQty += accountSales.mayInstQty;
                    accountSales.totalOtherQty += accountSales.mayOtherQty;
                    accountSales.totalSales +=   accountSales.maySales;
                    accountSales.totalNetSales +=  accountSales.mayNetSales;
                    accountSales.totalQty += accountSales.mayQty;
                    accountSales.mayLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.mayLensremoteEdgeQty;
                }
                if(MonthlyCYData.ContainsKey(6)){
                    SalesData data=MonthlyCYData.get(6);
                    accountSales.junSales += data.totalGrossSales ;
                    accountSales.junNetSales += data.totalNetSales ;
                    accountSales.junQty += data.totalQty;
                    accountSales.junLensSales += data.lensGrossSales ;
                    accountSales.junLensNetSales += data.lensNetSales ;
                    accountSales.junLensQty +=data.lensQty;
                    accountSales.junFramesSales += data.framesGrossSales ;
                    accountSales.junFramesNetSales += data.framesNetSales ;
                    accountSales.junFramesQty += data.framesQty;
                    accountSales.junInstSales +=  data.instrumentsGrossSales ;
                    accountSales.junInstNetSales +=  data.instrumentsNetSales ;
                    accountSales.junInstQty += data.instrumentsQty;
                    accountSales.junOtherSales +=  data.otherGrossSales ;
                    accountSales.junOtherNetSales += data.otherNetSales ;
                    accountSales.junOtherQty += data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.junLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.junFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.junInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.junOtherNetSales;
                    accountSales.totalLensSales += accountSales.junLensSales;
                    accountSales.totalFramesSales += accountSales.junFramesSales;
                    accountSales.totalInstSales += accountSales.junInstSales;
                    accountSales.totalOtherSales += accountSales.junOtherSales;
                    accountSales.totalLensQty += accountSales.junLensQty;
                    accountSales.totalFramesQty += accountSales.junFramesQty;
                    accountSales.totalInstQty += accountSales.junInstQty;
                    accountSales.totalOtherQty += accountSales.junOtherQty;
                    accountSales.totalSales += accountSales.junSales;
                    accountSales.totalNetSales += accountSales.junNetSales;
                    accountSales.totalQty += accountSales.junQty;         
                    accountSales.junLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.junLensremoteEdgeQty;
                }
                if(MonthlyCYData.ContainsKey(7)){
                    SalesData data=MonthlyCYData.get(7);
                    accountSales.julSales +=  data.totalGrossSales ;
                    accountSales.julNetSales += data.totalNetSales ;
                    accountSales.julQty += data.totalQty;
                    accountSales.julLensSales += data.lensGrossSales ;
                    accountSales.julLensNetSales += data.lensNetSales ;
                    accountSales.julLensQty += data.lensQty;
                    accountSales.julFramesSales += data.framesGrossSales ;
                    accountSales.julFramesNetSales += data.framesNetSales ;
                    accountSales.julFramesQty += data.framesQty;
                    accountSales.julInstSales += data.instrumentsGrossSales ;
                    accountSales.julInstNetSales += data.instrumentsNetSales ;
                    accountSales.julInstQty += data.instrumentsQty;
                    accountSales.julOtherSales += data.otherGrossSales ;
                    accountSales.julOtherNetSales += data.otherNetSales ;
                    accountSales.julOtherQty += data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.julLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.julFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.julInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.julOtherNetSales;
                    accountSales.totalLensSales += accountSales.julLensSales;
                    accountSales.totalFramesSales += accountSales.julFramesSales;
                    accountSales.totalInstSales += accountSales.julInstSales;
                    accountSales.totalOtherSales += accountSales.julOtherSales;
                    accountSales.totalLensQty += accountSales.julLensQty;
                    accountSales.totalFramesQty += accountSales.julFramesQty;
                    accountSales.totalInstQty += accountSales.julInstQty;
                    accountSales.totalOtherQty += accountSales.julOtherQty;
                    accountSales.totalSales +=  accountSales.julSales ;
                    accountSales.totalNetSales +=  accountSales.julNetSales ;
                    accountSales.totalQty += accountSales.julQty;
                    accountSales.julLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.julLensremoteEdgeQty;
                }
                if(MonthlyCYData.ContainsKey(8)){
                    SalesData data=MonthlyCYData.get(8);
                    accountSales.augSales +=  data.totalGrossSales ;
                    accountSales.augNetSales +=  data.totalNetSales ;
                    accountSales.augQty += data.totalQty;
                    accountSales.augLensSales += data.lensGrossSales ;
                    accountSales.augLensNetSales += data.lensNetSales ;
                    accountSales.augLensQty +=data.lensQty;
                    accountSales.augFramesSales += data.framesGrossSales ;
                    accountSales.augFramesNetSales += data.framesNetSales ;
                    accountSales.augFramesQty += data.framesQty;
                    accountSales.augInstSales += data.instrumentsGrossSales ;
                    accountSales.augInstNetSales += data.instrumentsNetSales ;
                    accountSales.augInstQty +=data.instrumentsQty;
                    accountSales.augOtherSales += data.otherGrossSales ;
                    accountSales.augOtherNetSales += data.otherNetSales ;
                    accountSales.augOtherQty += data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.augLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.augFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.augInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.augOtherNetSales;
                    accountSales.totalLensSales += accountSales.augLensSales;
                    accountSales.totalFramesSales += accountSales.augFramesSales;
                    accountSales.totalInstSales += accountSales.augInstSales;
                    accountSales.totalOtherSales += accountSales.augOtherSales;
                    accountSales.totalLensQty += accountSales.augLensQty;
                    accountSales.totalFramesQty += accountSales.augFramesQty;
                    accountSales.totalInstQty += accountSales.augInstQty;
                    accountSales.totalOtherQty += accountSales.augOtherQty;
                    accountSales.totalSales +=  accountSales.augSales;
                    accountSales.totalNetSales += accountSales.augNetSales;
                    accountSales.totalQty += accountSales.augQty;
                    accountSales.augLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.augLensremoteEdgeQty;    
                }
                if(MonthlyCYData.ContainsKey(9)){
                    SalesData data=MonthlyCYData.get(9);
                    accountSales.sepSales = accountSales.sepSales + data.totalGrossSales ;
                    accountSales.sepNetSales = accountSales.sepNetSales + data.totalNetSales ;
                    accountSales.sepQty = accountSales.sepQty +data.totalQty;
                    accountSales.sepLensSales = accountSales.sepLensSales + data.lensGrossSales ;
                    accountSales.sepLensNetSales = accountSales.sepLensNetSales + data.lensNetSales ;
                    accountSales.sepLensQty = accountSales.sepLensQty +data.lensQty;
                    accountSales.sepFramesSales = accountSales.sepFramesSales + data.framesGrossSales ;
                    accountSales.sepFramesNetSales = accountSales.sepFramesNetSales + data.framesNetSales ;
                    accountSales.sepFramesQty = accountSales.sepFramesQty +data.framesQty;
                    accountSales.sepInstSales = accountSales.sepInstSales + data.instrumentsGrossSales ;
                    accountSales.sepInstNetSales = accountSales.sepInstNetSales + data.instrumentsNetSales ;
                    accountSales.sepInstQty = accountSales.sepInstQty +data.instrumentsQty;
                    accountSales.sepOtherSales = accountSales.sepOtherSales + data.otherGrossSales ;
                    accountSales.sepOtherNetSales = accountSales.sepOtherNetSales + data.otherNetSales ;
                    accountSales.sepOtherQty = accountSales.sepOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.sepLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.sepFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.sepInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.sepOtherNetSales;
                    accountSales.totalLensSales += accountSales.sepLensSales;
                    accountSales.totalFramesSales += accountSales.sepFramesSales;
                    accountSales.totalInstSales += accountSales.sepInstSales;
                    accountSales.totalOtherSales += accountSales.sepOtherSales;
                    accountSales.totalLensQty += accountSales.sepLensQty;
                    accountSales.totalFramesQty += accountSales.sepFramesQty;
                    accountSales.totalInstQty += accountSales.sepInstQty;
                    accountSales.totalOtherQty += accountSales.sepOtherQty;
                    accountSales.totalSales += accountSales.sepSales;
                    accountSales.totalNetSales +=  accountSales.sepNetSales;
                    accountSales.totalQty += accountSales.sepQty;
                    accountSales.sepLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.sepLensremoteEdgeQty;                      
                }
                if(MonthlyCYData.ContainsKey(10)){
                    SalesData data=MonthlyCYData.get(10);
                    accountSales.octSales = accountSales.octSales + data.totalGrossSales ;
                    accountSales.octNetSales = accountSales.octNetSales + data.totalNetSales ;
                    accountSales.octQty = accountSales.octQty+data.totalQty;
                    accountSales.octLensSales = accountSales.octLensSales + data.lensGrossSales ;
                    accountSales.octLensNetSales = accountSales.octLensNetSales + data.lensNetSales ;
                    accountSales.octLensQty = accountSales.octLensQty +data.lensQty;
                    accountSales.octFramesSales = accountSales.octFramesSales + data.framesGrossSales ;
                    accountSales.octFramesNetSales = accountSales.octFramesNetSales + data.framesNetSales ;
                    accountSales.octFramesQty = accountSales.octFramesQty +data.framesQty;
                    accountSales.octInstSales = accountSales.octInstSales + data.instrumentsGrossSales ;
                    accountSales.octInstNetSales = accountSales.octInstNetSales + data.instrumentsNetSales ;
                    accountSales.octInstQty = accountSales.octInstQty +data.instrumentsQty;
                    accountSales.octOtherSales = accountSales.octOtherSales + data.otherGrossSales ;
                    accountSales.octOtherNetSales = accountSales.octOtherNetSales + data.otherNetSales ;
                    accountSales.octOtherQty = accountSales.octOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.octLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.octFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.octInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.octOtherNetSales;
                    accountSales.totalLensSales += accountSales.octLensSales;
                    accountSales.totalFramesSales += accountSales.octFramesSales;
                    accountSales.totalInstSales += accountSales.octInstSales;
                    accountSales.totalOtherSales += accountSales.octOtherSales;
                    accountSales.totalLensQty += accountSales.octLensQty;
                    accountSales.totalFramesQty += accountSales.octFramesQty;
                    accountSales.totalInstQty += accountSales.octInstQty;
                    accountSales.totalOtherQty += accountSales.octOtherQty;
                    accountSales.totalSales +=  accountSales.octSales;
                    accountSales.totalNetSales +=  accountSales.octNetSales;
                    accountSales.totalQty += accountSales.octQty ;
                    accountSales.octLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.octLensremoteEdgeQty; 
                }
                if(MonthlyCYData.ContainsKey(11)){                  
                    SalesData data=MonthlyCYData.get(11);                  
                    accountSales.novSales = accountSales.novSales + data.totalGrossSales ;
                    accountSales.novNetSales = accountSales.novNetSales + data.totalNetSales ;
                    accountSales.novQty = accountSales.novQty +data.totalQty;
                    accountSales.novLensSales = accountSales.novLensSales + data.lensGrossSales ;
                    accountSales.novLensNetSales = accountSales.novLensNetSales + data.lensNetSales ;
                    accountSales.novLensQty = accountSales.novLensQty +data.lensQty;
                    accountSales.novFramesSales = accountSales.novFramesSales + data.framesGrossSales ;
                    accountSales.novFramesNetSales = accountSales.novFramesNetSales + data.framesNetSales ;
                    accountSales.novFramesQty = accountSales.novFramesQty +data.framesQty;
                    accountSales.novInstSales = accountSales.novInstSales + data.instrumentsGrossSales ;
                    accountSales.novInstNetSales = accountSales.novInstNetSales + data.instrumentsNetSales ;
                    accountSales.novInstQty = accountSales.novInstQty +data.instrumentsQty;
                    accountSales.novOtherSales = accountSales.novOtherSales + data.otherGrossSales ;
                    accountSales.novOtherNetSales = accountSales.novOtherNetSales + data.otherNetSales ;
                    accountSales.novOtherQty = accountSales.novOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.novLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.novFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.novInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.novOtherNetSales;
                    accountSales.totalLensSales += accountSales.novLensSales;
                    accountSales.totalFramesSales += accountSales.novFramesSales;
                    accountSales.totalInstSales += accountSales.novInstSales;
                    accountSales.totalOtherSales += accountSales.novOtherSales;
                    accountSales.totalLensQty += accountSales.novLensQty;
                    accountSales.totalFramesQty += accountSales.novFramesQty;
                    accountSales.totalInstQty += accountSales.novInstQty;
                    accountSales.totalOtherQty += accountSales.novOtherQty;
                    accountSales.totalSales +=  accountSales.novSales;
                    accountSales.totalNetSales +=  accountSales.novNetSales;
                    accountSales.totalQty += accountSales.novQty;
                    accountSales.novLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.novLensremoteEdgeQty; 
                }
                if(MonthlyCYData.ContainsKey(12)){
                    SalesData data=MonthlyCYData.get(12);
                    accountSales.decSales = accountSales.decSales + data.totalGrossSales ;
                    accountSales.decNetSales = accountSales.decNetSales + data.totalNetSales ;
                    accountSales.decQty = accountSales.decQty +data.totalQty;
                    accountSales.decLensSales = accountSales.decLensSales + data.lensGrossSales ;
                    accountSales.decLensNetSales = accountSales.decLensNetSales + data.lensNetSales ;
                    accountSales.decLensQty = accountSales.decLensQty +data.lensQty;
                    accountSales.decFramesSales = accountSales.decFramesSales + data.framesGrossSales ;
                    accountSales.decFramesNetSales = accountSales.decFramesNetSales + data.framesNetSales ;
                    accountSales.decFramesQty = accountSales.decFramesQty +data.framesQty;
                    accountSales.decInstSales = accountSales.decInstSales + data.instrumentsGrossSales ;
                    accountSales.decInstNetSales = accountSales.decInstNetSales + data.instrumentsNetSales ;
                    accountSales.decInstQty = accountSales.decInstQty +data.instrumentsQty;
                    accountSales.decOtherSales = accountSales.decOtherSales + data.otherGrossSales ;
                    accountSales.decOtherNetSales = accountSales.decOtherNetSales + data.otherNetSales ;
                    accountSales.decOtherQty = accountSales.decOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.decLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.decFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.decInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.decOtherNetSales;
                    accountSales.totalLensSales += accountSales.decLensSales;
                    accountSales.totalFramesSales += accountSales.decFramesSales;
                    accountSales.totalInstSales += accountSales.decInstSales;
                    accountSales.totalOtherSales += accountSales.decOtherSales;
                    accountSales.totalLensQty += accountSales.decLensQty;
                    accountSales.totalFramesQty += accountSales.decFramesQty;
                    accountSales.totalInstQty += accountSales.decInstQty;
                    accountSales.totalOtherQty += accountSales.decOtherQty;
                    accountSales.totalSales +=  accountSales.decSales ;
                    accountSales.totalNetSales +=  accountSales.decNetSales ;
                    accountSales.totalQty += accountSales.decQty;
                    accountSales.decLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.decLensremoteEdgeQty;
                }
                if(MonthlyCYData.ContainsKey(1)){
                    SalesData data=MonthlyCYData.get(1);
                    accountSales.janSales = accountSales.janSales + data.totalGrossSales ;
                    accountSales.janNetSales = accountSales.janNetSales + data.totalNetSales ;
                    accountSales.janQty = accountSales.janQty +data.totalQty;
                    accountSales.janLensSales = accountSales.janLensSales + data.lensGrossSales ;
                    accountSales.janLensNetSales = accountSales.janLensNetSales + data.lensNetSales ;
                    accountSales.janLensQty = accountSales.janLensQty +data.lensQty;
                    accountSales.janFramesSales = accountSales.janFramesSales + data.framesGrossSales ;
                    accountSales.janFramesNetSales = accountSales.janFramesNetSales + data.framesNetSales ;
                    accountSales.janFramesQty = accountSales.janFramesQty +data.framesQty;
                    accountSales.janInstSales = accountSales.janInstSales + data.instrumentsGrossSales ;
                    accountSales.janInstNetSales = accountSales.janInstNetSales + data.instrumentsNetSales ;
                    accountSales.janInstQty = accountSales.janInstQty +data.instrumentsQty;
                    accountSales.janOtherSales = accountSales.janOtherSales + data.otherGrossSales ;
                    accountSales.janOtherNetSales = accountSales.janOtherNetSales + data.otherNetSales ;
                    accountSales.janOtherQty = accountSales.janOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.janLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.janFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.janInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.janOtherNetSales;
                    accountSales.totalLensSales += accountSales.janLensSales;
                    accountSales.totalFramesSales += accountSales.janFramesSales;
                    accountSales.totalInstSales += accountSales.janInstSales;
                    accountSales.totalOtherSales += accountSales.janOtherSales;
                    accountSales.totalLensQty += accountSales.janLensQty;
                    accountSales.totalFramesQty += accountSales.janFramesQty;
                    accountSales.totalInstQty += accountSales.janInstQty;
                    accountSales.totalOtherQty += accountSales.janOtherQty;
                    accountSales.totalSales +=  accountSales.janSales;
                    accountSales.totalNetSales +=   accountSales.janNetSales;
                    accountSales.totalQty += accountSales.janQty;
                    accountSales.janLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.janLensremoteEdgeQty;
                }
                if(MonthlyCYData.ContainsKey(2)){
                    SalesData data=MonthlyCYData.get(2);
                    accountSales.febSales = accountSales.febSales + data.totalGrossSales ;
                    accountSales.febNetSales = accountSales.febNetSales + data.totalNetSales ;
                    accountSales.febQty = accountSales.febQty +data.totalQty;
                    accountSales.febLensSales = accountSales.febLensSales + data.lensGrossSales ;
                    accountSales.febLensNetSales = accountSales.febLensNetSales + data.lensNetSales ;
                    accountSales.febLensQty = accountSales.febLensQty +data.lensQty;
                    accountSales.febFramesSales = accountSales.febFramesSales + data.framesGrossSales ;
                    accountSales.febFramesNetSales = accountSales.febFramesNetSales + data.framesNetSales ;
                    accountSales.febFramesQty = accountSales.febFramesQty +data.framesQty;
                    accountSales.febInstSales = accountSales.febInstSales + data.instrumentsGrossSales ;
                    accountSales.febInstNetSales = accountSales.febInstNetSales + data.instrumentsNetSales ;
                    accountSales.febInstQty = accountSales.febInstQty +data.instrumentsQty;
                    accountSales.febOtherSales = accountSales.febOtherSales + data.otherGrossSales ;
                    accountSales.febOtherNetSales = accountSales.febOtherNetSales + data.otherNetSales ;
                    accountSales.febOtherQty = accountSales.febOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.febLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.febFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.febInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.febOtherNetSales;
                    accountSales.totalLensSales += accountSales.febLensSales;
                    accountSales.totalFramesSales += accountSales.febFramesSales;
                    accountSales.totalInstSales += accountSales.febInstSales;
                    accountSales.totalOtherSales += accountSales.febOtherSales;
                    accountSales.totalLensQty += accountSales.febLensQty;
                    accountSales.totalFramesQty += accountSales.febFramesQty;
                    accountSales.totalInstQty += accountSales.febInstQty;
                    accountSales.totalOtherQty += accountSales.febOtherQty;
                    accountSales.totalSales +=   accountSales.febSales;
                    accountSales.totalNetSales +=  accountSales.febNetSales;
                    accountSales.totalQty += accountSales.febQty;
                    accountSales.febLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.febLensremoteEdgeQty;  
                }
                if(MonthlyCYData.ContainsKey(3)){
                    SalesData data=MonthlyCYData.get(3);
                    accountSales.marSales = accountSales.marSales + data.totalGrossSales ;
                    accountSales.marNetSales = accountSales.marNetSales + data.totalNetSales ;
                    accountSales.marQty = accountSales.marQty +data.totalQty;
                    accountSales.marLensSales = accountSales.marLensSales + data.lensGrossSales ;
                    accountSales.marLensNetSales = accountSales.marLensNetSales + data.lensNetSales ;
                    accountSales.marLensQty = accountSales.marLensQty +data.lensQty;
                    accountSales.marFramesSales = accountSales.marFramesSales + data.framesGrossSales ;
                    accountSales.marFramesNetSales = accountSales.marFramesNetSales + data.framesNetSales ;
                    accountSales.marFramesQty = accountSales.marFramesQty +data.framesQty;
                    accountSales.marInstSales = accountSales.marInstSales + data.instrumentsGrossSales ;
                    accountSales.marInstNetSales = accountSales.marInstNetSales + data.instrumentsNetSales ;
                    accountSales.marInstQty = accountSales.marInstQty +data.instrumentsQty;
                    accountSales.marOtherSales = accountSales.marOtherSales + data.otherGrossSales ;
                    accountSales.marOtherNetSales = accountSales.marOtherNetSales + data.otherNetSales ;
                    accountSales.marOtherQty = accountSales.marOtherQty +data.OthersQty;
                    accountSales.totalLensNetSales += accountSales.marLensNetSales;
                    accountSales.totalFramesNetSales += accountSales.marFramesNetSales;
                    accountSales.totalInstNetSales += accountSales.marInstNetSales;
                    accountSales.totalOtherNetSales += accountSales.marOtherNetSales;
                    accountSales.totalLensSales += accountSales.marLensSales;
                    accountSales.totalFramesSales += accountSales.marFramesSales;
                    accountSales.totalInstSales += accountSales.marInstSales;
                    accountSales.totalOtherSales += accountSales.marOtherSales;
                    accountSales.totalLensQty += accountSales.marLensQty;
                    accountSales.totalFramesQty += accountSales.marFramesQty;
                    accountSales.totalInstQty += accountSales.marInstQty;
                    accountSales.totalOtherQty += accountSales.marOtherQty;
                    accountSales.totalSales +=  accountSales.marSales ;
                    accountSales.totalNetSales +=  accountSales.marNetSales;
                    accountSales.totalQty +=  accountSales.marQty ;
                    accountSales.marLensremoteEdgeQty += data.remoteEdgingQty;
                    accountSales.totalLensremoteEdgeQty +=accountSales.marLensremoteEdgeQty;
                }

                }
            //Last Year Sales
            accountSales.aprSalesLY = 0;
            accountSales.maySalesLY = 0;
            accountSales.junSalesLY = 0;
            accountSales.julSalesLY = 0;
            accountSales.augSalesLY = 0;
            accountSales.sepSalesLY = 0;
            accountSales.octSalesLY = 0;
            accountSales.novSalesLY = 0;
            accountSales.decSalesLY = 0;
            accountSales.janSalesLY = 0;
            accountSales.febSalesLY = 0;
            accountSales.marSalesLY = 0;            
            accountSales.totalSalesLYYTD = 0;
            
            accountSales.aprNetSalesLY = 0;
            accountSales.mayNetSalesLY = 0;
            accountSales.junNetSalesLY = 0;
            accountSales.julNetSalesLY = 0;
            accountSales.augNetSalesLY = 0;
            accountSales.sepNetSalesLY = 0;
            accountSales.octNetSalesLY = 0;
            accountSales.novNetSalesLY = 0;
            accountSales.decNetSalesLY = 0;
            accountSales.janNetSalesLY = 0;
            accountSales.febNetSalesLY = 0;
            accountSales.marNetSalesLY = 0;
            accountSales.totalNetSalesLY = 0; 
            accountSales.totalNetSalesLYYTD = 0;
            
            accountSales.aprQtyLY = 0;
            accountSales.mayQtyLY = 0;
            accountSales.junQtyLY = 0;
            accountSales.julQtyLY = 0;
            accountSales.augQtyLY = 0;
            accountSales.sepQtyLY = 0;
            accountSales.octQtyLY = 0;
            accountSales.novQtyLY = 0;
            accountSales.decQtyLY = 0;
            accountSales.janQtyLY = 0;
            accountSales.febQtyLY = 0;
            accountSales.marQtyLY = 0;
        
            accountSales.aprLensesQtyLY = 0;
            accountSales.mayLensesQtyLY = 0;
            accountSales.junLensesQtyLY = 0;
            accountSales.julLensesQtyLY = 0;
            accountSales.augLensesQtyLY = 0;
            accountSales.sepLensesQtyLY = 0;
            accountSales.octLensesQtyLY = 0;
            accountSales.novLensesQtyLY = 0;
            accountSales.decLensesQtyLY = 0;
            accountSales.janLensesQtyLY = 0;
            accountSales.febLensesQtyLY = 0;
            accountSales.marLensesQtyLY = 0;    
        
            accountSales.aprLensNetSalesLY = 0;
            accountSales.mayLensNetSalesLY = 0;
            accountSales.junLensNetSalesLY = 0;
            accountSales.julLensNetSalesLY = 0;
            accountSales.augLensNetSalesLY = 0;
            accountSales.sepLensNetSalesLY = 0;
            accountSales.octLensNetSalesLY = 0;
            accountSales.novLensNetSalesLY = 0;
            accountSales.decLensNetSalesLY = 0;
            accountSales.janLensNetSalesLY = 0;
            accountSales.febLensNetSalesLY = 0;
            accountSales.marLensNetSalesLY = 0;
            
            accountSales.aprLensesSalesLY = 0;
            accountSales.mayLensesSalesLY = 0;
            accountSales.junLensesSalesLY = 0;
            accountSales.julLensesSalesLY = 0;
            accountSales.augLensesSalesLY = 0;
            accountSales.sepLensesSalesLY = 0;
            accountSales.octLensesSalesLY = 0;
            accountSales.novLensesSalesLY = 0;
            accountSales.decLensesSalesLY = 0;
            accountSales.janLensesSalesLY = 0;
            accountSales.febLensesSalesLY = 0;
            accountSales.marLensesSalesLY = 0;
            accountSales.totalLensesSalesLY = 0;
            
            accountSales.lensesAnnualSalesVsLFY = 0;
            accountSales.lensesAnnualQtytrendvsLFY = 0;
            accountSales.lensesSalesCFYvsLFYYTD = 0;
            accountSales.lensesQtyCFYvsLFYYTD = 0;
            accountSales.lensesSales3monthsCFY = 0;
            accountSales.lensesQty3monthsCFY = 0;
            accountSales.lensesSales3monthsLFY = 0;
            accountSales.lensesQty3monthsLFY = 0;
            accountSales.lensesSales3monthsCFYvsLFY = 0;
            accountSales.lensesQty3monthsCFYvsLFY = 0;
            accountSales.janLensremoteEdgeQtyLy = 0;
            accountSales.febLensremoteEdgeQtyLy = 0;
            accountSales.marLensremoteEdgeQtyLy = 0;
            //Loop through MonthlyLYLensMap to get the monthly lens qty and lens sales for ly
            if(MonthlyLYLensMap.size()  >0){
                if(MonthlyLYLensMap.ContainsKey(4)){
                    LensSales sales=MonthlyLYLensMap.get(4);
                    accountSales.aprLensesQtyLY +=sales.lensQty;
                    accountSales.aprLensesSalesLY +=sales.lensGrossSales;
                    accountSales.aprLensNetSalesLY +=sales.lensNetSales;                   
                }
                if(MonthlyLYLensMap.ContainsKey(5)){
                    LensSales sales=MonthlyLYLensMap.get(5);
                    accountSales.mayLensesQtyLY +=sales.lensQty;
                    accountSales.mayLensesSalesLY +=sales.lensGrossSales;
                    accountSales.mayLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(6)){
                    LensSales sales=MonthlyLYLensMap.get(6);
                    accountSales.junLensesQtyLY +=sales.lensQty;
                    accountSales.junLensesSalesLY +=sales.lensGrossSales;
                    accountSales.junLensNetSalesLY +=sales.lensNetSales;  
                }
                if(MonthlyLYLensMap.ContainsKey(7)){
                    LensSales sales=MonthlyLYLensMap.get(7);
                    accountSales.julLensesQtyLY +=sales.lensQty;
                    accountSales.julLensesSalesLY +=sales.lensGrossSales;
                    accountSales.julLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(8)){
                    LensSales sales=MonthlyLYLensMap.get(8);
                    accountSales.augLensesQtyLY +=sales.lensQty;
                    accountSales.augLensesSalesLY +=sales.lensGrossSales;
                    accountSales.augLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(9)){
                    LensSales sales=MonthlyLYLensMap.get(9);
                    accountSales.sepLensesQtyLY +=sales.lensQty;
                    accountSales.sepLensesSalesLY +=sales.lensGrossSales;
                    accountSales.sepLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(10)){
                    LensSales sales=MonthlyLYLensMap.get(10);
                    accountSales.octLensesQtyLY +=sales.lensQty;
                    accountSales.octLensesSalesLY +=sales.lensGrossSales;
                    accountSales.octLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(11)){
                    LensSales sales=MonthlyLYLensMap.get(11);
                    accountSales.novLensesQtyLY +=sales.lensQty;                  
                    accountSales.novLensesSalesLY +=sales.lensGrossSales;
                    accountSales.novLensNetSalesLY +=sales.lensNetSales;
                }
                if(MonthlyLYLensMap.ContainsKey(12)){
                    LensSales sales=MonthlyLYLensMap.get(12);
                    accountSales.decLensesQtyLY +=sales.lensQty;
                    accountSales.decLensesSalesLY +=sales.lensGrossSales;
                    accountSales.decLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(1)){
                    LensSales sales=MonthlyLYLensMap.get(1);
                    accountSales.janLensesQtyLY +=sales.lensQty;
                    accountSales.janLensesSalesLY +=sales.lensGrossSales;
                    accountSales.janLensremoteEdgeQtyLy +=sales.remoteEdgingQty;
                    accountSales.janLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(2)){
                    LensSales sales=MonthlyLYLensMap.get(2);
                    accountSales.febLensesQtyLY +=sales.lensQty;
                    accountSales.febLensesSalesLY +=sales.lensGrossSales;
                    accountSales.febLensremoteEdgeQtyLy +=sales.remoteEdgingQty;
                    accountSales.febLensNetSalesLY +=sales.lensNetSales; 
                }
                if(MonthlyLYLensMap.ContainsKey(3)){
                    LensSales sales=MonthlyLYLensMap.get(3);
                    accountSales.marLensesQtyLY +=sales.lensQty;
                    accountSales.marLensesSalesLY +=sales.lensGrossSales;
                    accountSales.marLensremoteEdgeQtyLy +=sales.remoteEdgingQty;
                    accountSales.marLensNetSalesLY +=sales.lensNetSales; 
                }
            }            
            system.debug(MonthlyLYData);
            if(MonthlyLYData.size() > 0){
                if(MonthlyLYData.ContainsKey(4)){
                    SalesData data=MonthlyLYData.get(4);
                    accountSales.aprSalesLY = accountSales.aprSalesLY + data.totalGrossSales ;
                    accountSales.aprNetSalesLY = accountSales.aprNetSalesLY + data.totalNetSales ;
                    accountSales.aprQtyLY = accountSales.aprQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.aprSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.aprNetSalesLY ;
                    if(month >= 4){
                        accountSales.totalSalesLYYTD +=  accountSales.aprSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.aprNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.aprQtyLY;
                    }                   
                    accountSales.totalQtyLY += accountSales.aprQtyLY;
                }
                if(MonthlyLYData.ContainsKey(5)){
                    SalesData data=MonthlyLYData.get(5);
                    accountSales.maySalesLY = accountSales.maySalesLY + data.totalGrossSales ;
                    accountSales.mayNetSalesLY = accountSales.mayNetSalesLY + data.totalNetSales ;
                    accountSales.mayQtyLY = accountSales.mayQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.maySalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.mayNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.mayQtyLY;
                    if((month > 5 && month <= 12)|| (month >=1 && month <=4)){
                        accountSales.totalSalesLYYTD +=  accountSales.maySalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.mayNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.mayQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(6)){
                    SalesData data=MonthlyLYData.get(6);
                    accountSales.junSalesLY = accountSales.junSalesLY + data.totalGrossSales ;
                    accountSales.junNetSalesLY = accountSales.junNetSalesLY + data.totalNetSales ;
                    accountSales.junQtyLY = accountSales.junQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.junSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.junNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.junQtyLY;
                     if((month > 6 && month <= 12)|| (month >=1 && month <=4)){
                         accountSales.totalSalesLYYTD +=  accountSales.junSalesLY ;
                         accountSales.totalNetSalesLYYTD +=  accountSales.junNetSalesLY ;
                         accountSales.totalQtyLYYTD += accountSales.junQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(7)){
                    SalesData data=MonthlyLYData.get(7);
                    accountSales.julSalesLY = accountSales.julSalesLY + data.totalGrossSales ;
                    accountSales.julNetSalesLY = accountSales.julNetSalesLY + data.totalNetSales ;
                    accountSales.julQtyLY = accountSales.julQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.julSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.julNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.julQtyLY;
                    if((month > 7 && month <= 12)|| (month >=1 && month <=4)){
                        accountSales.totalSalesLYYTD +=  accountSales.julSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.julNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.julQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(8)){
                    SalesData data=MonthlyLYData.get(8);
                    accountSales.augSalesLY = accountSales.augSalesLY + data.totalGrossSales ;
                    accountSales.augNetSalesLY = accountSales.augNetSalesLY + data.totalNetSales ;
                    accountSales.augQtyLY = accountSales.augQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.augSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.augNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.augQtyLY;
                    if((month > 8 && month <= 12)|| (month >= 1 && month <= 4)){
                        accountSales.totalSalesLYYTD +=  accountSales.augSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.augNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.augQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(9)){
                    SalesData data=MonthlyLYData.get(9);
                    accountSales.sepSalesLY = accountSales.sepSalesLY + data.totalGrossSales ;
                    accountSales.sepNetSalesLY = accountSales.sepNetSalesLY + data.totalNetSales ;
                    accountSales.sepQtyLY = accountSales.sepQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.sepSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.sepNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.sepQtyLY;
                    if((month > 9 && month <= 12)|| (month >=1 && month <=4)){
                        accountSales.totalSalesLYYTD +=  accountSales.sepSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.sepNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.sepQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(10)){
                    SalesData data=MonthlyLYData.get(10);
                    accountSales.octSalesLY = accountSales.octSalesLY + data.totalGrossSales ;
                    accountSales.octNetSalesLY = accountSales.octNetSalesLY + data.totalNetSales ;
                    accountSales.octQtyLY = accountSales.octQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.octSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.octNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.octQtyLY;
                    if((month > 10 && month <= 12)|| (month >= 1 && month <= 4)){
                        accountSales.totalSalesLYYTD +=  accountSales.octSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.octNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.octQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(11)){
                    SalesData data=MonthlyLYData.get(11);
                    accountSales.novSalesLY = accountSales.novSalesLY + data.totalGrossSales ;
                    accountSales.novNetSalesLY = accountSales.novNetSalesLY + data.totalNetSales ;
                    accountSales.novQtyLY = accountSales.novQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.novSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.novNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.novQtyLY;
                    if(month == 12 || (month >= 1 && month <= 4)){
                        accountSales.totalSalesLYYTD +=  accountSales.novSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.novNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.novQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(12)){
                    SalesData data=MonthlyLYData.get(12);
                    accountSales.decSalesLY = accountSales.decSalesLY + data.totalGrossSales ;
                    accountSales.decNetSalesLY = accountSales.decNetSalesLY + data.totalNetSales ;
                    accountSales.decQtyLY = accountSales.decQtyLY+data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.decSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.decNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.decQtyLY;
                    if(month >= 1 && month <= 4){
                        accountSales.totalSalesLYYTD +=  accountSales.decSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.decNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.decQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(1)){
                    SalesData data=MonthlyLYData.get(1);
                    accountSales.janSalesLY = accountSales.janSalesLY + data.totalGrossSales ;
                    accountSales.janNetSalesLY = accountSales.janNetSalesLY + data.totalNetSales ;
                    accountSales.janQtyLY = accountSales.janQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.janSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.janNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.janQtyLY;
                    if(month >= 2 && month <= 4){
                        accountSales.totalSalesLYYTD +=  accountSales.janSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.janNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.janQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(2)){
                    SalesData data=MonthlyLYData.get(2);
                    accountSales.febSalesLY = accountSales.febSalesLY + data.totalGrossSales ;
                    accountSales.febNetSalesLY = accountSales.febNetSalesLY + data.totalNetSales ;
                    accountSales.febQtyLY = accountSales.febQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.febSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.febNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.febQtyLY;
                    if(month == 3 || month == 4){
                        accountSales.totalSalesLYYTD +=  accountSales.febSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.febNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.febQtyLY;
                    }
                }
                if(MonthlyLYData.ContainsKey(3)){
                    SalesData data=MonthlyLYData.get(3);
                    accountSales.marSalesLY = accountSales.marSalesLY + data.totalGrossSales ;
                    accountSales.marNetSalesLY = accountSales.marNetSalesLY + data.totalNetSales ;
                    accountSales.marQtyLY = accountSales.marQtyLY +data.totalQty;
                    accountSales.totalSalesLY +=  accountSales.marSalesLY ;
                    accountSales.totalNetSalesLY +=  accountSales.marNetSalesLY ;
                    accountSales.totalQtyLY += accountSales.marQtyLY;
                    if(month == 4){
                        accountSales.totalSalesLYYTD +=  accountSales.marSalesLY ;
                        accountSales.totalNetSalesLYYTD +=  accountSales.marNetSalesLY ;
                        accountSales.totalQtyLYYTD += accountSales.marQtyLY;
                    }
                }                
            }    
            System.debug( accountSales.totalNetSalesLYYTD);
            accountSales.lensesAnnualSales=getLensesAnnualRevenue(accountSales,month);
            accountSales.lensesAnnualQty=getLensesAnnualQuantity(accountSales,month);
            if(accountSales.isGermanyAccount){
                accountSales.totalLensesSalesLY=accountSales.aprLensesSalesLY+ accountSales.mayLensesSalesLY+ accountSales.junLensesSalesLY+accountSales.julLensesSalesLY+accountSales.augLensesSalesLY
                    +accountSales.sepLensesSalesLY+accountSales.octLensesSalesLY+accountSales.novLensesSalesLY+accountSales.decLensesSalesLY+accountSales.janLensesSalesLY+accountSales.febLensesSalesLY+accountSales.marLensesSalesLY;
            }
            else if(accountSales.isSOSAorSONLAccount || accountSales.isOtherCountryAccount){
                   accountSales.totalLensesSalesLY=accountSales.aprLensNetSalesLY+ accountSales.mayLensNetSalesLY+ accountSales.junLensNetSalesLY+accountSales.julLensNetSalesLY+accountSales.augLensNetSalesLY
                    +accountSales.sepLensNetSalesLY+accountSales.octLensNetSalesLY+accountSales.novLensNetSalesLY+accountSales.decLensNetSalesLY+accountSales.janLensNetSalesLY+accountSales.febLensNetSalesLY+accountSales.marLensNetSalesLY;
            }
        
            accountSales.totalLensesQtyLY=accountSales.aprLensesQtyLY+ accountSales.mayLensesQtyLY+ accountSales.junLensesQtyLY+accountSales.julLensesQtyLY+accountSales.augLensesQtyLY
                +accountSales.sepLensesQtyLY+accountSales.octLensesQtyLY+accountSales.novLensesQtyLY+accountSales.decLensesQtyLY+accountSales.janLensesQtyLY+accountSales.febLensesQtyLY+accountSales.marLensesQtyLY;
           
            if(accountSales.totalLensesSalesLY != null && accountSales.totalLensesSalesLY != 0)
                accountSales.lensesAnnualSalesVsLFY=((accountSales.lensesAnnualSales-accountSales.totalLensesSalesLY)/accountSales.totalLensesSalesLY)*100;
            if(accountSales.totalLensesQtyLY != null && accountSales.totalLensesQtyLY != 0)
                accountSales.lensesAnnualQtytrendvsLFY=((accountSales.lensesAnnualQty - accountSales.totalLensesQtyLY)/ accountSales.totalLensesQtyLY)*100;
            if(MonthlyNYLensMap.size()  > 0){
                if(MonthlyNYLensMap.ContainsKey(1)){
                    LensSales sales=MonthlyNYLensMap.get(1);
                    accountSales.janQtyN2 +=sales.lensQty;
                    accountSales.janSalesN2 +=sales.lensGrossSales;
                    accountSales.janNetSalesN2 +=sales.lensNetSales;
                }
                if(MonthlyNYLensMap.ContainsKey(2)){
                    LensSales sales=MonthlyNYLensMap.get(2);
                    accountSales.febQtyN2 +=sales.lensQty;
                    accountSales.febSalesN2 +=sales.lensGrossSales;
                    accountSales.febNetSalesN2 +=sales.lensNetSales;
                }
                if(MonthlyNYLensMap.ContainsKey(3)){
                    LensSales sales=MonthlyNYLensMap.get(3);
                    accountSales.marQtyN2 +=sales.lensQty;
                    accountSales.marSalesN2 +=sales.lensGrossSales;
                    accountSales.marNetSalesN2 +=sales.lensNetSales;
                }
            }
           // accountSales.totalLensNetSalesLFYYTD=getLensesNetSalesYTD_LFY(accountSales,month);
            accountSales.totalLensesSalesLFYYTD=getLensesSalesYTD_LFY(accountSales,month);
            accountSales.totalLensesQtyLFYYTD=getLensesQuantityYTD_LFY(accountSales,month); 
           //needs this to be changed in Production
        	if(accountSales.totalLensesSalesLFYYTD != null && accountSales.totalLensesSalesLFYYTD != 0){
                if(accountSales.isGermanyAccount)
                    accountSales.lensesSalesCFYvsLFYYTD = ((accountSales.totalLensSales- accountSales.totalLensesSalesLFYYTD)/accountSales.totalLensesSalesLFYYTD)*100;
                else{
                    accountSales.lensesSalesCFYvsLFYYTD = ((accountSales.totalLensNetSales- accountSales.totalLensesSalesLFYYTD)/accountSales.totalLensesSalesLFYYTD)*100;
                }
            }
            if(accountSales.totalLensesQtyLFYYTD != null && accountSales.totalLensesQtyLFYYTD != 0)
                accountSales.lensesQtyCFYvsLFYYTD = ((accountSales.totalLensQty-accountSales.totalLensesQtyLFYYTD)/accountSales.totalLensesQtyLFYYTD)*100;       
            
            accountSales.lensesSales3monthsCFY=getLensesSalesLast3Month(accountSales,month);
            accountSales.lensesQty3monthsCFY=getLensesQuantityLast3Month(accountSales,month);
            accountSales.lensesSales3monthsLFY=getLensesSalesLast3MonthLY(accountSales,month);
            accountSales.lensesQty3monthsLFY=getLensesQuantityLast3MonthLY(accountSales,month);
            if(accountSales.lensesSales3monthsLFY != null && accountSales.lensesSales3monthsLFY != 0)
                accountSales.lensesSales3monthsCFYvsLFY=((accountSales.lensesSales3monthsCFY-accountSales.lensesSales3monthsLFY)/accountSales.lensesSales3monthsLFY)*100;
            if( accountSales.lensesQty3monthsLFY != null &&  accountSales.lensesQty3monthsLFY != 0)
                accountSales.lensesQty3monthsCFYvsLFY=((accountSales.lensesQty3monthsCFY- accountSales.lensesQty3monthsLFY)/ accountSales.lensesQty3monthsLFY)*100;
           
           /*Compute Lenses delays before shipment  */ 
        	RxAndStockSales rxSales ;
        	//To avoid null pointer exception while accessing
            for(Integer i=1;i<=12;i++){ 
                if(RxMapCY.size() > 0){
                    if(!RxMapCY.containsKey(i)){
                        rxSales = new RxAndStockSales();
                        RxMapCY.put(i,rxSales);
                    }
                }
                else{
                    rxSales = new RxAndStockSales();
                    RxMapCY.put(i,rxSales);
                }
                if(RxMaplY.size() > 0){
                    if(!RxMaplY.containsKey(i)){
                        rxSales = new RxAndStockSales();
                        RxMaplY.put(i,rxSales);
                    }
                }
                else{
                    rxSales = new RxAndStockSales();
                    RxMaplY.put(i,rxSales);
                }
                if(StockMapCY.size() > 0){
                    if(!StockMapCY.containsKey(i)){
                        rxSales = new RxAndStockSales();
                        StockMapCY.put(i,rxSales);
                    }
                }
                else
                {
                    rxSales = new RxAndStockSales();
                    StockMapCY.put(i,rxSales);
                }
                if(StockMapLY.size() > 0 ){
                    if(!StockMapLY.containsKey(i)){
                        rxSales = new RxAndStockSales();
                        StockMapLY.put(i,rxSales);
                    }
                }
                else{
                    rxSales = new RxAndStockSales();
                    StockMapLY.put(i,rxSales);
                }
            }
            System.debug(RxMapCY.size());
            accountSales.rxShippedSameDay=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,0,'RX');
            accountSales.rxShippedMax1Day=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,1,'RX');
            accountSales.rxShippedMax2Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,2,'RX');
            accountSales.rxShippedMax3Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,3,'RX');
            accountSales.rxShippedMax4Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,4,'RX');
            accountSales.rxShippedMax5Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,5,'RX');
            accountSales.rxShippedMax6Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,6,'RX');
            accountSales.rxShippedMax7Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,7,'RX');
            accountSales.rxShippedMax8Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,8,'RX');
            accountSales.rxShippedMax9Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,9,'RX');
            accountSales.rxShippedMax10Days=(Integer)getLensesDelays(RxMapCY,RxMaplY,month,10,'RX');
            accountSales.stockShippedSameDay=(Integer)getLensesDelays(StockMapCY,StockMapLY,month,0,'STOCK');
            accountSales.stockShippedMax1Day=(Integer)getLensesDelays(StockMapCY,StockMapLY,month,1,'STOCK');
            accountSales.stockShippedMax2Days=(Integer)getLensesDelays(StockMapCY,StockMapLY,month,2,'STOCK');
            accountSales.stockShippedMax3Days=(Integer)getLensesDelays(StockMapCY,StockMapLY,month,3,'STOCK');
            accountSales.stockShippedMax4Days=(Integer)getLensesDelays(StockMapCY,StockMapLY,month,4,'STOCK');
            accountSales.stockShippedMax5Days=(Integer)getLensesDelays(StockMapCY,StockMapLY,month,5,'STOCK');
            
            accountSales.shipmentAvgDelay=getShipmentAvgDelay3Month(RxMapCY,RxMapLY,StockMapCY,StockMapLY,month,'both'); 
            accountSales.shipmentStockAvgDelay=getShipmentAvgDelay3Month(null,null,StockMapCY,StockMapLY,month,'Stock');
            accountSales.shipmentRxAvgDelay=getShipmentAvgDelay3Month(RxMapCY,RxMapLY,null,null,month,'RX'); 
        
            accountSales.lensesSalesForecastCFY=getLensesSalesForecastCFY(accountSales,month);
            accountSales.lensesSalesForecastCFYvsLFY = 0;
            if(accountSales.totalLensesSalesLY != 0)
           		 accountSales.lensesSalesForecastCFYvsLFY=((accountSales.lensesSalesForecastCFY-accountSales.totalLensesSalesLY)/accountSales.totalLensesSalesLY)*100;
            accountSales.lensesForecastvsECPAgreement=0;
            if(ecpAggrement != null && ecpAggrement != 0){                
                   accountSales.lensesForecastvsECPAgreement=(accountSales.lensesSalesForecastCFY/ecpAggrement)*100;
            }
            accountSales.salesLast12Months=getLast12MonthSales(accountSales,month);
        
            //Compute variations for the completed months,make it 0 for coming months
            
            accountSales.aprVariation=getVariationSales(accountSales,4);
            accountSales.mayVariation=getVariationSales(accountSales,5);
            accountSales.junVariation=getVariationSales(accountSales,6);
            accountSales.julVariation=getVariationSales(accountSales,7);
            accountSales.augVariation=getVariationSales(accountSales,8);
            accountSales.sepVariation=getVariationSales(accountSales,9);
            accountSales.octVariation=getVariationSales(accountSales,10);
            accountSales.novVariation=getVariationSales(accountSales,11);
            accountSales.decVariation=getVariationSales(accountSales,12);
            accountSales.JanVariation=getVariationSales(accountSales,1);
            accountSales.FebVariation=getVariationSales(accountSales,2);
            accountSales.MarVariation=getVariationSales(accountSales,3);
            accountSales.TotalVariation=getVariationSales(accountSales,0);
            
            accountSales.aprNetVariation=getVariationNetSales(accountSales,4);
            accountSales.mayNetVariation=getVariationNetSales(accountSales,5);
            accountSales.junNetVariation=getVariationNetSales(accountSales,6);
            accountSales.julNetVariation=getVariationNetSales(accountSales,7);
            accountSales.augNetVariation=getVariationNetSales(accountSales,8);
            accountSales.sepNetVariation=getVariationNetSales(accountSales,9);
            accountSales.octNetVariation=getVariationNetSales(accountSales,10);
            accountSales.novNetVariation=getVariationNetSales(accountSales,11);
            accountSales.decNetVariation=getVariationNetSales(accountSales,12);
            accountSales.janNetVariation=getVariationNetSales(accountSales,1);
            accountSales.febNetVariation=getVariationNetSales(accountSales,2);
            accountSales.marNetVariation=getVariationNetSales(accountSales,3);
            accountSales.totalNetVariation=getVariationNetSales(accountSales,0);
        
            accountSales.aprLensesNetVariation=getVariationLensNetSales(accountSales,4);
            accountSales.mayLensesNetVariation=getVariationLensNetSales(accountSales,5);
            accountSales.junLensesNetVariation=getVariationLensNetSales(accountSales,6);
            accountSales.julLensesNetVariation=getVariationLensNetSales(accountSales,7);
            accountSales.augLensesNetVariation=getVariationLensNetSales(accountSales,8);
            accountSales.sepLensesNetVariation=getVariationLensNetSales(accountSales,9);
            accountSales.octLensesNetVariation=getVariationLensNetSales(accountSales,10);
            accountSales.novLensesNetVariation=getVariationLensNetSales(accountSales,11);
            accountSales.decLensesNetVariation=getVariationLensNetSales(accountSales,12);
            accountSales.janLensesNetVariation=getVariationLensNetSales(accountSales,1);
            accountSales.febLensesNetVariation=getVariationLensNetSales(accountSales,2);
            accountSales.marLensesNetVariation=getVariationLensNetSales(accountSales,3);
            accountSales.totalLensesNetVariation=getVariationLensNetSales(accountSales,0);
        
            accountSales.aprLensesGrossVariation=getVariationLensGrossSales(accountSales,4);
            accountSales.mayLensesGrossVariation=getVariationLensGrossSales(accountSales,5);
            accountSales.junLensesGrossVariation=getVariationLensGrossSales(accountSales,6);
            accountSales.julLensesGrossVariation=getVariationLensGrossSales(accountSales,7);
            accountSales.augLensesGrossVariation=getVariationLensGrossSales(accountSales,8);
            accountSales.sepLensesGrossVariation=getVariationLensGrossSales(accountSales,9);
            accountSales.octLensesGrossVariation=getVariationLensGrossSales(accountSales,10);
            accountSales.novLensesGrossVariation=getVariationLensGrossSales(accountSales,11);
            accountSales.decLensesGrossVariation=getVariationLensGrossSales(accountSales,12);
            accountSales.janLensesGrossVariation=getVariationLensGrossSales(accountSales,1);
            accountSales.febLensesGrossVariation=getVariationLensGrossSales(accountSales,2);
            accountSales.marLensesGrossVariation=getVariationLensGrossSales(accountSales,3);
            accountSales.totalLensesGrossVariation=getVariationLensGrossSales(accountSales,0);
            
            accountSales.aprVariationQty=getVariationQty(accountSales,4);
            accountSales.mayVariationQty=getVariationQty(accountSales,5);
            accountSales.junVariationQty=getVariationQty(accountSales,6);
            accountSales.julVariationQty=getVariationQty(accountSales,7);
            accountSales.augVariationQty=getVariationQty(accountSales,8);
            accountSales.sepVariationQty=getVariationQty(accountSales,9);
            accountSales.octVariationQty=getVariationQty(accountSales,10);
            accountSales.novVariationQty=getVariationQty(accountSales,11);
            accountSales.decVariationQty=getVariationQty(accountSales,12);
            accountSales.janVariationQty=getVariationQty(accountSales,1);
            accountSales.febVariationQty=getVariationQty(accountSales,2);
            accountSales.marVariationQty=getVariationQty(accountSales,3);
            accountSales.totalVariationQty=getVariationQty(accountSales,0);
        
            accountSales.aprLensesVariationQty=getLensesVariationQty(accountSales,4);
            accountSales.mayLensesVariationQty=getLensesVariationQty(accountSales,5);
            accountSales.junLensesVariationQty=getLensesVariationQty(accountSales,6);
            accountSales.julLensesVariationQty=getLensesVariationQty(accountSales,7);
            accountSales.augLensesVariationQty=getLensesVariationQty(accountSales,8);
            accountSales.sepLensesVariationQty=getLensesVariationQty(accountSales,9);
            accountSales.octLensesVariationQty=getLensesVariationQty(accountSales,10);
            accountSales.novLensesVariationQty=getLensesVariationQty(accountSales,11);
            accountSales.decLensesVariationQty=getLensesVariationQty(accountSales,12);
            accountSales.janLensesVariationQty=getLensesVariationQty(accountSales,1);
            accountSales.febLensesVariationQty=getLensesVariationQty(accountSales,2);
            accountSales.marLensesVariationQty=getLensesVariationQty(accountSales,3);
            accountSales.totalLensesVariationQty=getLensesVariationQty(accountSales,0);
            
            double strategicShare = StrategicVal/4;
            double lensSalesLast3Mo = getLast3MoLensSales(accountSales,Month);
            if(strategicShare != null && strategicShare != 0)
            {
                accountSales.shareOfWallet = (lensSalesLast3Mo/strategicShare)*100;
                if(accountSales.shareOfWallet > 100)
                    accountSales.shareOfWallet = 100;
            }
            if(StrategicVal != null && StrategicVal !=0){
                accountSales.sowLast12Mo = (accountSales.lensesAnnualSales/StrategicVal)*100; 
                 if(accountSales.sowLast12Mo > 100)
                    accountSales.sowLast12Mo = 100;
            }
        //Calculate Ordering Habits Json
        AccountSalesStatisticsControllerHelper helper=new AccountSalesStatisticsControllerHelper();
        String orderingHabits=helper.getOrderingHabits(recordId,accountSales.lensesAnnualSales,accountSales.lensesSales3monthsCFY); 
        accountSalesLst=new List<Object>{accountSales,orderingHabits,MonthlyCYData};
        return accountSalesLst;
    }
    
    @AuraEnabled
    public static List<AccountRelatedSales> getRelatedSalesList(Id recordId){
        Boolean isGermanyAccount=false;
        Boolean isSOSAorSONLAccount=false;
        Boolean isOtherCountryAccount=false;
        List<AccountRelatedSales> relatedAccountList =new List<AccountRelatedSales>();       

        try {
            Account me = [select ID, Hoya_Account_ID__c,Shop_country__c,parentId from account where id=:recordId];
            
            if( me.Hoya_Account_ID__c.startsWith('SO4900') ||  me.Hoya_Account_ID__c.startsWith('SO4990'))
                isGermanyAccount=true;
            else if(me.Hoya_Account_ID__c.startsWith('SO2700') || (me.Hoya_Account_ID__c.startsWith('SO3200') && me.Shop_country__c == 'NL') || (me.Hoya_Account_ID__c.startsWith('SO3200') && me.Shop_country__c != 'BE'))
                isSOSAorSONLAccount=true;
            else
               isOtherCountryAccount=true;
             /* search related account sales */          
             Integer year = Date.today().year();
             Integer Currentmonth = Date.today().month();
             if(Test.isRunningTest())
                Currentmonth=testMonth;
             //fiscal year is current year-1 from january to April, year from may to december
             if( Currentmonth <= 4 ){
                 year = year-1;
             }
           
            String parentId = '';
            String hoyaAccId='';
            List<Account> accounts=[select parentId,Hoya_Account_ID__c from account where id=:recordId];
            if(accounts.size() > 0){
                parentId=accounts[0].parentId;
                hoyaAccId=accounts[0].Hoya_Account_ID__c;
            }
            System.debug(parentId);
              /* current account */
            List<AggregateResult> salesLens=[SELECT CALENDAR_MONTH(InvoiceDate__c) month,sum(Lenses_Gross_Sales__c) grossSales,sum(Lenses_Net_Sales__c) netSales,sum(Lenses_Qty__c) lqty
                                                 from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c=:year
                                                 group by CALENDAR_MONTH(InvoiceDate__c)];
            Double totalNetSalesCFY=0;
            Double LensQtyCFY=0;
            String netOrGrossSales='';
            Boolean isNet=false;
            if(isSOSAorSONLAccount || isOtherCountryAccount)
                isNet = true;
            if(isNet)
                netOrGrossSales = 'netSales';
            else
                netOrGrossSales = 'grossSales';
            if(salesLens.size() > 0 ){
                for(AggregateResult ar:salesLens){
                    totalNetSalesCFY+=((double)(ar.get(netOrGrossSales)));
                    LensQtyCFY +=(Double)(ar.get('lqty'));
                }
            }
            List<AggregateResult> salesLensLFY=[SELECT CALENDAR_MONTH(InvoiceDate__c) month,sum(Lenses_Gross_Sales__c) grossSales,sum(Lenses_Net_Sales__c) netSales,sum(Lenses_Qty__c) lqty
                                                 from Sales_Statistics__c where Account__c=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c=:year-1
                                                 group by CALENDAR_MONTH(InvoiceDate__c)];
            Double totalNetSalesLFYYTD=0;
            Double aprNetSales=0;
            Double mayNetSales=0;
            Double junNetSales=0;
            Double julNetSales=0;
            Double augNetSales=0;
            Double sepNetSales=0;
            Double octNetSales=0;
            Double novNetSales=0;
            Double decNetSales=0;
            Double janNetSales=0;
            Double febNetSales=0;
            Double marNetSales=0;   
            
            Double totalQtyLFYYTD=0;
            Double aprQty=0;
            Double mayQty=0;
            Double junQty=0;
            Double julQty=0;
            Double augQty=0;
            Double sepQty=0;
            Double octQty=0;
            Double novQty=0;
            Double decQty=0;
            Double janQty=0;
            Double febQty=0;
            Double marQty=0;   
            
            if(salesLensLFY.size() > 0){
                for(AggregateResult ar:salesLensLFY){
                    if((Integer)ar.get('month') == 4){                    
                        aprNetSales= ((double)(ar.get(netOrGrossSales)));
                        aprQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 5){
                        mayNetSales= ((double)(ar.get(netOrGrossSales)));
                        mayQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 6){
                        junNetSales= ((double)(ar.get(netOrGrossSales)));
                        junQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 7){
                        julNetSales= ((double)(ar.get(netOrGrossSales)));
                        julQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 8){
                        augNetSales= ((double)(ar.get(netOrGrossSales)));
                        augQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 9){
                        sepNetSales= ((double)(ar.get(netOrGrossSales)));
                        sepQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 10){
                        octNetSales= ((double)(ar.get(netOrGrossSales)));
                        octQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 11){
                         novNetSales= ((double)(ar.get(netOrGrossSales)));
                         novQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 12){
                         decNetSales= ((double)(ar.get(netOrGrossSales)));
                         decQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 1){
                        janNetSales= ((double)(ar.get(netOrGrossSales)));
                        janQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 2){
                        febNetSales= ((double)(ar.get(netOrGrossSales)));
                        febQty=(Double)(ar.get('lQty'));
                    }
                    if((Integer)ar.get('month') == 3){
                         marNetSales= ((double)(ar.get(netOrGrossSales)));
                         marQty=(Double)(ar.get('lQty'));
                    }
                    switch on Currentmonth {
                        when  1{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales+octNetSales+novNetSales+decNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty+octQty+novQty+decQty;
                        }
                        when  2{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales+octNetSales+novNetSales+decNetSales+janNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty+octQty+novQty+decQty+janQty;
                        }
                        when  3{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales+octNetSales+novNetSales+decNetSales+janNetSales+febNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty+octQty+novQty+decQty+janQty+febQty;
                        }
                        when  4{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales+octNetSales+novNetSales+decNetSales+janNetSales+febNetSales+marNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty+octQty+novQty+decQty+janQty+febQty+marQty;  
                        }
                        when  5{
                            totalNetSalesLFYYTD = aprNetSales;
                            totalQtyLFYYTD = aprQty;
                        }
                        when  6{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales;
                            totalQtyLFYYTD = aprQty+mayQty;
                        }
                        when  7{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty;
                        }
                        when  8{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty;
                        }
                        when  9{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty;
                        }
                        when  10{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty;
                        }
                        when  11{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales+octNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty+octQty;
                        }
                        when  12{
                            totalNetSalesLFYYTD = aprNetSales+mayNetSales+junNetSales+julNetSales+augNetSales+sepNetSales+octNetSales+novNetSales;
                            totalQtyLFYYTD = aprQty+mayQty+junQty+julQty+augQty+sepQty+octQty+novQty;
                        }
                        when else {
                            totalNetSalesLFYYTD = 0;
                            totalQtyLFYYTD = 0;
                        }
                    }
                }
            }
            AccountRelatedSales Currentaccount=new AccountRelatedSales();
            Currentaccount.AccountId=recordId;
            Currentaccount.hoyaAccountId=hoyaAccId;
            Currentaccount.netSalesCFY=totalNetSalesCFY;
            Currentaccount.netSalesLFYYTD=totalNetSalesLFYYTD;
            Currentaccount.variationSales=0;
            if(Currentaccount.netSalesLFYYTD != 0)
             Currentaccount.variationSales=(( Currentaccount.netSalesCFY- Currentaccount.netSalesLFYYTD)/ Currentaccount.netSalesLFYYTD)*100;
            Currentaccount.volumesCFY=LensQtyCFY;
            Currentaccount.volumesLFYYTD=totalQtyLFYYTD;
            Currentaccount.variationVolumes=0;
            if(Currentaccount.volumesLFYYTD != 0)
                Currentaccount.variationVolumes =((LensQtyCFY-Currentaccount.volumesLFYYTD)/Currentaccount.volumesLFYYTD)*100;
            relatedAccountList.add(Currentaccount);
            
             /* Childrens of current account */
            System.debug('XXXX compute child data ');
            List<Account> accs=[select id,Hoya_Account_ID__c from account where parentid=:recordId];
            List<Id> childAccIdsList=new List<Id>();
            Set<Id> childAccIds=new set<Id>();
            Map<Id,String> hoyaAccIdMap=new Map<Id,String>();
            if(accs.size() > 0){
                for(Account acc:accs){
                    childAccIdsList.add(acc.Id);
                    hoyaAccIdMap.put(acc.Id,acc.Hoya_Account_ID__c);
                }
                
                childAccIdsList.sort();
                childAccIds.addAll(childAccIdsList);
                system.debug(childAccIds);
                List<AggregateResult> childLensSalesCFY=[SELECT Account__c,CALENDAR_MONTH(InvoiceDate__c) month,sum(Lenses_Gross_Sales__c) grossSales,sum(Lenses_Net_Sales__c) netSales,sum(Lenses_Qty__c) lqty
                                                         from Sales_Statistics__c where Account__c in (select id from account where parentid=:recordId) and (Type__c='0' OR Type__c='1') and Fiscal_Year__c=:year
                                                         group by Account__c,CALENDAR_MONTH(InvoiceDate__c) order by Account__c asc];
                Map<Id,List<Double>> CFYMap=new Map<Id,List<Double>>();
                List<Double> CFYList;
                if(childLensSalesCFY.size() > 0 && childAccIds.size() > 0){
                    for(Id childId:childAccIds){
                        Double totalChildNetSalesCFY=0;
                        Double LensChildQtyCFY=0;
                        for(AggregateResult ar:childLensSalesCFY){
                            if(childId == (Id)ar.get('Account__c')){
                                totalChildNetSalesCFY +=((double)(ar.get(netOrGrossSales)));
                                LensChildQtyCFY += (Double)(ar.get('lqty'));
                            }    
                        }
                        CFYList=new Double[2];
                        CFYList.add(0,totalChildNetSalesCFY);
                        CFYList.add(1,LensChildQtyCFY);
                        CFYMap.put(childId,CFYList); 
                    }
                }
                List<AggregateResult> childLensSalesLFY=[SELECT Account__c,CALENDAR_MONTH(InvoiceDate__c) month,sum(Lenses_Gross_Sales__c) grossSales,sum(Lenses_Net_Sales__c) netSales,sum(Lenses_Qty__c) lqty
                                                         from Sales_Statistics__c where Account__c in (select id from account where parentid=:recordId) and (Type__c='0' OR Type__c='1') and Fiscal_Year__c=:year-1
                                                         group by Account__c,CALENDAR_MONTH(InvoiceDate__c) order by Account__c asc];
                List<Double> childSalesList;
                Map<Id,List<Double>> ChildLFYMap=new Map<Id,List<Double>>();
                if(childLensSalesLFY.size() > 0 && childAccIds.size() > 0){
                    for(Id childId:childAccIds){
                        Double AprChildNetSales=0;
                        Double MayChildNetSales=0;
                        Double JunChildNetSales=0;
                        Double JulChildNetSales=0;
                        Double AugChildNetSales=0;
                        Double SepChildNetSales=0;
                        Double OctChildNetSales=0;
                        Double NovChildNetSales=0;
                        Double DecChildNetSales=0;
                        Double JanChildNetSales=0;
                        Double FebChildNetSales=0;
                        Double MarChildNetSales=0; 
                        Double AprChildQty=0;
                        Double MayChildQty=0;
                        Double JunChildQty=0;
                        Double JulChildQty=0;
                        Double AugChildQty=0;
                        Double SepChildQty=0;
                        Double OctChildQty=0;
                        Double NovChildQty=0;
                        Double DecChildQty=0;
                        Double JanChildQty=0;
                        Double FebChildQty=0;
                        Double MarChildQty=0;
                        Double totalChildNetSalesLFYYTD=0;
                        Double totalChildQtyLFYYTD=0;
                        Boolean isAccSame=false;
                        for(AggregateResult ar:childLensSalesLFY){
                            if(childId == (Id)ar.get('Account__c')){  
                                if((Integer)ar.get('month') == 4)
                                {
                                    AprChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    AprChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 5){
                                    MayChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    MayChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 6){
                                    JunChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    JunChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 7){
                                    JulChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    JulChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 8){
                                    AugChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    AugChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 9){
                                    SepChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    SepChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 10){
                                    OctChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    OctChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 11){
                                    NovChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    NovChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 12){
                                    DecChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    DecChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 1){
                                    JanChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    JanChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 2){
                                    FebChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    FebChildQty=(Double)(ar.get('lQty'));
                                }
                                else if((Integer)ar.get('month') == 3){
                                    MarChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                    MarChildQty=(Double)(ar.get('lQty'));
                                }
                            }
                            
                            switch on Currentmonth {
                                when  1{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty;
                                }
                                when  2{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales+JanChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty+JanChildQty;
                                }
                                when  3{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales+JanChildNetSales+FebChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty+JanChildQty+FebChildQty;
                                }
                                when  4{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales+JanChildNetSales+FebChildNetSales+MarChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty+JanChildQty+FebChildQty+marChildQty;
                                }
                                when  5{
                                    totalChildNetSalesLFYYTD = AprChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty;
                                }
                                when  6{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty;
                                }
                                when  7{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty;
                                }
                                when  8{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty;
                                }
                                when  9{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty;
                                }
                                when  10{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty;
                                }
                                when  11{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty;
                                }
                                when  12{
                                    totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales;
                                    totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty;
                                }
                                when else {
                                    totalChildNetSalesLFYYTD = 0;
                                    totalChildQtyLFYYTD = 0;
                                }
                            }
                            childSalesList= new Double[2];
                            childSalesList.add(0,totalChildNetSalesLFYYTD);
                            childSalesList.add(1,totalChildQtyLFYYTD);
                            ChildLFYMap.put(childId,childSalesList);                           
                        }
                    }
                }
                system.debug(childAccIds);
                if(childAccIds.size() > 0){
                    for(Id childId:childAccIds){
                        AccountRelatedSales Childaccount=new AccountRelatedSales();
                        if(CFYMap.size() > 0)
                        {
                            List<double> netSalesList=CFYMap.get(childId);
                            if(netSalesList[0] > 0)
                                Childaccount.netSalesCFY=netSalesList[0];
                            else
                                Childaccount.netSalesCFY=0;
                            if(netSalesList[1] > 0)
                                Childaccount.volumesCFY=netSalesList[1];
                            else
                                Childaccount.volumesCFY=0; 
                        }
                        else{
                            Childaccount.netSalesCFY=0;
                            Childaccount.volumesCFY=0;
                        }
                        Childaccount.AccountId=childId;
                        Childaccount.hoyaAccountId=hoyaAccIdMap.get(childId);
                        Childaccount.netSalesLFYYTD=0;
                        Childaccount.variationSales=0;
                        Childaccount.variationVolumes=0;
                        Childaccount.volumesLFYYTD=0;
                        if(ChildLFYMap.size() > 0){
                            if(ChildLFYMap.containsKey(childId)){
                                Childaccount.netSalesLFYYTD=ChildLFYMap.get(childId)[0];                   
                                if( Childaccount.netSalesLFYYTD != 0)
                                    Childaccount.variationSales = ((Childaccount.netSalesCFY- Childaccount.netSalesLFYYTD)/ Childaccount.netSalesLFYYTD)*100;
                                Childaccount.volumesLFYYTD = ChildLFYMap.get(childId)[1]; 
                                if(Childaccount.volumesLFYYTD != 0)
                                    Childaccount.variationVolumes =((Childaccount.volumesCFY-Childaccount.volumesLFYYTD)/Childaccount.volumesLFYYTD)*100;
                            }
                        }
                        relatedAccountList.add(Childaccount);
                    }
                }
            }
           /* Brothers of current account */
            if(parentId != null){
                List<Account> idList = [select id,Hoya_Account_ID__c from account where parentid=:parentId or id=:parentId];
                Set<Id> relatedIds = new Set<Id>();
                Map<Id,String> hoyaAccountIdMap=new Map<Id,String>();
                if(idList.size() > 0){
                    for(Account acc:idList){
                        if(acc.Id != recordId)
                            relatedIds.add(acc.Id);
                        hoyaAccountIdMap.put(acc.Id,acc.Hoya_Account_ID__c);
                    }   
                }
                    system.debug(relatedIds);
                //Set<Id> relatedIds = new Set<Id>(new Map<Id, Account>(idList).keySet()); 
                if(relatedIds.size() > 0){
                    List<AggregateResult> relatedLensSalesCFY=[SELECT Account__c,CALENDAR_MONTH(InvoiceDate__c) month,sum(Lenses_Gross_Sales__c) grossSales,sum(Lenses_Net_Sales__c) netSales,sum(Lenses_Qty__c) lqty
                                                               from Sales_Statistics__c where Account__c in :relatedIds and Account__c!=:recordId and Fiscal_Year__c=:year
                                                               group by Account__c,CALENDAR_MONTH(InvoiceDate__c) order by Account__c desc];
                    double relatedNetSalesCFY = 0;
                    Double relatedQtyCFY = 0;
                    List<Double> relatedSalesLst;
                    Map<Id,List<Double>> relatedSalesCFY=new Map<Id,List<Double>>();
                    if(relatedLensSalesCFY.size() > 0 && relatedIds.size() > 0) {
                        for(Id relatedId:relatedIds){                     
                            for(AggregateResult ar:relatedLensSalesCFY){
                                if(relatedId == (Id)ar.get('Account__c')){
                                    relatedNetSalesCFY +=((double)ar.get(netOrGrossSales));
                                    relatedQtyCFY +=(Double)ar.get('lqty');
                                }  
                            }
                            relatedSalesLst=new Double[2];
                            relatedSalesLst.add(0,relatedNetSalesCFY);
                            relatedSalesLst.add(1,relatedQtyCFY);
                            relatedSalesCFY.put(relatedId,relatedSalesLst);                       
                        }
                    } 
                    List<AggregateResult> relatedLensSalesLFY=[SELECT Account__c,CALENDAR_MONTH(InvoiceDate__c) month,sum(Lenses_Gross_Sales__c) grossSales,sum(Lenses_Net_Sales__c) netSales,sum(Lenses_Qty__c) lqty
                                                               from Sales_Statistics__c where Account__c in :relatedIds and Account__c !=:recordId and (Type__c='0' OR Type__c='1') and Fiscal_Year__c=:year-1
                                                               group by Account__c,CALENDAR_MONTH(InvoiceDate__c) order by Account__c desc];
                    Map<Id,List<Double>> relatedSalesLFY=new Map<Id,List<Double>>();
                    List<double> LFYList;
                    if(relatedLensSalesLFY.size() > 0 && relatedIds.size() > 0) {
                        for(Id relatedId:relatedIds){
                            Double AprChildNetSales=0;
                            Double MayChildNetSales=0;
                            Double JunChildNetSales=0;
                            Double JulChildNetSales=0;
                            Double AugChildNetSales=0;
                            Double SepChildNetSales=0;
                            Double OctChildNetSales=0;
                            Double NovChildNetSales=0;
                            Double DecChildNetSales=0;
                            Double JanChildNetSales=0;
                            Double FebChildNetSales=0;
                            Double MarChildNetSales=0; 
                            Double AprChildQty=0;
                            Double MayChildQty=0;
                            Double JunChildQty=0;
                            Double JulChildQty=0;
                            Double AugChildQty=0;
                            Double SepChildQty=0;
                            Double OctChildQty=0;
                            Double NovChildQty=0;
                            Double DecChildQty=0;
                            Double JanChildQty=0;
                            Double FebChildQty=0;
                            Double MarChildQty=0;
                            Double totalChildNetSalesLFYYTD=0;
                            Double totalChildQtyLFYYTD=0;
                            for(AggregateResult ar:relatedLensSalesLFY){
                                if(relatedId == (Id)ar.get('Account__c')){  
                                    if((Integer)ar.get('month') == 4)
                                    {
                                        AprChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        AprChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 5){
                                        MayChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        MayChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 6){
                                        JunChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        JunChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 7){
                                        JulChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        JulChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 8){
                                        AugChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        AugChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 9){
                                        SepChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        SepChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 10){
                                        OctChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        OctChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 11){
                                        NovChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        NovChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 12){
                                        DecChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        DecChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 1){
                                        JanChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        JanChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 2){
                                        FebChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        FebChildQty=(Double)(ar.get('lQty'));
                                    }
                                    else if((Integer)ar.get('month') == 3){
                                        MarChildNetSales= ((double)(ar.get(netOrGrossSales)));
                                        MarChildQty=(Double)(ar.get('lQty'));
                                    }
                                }                      
                                switch on Currentmonth {
                                    when  1{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty;
                                    }
                                    when  2{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales+JanChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty+JanChildQty;
                                    }
                                    when  3{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales+JanChildNetSales+FebChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty+JanChildQty+FebChildQty;
                                    }
                                    when  4{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales+DecChildNetSales+JanChildNetSales+FebChildNetSales+MarChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty+DecChildQty+JanChildQty+FebChildQty+MarChildQty;
                                    }
                                    when  5{
                                        totalChildNetSalesLFYYTD = AprChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty;
                                    }
                                    when  6{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty;
                                    }
                                    when  7{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty;
                                    }
                                    when  8{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty;
                                    }
                                    when  9{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty;
                                    }
                                    when  10{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty;
                                    }
                                    when  11{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty;
                                    }
                                    when  12{
                                        totalChildNetSalesLFYYTD = AprChildNetSales+MayChildNetSales+JunChildNetSales+JulChildNetSales+AugChildNetSales+SepChildNetSales+OctChildNetSales+NovChildNetSales;
                                        totalChildQtyLFYYTD = AprChildQty+MayChildQty+JunChildQty+JulChildQty+AugChildQty+SepChildQty+OctChildQty+NovChildQty;
                                    }
                                    when else {
                                        totalChildNetSalesLFYYTD = 0;
                                        totalChildQtyLFYYTD = 0;
                                    }
                                }
                                LFYList= new Double[2];
                                LFYList.add(0,totalChildNetSalesLFYYTD);
                                LFYList.add(1,totalChildQtyLFYYTD);
                                relatedSalesLFY.put(relatedId,LFYList);
                            }    
                        }                   
                    }
                    for(Id relatedId:relatedIds){ 
                        AccountRelatedSales relatedAccount=new AccountRelatedSales();
                        if(relatedSalesCFY.size() > 0)
                        {
                            List<Double> netSalesList=relatedSalesCFY.get(relatedId);
                            relatedAccount.netSalesCFY=netSalesList[0];
                            relatedAccount.volumesCFY=netSalesList[1];
                        }
                        else{
                            relatedAccount.netSalesCFY=0;
                            relatedAccount.volumesCFY=0;
                        }
                        relatedAccount.AccountId=relatedId;
                        if(hoyaAccountIdMap.size() > 0 && hoyaAccountIdMap.containsKey(relatedId))
                            relatedAccount.hoyaAccountId=hoyaAccountIdMap.get(relatedId);
                        else
                            relatedAccount.hoyaAccountId='';
                        relatedAccount.variationSales=0;
                        relatedAccount.variationVolumes=0;
                        relatedAccount.volumesLFYYTD=0;
                        relatedAccount.netSalesLFYYTD=0;
                        if(relatedSalesLFY.size() > 0){
                            if(relatedSalesLFY.containsKey(relatedId))
                            {
                                if(relatedSalesLFY.get(relatedId)[0] != 0)
                                    relatedAccount.netSalesLFYYTD=relatedSalesLFY.get(relatedId)[0];                       
                                if(relatedAccount.netSalesLFYYTD != 0)
                                    relatedAccount.variationSales=((relatedAccount.netSalesCFY-relatedAccount.netSalesLFYYTD)/relatedAccount.netSalesLFYYTD)*100;
                                relatedAccount.volumesLFYYTD=relatedSalesLFY.get(relatedId)[1]; 
                                if(relatedAccount.volumesLFYYTD != 0)
                                    relatedAccount.variationVolumes =((relatedAccount.volumesCFY-relatedAccount.volumesLFYYTD)/relatedAccount.volumesLFYYTD)*100;
                            }
                        }
                        relatedAccountList.add(relatedAccount);
                        system.debug(relatedAccountList);
                    }
                }
                
            }          
            
        } catch (Exception e) {
            LogException.log(e);
        }
        return relatedAccountList;
    } 
    
    public static Double parseNull(Double num){
        Double result=0;
        if(num == null)
            result =0.0;
        else
           result=num;
        return result;            
    }
    public static Integer parseNullInt(Integer num){
        Integer result=0;
        if(num == null)
            result =0;
        else
           result=num;       
        return result;            
    }
    public static decimal getLast3MoLensSales(AccountSales a,Integer month){
        double result = 0;
        try{
            if(a.isGermanyAccount){
                switch on month {
                    when  1{result = a.octLensSales+a.novLensSales+a.decLensSales;}
                    when  2{result = a.novLensSales+a.decLensSales+a.janLensSales;}
                    when  3{result = a.decLensSales+a.janLensSales+a.febLensSales;}
                    when  4{result = a.janLensSales+a.febLensSales+a.marLensSales;}
                    when  5{result = a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales;}
                    when  6{result = a.marLensesSalesLY+a.aprLensSales+a.mayLensSales;}
                    when  7{result = a.aprLensSales+a.mayLensSales+a.junLensSales;}
                    when  8{result = a.mayLensSales+a.junLensSales+a.julLensSales;}
                    when  9{result = a.junLensSales+a.julLensSales+a.augLensSales;}
                    when  10{result = a.julLensSales+a.augLensSales+a.sepLensSales;}
                    when  11{result = a.augLensSales+a.sepLensSales+a.octLensSales;}
                    when  12{result = a.sepLensSales+a.octLensSales+a.novLensSales;}
                    when else {result=0;}
                }
            }
            else if(a.isSOSAorSONLAccount || a.isOtherCountryAccount){
                switch on month {
                    when  1{result = a.octLensNetSales+a.novLensNetSales+a.decLensNetSales;}
                    when  2{result = a.novLensNetSales+a.decLensNetSales+a.janLensNetSales;}
                    when  3{result = a.decLensNetSales+a.janLensNetSales+a.febLensNetSales;}
                    when  4{result = a.janLensNetSales+a.febLensNetSales+a.marLensNetSales;}
                    when  5{result = a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales ;}
                    when  6{result = a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales;}
                    when  7{result = a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales;}
                    when  8{result = a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales;}
                    when  9{result = a.junLensNetSales+a.julLensNetSales+a.augLensNetSales;}
                    when  10{result = a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales;}
                    when  11{result = a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales;}
                    when else {result=0;}
                }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        } 
        return result;
    }
    public static decimal getLast12MonthSales(AccountSales a,Integer month){
        Decimal result=0;
          try{
              if(a.isGermanyAccount){
                  switch on month {                
                      when  1{
                          result = a.decLensSales+a.novLensSales+a.octLensSales+a.sepLensSales+a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY;
                      }
                      when  2{
                          result = a.janLensSales+a.decLensSales+a.novLensSales+a.octLensSales+a.sepLensSales+a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY;
                      }
                      when  3{
                          result = a.febLensSales+a.janLensSales+a.decLensSales+a.novLensSales+a.octLensSales+a.sepLensSales+a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY;
                      }
                      when  4{
                          result = a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY+a.sepLensesSalesLY+a.augLensesSalesLY+a.julLensesSalesLY+a.junLensesSalesLY+a.mayLensesSalesLY+a.aprLensesSalesLY;
                      }
                      when  5{
                          result = a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY+a.sepLensesSalesLY+a.augLensesSalesLY+a.julLensesSalesLY+a.junLensesSalesLY+a.mayLensesSalesLY;
                      }
                      when  6{
                          result = a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY+a.sepLensesSalesLY+a.augLensesSalesLY+a.julLensesSalesLY+a.junLensesSalesLY;
                      }
                      when  7{
                          result = a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY+a.sepLensesSalesLY+a.augLensesSalesLY+a.julLensesSalesLY;
                      }
                      when  8{
                          result = a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY+a.sepLensesSalesLY+a.augLensesSalesLY;
                      }
                      when  9{
                          result = a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY+a.sepLensesSalesLY;
                      }
                      when  10{
                          result =a.sepLensSales+a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY+a.octLensesSalesLY;
                      }
                      when  11{
                          result =a.octLensSales+a.sepLensSales+a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY+a.novLensesSalesLY;
                      }
                      when  12{
                          result =a.novLensSales+a.octLensSales+a.sepLensSales+a.augLensSales+a.julLensSales+a.junLensSales+a.mayLensSales+a.aprLensSales+a.marLensesSalesLY+a.febLensesSalesLY+a.janLensesSalesLY+a.decLensesSalesLY;
                      }
                      when else {result=0;}
                  }
              }
              else{
                  switch on month {                
                      when  1{
                          result = a.decLensNetSales+a.novLensNetSales+a.octLensNetSales+a.sepLensNetSales+a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY;
                      }
                      when  2{
                          result = a.janLensNetSales+a.decLensNetSales+a.novLensNetSales+a.octLensNetSales+a.sepLensNetSales+a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY;
                      }
                      when  3{
                          result = a.febLensNetSales+a.janLensNetSales+a.decLensNetSales+a.novLensNetSales+a.octLensNetSales+a.sepLensNetSales+a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY;
                      }
                      when  4{
                          result = a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY+a.sepLensNetSalesLY+a.augLensNetSalesLY+a.julLensNetSalesLY+a.junLensNetSalesLY+a.mayLensNetSalesLY+a.aprLensNetSalesLY;
                      }
                      when  5{
                          result = a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY+a.sepLensNetSalesLY+a.augLensNetSalesLY+a.julLensNetSalesLY+a.junLensNetSalesLY+a.mayLensNetSalesLY;
                      }
                      when  6{
                          result = a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY+a.sepLensNetSalesLY+a.augLensNetSalesLY+a.julLensNetSalesLY+a.junLensNetSalesLY;
                      }
                      when  7{
                          result = a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY+a.sepLensNetSalesLY+a.augLensNetSalesLY+a.julLensNetSalesLY;
                      }
                      when  8{
                          result = a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY+a.sepLensNetSalesLY+a.augLensNetSalesLY;
                      }
                      when  9{
                          result = a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY+a.sepLensNetSalesLY;
                      }
                      when  10{
                          result =a.sepLensNetSales+a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY+a.octLensNetSalesLY;
                      }
                      when  11{
                          result =a.octLensNetSales+a.sepLensNetSales+a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY+a.novLensNetSalesLY;
                      }
                      when  12{
                          result =a.novLensNetSales+a.octLensNetSales+a.sepLensNetSales+a.augLensNetSales+a.julLensNetSales+a.junLensNetSales+a.mayLensNetSales+a.aprLensNetSales+a.marLensNetSalesLY+a.febLensNetSalesLY+a.janLensNetSalesLY+a.decLensNetSalesLY;
                      }
                      when else {result=0;}
                  }
              }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        
        return result;
    }   
    public static double getLensesSalesForecastCFY(AccountSales a,Integer month){       
        double result=0;
        double totalLensSalesCFY=0;
        double remainingMonthLFY=0;
       
        try{   
            if(a.isGermanyAccount){
                totalLensSalesCFY=a.totalLensSales;
                switch on month {               
                    when  1{remainingMonthLFY = a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}               
                    when  2{remainingMonthLFY = a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  3{remainingMonthLFY = a.marLensesSalesLY;}
                    when  4{remainingMonthLFY = 0;}
                    when  5{remainingMonthLFY = a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  6{remainingMonthLFY = a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  7{remainingMonthLFY = a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  8{remainingMonthLFY = a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  9{remainingMonthLFY = a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  10{remainingMonthLFY = a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  11{remainingMonthLFY = a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  12{remainingMonthLFY = a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when else {remainingMonthLFY=0;}
                }                 
            }
            else if(a.isSOSAorSONLAccount || a.isOtherCountryAccount){
                totalLensSalesCFY=a.totalLensNetSales;
                switch on month {               
                    when  1{remainingMonthLFY = a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}               
                    when  2{remainingMonthLFY = a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  3{remainingMonthLFY = a.marLensNetSalesLY;}
                    when  4{remainingMonthLFY = 0;}
                    when  5{remainingMonthLFY = a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  6{remainingMonthLFY = a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  7{remainingMonthLFY = a.julLensNetSalesLY+a.augLensesSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  8{remainingMonthLFY = a.augLensesSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  9{remainingMonthLFY = a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  10{remainingMonthLFY = a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  11{remainingMonthLFY = a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  12{remainingMonthLFY = a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when else {remainingMonthLFY=0;}
                } 
            }
            result=totalLensSalesCFY+(remainingMonthLFY*(1+(a.lensesSales3monthsCFYvsLFY/100)));
            
        }
        catch (Exception e) {
            LogException.log(e);
        }        
        return result;
    }
      //variation for total gross sales
    public static Double getVariationSales(AccountSales a,Integer Month){
        Double result=0;
          try{
            switch on month {
                when  0{
                    if(a.totalSales > 0 && a.totalSalesLYYTD != null && a.totalSalesLYYTD != 0)
                        result = ((a.totalSales-a.totalSalesLYYTD)/a.totalSalesLYYTD)*100;
                }
                when  1{
                    if(a.janSales > 0 && a.janSalesLY != null && a.janSalesLY != 0)
                        result = ((a.janSales-a.janSalesLY)/a.janSalesLY)*100;
                }
                when  2{
                    if(a.febSales > 0 && a.febSalesLY != null && a.febSalesLY != 0)
                        result = ((a.febSales-a.febSalesLY)/a.febSalesLY)*100;
                }
                when  3{
                    if( a.marSales > 0 && a.marSalesLY != null && a.marSalesLY !=0)
                        result = ((a.marSales-a.marSalesLY)/a.marSalesLY)*100;
                }
                when  4{
                    if( a.aprSales > 0 && a.aprSalesLY != null && a.aprSalesLY != 0)
                     result = ((a.aprSales-a.aprSalesLY)/a.aprSalesLY)*100;
                }
                when  5{
                    if(a.maySales > 0 && a.maySalesLY != null && a.maySalesLY != 0)
                        result = ((a.maySales-a.maySalesLY)/a.maySalesLY)*100;
                }
                when  6{
                    if( a.junSales > 0 && a.junSalesLY != null && a.junSalesLY != 0)
                     result = ((a.junSales-a.junSalesLY)/a.junSalesLY)*100;
                }
                when  7{
                    if(a.julSales > 0 && a.julSalesLY != null && a.julSalesLY != 0)
                     result = ((a.julSales-a.julSalesLY)/a.julSalesLY)*100;
                }
                when  8{
                    if(a.augSales > 0 && a.augSalesLY != null && a.augSalesLY != 0)
                        result = ((a.augSales-a.augSalesLY)/a.augSalesLY)*100;
                }
                when  9{
                    if(a.sepSales > 0 && a.sepSalesLY != null && a.sepSalesLY != 0)
                        result = ((a.sepSales-a.sepSalesLY)/a.sepSalesLY)*100;
                }
                when  10{
                    if(a.octSales > 0 && a.octSalesLY != null && a.octSalesLY != 0)
                     result = ((a.octSales-a.octSalesLY)/a.octSalesLY)*100;
                }
                when  11{
                    if(a.novSales > 0 && a.novSalesLY != null && a.novSalesLY != 0)
                     result = ((a.novSales-a.novSalesLY)/a.novSalesLY)*100;
                }
                when  12{
                    if(a.decSales > 0 && a.decSalesLY != null && a.decSalesLY != 0)
                     result = ((a.decSales-a.decSalesLY)/a.decSalesLY)*100;
                }
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    //variation for lenses gross sales
    public static Double getVariationLensGrossSales(AccountSales a,Integer Month){
        Double result=0;
          try{
            switch on month {
                when  0{
                    if(a.totalLensSales > 0 && a.totalLensesSalesLFYYTD != null && a.totalLensesSalesLFYYTD != 0)
                        result = ((a.totalLensSales-a.totalLensesSalesLFYYTD)/a.totalLensesSalesLFYYTD)*100;
                }
                when  1{
                    if(a.janLensSales > 0 && a.janLensesSalesLY != null && a.janLensesSalesLY != 0)
                        result = ((a.janLensSales-a.janLensesSalesLY)/a.janLensesSalesLY)*100;
                }
                when  2{
                    if(a.febLensSales > 0 && a.febLensesSalesLY != null && a.febLensesSalesLY != 0)
                        result = ((a.febLensSales-a.febLensesSalesLY)/a.febLensesSalesLY)*100;
                }
                when  3{
                    if(a.marLensSales > 0 && a.marLensesSalesLY != null && a.marLensesSalesLY !=0)
                        result = ((a.marLensSales-a.marLensesSalesLY)/a.marLensesSalesLY)*100;
                }
                when  4{
                   if(a.aprLensSales > 0 && a.aprLensesSalesLY != null && a.aprLensesSalesLY != 0)
                        result = ((a.aprLensSales-a.aprLensesSalesLY)/a.aprLensesSalesLY)*100;
                }
                when  5{
                    if(a.mayLensSales > 0 && a.mayLensesSalesLY != null && a.mayLensesSalesLY != 0)
                        result = ((a.mayLensSales-a.mayLensesSalesLY)/a.mayLensesSalesLY)*100;
                }
                when  6{
                    if(a.junLensSales > 0 && a.junLensesSalesLY != null && a.junLensesSalesLY != 0)
                     result = ((a.junLensSales-a.junLensesSalesLY)/a.junLensesSalesLY)*100;
                }
                when  7{
                    if(a.julLensSales > 0 && a.julLensesSalesLY != null && a.julLensesSalesLY != 0)
                     result = ((a.julLensSales-a.julLensesSalesLY)/a.julLensesSalesLY)*100;
                }
                when  8{
                    if(a.augLensSales > 0 && a.augLensesSalesLY != null && a.augLensesSalesLY != 0)
                        result = ((a.augLensSales-a.augLensesSalesLY)/a.augLensesSalesLY)*100;
                }
                when  9{
                    if(a.sepLensSales >0 && a.sepLensesSalesLY != null && a.sepLensesSalesLY != 0)
                        result = ((a.sepLensSales-a.sepLensesSalesLY)/a.sepLensesSalesLY)*100;
                }
                when  10{
                    if(a.octLensSales > 0 && a.octLensesSalesLY != null && a.octLensesSalesLY != 0)
                     result = ((a.octLensSales-a.octLensesSalesLY)/a.octLensesSalesLY)*100;
                }
                when  11{
                    if(a.novLensSales > 0 && a.novLensesSalesLY != null && a.novLensesSalesLY != 0)
                     result = ((a.novLensSales-a.novLensesSalesLY)/a.novLensesSalesLY)*100;
                }
                when  12{
                    if(a.decLensSales > 0 && a.decLensesSalesLY != null && a.decLensesSalesLY != 0)
                     result = ((a.decLensSales-a.decLensesSalesLY)/a.decLensesSalesLY)*100;
                }
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    //variation for lenses net sales
    public static Double getVariationLensNetSales(AccountSales a,Integer Month){
        Double result=0;
          try{
            switch on month {
                when  0{
                    if(a.totalLensNetSales > 0 && a.totalLensesSalesLFYYTD != null && a.totalLensesSalesLFYYTD != 0)
                        result = ((a.totalLensNetSales-a.totalLensesSalesLFYYTD)/a.totalLensesSalesLFYYTD)*100;
                }
                when  1{
                    if(a.janLensNetSales > 0 && a.janLensNetSalesLY != null && a.janLensNetSalesLY != 0)
                        result = ((a.janLensNetSales-a.janLensNetSalesLY)/a.janLensNetSalesLY)*100;
                }
                when  2{
                    if(a.febLensNetSales > 0 && a.febLensNetSalesLY != null && a.febLensNetSalesLY != 0)
                        result = ((a.febLensNetSales-a.febLensNetSalesLY)/a.febLensNetSalesLY)*100;
                }
                when  3{
                    if(a.marLensNetSales > 0 && a.marLensNetSalesLY != null && a.marLensNetSalesLY !=0)
                        result = ((a.marLensNetSales-a.marLensNetSalesLY)/a.marLensNetSalesLY)*100;
                }
                when  4{
                   if(a.aprLensNetSales > 0 && a.aprLensNetSalesLY != null && a.aprLensNetSalesLY != 0)
                        result = ((a.aprLensNetSales-a.aprLensNetSalesLY)/a.aprLensNetSalesLY)*100;
                }
                when  5{
                    if(a.mayLensNetSales > 0 && a.mayLensNetSalesLY != null && a.mayLensNetSalesLY != 0)
                        result = ((a.mayLensNetSales-a.mayLensNetSalesLY)/a.mayLensNetSalesLY)*100;
                }
                when  6{
                    if(a.junLensNetSales > 0 && a.junLensNetSalesLY != null && a.junLensNetSalesLY != 0)
                     result = ((a.junLensNetSales-a.junLensNetSalesLY)/a.junLensNetSalesLY)*100;
                }
                when  7{
                    if(a.julLensNetSales > 0 && a.julLensNetSalesLY != null && a.julLensNetSalesLY != 0)
                     result = ((a.julLensNetSales-a.julLensNetSalesLY)/a.julLensNetSalesLY)*100;
                }
                when  8{
                    if(a.augLensNetSales > 0 && a.augLensNetSalesLY != null && a.augLensNetSalesLY != 0)
                        result = ((a.augLensNetSales-a.augLensNetSalesLY)/a.augLensNetSalesLY)*100;
                }
                when  9{
                    if(a.sepLensNetSales > 0 && a.sepLensNetSalesLY != null && a.sepLensNetSalesLY != 0)
                        result = ((a.sepLensNetSales-a.sepLensNetSalesLY)/a.sepLensNetSalesLY)*100;
                }
                when  10{
                    if(a.octLensNetSales > 0 && a.octLensNetSalesLY != null && a.octLensNetSalesLY != 0)
                     result = ((a.octLensNetSales-a.octLensNetSalesLY)/a.octLensNetSalesLY)*100;
                }
                when  11{
                    if(a.novLensNetSales > 0 && a.novLensNetSalesLY != null && a.novLensNetSalesLY != 0)
                     result = ((a.novLensNetSales-a.novLensNetSalesLY)/a.novLensNetSalesLY)*100;
                }
                when  12{
                    if(a.decLensNetSales > 0 && a.decLensNetSalesLY != null && a.decLensNetSalesLY != 0)
                     result = ((a.decLensNetSales-a.decLensNetSalesLY)/a.decLensNetSalesLY)*100;
                }
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    //variation for total net sales
    public static Double getVariationNetSales(AccountSales a,Integer Month){
        Double result=0;
          try{
            switch on month {
                when  0{
                    if(a.totalNetSales > 0 && a.totalNetSalesLYYTD != null && a.totalNetSalesLYYTD != 0)
                        result = ((a.totalNetSales-a.totalNetSalesLYYTD)/a.totalNetSalesLYYTD)*100;
                }
                when  1{
                    if(a.janNetSales > 0 && a.janNetSalesLY != null && a.janNetSalesLY != 0)
                        result = ((a.janNetSales-a.janNetSalesLY)/a.janNetSalesLY)*100;
                }
                when  2{
                    if(a.febNetSales > 0 && a.febNetSalesLY != null && a.febNetSalesLY != 0)
                        result = ((a.febNetSales-a.febNetSalesLY)/a.febNetSalesLY)*100;
                }
                when  3{
                    if(a.marNetSales > 0 && a.marNetSalesLY != null && a.marNetSalesLY !=0)
                        result = ((a.marNetSales-a.marNetSalesLY)/a.marNetSalesLY)*100;
                }
                when  4{
                    if(a.aprNetSales > 0 && a.aprNetSalesLY != null && a.aprNetSalesLY != 0)
                     result = ((a.aprNetSales-a.aprNetSalesLY)/a.aprNetSalesLY)*100;
                }
                when  5{
                    if(a.mayNetSales > 0 && a.mayNetSalesLY != null && a.mayNetSalesLY != 0)
                        result = ((a.mayNetSales-a.mayNetSalesLY)/a.mayNetSalesLY)*100;
                }
                when  6{
                    if(a.junNetSales > 0 && a.junNetSalesLY != null && a.junNetSalesLY != 0)
                     result = ((a.junNetSales-a.junNetSalesLY)/a.junNetSalesLY)*100;
                }
                when  7{
                    if(a.julNetSales > 0 && a.julNetSalesLY != null && a.julNetSalesLY != 0)
                     result = ((a.julNetSales-a.julNetSalesLY)/a.julNetSalesLY)*100;
                }
                when  8{
                    if(a.augNetSales > 0 && a.augNetSalesLY != null && a.augNetSalesLY != 0)
                        result = ((a.augNetSales-a.augNetSalesLY)/a.augNetSalesLY)*100;
                }
                when  9{
                    if(a.sepNetSales > 0 && a.sepNetSalesLY != null && a.sepNetSalesLY != 0)
                        result = ((a.sepNetSales-a.sepNetSalesLY)/a.sepNetSalesLY)*100;
                }
                when  10{
                    if(a.octNetSales > 0 && a.octNetSalesLY != null && a.octNetSalesLY != 0)
                     result = ((a.octNetSales-a.octNetSalesLY)/a.octNetSalesLY)*100;
                }
                when  11{
                    if(a.novNetSales > 0 && a.novNetSalesLY != null && a.novNetSalesLY != 0)
                     result = ((a.novNetSales-a.novNetSalesLY)/a.novNetSalesLY)*100;
                }
                when  12{
                    if(a.decNetSales > 0 && a.decNetSalesLY != null && a.decNetSalesLY != 0)
                     result = ((a.decNetSales-a.decNetSalesLY)/a.decNetSalesLY)*100;
                }
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);           
        }
        return result;
    } 
    //variation for total qty
    public static Double getVariationQty(AccountSales a,Integer Month){
        Double result=0;
          try{
            switch on month {
                when  0{
                       if(a.totalQty > 0 && a.totalQtyLYYTD != null && a.totalQtyLYYTD != 0)
                            result = ((a.totalQty-a.totalQtyLYYTD)/a.totalQtyLYYTD)*100;
                }
                when  1{
                       if(a.janQty > 0 && a.janQtyLY != null && a.janQtyLY != 0)
                         result = ((a.janQty-a.janQtyLY)/a.janQtyLY)*100;
                }
                when  2{
                       if(a.febQty > 0 && a.febQtyLY != null && a.febQtyLY != 0)
                         result = ((a.febQty-a.febQtyLY)/a.febQtyLY)*100;
                }
                when  3{
                       if(a.marQty > 0 && a.marQtyLY != null && a.marQtyLY != 0)
                            result = ((a.marQty-a.marQtyLY)/a.marQtyLY)*100;
                }
                when  4{
                       if(a.aprQty > 0 && a.aprQtyLY != null && a.aprQtyLY != 0)
                          result = ((a.aprQty-a.aprQtyLY)/a.aprQtyLY)*100;
                }
                when  5{
                       if(a.mayQty > 0 && a.mayQtyLY != null && a.mayQtyLY != 0)
                            result = ((a.mayQty-a.mayQtyLY)/a.mayQtyLY)*100;
                }
                when  6{
                       if(a.junQty > 0 && a.junQtyLY != null && a.junQtyLY != 0)
                         result = ((a.junQty-a.junQtyLY)/a.junQtyLY)*100;
                }
                when  7{
                       if(a.julQty > 0 && a.julQtyLY != null && a.julQtyLY != 0)
                            result = ((a.julQty-a.julQtyLY)/a.julQtyLY)*100;
                }
                when  8{
                       if(a.augQty > 0 && a.augQtyLY != null && a.augQtyLY != 0)
                          result = ((a.augQty-a.augQtyLY)/a.augQtyLY)*100;
                }
                when  9{
                       if(a.sepQty > 0 && a.sepQtyLY != null && a.sepQtyLY != 0)
                          result = ((a.sepQty-a.sepQtyLY)/a.sepQtyLY)*100;
                }
                when  10{
                       if(a.octQty > 0 && a.octQtyLY != null && a.octQtyLY != 0)
                        result = ((a.octQty-a.octQtyLY)/a.octQtyLY)*100;
                }
                when  11{
                       if(a.novQty > 0 && a.novQtyLY != null && a.novQtyLY != 0)
                        result = ((a.novQty-a.novQtyLY)/a.novQtyLY)*100;
                }
                when  12{
                       if(a.decQty > 0 && a.decQtyLY != null && a.decQtyLY != 0)
                         result = ((a.decQty-a.decQtyLY)/a.decQtyLY)*100;
                }
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    //variation for lenses qty
    public static Double getLensesVariationQty(AccountSales a,Integer Month){
        Double result=0;
          try{
            switch on month {
                when  0{
                       if(a.totalLensQty > 0 && a.totalLensesQtyLFYYTD != null && a.totalLensesQtyLFYYTD != 0)
                            result = ((a.totalLensQty-a.totalLensesQtyLFYYTD)/a.totalLensesQtyLFYYTD)*100;
                }
                when  1{
                       if(a.janLensQty > 0 && a.janLensesQtyLY != null && a.janLensesQtyLY != 0)
                         result = ((a.janLensQty-a.janLensesQtyLY)/a.janLensesQtyLY)*100;
                }
                when  2{
                       if(a.febLensQty > 0 && a.febLensesQtyLY != null && a.febLensesQtyLY != 0)
                         result = ((a.febLensQty-a.febLensesQtyLY)/a.febLensesQtyLY)*100;
                }
                when  3{
                       if(a.marLensQty > 0 && a.marLensesQtyLY != null && a.marLensesQtyLY != 0)
                            result = ((a.marLensQty-a.marLensesQtyLY)/a.marLensesQtyLY)*100;
                }
                when  4{
                       if(a.aprLensQty > 0 && a.aprLensesQtyLY != null && a.aprLensesQtyLY != 0)
                          result = ((a.aprLensQty-a.aprLensesQtyLY)/a.aprLensesQtyLY)*100;
                }
                when  5{
                       if(a.mayLensQty > 0 && a.mayLensesQtyLY != null && a.mayLensesQtyLY != 0)
                            result = ((a.mayLensQty-a.mayLensesQtyLY)/a.mayLensesQtyLY)*100;
                }
                when  6{
                       if(a.junLensQty > 0 && a.junLensesQtyLY != null && a.junLensesQtyLY != 0)
                         result = ((a.junLensQty-a.junLensesQtyLY)/a.junLensesQtyLY)*100;
                }
                when  7{
                       if(a.julLensQty > 0 && a.julLensesQtyLY != null && a.julLensesQtyLY != 0)
                            result = ((a.julLensQty-a.julLensesQtyLY)/a.julLensesQtyLY)*100;
                }
                when  8{
                       if(a.augLensQty > 0 && a.augLensesQtyLY != null && a.augLensesQtyLY != 0)
                          result = ((a.augLensQty-a.augLensesQtyLY)/a.augLensesQtyLY)*100;
                }
                when  9{
                       if(a.sepLensQty > 0 && a.sepLensesQtyLY != null && a.sepLensesQtyLY != 0)
                          result = ((a.sepLensQty-a.sepLensesQtyLY)/a.sepLensesQtyLY)*100;
                }
                when  10{
                       if(a.octLensQty > 0 && a.octLensesQtyLY != null && a.octLensesQtyLY != 0)
                        result = ((a.octLensQty-a.octLensesQtyLY)/a.octLensesQtyLY)*100;
                }
                when  11{
                       if(a.novLensQty > 0 && a.novLensesQtyLY != null && a.novLensesQtyLY != 0)
                        result = ((a.novLensQty-a.novLensesQtyLY)/a.novLensesQtyLY)*100;
                }
                when  12{
                       if(a.decLensQty > 0 && a.decLensesQtyLY != null && a.decLensesQtyLY != 0)
                         result = ((a.decLensQty-a.decLensesQtyLY)/a.decLensesQtyLY)*100;
                }
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    } 
    public static Double getLensesAnnualRevenue(AccountSales a, Integer month){
        Double result = 0;
        try{
            if(a.isGermanyAccount){
                switch on month {
                    when  1{result = a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales+a.octLensSales+a.novLensSales+a.decLensSales;}
                    when  2{result = a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales+a.octLensSales+a.novLensSales+a.decLensSales+a.janLensSales;}
                    when  3{result = a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales+a.octLensSales+a.novLensSales+a.decLensSales+a.janLensSales+a.febLensSales;}
                    when  4{result = a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales+a.octLensSales+a.novLensSales+a.decLensSales+a.janLensSales+a.febLensSales+a.marLensSales;}
                    when  5{result = a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales ;}
                    when  6{result = a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales;}
                    when  7{result = a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales;}
                    when  8{result = a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales;}
                    when  9{result = a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales;}
                    when  10{result = a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales;}
                    when  11{result = a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales+a.octLensSales;}
                    when  12{result = a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales+a.mayLensSales+a.junLensSales+a.julLensSales+a.augLensSales+a.sepLensSales+a.octLensSales+a.novLensSales;}
                    when else {result=0;}
                }
            }
            else if(a.isSOSAorSONLAccount || a.isOtherCountryAccount){
                 switch on month {
                    when  1{result = a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales+a.decLensNetSales;}
                    when  2{result = a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales+a.decLensNetSales+a.janLensNetSales;}
                    when  3{result = a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales+a.decLensNetSales+a.janLensNetSales+a.febLensNetSales;}
                    when  4{result = a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales+a.decLensNetSales+a.janLensNetSales+a.febLensNetSales+a.marLensNetSales;}
                    when  5{result = a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales ;}
                    when  6{result = a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales;}
                    when  7{result = a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales;}
                    when  8{result = a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales;}
                    when  9{result = a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales;}
                    when  10{result = a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales;}
                    when  11{result = a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales;}
                    when  12{result = a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales;}
                    when else {result=0;}
                }

            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
        
          
    }
    public static Double getLensesAnnualQuantity(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty+a.octLensQty+a.novLensQty+a.decLensQty;}
                when  2{result = a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty+a.octLensQty+a.novLensQty+a.decLensQty+a.janLensQty;}
                when  3{result = a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty+a.octLensQty+a.novLensQty+a.decLensQty+a.janLensQty+a.febLensQty;}
                when  4{result = a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty+a.octLensQty+a.novLensQty+a.decLensQty+a.janLensQty+a.febLensQty+a.marLensQty;}
                when  5{result = a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty;}
                when  6{result = a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty;}
                when  7{result = a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty;}
                when  8{result = a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty;}
                when  9{result = a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junQty+a.julLensQty+a.augLensQty;}
                when  10{result = a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty;}
                when  11{result = a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty+a.octLensQty;}
                when  12{result = a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty+a.mayLensQty+a.junLensQty+a.julLensQty+a.augLensQty+a.sepLensQty+a.octLensQty+a.novLensQty;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }
    public static Double getLensesSalesYTD_LFY(AccountSales a, Integer month){
        Double result = 0;
        try{
            if(a.isGermanyAccount){
             switch on month{
                when  1{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY;}
                when  2{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY;}
                when  3{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY;}
                when  4{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                when  5{result = a.aprLensesSalesLY;}
                when  6{result = a.aprLensesSalesLY+a.mayLensesSalesLY;}
                when  7{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY;}
                when  8{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY;}
                when  9{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY;}
                when  10{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY;}
                when  11{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY;}
                when  12{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY;}
                when else {result=0;}               
             }
            }
            else if (a.isSOSAorSONLAccount || a.isOtherCountryAccount){
                switch on month{
                    when  1{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY;}
                    when  2{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY;}
                    when  3{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY;}
                    when  4{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  5{result = a.aprLensNetSalesLY;}
                    when  6{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY;}
                    when  7{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY;}
                    when  8{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY;}
                    when  9{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY;}
                    when  10{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY;}
                    when  11{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY;}
                    when  12{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY;}
                    when else {result=0;}               
             }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }

    public static Double getLensesQuantityYTD_LFY(AccountSales a, Integer month){
        Double result = 0;
        try{
             switch on month{
                when  1{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY;}
                when  2{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY;}
                when  3{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY;}
                when  4{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY;}
                when  5{result = a.aprLensesQtyLY;}
                when  6{result = a.aprLensesQtyLY+a.mayLensesQtyLY;}
                when  7{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY;}
                when  8{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY;}
                when  9{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY;}
                when  10{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY;}
                when  11{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY;}
                when  12{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY;}
                when else {result=0;}               
             }           
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }   
    public static Double getLensesQuantityLast3Month(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.octLensQty+a.novLensQty+a.decLensQty;}
                when  2{result = a.novLensQty+a.decLensQty+a.janLensQty;}
                when  3{result = a.decLensQty+a.janLensQty+a.febLensQty;}
                when  4{result = a.janLensesQtyLY+a.febLensesQtyLY+a.marLensesQtyLY;}
                when  5{result = a.febLensesQtyLY+a.marLensesQtyLY+a.aprLensQty;}
                when  6{result = a.marLensesQtyLY+a.aprLensQty+a.mayLensQty;}
                when  7{result = a.aprLensQty+a.mayLensQty+a.junLensQty;}
                when  8{result = a.mayLensQty+a.junLensQty+a.julLensQty;}
                when  9{result = a.junLensQty+a.julLensQty+a.augLensQty;}
                when  10{result = a.julLensQty+a.augLensQty+a.sepLensQty;}
                when  11{result = a.augLensQty+a.sepLensQty+a.octLensQty;}
                when  12{result = a.sepLensQty+a.octLensQty+a.novLensQty;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }    
    public static Double getLensesQuantityLast3MonthLY(AccountSales a, Integer month){
        Double result = 0;
        try{
            switch on month {
                when  1{result = a.octLensesQtyLY+a.novLensesQtyLY+a.decLensesQtyLY;}
                when  2{result = a.novLensesQtyLY+a.decLensesQtyLY+a.janLensesQtyLY;}
                when  3{result = a.decLensesQtyLY+a.janLensesQtyLY+a.febLensesQtyLY;}
                when  4{result = a.janQtyN2+a.febQtyN2+a.marQtyN2;}
                when  5{result = a.febQtyN2+a.marQtyN2+a.aprLensesQtyLY;}
                when  6{result = a.marQtyN2+a.aprLensesQtyLY+a.mayLensesQtyLY;}
                when  7{result = a.aprLensesQtyLY+a.mayLensesQtyLY+a.junLensesQtyLY;}
                when  8{result = a.mayLensesQtyLY+a.junLensesQtyLY+a.julLensesQtyLY;}
                when  9{result = a.junLensesQtyLY+a.julLensesQtyLY+a.augLensesQtyLY;}
                when  10{result = a.julLensesQtyLY+a.augLensesQtyLY+a.sepLensesQtyLY;}
                when  11{result = a.augLensesQtyLY+a.sepLensesQtyLY+a.octLensesQtyLY;}
                when  12{result = a.sepLensesQtyLY+a.octLensesQtyLY+a.novLensesQtyLY;}
                when else {result=0;}
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }
    public static Double getLensesSalesLast3MonthLY(AccountSales a, Integer month){
        Double result = 0;
        try{
            if(a.isGermanyAccount){
                switch on month {
                    when  1{result = a.octLensesSalesLY+a.novLensesSalesLY+a.decLensesSalesLY;}
                    when  2{result = a.novLensesSalesLY+a.decLensesSalesLY+a.janLensesSalesLY;}
                    when  3{result = a.decLensesSalesLY+a.janLensesSalesLY+a.febLensesSalesLY;}
                    when  4{result = a.janSalesN2+a.febSalesN2+a.marSalesN2;}
                    when  5{result = a.febSalesN2+a.marSalesN2+a.aprLensesSalesLY;}
                    when  6{result = a.marSalesN2+a.aprLensesSalesLY+a.mayLensesSalesLY;}
                    when  7{result = a.aprLensesSalesLY+a.mayLensesSalesLY+a.junLensesSalesLY;}
                    when  8{result = a.mayLensesSalesLY+a.junLensesSalesLY+a.julLensesSalesLY;}
                    when  9{result = a.junLensesSalesLY+a.julLensesSalesLY+a.augLensesSalesLY;}
                    when  10{result = a.julLensesSalesLY+a.augLensesSalesLY+a.sepLensesSalesLY;}
                    when  11{result = a.augLensesSalesLY+a.sepLensesSalesLY+a.octLensesSalesLY;}
                    when  12{result = a.sepLensesSalesLY+a.octLensesSalesLY+a.novLensesSalesLY;}
                    when else {result=0;}
                }
            }
            else if(a.isSOSAorSONLAccount || a.isOtherCountryAccount){
                 switch on month {
                    when  1{result = a.octLensNetSalesLY+a.novLensNetSalesLY+a.decLensNetSalesLY;}
                    when  2{result = a.novLensNetSalesLY+a.decLensNetSalesLY+a.janLensNetSalesLY;}
                    when  3{result = a.decLensNetSalesLY+a.janLensNetSalesLY+a.febLensNetSalesLY;}
                    when  4{result = a.janNetSalesN2+a.febNetSalesN2+a.marNetSalesN2;}
                    when  5{result = a.febNetSalesN2+a.marNetSalesN2+a.aprLensNetSalesLY;}
                    when  6{result = a.marNetSalesN2+a.aprLensNetSalesLY+a.mayLensNetSalesLY;}
                    when  7{result = a.aprLensNetSalesLY+a.mayLensNetSalesLY+a.junLensNetSalesLY;}
                    when  8{result = a.mayLensNetSalesLY+a.junLensNetSalesLY+a.julLensNetSalesLY;}
                    when  9{result = a.junLensNetSalesLY+a.julLensNetSalesLY+a.augLensNetSalesLY;}
                    when  10{result = a.julLensNetSalesLY+a.augLensNetSalesLY+a.sepLensNetSalesLY;}
                    when  11{result = a.augLensNetSalesLY+a.sepLensNetSalesLY+a.octLensNetSalesLY;}
                    when  12{result = a.sepLensNetSalesLY+a.octLensNetSalesLY+a.novLensNetSalesLY;}
                    when else {result=0;}
                }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }    
    public static Double getLensesSalesLast3Month(AccountSales a, Integer month){
        Double result = 0;
        try{
            if(a.isGermanyAccount){
                switch on month {
                    when  1{result = a.octLensSales+a.novLensSales+a.decLensSales;}
                    when  2{result = a.novLensSales+a.decLensSales+a.janLensSales;}
                    when  3{result = a.decLensSales+a.janLensSales+a.febLensSales;}
                    when  4{result = a.janLensesSalesLY+a.febLensesSalesLY+a.marLensesSalesLY;}
                    when  5{result = a.febLensesSalesLY+a.marLensesSalesLY+a.aprLensSales;}
                    when  6{result = a.marLensesSalesLY+a.aprLensSales+a.mayLensSales;}
                    when  7{result = a.aprLensSales+a.mayLensSales+a.junLensSales;}
                    when  8{result = a.mayLensSales+a.junLensSales+a.julLensSales;}
                    when  9{result = a.junLensSales+a.julLensSales+a.augLensSales;}
                    when  10{result = a.julLensSales+a.augLensSales+a.sepLensSales;}
                    when  11{result = a.augLensSales+a.sepLensSales+a.octLensSales;}
                    when  12{result = a.sepLensSales+a.octLensSales+a.novLensSales;}
                    when else {result=0;}
                }
            }
            else if(a.isSOSAorSONLAccount || a.isOtherCountryAccount){
                switch on month {
                    when  1{result = a.octLensNetSales+a.novLensNetSales+a.decLensNetSales;}
                    when  2{result = a.novLensNetSales+a.decLensNetSales+a.janLensNetSales;}
                    when  3{result = a.decLensNetSales+a.janLensNetSales+a.febLensNetSales;}
                    when  4{result = a.janLensNetSalesLY+a.febLensNetSalesLY+a.marLensNetSalesLY;}
                    when  5{result = a.febLensNetSalesLY+a.marLensNetSalesLY+a.aprLensNetSales;}
                    when  6{result = a.marLensNetSalesLY+a.aprLensNetSales+a.mayLensNetSales;}
                    when  7{result = a.aprLensNetSales+a.mayLensNetSales+a.junLensNetSales;}
                    when  8{result = a.mayLensNetSales+a.junLensNetSales+a.julLensNetSales;}
                    when  9{result = a.junLensNetSales+a.julLensNetSales+a.augLensNetSales;}
                    when  10{result = a.julLensNetSales+a.augLensNetSales+a.sepLensNetSales;}
                    when  11{result = a.augLensNetSales+a.sepLensNetSales+a.octLensNetSales;}
                    when  12{result = a.sepLensNetSales+a.octLensNetSales+a.novLensNetSales;}
                    when else {result=0;}
                }
            }
        }
        catch (Exception e) {
            LogException.log(e);
        }
        return result;
    }
   
//new methods
    public static double getLensesDelays(Map<Integer,RxAndStockSales> CYMap, Map<Integer,RxAndStockSales> LYMap, Integer month, Integer days, String type){
        double result = 0;
        List<String> monthLst;
        switch on month {               
            when  1{monthLst = new List<String>{'10:CY','11:CY','12:CY'};}
            when  2{monthLst = new List<String>{'11:CY','12:CY','1:CY'};}
            when  3{monthLst = new List<String>{'12:CY','1:CY','2:CY'};}
            when  4{monthLst = new List<String>{'1:CY','2:CY','3:CY'};}
            when  5{monthLst = new List<String>{'2:LY','3:LY','4:CY'};}
            when  6{monthLst = new List<String>{'3:LY','4:CY','5:CY'};}
            when  7{monthLst = new List<String>{'4:CY','5:CY','6:CY'};}
            when  8{monthLst = new List<String>{'5:CY','6:CY','7:CY'};}
            when  9{monthLst = new List<String>{'6:CY','7:CY','8:CY'};}
            when  10{monthLst = new List<String>{'7:CY','8:CY','9:CY'};}
            when  11{monthLst = new List<String>{'8:CY','9:CY','10:CY'};}
            when  12{monthLst = new List<String>{'9:CY','10:CY','11:CY'};}
            when else {monthLst = new List<String>();}
        }
        double shipOnDayCount =0;
        double qty = 0;
        if(type == 'RX'){          
            if(days == 0){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedonSameDay;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                            system.debug(shipOnDayCount+''+qty);
                        }
                        else{
                            System.debug(LYMap.get(Integer.valueOf(mon.substringBefore(':'))));
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedonSameDay;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                            system.debug(shipOnDayCount+''+qty);
                        }
                    }
                }
            }
            else if(days == 1){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin1Day;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin1Day;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 2){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin2Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin2Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 3){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin3Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin3Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 4){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin4Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin4Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 5){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin5Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin5Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 6){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin6Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin6Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 7){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin7Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin7Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 8){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin8Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin8Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 9){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin9Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin9Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            else if(days == 10){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin10Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxShippedin10Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                        }
                    }
                }
            }
            
        }
        else{
            if(days == 0){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedonSameDay;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedonSameDay;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                    }
                }
            }
            else if(days == 1){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin1Day;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin1Day;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                    }
                }
            }
            else if(days == 2){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin2Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin2Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                    }
                }
            }
            else if(days == 3){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin3Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin3Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                    }
                }
            }
            else if(days == 4){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin4Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin4Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                    }
                }
            }
            else if(days == 5){
                if(monthLst.size() > 0){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            shipOnDayCount += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin5Days;
                            qty += CYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                        else{
                            shipOnDayCount += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockShippedin5Days;
                            qty += LYMap.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                        }
                    }
                }
            }
        }
        if(qty != 0)
            result=(shipOnDayCount/qty)*100;
        return result;
    }
    public static Map<Integer,double> getTotalrxShippedDelay(Map<Integer,RxandStockSales> rxMapCY,Map<Integer,RxandStockSales> rxMapLY,String year){
        double total =0;
        Integer monthcount =0;
        
        Map<Integer,double> monthlydelayMap =new  Map<Integer,double>();    
        Map<Integer,RxandStockSales> rxMap= new Map<Integer,RxandStockSales>();
        if(year == 'CY'){
            rxMap.putAll(rxMapCY);
            monthcount = 12;
        }
        else{
            rxMap.putAll(rxMapLY);
            monthcount = 3;
        }
        if(rxMap.size() > 0){
            for(Integer i=1 ; i<=monthcount ;i++){
                if(rxMap.containsKey(i)){
                    Integer RxQty = rxMap.get(i).rxQty;
                    Integer rxQtyShippedin10days=rxMap.get(i).rxShippedin10Days;
                    Integer rxQtyinDelay=RxQty-rxQtyShippedin10days;
                    double shipped0=0;
                    double shipped1=0;
                    double shipped2=0;
                    double shipped3=0;
                    double shipped4=0;
                    double shipped5=0;
                    double shipped6=0;
                    double shipped7=0;
                    double shipped8=0;
                    double shipped9=0;
                    double shipped10=0;                
                    if(rxMap.get(i).rxShippedonSameDay > 0)
                        shipped0=rxMap.get(i).rxShippedonSameDay;
                    if(rxMap.get(i).rxShippedin1Day > 0  ){
                        shipped1=rxMap.get(i).rxShippedin1Day - shipped0;
                    }
                    if(rxMap.get(i).rxShippedin2Days > 0  ){                     
                        shipped2=rxMap.get(i).rxShippedin2Days -(shipped0 + shipped1) ;
                    }
                    if(rxMap.get(i).rxShippedin3Days > 0  ){
                        shipped3=rxMap.get(i).rxShippedin3Days -(shipped0 + shipped1 + shipped2) ;
                    }
                    if(rxMap.get(i).rxShippedin4Days > 0  ){
                        shipped4=rxMap.get(i).rxShippedin4Days -(shipped0 + shipped1 +shipped2 +shipped3) ;
                    }
                    if(rxMap.get(i).rxShippedin5Days > 0  ){
                        shipped5=rxMap.get(i).rxShippedin5Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4) ;
                    }
                    if(rxMap.get(i).rxShippedin6Days > 0  ){
                        shipped6=rxMap.get(i).rxShippedin6Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5) ;
                    }
                    if(rxMap.get(i).rxShippedin7Days > 0  ){
                        shipped7=rxMap.get(i).rxShippedin7Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 +shipped5 +shipped6) ;
                    }
                    if(rxMap.get(i).rxShippedin8Days > 0  ){
                        shipped8=rxMap.get(i).rxShippedin8Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5 + shipped6 +shipped7) ;
                    }
                    if(rxMap.get(i).rxShippedin9Days > 0  ){
                        shipped9=rxMap.get(i).rxShippedin9Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5 + shipped6 +shipped7 +shipped8) ;
                    }
                    if(rxMap.get(i).rxShippedin10Days > 0  ){
                        shipped10=rxMap.get(i).rxShippedin10Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4 + shipped5 + shipped6 +shipped7+shipped8+shipped9) ;
                    }
                    
                    total= (shipped0 * 0)+(shipped1 * 1)+(shipped2 * 2) +(shipped3 * 3)+(shipped4 * 4)
                        +(shipped5 * 5)+(shipped6 * 6)+(shipped7 * 7)+( shipped8 * 8)+(shipped9 * 9)+(shipped10 * 10)+(rxQtyinDelay*10);
                    
                }
                monthlydelayMap.put(i,total);
            }
        }
        return monthlydelayMap;
    }
    public static Map<Integer,double> getTotalstockShippedDelay(Map<Integer,RxandStockSales> stockMapCY,Map<Integer,RxandStockSales> stockMapLY,String year){
        Map<Integer,double> monthlydelayMap =new  Map<Integer,double>();
        double total=0;
        Integer monthcount =0;
        Map<Integer,RxandStockSales> stockMap= new Map<Integer,RxandStockSales>();
        if(year == 'CY'){
            stockMap.putAll(stockMapCY);
            monthcount = 12;
        }
        else{
            stockMap.putAll(stockMapLY);
            monthcount = 3;
        }
        if(stockMap.size() > 0){
            for(Integer i=1 ; i<=monthcount ;i++){ 
                if(stockMap.containsKey(i)){
                    Integer stockQty = stockMap.get(i).stockQty;
                    Integer stockQtyShippedin5days=stockMap.get(i).stockShippedin5Days;
                    Integer stockQtyinDelay=stockQty-stockQtyShippedin5days;
                    double shipped0=0;
                    double shipped1=0;
                    double shipped2=0;
                    double shipped3=0;
                    double shipped4=0;
                    double shipped5=0;               
                    if(stockMap.get(i).stockShippedonSameDay > 0)
                        shipped0=stockMap.get(i).stockShippedonSameDay;
                    if(stockMap.get(i).stockShippedin1Day  > 0  ){
                        shipped1=stockMap.get(i).stockShippedin1Day - shipped0;
                    }
                    if(stockMap.get(i).stockShippedin2Days > 0  ){                     
                        shipped2=stockMap.get(i).stockShippedin2Days -(shipped0 + shipped1) ;
                    }
                    if(stockMap.get(i).stockShippedin3Days > 0  ){
                        shipped3=stockMap.get(i).stockShippedin3Days -(shipped0 + shipped1 + shipped2) ;
                    }
                    if(stockMap.get(i).stockShippedin4Days > 0  ){
                        shipped4=stockMap.get(i).stockShippedin4Days -(shipped0 + shipped1 +shipped2 +shipped3) ;
                    }
                    if(stockMap.get(i).stockShippedin5Days > 0  ){
                        shipped5=stockMap.get(i).stockShippedin5Days -(shipped0 + shipped1 + shipped2 + shipped3 + shipped4) ;
                    }
                    if(stockQty > 0)
                        Total= (shipped0 * 0)+(shipped1 * 1)+(shipped2 * 2) +(shipped3 * 3)+(shipped4 * 4)+(shipped5 * 5)+(stockQtyinDelay*5);
                }
                monthlydelayMap.put(i,total);
            }
        }
        return monthlydelayMap;
    }
    public static double getShipmentAvgDelay3Month(Map<Integer,RxandStockSales> rxMapCY,Map<Integer,RxandStockSales> rxMapLY,Map<Integer,RxandStockSales> stockMapCY,Map<Integer,RxandStockSales> stockMapLY,Integer month,String type){
        double delay=0;
        
        Map<Integer,double> getTotalCYMap = new Map<Integer,double>();
        Map<Integer,double> getTotalLYMap = new Map<Integer,double>();
        if(type == 'RX' ){
            getTotalCYMap=getTotalrxShippedDelay(rxMapCY,rxMapLY,'CY');
            getTotalLYMap=getTotalrxShippedDelay(rxMapCY,rxMapLY,'LY'); 
            system.debug(getTotalCYMap);
            system.debug(getTotalLYMap);
        }
        else if(type == 'Stock'){
            getTotalCYMap=getTotalstockShippedDelay(stockMapCY,stockMapLY,'CY');
            system.debug(getTotalCYMap);
            getTotalLYMap=getTotalstockShippedDelay(stockMapCY,stockMapLY,'LY'); 
            system.debug(getTotalLYMap);
        }
        else{
            Map<Integer,double> getRxCYMap = getTotalrxShippedDelay(rxMapCY,rxMapLY,'CY');
            Map<Integer,double> getRxLYMap = getTotalrxShippedDelay(rxMapCY,rxMapLY,'LY');
            Map<Integer,double> getStockCYMap = getTotalstockShippedDelay(stockMapCY,stockMapLY,'CY');
            Map<Integer,double> getStockLYMap = getTotalstockShippedDelay(stockMapCY,stockMapLY,'LY');
            
            for(Integer i=1;i<=12;i++){
                double totalCY = 0;
                if(getRxCYMap.size() > 0 && getRxCYMap.containsKey(i) )
                    totalCY += getRxCYMap.get(i);     
                if(getStockCYMap.size() > 0 && getStockCYMap.containsKey(i))
                    totalCY += getStockCYMap.get(i); 
                
                double totalLY = 0;
                if(getRxLYMap.size() > 0 && getRxLYMap.containsKey(i) )
                    totalLY += getRxLYMap.get(i);     
                if(getStockLYMap.size() > 0 && getStockLYMap.containsKey(i))
                    totalLY += getStockLYMap.get(i); 
                getTotalCYMap.put(i,totalCY);
                getTotalLYMap.put(i,totalLY);                
            }           
        }
        List<String> monthLst;
        switch on month {               
            when  1{monthLst = new List<String>{'10:CY','11:CY','12:CY'};}
            when  2{monthLst = new List<String>{'11:CY','12:CY','1:CY'};}
            when  3{monthLst = new List<String>{'12:CY','1:CY','2:CY'};}
            when  4{monthLst = new List<String>{'1:CY','2:CY','3:CY'};}
            when  5{monthLst = new List<String>{'2:LY','3:LY','4:CY'};}
            when  6{monthLst = new List<String>{'3:LY','4:CY','5:CY'};}
            when  7{monthLst = new List<String>{'4:CY','5:CY','6:CY'};}
            when  8{monthLst = new List<String>{'5:CY','6:CY','7:CY'};}
            when  9{monthLst = new List<String>{'6:CY','7:CY','8:CY'};}
            when  10{monthLst = new List<String>{'7:CY','8:CY','9:CY'};}
            when  11{monthLst = new List<String>{'8:CY','9:CY','10:CY'};}
            when  12{monthLst = new List<String>{'9:CY','10:CY','11:CY'};}
            when else {monthLst=new List<String>();}
        }      
        try{
            double qty =0;
            double totalQty = 0;
            if(monthLst.size() > 0){
                if(type == 'RX' || type == 'both'){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            qty += rxMapCY.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                            totalQty += getTotalCYMap.get(Integer.valueOf(mon.substringBefore(':')));
                            system.debug(qty+'-'+totalQty);
                        }
                        else{
                            qty += rxMapLY.get(Integer.valueOf(mon.substringBefore(':'))).rxQty;
                            totalQty += getTotalLYMap.get(Integer.valueOf(mon.substringBefore(':')));
                            system.debug(qty+'-'+totalQty);
                        }
                    }
                    system.debug(qty+'-'+totalQty);
                }
                if(type == 'Stock' || type == 'both'){
                    for(String mon:monthLst){
                        if(mon.substringAfter(':') == 'CY'){
                            qty += stockMapCY.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                            totalQty += getTotalCYMap.get(Integer.valueOf(mon.substringBefore(':')));
                            system.debug(qty+''+totalQty);
                        }
                        else{
                            qty += stockMapLY.get(Integer.valueOf(mon.substringBefore(':'))).stockQty;
                            totalQty += getTotalLYMap.get(Integer.valueOf(mon.substringBefore(':')));
                            system.debug(qty+'-'+totalQty);
                        }
                    }
                    system.debug(qty+'-'+totalQty);
                }
            }
            if(qty != 0)
                delay=totalQty/qty ;    
            System.debug(delay);        
        }
        catch (Exception e){
            LogException.log(e);         
        }        
        return delay;
    }
}