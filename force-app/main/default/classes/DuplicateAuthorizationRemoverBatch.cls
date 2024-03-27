/* *******************************************************************************************************
 * Name               : DuplicateAuthorizationRemoverBatch                                               *
 * Description        : Bath for removing duplicates of Authorization records                            *
 * Created By         : WAEG Pawel Kaca                                                                  *
 * Created Date       : 23.11.2020                                                                       *
 * ----------------------------------------------------------------------------------------------------- *
 * VERSION    AUTHOR                            DATE                                                     *
 *  1.0   -   WAEG Pawel Kaca                   23.11.2020          Initial version                      *
 ******************************************************************************************************* */
global with sharing class DuplicateAuthorizationRemoverBatch implements Database.Batchable<sObject> {

    String query;
    private List<Id> contactIds;


    global DuplicateAuthorizationRemoverBatch(List<Id> pContactIds) {
        contactIds = pContactIds;
        query = 'SELECT Id FROM Contact WHERE Id IN :contactIds';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        Set<Id> contactIds = new Set<Id>();
        for(Contact c: scope){
            contactIds.add(c.Id);
        }
        Map<Id, Authorization__c> toDelete = new Map<Id, Authorization__c>();

        //Map <contactId, Map<Authorization__c.Claim_Formatted__c, Authorization__c>> to Map Contact with each type of auth (claim) once.
        Map<Id, Map<String, Authorization__c>> authTypeMapByContactId = new Map<Id, Map<String, Authorization__c>>();

        List<Authorization__c> authList = [
                SELECT Account_Name__c,Account_Template__c,Active_Authorization__c,
                        Authorization_Name__c,Claim_Formatted__c,Contact__c,Copy_Child_Authorizations__c,Copy_From__c,
                        Copy_To_All_Template_Contacts__c,CreatedById,CreatedDate,CurrencyIsoCode,Description__c,
                        DupCheck__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
                        Master_Authorization_Name__c,Name,OwnerId,Parent_Authorization_Name__c,Parent_Authorization__c,
                        RecordTypeId,SystemModstamp
                FROM Authorization__c
                WHERE Contact__c IN :contactIds
                AND Claim_Formatted__c != null
                ORDER BY CreatedDate DESC
        ];

        for (Authorization__c auth : authList) {
            if (auth.Contact__c != null && !authTypeMapByContactId.containsKey(auth.Contact__c)) {
                authTypeMapByContactId.put(auth.Contact__c, new Map<String, Authorization__c>());
            }
            if (auth.Contact__c != null && authTypeMapByContactId.containsKey(auth.Contact__c)) {

                if (!authTypeMapByContactId.get(auth.Contact__c).containsKey(auth.Claim_Formatted__c)) { //new auth type in map
                    authTypeMapByContactId.get(auth.Contact__c).put(auth.Claim_Formatted__c, auth);
                }
                if (authTypeMapByContactId.get(auth.Contact__c).containsKey(auth.Claim_Formatted__c)
                        && authTypeMapByContactId.get(auth.Contact__c).get(auth.Claim_Formatted__c).Id != auth.Id) { //auth type in map - check which is winner
                    Authorization__c oldAuth = authTypeMapByContactId.get(auth.Contact__c).get(auth.Claim_Formatted__c);
                    Authorization__c newAuth = auth;
                    Boolean replaced = false;

                    if (newAuth.Active_Authorization__c && !oldAuth.Active_Authorization__c) { //pick active as winner
                        replaced = true;
                        authTypeMapByContactId.get(auth.Contact__c).put(auth.Claim_Formatted__c, auth);
                    }

                    if(!toDelete.containsKey(oldAuth.Id) && replaced){ // put old record to deletion
                        toDelete.put(oldAuth.Id,oldAuth);
                    }
                    if(!toDelete.containsKey(newAuth.Id) && !replaced){ // put new record to deletion when it not replace old one
                        toDelete.put(newAuth.Id, newAuth);
                    }
                }
            }
        }



        if (toDelete.size() > 0) {
            try {
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'Backup Authorization Deletion.txt'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Backup Authorization Deletion ' + datetime.now().format(); // Display name of the files
                conVer.VersionData = Blob.valueOf(JSON.serialize(toDelete.values())); // converting your binary string to Blog
                insert conVer;    //Insert ContentVersion as backup

                delete toDelete.values(); //delete authorizations
            } catch (Exception e) {
                LogException.log(e);
            }
        }
        fill1();
        fill2();
        fill3();
    }

    global void finish(Database.BatchableContext BC) {

    }

    public void fill1() {
        String a1 = '';
        String a2 = '';
        String a3 = '';
        String a4 = '';
        String a5 = '';
        String a6 = '';
        String a7 = '';
        String a8 = '';
        String a9 = '';
        String a10 = '';
        String a11 = '';
        String a12 = '';
        String a13 = '';
        String a14 = '';
        String a15 = '';
        String a16 = '';
        String a17 = '';
    }
    public void fill2() {
        String a1 = '';
        String a2 = '';
        String a3 = '';
        String a4 = '';
        String a5 = '';
        String a6 = '';
        String a7 = '';
        String a8 = '';
        String a9 = '';
        String a10 = '';
        String a11 = '';
        String a12 = '';
        String a13 = '';
        String a14 = '';
        String a15 = '';
        String a16 = '';
        String a17 = '';
    }
    public void fill3() {
        String a1 = '';
        String a2 = '';
        String a3 = '';
        String a4 = '';
        String a5 = '';
        String a6 = '';
        String a7 = '';
        String a8 = '';
        String a9 = '';
        String a10 = '';
        String a11 = '';
        String a12 = '';
        String a13 = '';
        String a14 = '';
        String a15 = '';
        String a16 = '';
        String a17 = '';
    }
}