/**
 * @Aurthor : Surawat Sakulmontreechai
 * @Email : surawat.sakulmontreechai@hoya.com
 * @CreatedDate : 2024-06-14
 * @Description :   Support for Task-1479 | Map implementation | https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1479/
 *                  We use Account.TACTICOM_SOF__c in the criteria for Visit Zone.
 *                  We can user lat/long from Account.ShippingLatitude / Account.ShippingLongitude
 *                  But for the address, we still using from Shop_Street__c, Shop_City, Shop_State__c, Shop_Postal_Code__c, Shop_Country__c
 * @Created By : Surawat Sakulmontreechai
 */
public with sharing class visitZonesMapController {

    public class DataSet{
        public DataSet(String AccountId, String Hoya_Account_Id, String AccountName, String VisitZone, String AccountStreet, String AccountCity, String AccountState, String AccountPostalCode, String AccountCountry, Integer VisitCouter, Double AccountShippingLatitude, Double AccountShippingLongitude){
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
    }

    @AuraEnabled(cacheable=true)
    public static List<DataSet> getAccountForMapData(String ZoneName){
        String currentUserLoginId = UserInfo.getUserId();
        //System.debug('Visit Zone = > '+ZoneName);
        //get data for the account first
        List<Account> accountList = new List<Account>();

        If(String.isEmpty(ZoneName) || String.isBlank(ZoneName)){
            accountList = [SELECT Id, Hoya_Account_ID__c, Name, OwnerId, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c,
                            Shop_Country__c, TACTICOM_SOF__c, ShippingLatitude, ShippingLongitude FROM Account WHERE (OwnerId=:currentUserLoginId) AND (Account_Status__c != 'Closed') 
                            AND (TACTICOM_SOF__c != null) ORDER BY Name ASC];
        }else{
            accountList = [SELECT Id, Hoya_Account_ID__c, Name, OwnerId, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c,
                            Shop_Country__c, TACTICOM_SOF__c, ShippingLatitude, ShippingLongitude FROM Account WHERE (OwnerId=:currentUserLoginId) AND (Account_Status__c != 'Closed') 
                            AND (TACTICOM_SOF__c =: ZoneName) AND (TACTICOM_SOF__c != null) ORDER BY Name ASC];
        }

        Set<Id> accountIds = new Set<Id>();
        for(Account eachAcc : accountList){
            accountIds.add(eachAcc.Id);
        }

        //get visits data base on above soql in the account id and Assign_to__c in Visits__c object
        //this is just only numeric, to check has LAST 7 days visited or not

        List<Visits__c> visitList = [SELECT Id, Account__c, Assigned_to__c FROM Visits__c WHERE (Assigned_to__c=:currentUserLoginId) 
                                        AND (Account__c IN:accountIds) AND (Visit_Status__c IN ('Planned', 'Complete')) AND (Visit_Type__c = 'Visit') 
                                        AND Start_Day__c = LAST_N_DAYS:7];
        Map<Id, Integer> mapAccToVisits = new Map<Id, Integer>();

        for(Visits__c eachVisit : visitList){
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

            dataset.add(new DataSet(AccountId, Hoya_Account_Id, AccountName, VisitZone, AccountStreet, AccountCity, AccountState, AccountPostalCode, AccountCountry, VisitCounter, AccountShippingLatitude, AccountShippingLongitude));

        }
        //System.debug('Data Set == > '+dataset.size()+' record(s) & Data == > '+dataset);
        return dataset;

    }
}