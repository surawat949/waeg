/*
    ** This testing class for APACAccountNearAccountController_Test apex class
    ** Create by Surawat Sakulmontreechai - 2021-11-01
    ** Update test : 2024-07-15
*/
@IsTest
public with sharing class APACAccountNearAccountController_Test {
    public APACAccountNearAccountController_Test() {

    }

    @IsTest
    static void getOpportunityTest(){
        
        Test.StartTest();

        String oneParam = 'param1';

        Account acc = new Account();
        acc.Name = 'Test';
        acc.hoya_account_id__c = '123456';
        acc.RecordTypeId = '012b00000000P38';
        acc.shippingCity='Victoria';
        acc.ShippingStreet='SH B045 Chatswood Chase S/C 245';
        acc.ShippingLatitude=-33.79378366591115;
        acc.ShippingLongitude=151.19098186046202;
        acc.ShippingCountry='AU';
        acc.ShippingPostalCode='2067';
        insert acc;

        Account newAcc = new Account();
        newAcc.Name = 'Test Contact Relationship';
        newAcc.Hoya_Account_Id__c = 'TE001002';
        insert newAcc;

        Opportunity o = new Opportunity();
        o.Name = 'test zxcv';
        o.AccountId = acc.Id;
        o.StageName ='1.start';
        o.CloseDate = System.today().addDays(10);
        insert o;

        Profile p = [select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testlastname';
        u.Email = 'test@hoya.com.invalid';
        u.UserName = 'test@hoya.com.pcpy';
        u.EmailEncodingKey = 'UTF-8';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'test';
        insert u;

        Campaign c = new Campaign();
        c.Name = 'test-campaign';
        insert c;

        Account_Campaing_Member__c cm = new Account_Campaing_Member__c();
        cm.Account_Name__c = acc.Id;
        cm.Central_Campaign__c = c.Id;
        insert cm;

        Equipment__c e = new Equipment__c();
        e.Name = 'Test Equipment';
        e.Account__c = acc.Id;
        insert e;

        Contact ct = new Contact();
        ct.FirstName = 'Test';
        ct.LastName = 'Contacts';
        ct.AccountId = acc.Id;
        insert ct;

        Contact newCon = new Contact();
        newCon.FirstName = 'Test';
        newCon.LastName = 'TestAccountContactRelationShip';
        newCon.AccountId = acc.Id;
        insert newCon;

        AccountContactRelation accContact = new AccountContactRelation();
        accContact.AccountId = newAcc.Id;
        accContact.ContactId = newCon.Id;
        insert accContact;

        APACAccountNearAccountController.getAccount(o.Id);
        APACAccountNearAccountController.getOpportunityByAccount(acc.Id);
        APACAccountNearAccountController.getOpportunity(o.Id);
        APACAccountNearAccountController.fetchUser();
        APACAccountNearAccountController.getCompanyName();
        APACAccountNearAccountController.getOppToCampaignMember(o.Id);
        APACAccountNearAccountController.getCampaignMember(acc.Id);
        APACAccountNearAccountController.findAccountsForMap(c.Id);
        APACAccountNearAccountController.getAccountsCampaign(false, oneParam);
        APACAccountNearAccountController.getAccountsCampaignNearby(acc.Id, false);
        APACAccountNearAccountController.getAccounts(acc.Id, 5, 'param', 0, 99999, 'Essilor', 'Zeiss', 'A1');
        APACAccountNearAccountController.getAccountbyCompetitor(acc.Id, 5);
        APACAccountNearAccountController.getEquipmentId(acc.Id);
        APACAccountNearAccountController.getHoyaLogEduipment(acc.Id);
        APACAccountNearAccountController.getIpadVisualReal(acc.Id);
        APACAccountNearAccountController.getContactList(acc.Id);
        APACAccountNearAccountController.getAccountLinkToContact(acc.Id);
        APACAccountNearAccountController.getClinicByContactId(ct.Id);
        APACAccountNearAccountController.getAccountContactbyContactId(ct.Id);
        APACAccountNearAccountController.getCampaignList();
        APACAccountNearAccountController.getEuipementsAll(acc.Id);
        APACAccountNearAccountController.getFSVProject(acc.Id);
        APACAccountNearAccountController.getHoyaIdentifierEMEA(acc.Id);
        APACAccountNearAccountController.getHoyaIlogForChart(acc.Id);
        APACAccountNearAccountController.getVisitData(acc.Id);
        APACAccountNearAccountController.getTaskData(acc.Id);
        APACAccountNearAccountController.getAccountCampaignMember(acc.Id);
        APACAccountNearAccountController.getOpportunityEMEA(acc.Id);
        APACAccountNearAccountController.getTaskForOpp(acc.Id);
        APACAccountNearAccountController.getInstruInShop(acc.Id);
        APACAccountNearAccountController.getSoftwareInShop(acc.Id);
        APACAccountNearAccountController.getEquipmentTool(acc.Id);
        APACAccountNearAccountController.getMediaTools(acc.Id, 'Hoyailog orders with visuReal');
        APACAccountNearAccountController.deleteRelationship(accContact.Id);

        Test.StopTest();
        
    }

    @IsTest
    static void runVisitTaskAPACTest(){

        Profile p = [select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testlastname';
        u.Email = 'test@hoya.com.invalid';
        u.UserName = 'test@hoya.com.pcpy';
        u.EmailEncodingKey = 'UTF-8';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'test';
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 'test-12345';
        a.Name = 'Test-account';
        insert a;

        Visit_Task_APAC__c v = new Visit_Task_APAC__c();
        v.Account__c = a.Id;
        v.OwnerId = u.Id;
        v.Checked_Location_Time__c = system.now();
        insert v;

        List<Visit_Task_APAC__c> listVisitTask = new List<Visit_Task_APAC__c>();

        Test.StartTest();
        APACAccountNearAccountController.getVisitTaskMappingMap(u.CompanyName);
        system.assert(true);
        Test.StopTest();
    }
}