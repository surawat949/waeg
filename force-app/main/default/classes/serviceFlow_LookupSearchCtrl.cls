public class serviceFlow_LookupSearchCtrl {
    @AuraEnabled
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        for(sObject so : Database.Query('Select Id, Name, Shop_email_address__c,Brand__c, Phone, '+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\' LIMIT 20 ')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id, so));
        }
        return sObjectResultList;
    }
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public sObject sObjectRec;
        public SObJectResult(String recNameTemp, Id recIdTemp, sObject sObjectRecord) {
            recName = recNameTemp;
            recId = recIdTemp;
            sObjectRec = sObjectRecord;
        }
    }
}