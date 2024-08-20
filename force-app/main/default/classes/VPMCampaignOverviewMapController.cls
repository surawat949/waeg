public without sharing class VPMCampaignOverviewMapController {

    public class DataSet{
        public DataSet(String AccountId, String CampaignName, String AccCampaignName, String AccountShippingStreet, String AccountShippingCity, String AccountShippingState, String AccountShippingPostalCode, String AccountNameText, String AccountHoyaAccountId, Boolean IsPresent, Integer VisitedSize, String AccountCountry, Boolean CampaignPriority, Datetime LastStoreVisitDate){
            this.AccountId = AccountId;
            this.CampaignName = CampaignName;
            this.AccCampaignName = AccCampaignName;
            this.AccountShippingStreet = AccountShippingStreet;
            this.AccountShippingCity = AccountShippingCity;
            this.AccountShippingState = AccountShippingState;
            this.AccountShippingPostalCode = AccountShippingPostalCode;
            this.AccountNameText = AccountNameText;
            this.AccountHoyaAccountId = AccountHoyaAccountId;
            this.IsPresent = IsPresent;
            this.VisitedSize = VisitedSize;
            this.AccountCountry = AccountCountry;
            this.CampaignPriority = CampaignPriority;
            this.LastStoreVisitDate = LastStoreVisitDate;

        }
        @AuraEnabled public String AccountId{get;set;}
        @AuraEnabled public String CampaignName{get;set;}
        @AuraEnabled public String AccCampaignName{get;set;}
        @AuraEnabled public String AccountShippingStreet{get;set;}
        @AuraEnabled public String AccountShippingCity{get;set;}
        @AuraEnabled public String AccountShippingState{get;set;}
        @AuraEnabled public String AccountShippingPostalCode{get;set;}
        @AuraEnabled public String AccountNameText{get;set;}
        @AuraEnabled public String AccountHoyaAccountId{get;set;}
        @AuraEnabled public Boolean IsPresent{get;set;}
        @AuraEnabled public Integer VisitedSize{get;set;}
        @AuraEnabled public String AccountCountry{get;set;}
        @AuraEnabled public Boolean CampaignPriority{get;set;}
        @AuraEnabled public Datetime LastStoreVisitDate{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<DataSet> getAccountCampaignMember(String CampaignId){

        List<Account_Campaing_Member__c> accCampMemberList = new List<Account_Campaing_Member__c>();
        if(String.isEmpty(CampaignId) || String.isBlank(CampaignId)){
            //get all from the system for the initial load
            accCampMemberList = [SELECT Id, Name, Account_Name__c, Campaign_Name__c, campaign_active__c,Campaign_Presented__c,
            Account_Name__r.Shop_Street__c,Account_Name__r.Shop_State__c, Account_Name__r.Shop_City__c, Account_Name__r.Shop_Postal_Code__c, Account_Name__r.Shop_Country__c, 
            Account_Name__r.Hoya_Account_ID__c, Account_Name__r.Name, Campaign_Priority__c, Account_Name__r.Last_Visit_date__c    
            FROM Account_Campaing_Member__c WHERE  campaign_active__c = true WITH USER_MODE ORDER BY LastModifiedDate DESC limit 500];
        } else {
            accCampMemberList = [SELECT Id, Name, Account_Name__c, Campaign_Name__c, campaign_active__c,Campaign_Presented__c,
            Account_Name__r.Shop_Street__c,Account_Name__r.Shop_State__c, Account_Name__r.Shop_City__c, Account_Name__r.Shop_Postal_Code__c, Account_Name__r.Shop_Country__c, 
            Account_Name__r.Hoya_Account_ID__c, Account_Name__r.Name, Campaign_Priority__c, Account_Name__r.Last_Visit_date__c     
            FROM Account_Campaing_Member__c WHERE  campaign_active__c = true AND Central_Campaign__c = :CampaignId WITH USER_MODE ORDER BY LastModifiedDate DESC limit 500];
        }
        
        Set<Id> accIds = new Set<Id>();
        for(Account_Campaing_Member__c eachACM : accCampMemberList) {
            accIds.add(eachACM.Account_Name__c);
        }

        Date today = date.today();    
        Integer dayNum = Math.mod(Date.newInstance(1900, 1, 7).daysBetween(today),7);
        Date lastDayofWeek;
        Date firstDayofWeek;
        Date nextWeekDayOfWeek;

        if(dayNum == 0){
            lastDayofWeek = today;
            firstDayofWeek = today-6;
            nextWeekDayOfWeek = today+8;
        }else{
            firstDayofWeek = today-(dayNum-1);
            lastDayofWeek = today+(4-(dayNum-1));
            nextWeekDayOfWeek = lastDayofWeek + 7;
        }

        // Get All Visits data
        List<Visits__c> visList = [SELECT Account__c, Start_Day__c FROM Visits__c WHERE (Account__c IN :accIds) AND (Visit_Type__c = 'Visit') AND (Start_Day__c >= :today) AND (Start_Day__c <= :nextWeekDayOfWeek) AND (Visit_Status__c = 'Planned') ORDER BY Start_Day__c DESC];
        Map<Id, Integer> mapAccToVisits = new Map<Id,Integer>();
        for (Visits__c eachVisit : visList) {
            if (!mapAccToVisits.containsKey(eachVisit.Account__c)) {
                Integer count = 1;
                mapAccToVisits.put(eachVisit.Account__c, count);
            } else {
                Integer existingCount = mapAccToVisits.get(eachVisit.Account__c);
                existingCount++;
                mapAccToVisits.put(eachVisit.Account__c, existingCount);
            }
            
        }

        List<DataSet> dataset = new List<DataSet>();
        for (Account_Campaing_Member__c eachACM : accCampMemberList) {
            String AccountId = (String)eachACM.Account_Name__c;
            String CampaignName = (String)eachACM.Campaign_Name__c;
            String AccCampaignName = (String)eachACM.Name;
            String AccountShippingStreet = (String)eachACM.Account_Name__r.Shop_Street__c;
            String AccountShippingCity = (String)eachACM.Account_Name__r.Shop_City__c;
            String AccountShippingState = (String)eachACM.Account_Name__r.Shop_State__c;
            String AccountShippingPostalCode = (String)eachACM.Account_Name__r.Shop_Postal_Code__c;
            String AccountNameText = (String)eachACM.Account_Name__r.Name;
            String AccountHoyaAccountId = (String)eachACM.Account_Name__r.Hoya_Account_ID__c;
            Boolean IsPresent = (Boolean)eachACM.Campaign_Presented__c; 
            Integer visitSize = 0;
            String AccountCountry = (String)eachACM.Account_Name__r.Shop_Country__c;
            if (mapAccToVisits.get(eachACM.Account_name__c) != null) {
                visitSize = mapAccToVisits.get(eachACM.Account_name__c);
            }
            Boolean CampaignPriority = (Boolean)eachACM.Campaign_Priority__c;
            Datetime LastStoreVisitDate = (Datetime)eachACM.Account_Name__r.Last_Visit_date__c;

            dataset.add(new DataSet(AccountId, CampaignName, AccCampaignName, AccountShippingStreet, AccountShippingCity, AccountShippingState, AccountShippingPostalCode, AccountNameText, AccountHoyaAccountId, IsPresent, visitSize, AccountCountry, CampaignPriority, LastStoreVisitDate));   
        }
        return dataset;
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getCampaignList(){
        List<optionSet> optionList = new List<optionSet>();
        String currentUser = UserInfo.getUserId();
        String companyName = [SELECT CompanyName FROM User WHERE Id=:currentUser].CompanyName;
        List<Campaign> campaignList = new List<Campaign>();

        if(String.isBlank(companyName) || String.isEmpty(companyName) || companyName == 'HVC'){
            campaignList = [SELECT Id, Name FROM Campaign WHERE IsActive=true WITH USER_MODE ORDER BY Name ASC LIMIT 500];
        }else{
            campaignList = [SELECT Id, Name FROM Campaign WHERE IsActive=true AND Campaign_Subsidiary__c =: companyName WITH SYSTEM_MODE ORDER BY Name ASC LIMIT 500];
        }
        
        for(Campaign c : campaignList){
            optionList.add(new optionSet(c.Name, c.Id));
        }

        return optionList;
    }

    public class optionSet{

        @AuraEnabled public string label;
        @AuraEnabled public string value;

        public optionSet(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
}