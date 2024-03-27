public class TabVisitsController {
    
    public static final String EC_ACCOUNT_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
    Public static map<id,account> accountDetailsMap = new map<id,account>();
    Public static Map<id,list<account>> parentChildLinkedListMap = new map<id,list<account>>();
    
    // logic took from TacticomAccountPageController
    @AuraEnabled(cacheable=true)
    public static String TacticomDetails(String recordId){
        
        Account acc=[select Id, hoya_account_id__c, door__c, Strategic_Value_Net_Sales__c, TACTICOM_HLFR__c, TACTICOM_SOF__c, Brand__c, Zonal__c, annualRevenue, Sales_Total_Current_Year__c
                     from Account where Id =:recordId WITH SECURITY_ENFORCED];
        List<Account> sameDoorAcc = new List<Account>();
        if(acc.door__c != null)
           sameDoorAcc = [select Id,TACTICOM_SOF__c, Brand__c,Owner.Name from Account where Door__c =:acc.door__c and id !=: acc.Id];

        String isSeiko='NO';
        String isHoya='NO';
        
        //Current account is Seiko
        if(acc.hoya_account_id__c.substring(0,2)=='SO' || acc.Brand__c == 'SEIKO'){
            //it has a door Acc 
            if((!sameDoorAcc.isEmpty()) && (sameDoorAcc[0].Brand__c != 'PENTAX' || acc.Brand__c != 'OEM')){
                if(sameDoorAcc[0].TACTICOM_SOF__c != null && sameDoorAcc[0].TACTICOM_SOF__c != 'None')
                	isHoya ='YES';
            }
            if(acc.TACTICOM_SOF__c != null && acc.TACTICOM_SOF__c != 'None')
                isSeiko = 'YES';
        }        
        //For HOYA Account
        else if(acc.Brand__c != 'PENTAX' || acc.Brand__c != 'OEM'){
            if(!sameDoorAcc.isEmpty() && sameDoorAcc[0].Brand__c == 'SEIKO'){
                if(sameDoorAcc[0].TACTICOM_SOF__c != null && sameDoorAcc[0].TACTICOM_SOF__c != 'None'){
                    isSeiko ='YES';
                }
            }
            if(acc.TACTICOM_SOF__c != null && acc.TACTICOM_SOF__c != 'None'){
                isHoya ='YES';
            }
        }     
        String buddyPartner='';
        if(!sameDoorAcc.isEmpty()){
            buddyPartner = sameDoorAcc[0].Owner.Name;
        }
        //Frame data to send to LWC
        TacticomData tacticom=new TacticomData();
        tacticom.isSEIKO=isSeiko;
        tacticom.isHOYA=isHoya;
        tacticom.buddyPartner = buddyPartner;
        return JSON.serialize(tacticom);
    }
    
    
      public class TacticomData {    
      @AuraEnabled public String isSEIKO {get;set;}
      @AuraEnabled public String isHOYA {get;set;}
      @AuraEnabled public String buddyPartner {get;set;}
    } 
 
        @TestVisible    
        @AuraEnabled(cacheable=true)
        public static List<AggregateResult> getAccountsByZone(String accOwner){
            List<AggregateResult> result =  [Select SUM(Estimated_Planned_Visits__c ) cnt,TACTICOM_SOF__c from Account where TACTICOM_SOF__c !=null AND ownerId=:accOwner group by TACTICOM_SOF__c ]; 
            return result;
        }
    
    
      //Wrapper class to store Related Parent and child Account details 
        public class AccountRelatedSales{
            public AccountRelatedSales(){}
            @AuraEnabled public double totalAnualRevenue{get;set;}  //'Parent & Child Total Sales'
            @AuraEnabled public double totalPotential{get;set;}  //'Parent & Child Total Potential'
            @AuraEnabled public decimal parentAccountSOW{get;set;}  //'Parent & Child SOW'
            @AuraEnabled public String parentAccountSegmentation{get;set;}
            @AuraEnabled public String parentHOYAAccount{get;set;}
        } 
  
    @AuraEnabled(cacheable=true)    
    public static AccountRelatedSales Aggregate(String parentId){
        
        AccountRelatedSales sales = new AccountRelatedSales();
        Double parentChildTotalPotential = 0;
        Double parentChildTotalSales = 0;
        decimal parentChildSOW = 0;
        
        if(parentId!=null){
            try{                
                //calculating parentChildTotalPotential               
                List<AccountDetail> accList = getAllAccountRecordsInHierarchy(parentId);
                
                Set<Id> allAccIds = new Set<Id>();
                for(AccountDetail EA: accList){
                    if(EA.netSales!=null){
                        allAccIds.add(EA.accountId);
                        parentChildTotalPotential = parentChildTotalPotential + EA.netSales;
                    } 
                }
                
                //calculating  Parent & Child Total Sales
                List<Last_Sales_Statistics__c> lastSales = [Select Id, Lenses_Net_Sales_Last_12Mo__c, Account__c from Last_Sales_Statistics__c where Account__c IN :allAccIds  AND Account__r.recordTypeId != :EC_ACCOUNT_RT];
                for(Last_Sales_Statistics__c ES: lastSales){
                    if(ES.Lenses_Net_Sales_Last_12Mo__c!= null){
                        parentChildTotalSales = parentChildTotalSales + ES.Lenses_Net_Sales_Last_12Mo__c;
                    }
                }
                
                //calculating Parent & Child SOW
                if(parentChildTotalSales!=0 && parentChildTotalPotential!=0){
                    decimal sowData = parentChildTotalSales/parentChildTotalPotential;
                    //if percenatge is greater than 100 then round of to 100
                    parentChildSOW  = sowData.setScale(2) > 1.0 ? 1.0 : sowData.setScale(2);
                }
                
                //calculating parentAccountSegmentation
                String parentAccountSegmentationTemp = ''; 
                if(parentChildTotalPotential<2){
                    parentAccountSegmentationTemp='UNCATEGORIZED';
                }
                else {
                    if(parentChildTotalPotential< accList[0].ownerSegmentC){
                        parentAccountSegmentationTemp='C';
                    }
                    else if(parentChildTotalPotential< accList[0].ownerSegmentA){
                        parentAccountSegmentationTemp='B';
                    }
                    else{
                        parentAccountSegmentationTemp='A';
                    }
                }
                
                if(parentChildTotalPotential >2 && parentChildSOW < accList[0].ownerSegmentC3){
                    parentAccountSegmentationTemp = parentAccountSegmentationTemp + '3';
                }
                else if(parentChildTotalPotential >2 && parentChildSOW < accList[0].ownerSegmentA1){
                    parentAccountSegmentationTemp = parentAccountSegmentationTemp + '2';
                }        
                else if(parentChildTotalPotential >2){
                    parentAccountSegmentationTemp = parentAccountSegmentationTemp + '1';
                }
                //HOYA account Id of parent account
                //Passing as a wrapper to pass to LWC
                sales.totalAnualRevenue = parentChildTotalSales ;
                sales.totalPotential = parentChildTotalPotential;  
                sales.parentAccountSOW = parentChildSOW;
                sales.parentHOYAAccount = accList[0].parentHoyaId !=null ? accList[0].parentHoyaId : ''; //BUG 1014 fix
                sales.parentAccountSegmentation = parentAccountSegmentationTemp;
                
            }
            catch(Exception ex){
            }
        }
        Return sales!= Null ? sales : null ;
    }
    
    
    @TestVisible    
    @AuraEnabled(cacheable=true)
    public static List<recomendedVisitDetails> recommendedAccountsByZone(String accOwner){
     
        List<AggregateResult> result =  [Select SUM(Estimated_Planned_Visits__c ) cnt,TACTICOM_SOF__c from Account  where TACTICOM_SOF__c !=null AND ownerId=:accOwner AND Lenses_Net_Sales_Last_12Mo__c > 0 group by TACTICOM_SOF__c ];//where OwnerId =:userId
        List<recomendedVisitDetails> recomList=new List<recomendedVisitDetails>();
        recomendedVisitDetails recomVisit=new recomendedVisitDetails(); 
        decimal recommendedVisit=0;
        for(AggregateResult EAR:result){
           recommendedVisit=recommendedVisit + (decimal)EAR.get('cnt');
        }
                    if((recommendedVisit + 80)<=750){
                     recomVisit.recommendedVisit=recommendedVisit + 80;
                     }
                     else if((recommendedVisit + 80)>750){
                      recomVisit.recommendedVisit = 750;
                     }
                     if((recommendedVisit + 80)<=750){
                      recomVisit.recommendedVisitPerSubArea= ((recommendedVisit + 80)/5);
                        }
                      else if((recommendedVisit + 80)>750){
                            recomVisit.recommendedVisitPerSubArea= (750/5);
                       }
             recomList.add(recomVisit);      
             return recomList;
    }
 
    //Wrapper class to store recommended visit details
    public class recomendedVisitDetails{
        public recomendedVisitDetails(){}
        @AuraEnabled public double recommendedVisit{get;set;}
        @AuraEnabled public double recommendedVisitPerSubArea{get;set;}
        
    } 
    
    
    public static List<AccountDetail> getAllAccountRecordsInHierarchy( String accId){
       
        List<AccountDetail> resultList = new List<AccountDetail>();
        List<Account> item;
        //BUG 1014 fix - added parent.Hoya_account_id__c in the query
        item = [select Id, hoya_account_id__c, name, Strategic_Value_Net_Sales__c,parent.Hoya_account_id__c, parentId, Owner.Segment_C_Potential_Less_Than__c,
                Owner.Segment_A_Potential_Higher_Than__c, Owner.Segment_C3_SOW_Less_Than__c, Owner.Segment_A1_SOW_HigherThan__c 
                from Account where id=:accId AND recordTypeId != :EC_ACCOUNT_RT];   
        
        if (!item.isEmpty()) {
            AccountDetail detail = new AccountDetail();
            detail.accountId = item[0].Id;
            detail.hoya_account_id = item[0].hoya_account_id__c;
            detail.name = item[0].name;
            detail.parentId = item[0].parentId;
            detail.netSales = item[0].Strategic_Value_Net_Sales__c;
            detail.ownerSegmentC = item[0].Owner.Segment_C_Potential_Less_Than__c;
            detail.ownerSegmentA = item[0].Owner.Segment_A_Potential_Higher_Than__c;
            detail.ownerSegmentC3 = item[0].Owner.Segment_C3_SOW_Less_Than__c;
            detail.ownerSegmentA1 = item[0].Owner.Segment_A1_SOW_HigherThan__c;
            //BUG 1014 fix
            if(item[0].parentId != null && item[0].parent.Hoya_account_id__c != null){
                detail.parentHoyaId = item[0].parent.Hoya_account_id__c;
            }
            //adding current account details to the list
            resultList.add(detail);
            Set<Id> accIdSet = new Set<Id>();
            accIdSet.add(item[0].Id);
            //will return all the child accounts and adds to the list
            resultList.addAll(getRecursiveAccountList(accIdSet));
        } 
        return resultList != Null ? resultList : Null;
    }
    
     private class AccountDetail {
         public Id accountId{get;set;}
         public String hoya_account_id{get;set;}
         public String name{get;set;}
         public String parentHoyaId{get;set;}
         public Id parentId{get;set;}
         public Decimal netSales{get;set;}
         public Decimal ownerSegmentC{get;set;}
         public Decimal ownerSegmentA{get;set;}
         public Decimal ownerSegmentC3{get;set;}
         public Decimal ownerSegmentA1{get;set;}
     }
    
    private static List<AccountDetail> getRecursiveAccountList(Set<Id> accIdSet){
         List<Account> temp = [select Id, hoya_account_id__c, name,Strategic_Value_Net_Sales__c, parentId,Owner.Segment_C_Potential_Less_Than__c, 
                               Owner.Segment_A_Potential_Higher_Than__c, Owner.Segment_C3_SOW_Less_Than__c, Owner.Segment_A1_SOW_HigherThan__c
                               from Account where parentId IN :accIdSet  AND recordTypeId != :EC_ACCOUNT_RT];
         List<AccountDetail> result = new List<AccountDetail>();
         if (temp != null && temp.size() > 0) {
             Set<Id> accIds = new Set<Id>();
             for (Account item : temp) {
 
                 AccountDetail detail = new AccountDetail();
                 detail.accountId = item.Id;
                 detail.hoya_account_id = item.hoya_account_id__c;
                 detail.name = item.name;
                 detail.parentId = item.parentId;
                 detail.netSales = item.Strategic_Value_Net_Sales__c;
                 detail.ownerSegmentC = item.Owner.Segment_C_Potential_Less_Than__c;
                 detail.ownerSegmentA = item.Owner.Segment_A_Potential_Higher_Than__c;
                 detail.ownerSegmentC3 = item.Owner.Segment_C3_SOW_Less_Than__c;
                 detail.ownerSegmentA1 = item.Owner.Segment_A1_SOW_HigherThan__c;
                 
                 result.add(detail);
                 accIds.add(item.Id);
             }
             result.addAll(getRecursiveAccountList(accIds));
         }
         return result;
     }
    
}