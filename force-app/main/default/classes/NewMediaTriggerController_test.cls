/*
    ===================================================================
    New Media Usage Test for NewMediaTriggerController.cls (Class)
    Created by : Surawat Sakulmontreechai | sakulmontreechai@yahoo.com
    Created date : 2022-07-22
    ===================================================================
*/
@IsTest
public with sharing class NewMediaTriggerController_test {
    public NewMediaTriggerController_test() {

    }

    @IsTest
    static void runCtrldoNewMediaUsageAfterInsert(){

        Test.StartTest();

        String userId = UserInfo.getUserId();
        String seikoRecId = [SELECT Id FROM RecordType WHERE SObjectType='Account' AND DeveloperName='SEIKO_Entity'].Id;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'SO-08922091';
        a.Name = 'New Media Usage Test';
        a.OwnerId = userId;
        a.RecordTypeId = seikoRecId;
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Seiko_Data__c s = new Seiko_Data__c();
        s.Account__c = a.Id;
        s.Name = a.Name;
        s.CurrencyIsoCode = 'EUR';
        s.SEIKO_Xtranet__c = true;
        s.SEIKO_Vision_Xperience_iPAD__c = true;
        //s.Hoya_Account_Id__c = a.Hoya_Account_ID__c;
        insert s;

        New_Media_Usage__c n = new New_Media_Usage__c();
        n.Hoya_Account_ID__c = a.Id;
        n.External_key__c = a.Hoya_Account_Id__c+'-'+a.Name;
        n.Tool__c = 'SXN orders';
        insert n;

        New_Media_Usage__c n2 = new New_Media_Usage__c();
        n2.Hoya_Account_ID__c = a.Id;
        n2.External_key__c = a.Hoya_Account_Id__c+'-'+a.Name+'-eColumn';
        n2.Tool__c = 'eColumn Measurements';
        insert n2;
        
        New_Media_Usage__c n3 = new New_Media_Usage__c();
        n3.Hoya_Account_ID__c = a.Id;
        n3.External_key__c = a.Hoya_Account_Id__c+'-'+a.Name+'Measurements';
        n3.Tool__c = 'Measurements';
        insert n3;

        List<New_Media_Usage__c> listnewMedia = new List<New_Media_Usage__c>();
        List<New_Media_Usage__c> listnewMedia2 = new List<New_Media_Usage__c>();

        for(New_Media_Usage__c nn : listnewMedia){
            listnewMedia.add(nn);
        }

        for(New_Media_Usage__c nn : listnewMedia2){
            listnewMedia2.add(nn);
        }

        NewMediaTriggerController.doNewMediaUsageAfterInsert(listnewMedia);
        NewMediaTriggerController.doNewMediaUsageAfterInsert(listnewMedia2);

        system.assert(true);
        Test.StopTest();

    }
}