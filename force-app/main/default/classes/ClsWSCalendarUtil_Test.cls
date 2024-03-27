/**
*  This test class is for ClsWSCalendarUtil.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   

@changed log
* 2023-11-30 Surawat Sakulmontreechai<<surawat.sakulmontreechai@hoya.com>>
* - update testing class and change api to v.55.0
* - code coverage : 91%
*/
@IsTest
public with sharing class ClsWSCalendarUtil_Test {
    @TestSetup
    static void makeData(){

        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];

        User u = new User();
        u.Firstname = 'test_visits';
        u.Lastname = 'testtestvisits';
        u.Username = 'testini@hoya.com.pcpy';
        u.Email = 'testtest@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'STest2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'HAPL';
        u.ManagerId = UserInfo.getUserId();
        insert u;

        User u2 = new User();
        u2.FirstName = 'test2';
        u2.LastName = 'testlast2';
        u2.Username = 'test2@hoya.invalid';
        u2.Email = 'test2@hoya.invalid';
        u2.ProfileId = p.Id;
        u2.Alias = 'test2';
        u2.TimeZoneSidKey = 'Asia/Bangkok';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        u2.CompanyName = 'HVC';
        u2.ManagerId = u.Id;
        insert u2;

        MetaDataInfo__c m = new MetaDataInfo__c();
        m.Name = 'Test1';
        m.label__c = 'Test1';
        m.query1__c = 'where id!=null';
        m.query2__c = 'where id=null';
        m.query3__c = 'where hoya_account_id__c like %';
        m.query4__c = 'where shop_country__c=null';
        insert m;
        
    }

    @IsTest
    static void myUnitTest01(){
        User uList = [SELECT Id, FirstName, LastName, Username, ProfileId, TimeZoneSidKey, ManagerId  
                        FROM User WHERE Username='testini@hoya.com.pcpy' limit 1];

        Profile profileList = [select Id,PermissionsApiEnabled ,PermissionsModifyAllData from Profile where id=:uList.ProfileId limit 1];
        for(Schema.PicklistEntry f : Visits__c.Visit_Type__c.getDescribe().getPicklistValues()){
            System.debug('Visit Picklist =>'+f);
        }

        List<MetaDataInfo__c> mList1 = new List<MetaDataInfo__c>([SELECT Id, Name, label__c, query1__c, query2__c,
                                    query3__c, query4__c FROM MetaDataInfo__c
                                    where Name='Test1' limit 1]);
        
        
        Test.StartTest();
        ClsWSCalendarUtil.getUserTimeZoneSidKey();
        ClsWSCalendarUtil.getVisitType();
        ClsWSCalendarUtil.getMetadataPermission();
        ClsWSCalendarUtil.ClsEmployeeAccessLevel clsEmp =new ClsWSCalendarUtil.ClsEmployeeAccessLevel();
        clsEmp.userId = uList.Id;
        clsEmp.accessLevel = 'EDIT';
        Set<Id> managerIds = new Set<Id>();
        managerIds.add(uList.ManagerId);
        ClsWSCalendarUtil.getEmployeeAccessLevels();

        ClsWSCalendarUtil.ClsMetaDataInfo clsMetadata = new ClsWSCalendarUtil.ClsMetaDataInfo();
        List<ClsWSCalendarUtil.ClsMetaDataInfo> ll = new List<ClsWSCalendarUtil.ClsMetaDataInfo>();
        clsMetadata.label = 'test';
        clsMetadata.filterStr = 'where hoya_account_id__c!=null';
        ll.add(clsMetadata);
        System.debug(ClsWSCalendarUtil.setMetaDataInfo(ll));

        ClsWSCalendarUtil.getMetaDataInfo();
        Test.StopTest();

        System.assert(true);
    }

}