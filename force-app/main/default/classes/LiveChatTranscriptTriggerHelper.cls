public class LiveChatTranscriptTriggerHelper {
    public static Id customerServiceContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('serviceFlow_Customer_Service_Contact').getRecordTypeId();
    public static void doPopulateContactToAgent(List<LiveChatTranscript> liveChatTranscriptList) {
        Map<String, String> emailHoyaCombinationMap = new Map<String, String>();
        for (LiveChatTranscript liveChatTranscriptRecord : liveChatTranscriptList) {
            emailHoyaCombinationMap.put(liveChatTranscriptRecord.Hoya_Account_ID__c, liveChatTranscriptRecord.Customer_Email__c);
        }
        if (!emailHoyaCombinationMap.isEmpty()) {
            Map<String, Contact> conMap  = getContactsByEmailAndAccount(emailHoyaCombinationMap);
            Map<String, Account> acctMap = getAccountsByHoyaAccountID(emailHoyaCombinationMap.keySet());
            linkTranscriptsToContactsAndAccounts(liveChatTranscriptList, conMap, acctMap);
        }
        
    }
    public static void doUpdateContactDetails(List<LiveChatTranscript> liveChatTranscriptList){
        Map<String, String> hoyaIdContactIdMap = new Map<String, String>();
        for (LiveChatTranscript liveChatTranscriptRecord : liveChatTranscriptList) {
            hoyaIdContactIdMap.put(liveChatTranscriptRecord.Hoya_Account_ID__c,liveChatTranscriptRecord.ContactId);
        }
        if (!hoyaIdContactIdMap.isEmpty()) {
            Map<String, Account> acctMap = getAccountsByHoyaAccountID(hoyaIdContactIdMap.keySet());
            updateContact(hoyaIdContactIdMap,acctMap);
        }
    }
    
    public static void updateContact(Map<String, String> hoyaIdContactIdMap, Map<String, Account> acctMap){
        List<Contact> conList = [Select Id,RecordTypeId,AccountId from Contact Where Id IN : hoyaIdContactIdMap.values()];
        if(!conList.isEmpty()){
            for(String hoyaAccountId : hoyaIdContactIdMap.keySet()){
                for(Contact conUpdate : conList){
                    conUpdate.RecordTypeId = customerServiceContactRecordTypeId;
                    if(acctMap.containsKey(hoyaAccountId)){
                        conUpdate.AccountId = acctMap.get(hoyaAccountId).Id;
                    }
                }
            }
        }
        update conList;
    }

    public static Map<String, Account> getAccountsByHoyaAccountID(Set<String> hoyaAccountIdSet) {
        Map<String, Account> acctMap = new Map<String, Account>();
        for (Account accountRec : [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c IN :hoyaAccountIdSet]) {
            acctMap.put(accountRec.Hoya_Account_ID__c, accountRec);
        }
        return acctMap;
    }

    public static Map<String, Contact> getContactsByEmailAndAccount(Map<String, String> emailHoyaCombinationMap) {
        Map<String, Contact> conMap = new Map<String, Contact>();
        for (Contact contactRec : [SELECT Id, Email, AccountId, Account.Hoya_Account_ID__c FROM Contact WHERE Account.Hoya_Account_ID__c IN :emailHoyaCombinationMap.keySet() AND Email IN :emailHoyaCombinationMap.values()]) {
            conMap.put(contactRec.Account.Hoya_Account_ID__c, contactRec);
        }
        return conMap;
    }

    public static void linkTranscriptsToContactsAndAccounts(List<LiveChatTranscript> liveChatTranscriptList, Map<String, Contact> conMap, Map<String, Account> acctMap) {
        for (LiveChatTranscript liveChatTranscriptRecord : liveChatTranscriptList) {
            String hoyaAccountId = liveChatTranscriptRecord.Hoya_Account_ID__c;
            if (conMap.containsKey(hoyaAccountId)) {
                Contact relatedContact = conMap.get(hoyaAccountId);
                liveChatTranscriptRecord.ContactId = relatedContact.Id;
                //liveChatTranscriptRecord.AccountId = relatedContact.AccountId;
            }
            if (acctMap.containsKey(hoyaAccountId)) {
                Account relatedAccount = acctMap.get(hoyaAccountId);
                liveChatTranscriptRecord.AccountId = relatedAccount.Id;
            }
        }
    }
}