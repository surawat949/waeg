public class serviceFlow_EmailMessageTriggerHandler
{
    public static Map < String, ServiceFlowEmailConfig__mdt > getMetaConfig()
    {
        Map < String, ServiceFlowEmailConfig__mdt > mapOfConfig = new Map < String, ServiceFlowEmailConfig__mdt > ();
        for (ServiceFlowEmailConfig__mdt config: ServiceFlowEmailConfig__mdt.getAll().values())
        {
            mapOfConfig.put(config.Label, config);
        }
        return mapOfConfig;
    }
    public static void updateCaseDetails(List < EmailMessage > listOfEmailMessages)
    {
        String recordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
        Map < String, String > parentMap = new Map < String, String > ();
        for (EmailMessage emailMessage: listOfEmailMessages)
        {
            String caseRecordId = emailMessage.ParentId;
            if (String.isNotBlank(emailMessage.ParentId) && caseRecordId.startsWithIgnoreCase('500'))
            {
                parentMap.put(emailMessage.ParentId, emailMessage.ToAddress);
            }
        }
        if (parentMap.size() > 0)
        {
            List < Case > caseList = [
                Select Id, RecordTypeId, Priority, Origin, OwnerId,User_country__c, SFlow_Subject__c, SFlow_Sub_Subject__c From Case
                Where Id IN: parentMap.keySet() AND RecordTypeId =:recordTypeId
            ];
            Map < String, ServiceFlowEmailConfig__mdt > configMap = getMetaConfig();
            for (Case caseRec: caseList)
            {
                String emailAddress = parentMap.get(caseRec.Id);
                if (configMap.containsKey(emailAddress))
                {
                    ServiceFlowEmailConfig__mdt emailConfigRec = configMap.get(emailAddress);
                    mapCaseDetailsUtility(caseRec,emailConfigRec);
                }
            }
            update caseList;
        }
    }
    public static void mapCaseDetailsUtility(Case caseRec, ServiceFlowEmailConfig__mdt emailConfigRec){
        caseRec.Priority = emailConfigRec.Priority__c;
        caseRec.User_country__c = emailConfigRec.User_Country__c;
        caseRec.SFlow_Subject__c = emailConfigRec.Subject__c;
        caseRec.SFlow_Sub_Subject__c = emailConfigRec.Sub_Subject__c;
    }
}