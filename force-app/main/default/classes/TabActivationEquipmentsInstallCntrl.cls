public class TabActivationEquipmentsInstallCntrl {
    @AuraEnabled
   public static List<Equipment__c> getInstruInShop(Id recordId){
        List<Equipment__c> e = [SELECT Id,Name, Brand2__c, Model2__c, Subtype__c, Shipment_Date__c, Installation_Date__c
                                    FROM Equipment__c WHERE (Account__c=:recordId) AND
                                    (Subtype__c IN ('EyeGenius', 'iPad', 'iPad Apple', 'Kit PDM', 'Measurement', 'PC', 'Refraction', 'Tracer', 'Video Centration System (VCS)', 'Visualreal', 'Visualreal portable', 'Yuniku', 'SEIKO Displays', 'SEIKO Display', 'Seiko SVS'))];
        return e;
   }

   @AuraEnabled
   public static List<Equipment__c> getSoftwareInShop(Id recordId){
        List<Equipment__c> c = [SELECT Id,Name, Brand2__c, Model2__c, Subtype__c, Shipment_Date__c, Installation_Date__c 
                                FROM Equipment__c WHERE (Account__c=:recordId) AND 
                                (Subtype__c IN ('IPADapp','Ordering Software','PMS','Software', 'Web tools'))];
        return c;
   }

}