// serviceFlow_ChatAttachedCases.cls
public class serviceFlow_ChatAttachedCases {
    @AuraEnabled(cacheable=true)
    public static List<CaseWrapper> getChatCases(String recordId){
        LiveChatTranscript chatRec = [Select Id,Hoya_Account_ID__c From LiveChatTranscript Where Id=:recordId];
        List<CaseWrapper> cases = new List<CaseWrapper>();
        for (Case caseRec : [Select Id, CaseNumber,AccountId,Account.Hoya_Account_ID__c,Description,CreatedDate From Case Where Account.Hoya_Account_ID__c =: chatRec.Hoya_Account_ID__c And Origin='Chat']) {
            cases.add(new CaseWrapper(caseRec));
        }
        return cases;
    }

    public class CaseWrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String CaseNumber { get; set; }
        @AuraEnabled public String ViewRecordUrl { get; set; }
        @AuraEnabled public String CreatedDate { get; set; }
        
        @AuraEnabled public String AccountId { get; set; }
        @AuraEnabled public String Hoya_Account_ID { get; set; }
        @AuraEnabled public String Description { get; set; }
        public CaseWrapper(Case caseRec) {
            this.Id = caseRec.Id;
            this.CaseNumber = caseRec.CaseNumber;
            this.CreatedDate = String.valueOf(caseRec.CreatedDate.date());
            this.AccountId = caseRec.AccountId;
            this.Hoya_Account_ID = caseRec.Account.Hoya_Account_ID__c;
            this.Description = caseRec.Description;
            this.ViewRecordUrl = '/lightning/r/Case/'+caseRec.Id+'/view';
        }
    }
}