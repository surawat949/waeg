public with sharing class visitZonesMapController {

    public class DataSet{
        public DataSet(String AccountId, String Hoya_Account_Id, String AccountName, String VisitZone, String AccountStreet, String AccountCity, String AccountState, String AccountPostalCode, String AccountCountry, Integer VisitCouter, Double AccountShippingLatitude, Double AccountShippingLongitude,String Segmentation,Decimal plannedVisits,DateTime LastVisitDate){
            this.AccountId = AccountId;
            this.Hoya_Account_Id = Hoya_Account_Id;
            this.AccountName = AccountName;
            this.VisitZone = VisitZone;
            this.AccountStreet = AccountStreet;
            this.AccountCity = AccountCity;
            this.AccountState = AccountState;
            this.AccountPostalCode = AccountPostalCode;
            this.AccountCountry = AccountCountry;
            this.VisitCouter = VisitCouter;
            this.AccountShippingLatitude = AccountShippingLatitude;
            this.AccountShippingLongitude = AccountShippingLongitude;
            this.Segmentation = Segmentation;
            this.TotalVisitsPlanned = plannedVisits;
            this.LastVisitDate = LastvisitDate;
        }

        @AuraEnabled public String AccountId{get;set;}
        @AuraEnabled public String Hoya_Account_Id{get;set;}
        @AuraEnabled public String AccountName{get;set;}
        @AuraEnabled public String VisitZone{get;set;}
        @AuraEnabled public String AccountStreet{get;set;}
        @AuraEnabled public String AccountCity{get;set;}
        @AuraEnabled public String AccountState{get;set;}
        @AuraEnabled public String AccountPostalCode{get;set;}
        @AuraEnabled public String AccountCountry{get;set;}
        @AuraEnabled public Integer VisitCouter{get;set;}
        @AuraEnabled public Double AccountShippingLatitude{get;set;}
        @AuraEnabled public Double AccountShippingLongitude{get;set;}
        @AuraEnabled public String Segmentation{get;set;}
        @AuraEnabled public Decimal TotalVisitsPlanned{get;set;}
        @AuraEnabled public DateTime LastVisitDate{get;set;}
        
    }

    @AuraEnabled(cacheable=true)
    public static List<DataSet> getAccountForMapData(String ZoneName, Boolean IsSelected, Id userId, Integer numberofDays){
        String currentUserLoginId = userId;
        List<Account> accountList = new List<Account>();

        If((String.isEmpty(ZoneName) || String.isBlank(ZoneName)) && (IsSelected == false)){
            accountList = [SELECT Id, Hoya_Account_ID__c,Segmentation_Net__c,Total_Visits_Planned__c,Last_Visit_date__c, Name, OwnerId, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c,
                            Shop_Country__c, TACTICOM_SOF__c, ShippingLatitude, ShippingLongitude FROM Account WHERE (OwnerId=:currentUserLoginId) AND (Account_Status__c != 'Closed') 
                            AND (TACTICOM_SOF__c != null) ORDER BY Name ASC];
        }else if((String.isEmpty(ZoneName) || String.isBlank(ZoneName)) && (IsSelected == true)){
            accountList = [SELECT Id, Hoya_Account_ID__c,Segmentation_Net__c,Total_Visits_Planned__c,Last_Visit_date__c, Name, OwnerId, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c,
                            Shop_Country__c, TACTICOM_SOF__c, ShippingLatitude, ShippingLongitude FROM Account WHERE (OwnerId=:currentUserLoginId) AND (Account_Status__c != 'Closed') 
                            AND (TACTICOM_SOF__c != null) AND (TACTICOM_SOF__c != 'Not Selected') ORDER BY Name ASC];

        }else{
            accountList = [SELECT Id, Hoya_Account_ID__c,Segmentation_Net__c,Total_Visits_Planned__c,Last_Visit_date__c, Name, OwnerId, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c,
                            Shop_Country__c, TACTICOM_SOF__c, ShippingLatitude, ShippingLongitude FROM Account WHERE (OwnerId=:currentUserLoginId) AND (Account_Status__c != 'Closed') 
                            AND (TACTICOM_SOF__c =: ZoneName) AND (TACTICOM_SOF__c != null) ORDER BY Name ASC];
        }

        Set<Id> accountIds = new Set<Id>();
        for(Account eachAcc : accountList){
            accountIds.add(eachAcc.Id);
        }
        System.debug('accountIds'+accountIds);

        //get visits data base on above soql in the account id and Assign_to__c in Visits__c object
        //this is just only numeric, to check has LAST 7 days visited or not

       /* List<Visits__c> visitList = [SELECT Id, Account__c, Assigned_to__c FROM Visits__c WHERE (Assigned_to__c=:currentUserLoginId) 
                                        AND (Account__c IN:accountIds) AND (Visit_Status__c IN ('Planned', 'Complete')) AND (Visit_Type__c = 'Visit') 
                                        AND Start_Day__c = LAST_N_DAYS:numberofDays ];*/
        String query = 'SELECT Id, Account__c, Assigned_to__c FROM Visits__c WHERE Assigned_to__c = :currentUserLoginId' +
               ' AND Account__c IN :accountIds' +
               ' AND Visit_Status__c IN (\'Planned\', \'Complete\')' +
               ' AND Visit_Type__c = \'Visit\'';
        if(numberofDays > 7){
            query += ' AND (Start_Day__c = LAST_N_DAYS:30 OR Start_Day__c = NEXT_N_DAYS:7)';
        }else{
             query += ' AND Start_Day__c = LAST_N_DAYS:7';
        }

        List<Visits__c> visitList = Database.query(query);
        System.debug('visitList'+visitList);
        Map<Id, Integer> mapAccToVisits = new Map<Id, Integer>();

        for(Visits__c eachVisit : visitList){
                    System.debug('eachVisit'+eachVisit.Account__c);
            if(!mapAccToVisits.containsKey(eachVisit.Account__c)){
                Integer count = 1;
                mapAccToVisits.put(eachVisit.Account__c, count);
            }else{
                Integer existingCount = mapAccToVisits.get(eachVisit.Account__c);
                existingCount++;
                mapAccToVisits.put(eachVisit.Account__c, existingCount);
            }
        }

        List<DataSet> dataset = new List<DataSet>();
        for(Account eachAccount : accountList){
            String AccountId = (String)eachAccount.Id;
            String Hoya_Account_Id = (String)eachAccount.Hoya_Account_ID__c;
            String AccountName = (String)eachAccount.Name;
            String VisitZone = (String)eachAccount.TACTICOM_SOF__c;
            String AccountStreet = (String)eachAccount.Shop_Street__c;
            String AccountCity = (String)eachAccount.Shop_City__c;
            String AccountState = (String)eachAccount.Shop_State__c;
            String AccountPostalCode = (String)eachAccount.Shop_Postal_Code__c;
            String AccountCountry = (String)eachAccount.Shop_Country__c;
            Integer VisitCounter;
            if(mapAccToVisits.get(eachAccount.Id)!=null){
                VisitCounter = mapAccToVisits.get(eachAccount.Id);
            }
            Double AccountShippingLatitude = (Double)eachAccount.ShippingLatitude;
            Double AccountShippingLongitude = (Double)eachAccount.ShippingLongitude;

            dataset.add(new DataSet(AccountId, Hoya_Account_Id, AccountName, VisitZone, AccountStreet, AccountCity, AccountState, AccountPostalCode, AccountCountry, VisitCounter, AccountShippingLatitude, AccountShippingLongitude,eachAccount.Segmentation_Net__c,eachAccount.Total_Visits_Planned__c,eachAccount.Last_Visit_date__c));

        }
        return dataset;
    }
    @AuraEnabled public static Map<String, String> getTranslations(){
        return Utility.getTranslatedPicklistValues('Account', 'Tacticom_SOF__c');
    }
}