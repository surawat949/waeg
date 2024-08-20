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
 
    /*@TestVisible    
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getAccountsByZone(String accOwner){
        List<AggregateResult> result =  [Select SUM(Estimated_Planned_Visits__c ) cnt,TACTICOM_SOF__c from Account where TACTICOM_SOF__c !=null AND ownerId=:accOwner group by TACTICOM_SOF__c ]; 
        return result;
    }
    */


    //Wrapper class to store Related Parent and child Account details 
    public class AccountRelatedSales{
        public AccountRelatedSales(){}
        @AuraEnabled public double consolidationKeyStrategicValue{get;set;}  
        @AuraEnabled public decimal consolidationKeyShareOfWallet{get;set;}  
        @AuraEnabled public String consolidationKeySegmentation{get;set;}
    } 

 

    @AuraEnabled(cacheable=true)    
    public static AccountRelatedSales Aggregate(String parentId,String key){
        
        AccountRelatedSales sales = new AccountRelatedSales();
        Double consolidationKeyTotalStrategic = 0;
        Double consolidationKeyLast3MoSales =0;
        decimal consolidationKeySOW = 0;
        Double totalSegmentC3 = 0;
        Double totalSegmentA1 = 0;
        Double totalSegmentA = 0;
        Double totalSegmentC = 0;
        
        if(key!=null){
            try{                
                List<Account> accList;
                List<Account> currAcctList=new List<Account>();
                accList = [select Id, hoya_account_id__c, name, Strategic_Value_Net_Sales__c,parent.Hoya_account_id__c, parentId, Owner.Segment_C_Potential_Less_Than__c,
                Owner.Segment_A_Potential_Higher_Than__c, Owner.Segment_C3_SOW_Less_Than__c, Owner.Segment_A1_SOW_HigherThan__c, Local_Consolidation_Key__c,Lenses_Net_Sales_Last_3Mo_CFY__c
                from Account where Local_Consolidation_Key__c =:key and recordTypeId != :EC_ACCOUNT_RT]; 
                //calculating TotalPotential based on Local Consolodation Key  
                Set<Id> allAccIds = new Set<Id>();          
                for(Account acc: accList){
                    if(acc.Id == parentId)
                    {
                     currAcctList.add(acc);
                     System.debug('check current account list'+currAcctList);
                    }
                    if(acc.Strategic_Value_Net_Sales__c!=null){
                        allAccIds.add(acc.Id);
                        consolidationKeyTotalStrategic = consolidationKeyTotalStrategic + acc.Strategic_Value_Net_Sales__c;
                    } 
                    
                    if(acc.Lenses_Net_Sales_Last_3Mo_CFY__c!=null){
                       consolidationKeyLast3MoSales = consolidationKeyLast3MoSales + acc.Lenses_Net_Sales_Last_3Mo_CFY__c;
                    }
                    if(acc.Owner.Segment_C3_SOW_Less_Than__c != null){
                        totalSegmentC3 += acc.Owner.Segment_C3_SOW_Less_Than__c;
                    }
                    if(acc.Owner.Segment_A1_SOW_HigherThan__c != null){
                        totalSegmentA1 += acc.Owner.Segment_A1_SOW_HigherThan__c;
                    }
                    if(acc.Owner.Segment_C_Potential_Less_Than__c != null){
                        totalSegmentC += acc.Owner.Segment_C_Potential_Less_Than__c;
                    }
                    if(acc.Owner.Segment_A_Potential_Higher_Than__c != null){
                        totalSegmentA += acc.Owner.Segment_A_Potential_Higher_Than__c;
                    }
                }
           
                if(consolidationKeyLast3MoSales!=0 && consolidationKeyTotalStrategic!=0){
                    decimal sowData = consolidationKeyLast3MoSales/(consolidationKeyTotalStrategic/4);
                    //if percenatge is greater than 100 then round of to 100
                    consolidationKeySOW  = sowData.setScale(2) > 1.0 ? 1.0 : sowData.setScale(2);
                }
                //calculating ConsolidationAccountSegmentation
                String consolidationKeyAccountSegmentationTemp = ''; 
                Double consolidationSales = 0;
                if(consolidationKeyTotalStrategic != 0)
                    consolidationSales = (consolidationKeyLast3MoSales/(consolidationKeyTotalStrategic/4))*100;
                Double segmentC3Avg = 0;
                Integer accCount = accList.size();
                if(accCount != 0)
                	segmentC3Avg = totalSegmentC3/accCount ;
                Double segmentA1Avg = 0;
                if(accCount != 0)
                	segmentA1Avg = totalSegmentA1/accCount ;
                Double segmentCAvg = 0;
                Double segmentAAvg = 0;
                if(accCount != 0)
                	segmentAAvg = totalSegmentA/accCount ;
                if(accCount != 0)
                	segmentCAvg = totalSegmentC/accCount ;
                if(consolidationKeyTotalStrategic<2){
                    consolidationKeyAccountSegmentationTemp='UNCATEGORIZED';
                }
                else {
                    if(consolidationKeyTotalStrategic < segmentCAvg){
                        consolidationKeyAccountSegmentationTemp='C';
                    }
                    else if(consolidationKeyTotalStrategic < segmentAAvg){
                        consolidationKeyAccountSegmentationTemp='B';
                    }
                    else{
                        consolidationKeyAccountSegmentationTemp='A';
                    }
                }
                
                if(consolidationSales < segmentC3Avg){
                    consolidationKeyAccountSegmentationTemp = consolidationKeyAccountSegmentationTemp + '3';
                }
                else if(consolidationSales < segmentA1Avg){
                    consolidationKeyAccountSegmentationTemp = consolidationKeyAccountSegmentationTemp + '2';
                }        
                else{
                    if(consolidationKeyAccountSegmentationTemp != 'UNCATEGORIZED')
                    	consolidationKeyAccountSegmentationTemp = consolidationKeyAccountSegmentationTemp + '1';
                }
                //HOYA account Id of parent account
                //Passing as a wrapper to pass to LWC
             
                sales.consolidationKeyStrategicValue = consolidationKeyTotalStrategic;  
                sales.consolidationKeyShareOfWallet = consolidationKeySOW;
                sales.consolidationKeySegmentation = consolidationKeyAccountSegmentationTemp;
                System.debug('check current ACCOUNT KEY SEGMENTATION'+sales.consolidationKeySegmentation);

            }
            catch(Exception ex){
            }
        }
        Return sales!= Null ? sales : null ;
    }
    
    
    /*@TestVisible    
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
        
    } */
       
}