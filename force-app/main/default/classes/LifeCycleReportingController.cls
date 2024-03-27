public with sharing class LifeCycleReportingController {
	private static Decimal count = 0;
    private static Decimal countOfAccounts = 0;
    private static String currencyCode = '';
    //Account_Life_Cycle__c
    @AuraEnabled(cacheable=true)
    public static LifeCycleReportingController.wrapper getAccountLifeCycleRecords(){
        LifeCycleReportingController.wrapper wrapperResponse = new LifeCycleReportingController.wrapper();
    	List<Account_Life_Cycle__c> lifeCycleList = [Select id,Tacticom__c,Account__c,Current_SOW_L3Mo__c,Segmentation__c,Previous_Stage__c,Stage__c,External_Key__c,Name,Lenses_Net_Sales_Last_12Mo__c,Account__r.CurrencyIsoCode,Account__r.OwnerId,Account__r.Owner.Name,Account__r.Name,Account__r.AMT_gross_sales__c from Account_Life_Cycle__c];
        System.debug(lifeCycleList.size());
        System.debug(lifeCycleList[0].Account__r.Owner.Name);
        currencyCode = lifeCycleList[0].Account__r.CurrencyIsoCode;
        wrapperResponse.lifeCycleWrapperList = lifeCycleList;
        String accountOwnerName;
        String objectName = 'Account_Life_Cycle__c';
        String fieldName ='Stage__c';
        Map<String,Decimal> stageNameMap = new Map<String,Decimal>();
        //Map<String,Decimal> stageRecordCountMap = new Map<String,Decimal>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(!stageNameMap.containsKey(pickListVal.getValue())){
                stageNameMap.put(pickListVal.getValue(), 0);
            }
        }
        Map<String,Decimal> stageRecordCountMap = new Map<String,Decimal>(stageNameMap);
        for(Account_Life_Cycle__c opp: lifeCycleList){
            if(stageNameMap.containsKey(opp.Stage__c)){
                count = stageNameMap.get(opp.Stage__c);
                stageNameMap.put(opp.Stage__c, count + opp.Lenses_Net_Sales_Last_12Mo__c);
                countOfAccounts = stageRecordCountMap.get(opp.Stage__c);
                stageRecordCountMap.put(opp.Stage__c, ++countOfAccounts);
            }
        }
        List<LifeCycleReportingController.stageObject> pickValList = new List<LifeCycleReportingController.stageObject>();
        for(String stage: stageNameMap.keySet()){
            LifeCycleReportingController.stageObject pickVal = new LifeCycleReportingController.stageObject();
            pickVal.stage = stage;
            pickVal.summation = stageNameMap.get(stage);
            pickVal.noOfRecords = stageRecordCountMap.get(stage);
            pickVal.accountCurrency = currencyCode;
            pickValList.add(pickVal);
        }
        wrapperResponse.pickVals = pickValList;
        System.debug(pickValList.size());
        System.debug(pickValList[0]);
        return wrapperResponse;
    }
    
    public class stageObject{
        @AuraEnabled public Decimal noOfRecords = 0;
        @AuraEnabled public String stage = '';
        @AuraEnabled public Decimal summation = 0;
        @AuraEnabled public String accountCurrency = '';
    }
    
    public class wrapper{
        @AuraEnabled
        public List<Account_Life_Cycle__c> lifeCycleWrapperList = new List<Account_Life_Cycle__c>(); 
        @AuraEnabled
        public List<LifeCycleReportingController.stageObject> pickVals = new List<LifeCycleReportingController.stageObject>();

    }
}