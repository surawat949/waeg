public with sharing class serviceFlowActiveCampaignMemberControler {

    @AuraEnabled
    public static List<Account_Campaing_Member__c> getCampaignMemberList(Id recordId) {
        String objectName = recordId.getSObjectType().getDescribe().getName();
        String hoyaAccountId = '';

        if (objectName == 'Case') {
            hoyaAccountId = getHoyaAccountIdFromCase(recordId);
        } else if (objectName == 'LiveChatTranscript') {
            hoyaAccountId = getHoyaAccountIdFromLiveChatTranscript(recordId);
        }

        if (String.isNotBlank(hoyaAccountId)) {
            Date endDate = Date.today().addMonths(-2);
            return [
                SELECT Name, Id, Central_Campaign__c, Account_Name__c, Campaign_Start_Date_t__c, Campaign_End_Date_t__c, campaign_active__c,
                    Central_Campaign__r.Name, Campaign_Name__c, Campaign_Presented__c
                FROM Account_Campaing_Member__c/*
                WHERE Account_Name__r.Hoya_Account_ID__c = :hoyaAccountId
                    AND campaign_active__c = true
                    AND Campaign_End_Date_t__c >= :endDate
                ORDER BY Campaign_Start_Date_t__c DESC, Campaign_End_Date_t__c DESC*/
            ];
        }

        return new List<Account_Campaing_Member__c>();
    }

    public static String getHoyaAccountIdFromCase(Id caseId) {
        Case caseRec = [SELECT Id, Account.Hoya_Account_ID__c FROM Case WHERE Id = :caseId AND Account.Hoya_Account_ID__c != null LIMIT 1];
        return caseRec != null ? caseRec.Account.Hoya_Account_ID__c : '';
    }

    public static String getHoyaAccountIdFromLiveChatTranscript(Id transcriptId) {
        LiveChatTranscript transcriptRec = [SELECT Id, Hoya_Account_ID__c FROM LiveChatTranscript WHERE Id = :transcriptId AND Hoya_Account_ID__c != null LIMIT 1];
        return transcriptRec != null ? transcriptRec.Hoya_Account_ID__c : '';
    }
}