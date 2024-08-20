public with sharing class ActiveCampaignMemberControler {
    public ActiveCampaignMemberControler() {

    }
    @AuraEnabled
    public static List<Account_Campaing_Member__c> getCampaignMemberList(Id accId){
        System.debug('XXX getCampaignMemberList execute for id=' + accId);
        Date endDate = Date.today().addMonths(-2);

        List<Account_Campaing_Member__c> result= [SELECT  Name,id, Central_Campaign__c, Account_Name__c, Campaign_Start_Date_t__c, Campaign_End_Date_t__c, campaign_active__c
        , Central_Campaign__r.name, Campaign_Name__c,Campaign_Presented__c
         FROM Account_Campaing_Member__c WHERE Account_Name__c=:accId AND campaign_active__c=true 
         and Campaign_End_Date_t__c>=:endDate
         order by Campaign_Start_Date_t__c desc, Campaign_End_Date_t__c desc];
        
        for(Account_Campaing_Member__c m:result){
            System.debug('Member_name:'+m.name);
        }
        System.debug('Member List Size=' + result.size());
        return result;
    }

    @AuraEnabled
    public static void saveCampaignMember(Id cmId, boolean presented){
        System.debug('XXX call saveCampaignMember (' + cmId + ',' + presented + ')');
        List<Account_Campaing_Member__c> acmList = [SELECT id, name,Campaign_Presented__c FROM Account_Campaing_Member__c WHERE id=:cmId ];
        Account_Campaing_Member__c acm = acmList.get(0);
        acm.Campaign_Presented__c = presented;
        update acm;
        System.debug(cmId + ' saved');
    }
}