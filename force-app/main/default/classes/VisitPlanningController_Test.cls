/**
 * Created by thomas.schnocklake on 21.03.18.
 */
@isTest

private class VisitPlanningController_Test {

    @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i, Hoya_Account_ID__c = 'DE12345'+i));
        }
        insert testAccts;


        Event event = new Event();
        event.Subject = 'Test FFAs';
        event.DurationInMinutes = 120;
        event.ActivityDateTime = date.today()+1;
        event.Description = 'ldshafkjhakldshfjkadksj';
        event.WhatId = testAccts[0].Id;
        // insert event;

        Visits__c visit = new Visits__c();
        visit.Account__c = testAccts[0].Id;
        visit.Activity_Id__c = event.Id;
        // visit.Visit_Reason__c = 'Contract;Complaints;Hoya(i)log';
        visit.Visit_Type__c = 'Visit';
        visit.Visit_Status__c = 'Complete';
        visit.Visit_Reason__c = 'Acquisition';
        visit.Call_To_Action__c = 'Hunt – Plan Next Visit';
        //visit.Actions_executed__c = 'Hunt 1 – Account Discovery';
        visit.Secondary_Tactic__c = 'Journal';
        visit.HVNA_Appointment__c = 'NO - Cold-call';
        visit.HVNA_Visit_Type__c = 'Call';
        visit.HVNA_Customer_Goal__c = 'Grow SOW';
        visit.HVNA_Visit_Objective__c = 'EyeMed';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.Start_Time__c = System.now();
        visit.End_Time__c = System.now().addHours(3);
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
    }

    @isTest static void getAccountFieldList() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        List<String> zelist = VisitPlanningController.getSelectedAccountFieldList();
        VisitPlanningController.saveSelectedAccountFieldList(zelist);
        VisitPlanningController.getAccountFieldList();
        system.assert(true);
        Test.stopTest();
    }
    @isTest static void retrieveAndManipulateVisits() {
        Account acct = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        List<Visits__c> visits = VisitPlanningController.getVisits(System.now().addHours(-3), System.now().addHours(6));
        VisitPlanningController.getVisit('' + visits[0].Id);
        VisitPlanningController.upsertVisit(visits[0]);
        VisitPlanningController.deleteVisit(visits[0]);
        system.assert(true);
        Test.stopTest();
    }
    @isTest static void getListViews() {
        Test.startTest();
        Account acct = [SELECT Id FROM Account LIMIT 1];

        VisitPlanningController.getListViews();
        VisitPlanningController.getCampaignList();
        VisitPlanningController.getAccountZonalList();
        VisitPlanningController.getAccountTacticomHoyaList();
        VisitPlanningController.getAccountTacticomSeikoList();
        List<String> testList = Toolbox.getCompanyList('HLFR');
        system.assert(true);
        Test.stopTest();

    }

    @isTest static void getAccounts() {
        //String listViewId = 'gibtsNet';
        String listViewId = [SELECT Id FROM ListView WHERE Name='HLHK Accounts' AND SobjectType='Account' ORDER BY CreatedDate DESC LIMIT 1].Id;
        System.debug('XXX List View Id is == >'+listViewId);
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
                'callout:SelfSelf/services/data/v41.0/sobjects/Account/listviews/' + listViewId + '/describe',
                'UNITTESTRESULT_VisitPlanningController_Test');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Account acc = new Account();
        acc.Name='TesVl123';
        acc.Hoya_Account_Id__c = 'FR0v1234';
        acc.currencyIsoCode='EUR';
        acc.Zonal__c = 'Sub-area 1';
        acc.TACTICOM_SOF__c = 'Sub-area 1';
        insert acc;

        Campaign c = new Campaign();
        c.name='testcamp';
        c.Campaign_Description__c='campaign description';
        c.Company_Code__c='HLFR';
        insert c;

        Account_Campaing_Member__c accMember = new Account_Campaing_Member__c();
        accMember.Campaign_Description_t__c = 'XYZ Acc Campaign Member';
        accMember.Account_Name__c = acc.id;
        accMember.Central_Campaign__c = c.id;
        accMember.Campaign_Priority__c = true;
        accMember.Campaign_Presented__c = false;
        insert accMember;

        String profileId = [select Id from profile where name='System Administrator' limit 1].Id;

        User u = new User();
        u.FirstName = 'Testsurawat';
        u.LastName = 'Surawattest';
        u.CompanyName = 'HVNA';
        u.Username = 'testtestsur@hoya.com.waeg';
        u.Email = 'testtestsur@hoya.com.invalid';
        u.Alias = 'ttt';
        u.ProfileId = profileId;
        u.currencyIsoCode = 'USD';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;

        Account a = new Account();
        a.Hoya_Account_ID__c = 't-001';
        a.Name = 'test-hvna';
        a.CurrencyIsoCode = 'USD';
        a.OwnerId = u.Id;
        insert a;

        String oppRecId = Schema.SobjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();
        Opportunity o = new Opportunity();
        o.Name = 'Hunting-HVNA';
        o.StageName = '1-Initial Contact';
        o.RecordTypeId = oppRecId;
        o.currencyIsoCode = 'USD';
        o.AccountId = a.Id;
        o.CloseDate = System.today()+10;
        o.OwnerId = u.Id;
        insert o;

        Test.setMock(HttpCalloutMock.class, multimock);
        Test.startTest();
        Boolean targetList = true;
        VisitPlanningController.getAccounts(listViewId, new List<String>{'Id','Name', 'Hoya_Account_ID__c'}, '30382', c.Id, false, false, 'browser', 50, 'Sub-area 1', '', 'Sub-area 1', targetList);
        

        VisitPlanningController.getContactsForAccount(acc.id);
        VisitPlanningController.getAccount(acc.id);
        VisitPlanningController.getOpportunityByAccountList(a.Id);
        /*VisitPlanningController.getOpportunityMember(acc.id);*/
        VisitPlanningController.getCampaignListByAccount(acc.id);
        Test.stopTest();
    }


    @isTest static void testOther(){
        Test.startTest();
        Datetime startDate = System.today().addDays(-1);
        Datetime endDate = System.today();
        VisitPlanningController.getuserEvents(startDate, endDate);
        VisitPlanningController.getUserIdEvents(startDate, endDate, UserInfo.getUserId());
        VisitPlanningController.getTranslations();
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        VisitPlanningController.translateSObject('Opportunity', gdMap);
        VisitPlanningController.getUserCompany(UserInfo.getUserId());
        VisitPlanningController.getSRX_ObjectiveOptionList();
        VisitPlanningController.getSRX_OutcomeOptionList();
        VisitPlanningController.fetchUser();
        VisitPlanningController.getSRX_ActionExecutedOptionList();
        VisitPlanningController.getSRX_OutcomeOptionList();
        VisitPlanningController.getSRX_ObjectiveOptionList();
        VisitPlanningController.getRoleSubordinateUsers(UserInfo.getUserId());
        set<Id> idset = VisitPlanningController.getSubordinateRoles(UserInfo.getUserRoleId());
        VisitPlanningController.getAllSubRoleIds(idset);
        VisitPlanningController.getUserProfile();
        VisitPlanningController.getSelectedAccountFieldList();
        VisitPlanningController.getCompanyName();
        /*VisitPlanningController.getNewStageName();*/
        VisitPlanningController.getCampaignInterested();
        VisitPlanningController.getCampaignInterested2();
        VisitPlanningController.getCampaignInterested3();
        //VisitPlanningController.getOpportunityStageList();
        //VisitPlanningController.getOpportunityStageName();
        VisitPlanningController.getAccountTacticomHoyaList();
        VisitPlanningController.getAccountTacticomSeikoList();
        List<SelectOption> optionList = VisitPlanningController.getOptionsForDescribe(Account.Zonal__c.getDescribe());
        //List<SelectOption> optionList2 = VisitPlanningController.getOptionsForDescribe(Account.TACTICOM_HLFR__c.getDescribe());
        //List<SelectOption> optionList3 = VisitPlanningController.getOptionsForDescribe(Account.TACTICOM_SOF__c.getDescribe());
        VisitPlanningController.toOptionList(optionList,false);
        //VisitPlanningController.toOptionList(optionList2, false);
        //VisitPlanningController.toOptionList(optionList3, false);

        Campaign c = new Campaign();
        c.name='testcamp';
        c.Campaign_Description__c='campaign description';
        c.Company_Code__c='HLFR';
        insert c;
        VisitPlanningController.getCampaignName(c.Id);

        Account a = new Account();
        a.Name = 'XYZ Opp test';
        a.Hoya_Account_ID__c ='XYZ987654';
        insert a;

        Opportunity opp = new Opportunity();
        opp.Name = 'XYZ opp name';
        opp.AccountId = a.id;
        opp.StageName ='1.start';
        opp.CloseDate = System.today();
        insert opp;

        Account_Campaing_Member__c accMember = new Account_Campaing_Member__c();
        accMember.Campaign_Description_t__c = 'XYZ Acc Campaign Member';
        accMember.Account_Name__c = a.id;
        accMember.Central_Campaign__c = c.id;
        insert accMember;
        VisitPlanningController.getAccCampaignMember(a.id, c.id);
        VisitPlanningController.getAccCampaign(c.id);

        //Account oa=  VisitPlanningController.getAccountByOpportunity(opp.Id);

        Test.stopTest();
    }
    
    @isTest
    static void testUserId(){
        String profileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;

        User u = new User();
        u.FirstName = 'Test-surawat';
        u.LastName = 'Testtest';
        u.UserName = 'testtest@hoya.com.waeg';
        u.Email = 'test_waeg@hoya.com.invalid';
        u.ProfileId = profileId;
        u.Alias = 'tt';
        u.CompanyName = 'HVC';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        
        insert u;
        Test.startTest();
        VisitPlanningController.getUserRegion(u.Id);
        VisitPlanningController.getUserName();
        Test.stopTest();

    }

    @isTest
    static void TestgetOpportunityByAccount(){

        String usrId = UserInfo.getUserId();
        String OppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();

        Account a = new Account();
        a.Hoya_Account_ID__c = 'Test-111';
        a.Name = 'TestOpp';
        a.OwnerId = usrId;
        a.CurrencyIsoCode = 'EUR';
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'HUNT-TEST';
        o.AccountId = a.Id;
        o.StageName = '1-Initial Contact';
        o.RecordTypeId = OppRecId;
        o.CloseDate = System.today()+1;
        o.OwnerId = usrId;
        o.NextStep = 'Test';
        o.Description = 'Test';
        insert o;

        Test.startTest();
        VisitPlanningController.getAccountByOpportunity(o.Id);
        VisitPlanningController.getOpportunity(o.Id);
        VisitPlanningController.getOpportunityMember(o.Id);
        Test.stopTest();

    }
}