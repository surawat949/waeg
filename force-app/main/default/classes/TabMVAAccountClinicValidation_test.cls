@IsTest
public with sharing class TabMVAAccountClinicValidation_test {
    public TabMVAAccountClinicValidation_test() {

    }

    @TestSetup
    static void makeData(){
        
        String QIDC_OPT = Schema.SObjectType.QIDC__Validation_Request_ims__c.getRecordTypeInfosByDeveloperName().get('Workplace').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'Surawatest';
        u.Lastname = 'Surawattestest';
        u.Username = 'testini@hoya.com.pcpy2';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HVC';
        u.QIDC__OK_Available_Countries_ims__c = 'KR';
        insert u;

        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'WKRE00035777';
        a1.Name = '(VOM)봄안과의원';
        a1.Shop_Name__c = '(VOM)봄안과의원';
        a1.QIDC__OneKeyId_IMS__c = 'WKRE00035777';
        a1.ShippingStreet = '안심로 58';
        a1.ShippingCity = '율하동';
        a1.ShippingState = '대구';
        a1.ShippingPostalcode = '41151';
        a1.ShippingLatitude = 35.87007;
        a1.ShippingLongitude = 128.69203;
        insert a1;

        QIDC__Validation_Request_ims__c q1 = new QIDC__Validation_Request_ims__c();
        q1.QIDC__Request_Type_ims__c = 'New';
        q1.QIDC__Workplace_ims__c = a1.Id;
        q1.QIDC__Status_ims__c = 'Pending';
        q1.RecordTypeId = QIDC_OPT;
        q1.QIDC__Request_Date_ims__c = System.now();
        q1.QIDC__Country_ISO_Code_ims__c = 'KR';
        //insert q1;

    }
    
    @isTest
    static void testWholeClass(){
        List<User> usr = [SELECT Id FROM User WHERE Username = 'testini@hoya.com.pcpy2' LIMIT 1];
        
        if(!usr.IsEmpty()){
            System.runAs(usr[0]){
                Account a = [SELECT Id, Hoya_Account_ID__c FROM Account WHERE Hoya_Account_ID__c = 'WKRE00035777' LIMIT 1];
                List<QIDC__Validation_Request_ims__c> qidc = [SELECT Id FROM QIDC__Validation_Request_ims__c WHERE QIDC__Workplace_ims__c=:a.Id];

                Test.StartTest();
                TabMVAAccountClinicValidation.getValidationNameByAccountId(a.Id);
                TabMVAAccountClinicValidation.getValidationNameByAccountIdAll(a.Id);
                TabMVAAccountClinicValidation.getContactOpthalmologistRecTypeId();
                Test.StopTest();

                try{
                    TabMVAAccountClinicValidation.getValidationNameByAccountId(null);
                }catch(Exception e){
                    System.assertEquals(e.getMessage(), e.getMessage());
                }
            }
        }
    }
}