@isTest
public class CustomerReviewPerformanceController_test {
    @TestSetup
    static void makeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'Testlastname';
        u.Email = 'test@hoya.com.invalid';
        u.UserName = 'test@hoya.com.pcpy';
        u.Sales_Role__c = 'NSM';
        u.EmailEncodingKey = 'UTF-8';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';        
        u.Alias = 'testusr';
        u.CompanyName = 'HLUK';
        u.ManagerId = UserInfo.getUserId();
        insert u;
        
        Budget_by_ASM__c budget=new Budget_by_ASM__c();
        budget.LocalSales1CY__c=234;
        budget.LocalSales11LY__c=2000;
        budget.Quota6CY__c=700;
        budget.Lookupuser__c = u.id;
        insert budget;
        
        Account acc1 = new Account();
        acc1.Name='sales test Germany account';
        acc1.hoya_account_id__c='SO4900999xx';
        acc1.OwnerId=u.id;        
        insert acc1;
        
        Integer CFY=Date.today().year();
        Sales_Statistics__c stat1=new Sales_Statistics__c();
        stat1.Account__c=acc1.Id;
        stat1.Lenses_Net_Sales__c=1000;
        stat1.Type__c='0';
        stat1.Year__c=CFY;
        stat1.Month__c=4;
        stat1.External_Key__c=acc1.id+'-'+ stat1.Type__c+'-'+stat1.Month__c+'-'+stat1.Year__c;
        stat1.Fiscal_Year__c=CFY;
        insert stat1;
        
        Sales_Statistics__c stat2=new Sales_Statistics__c();
        stat2.Account__c=acc1.Id;
        stat2.Lenses_Net_Sales__c=1000;
        stat2.Type__c='0';
        stat2.Year__c=CFY-1;
        stat2.Month__c=12;
        stat2.External_Key__c=acc1.id+'-'+ stat2.Type__c+'-'+stat2.Month__c+'-'+stat2.Year__c;
        stat2.Fiscal_Year__c=CFY-1;
        insert stat2;
        
        Sales_Statistics__c stat3=new Sales_Statistics__c();
        stat3.Account__c=acc1.Id;
        stat3.Lenses_Net_Sales__c=1000;
        stat3.Type__c='0';
        stat3.Year__c=CFY;
        stat3.Month__c=5;
        stat3.External_Key__c=acc1.id+'-'+ stat3.Type__c+'-'+stat3.Month__c+'-'+stat3.Year__c;
        stat3.Fiscal_Year__c=CFY;
        insert stat3;
        
        Sales_Statistics__c stat4=new Sales_Statistics__c();
        stat4.Account__c=acc1.Id;
        stat4.Lenses_Net_Sales__c=1000;
        stat4.Type__c='0';
        stat4.Year__c=CFY-1;
        stat4.Month__c=11;
        stat4.External_Key__c=acc1.id+'-'+ stat4.Type__c+'-'+stat4.Month__c+'-'+stat4.Year__c;
        stat4.Fiscal_Year__c=CFY-1;
        insert stat4;
        
        Sales_Statistics__c stat5=new Sales_Statistics__c();
        stat5.Account__c=acc1.Id;
        stat5.Lenses_Net_Sales__c=1000;
        stat5.Type__c='1';
        stat5.Year__c=CFY;
        stat5.Month__c=4;
        stat5.External_Key__c=acc1.id+'-'+ stat5.Type__c+'-'+stat5.Month__c+'-'+stat5.Year__c;
        stat5.Fiscal_Year__c=CFY;
        insert stat5;
        
        Visits__c visit1 = new Visits__c();
        visit1.Account__c = acc1.Id;
        visit1.Visit_Type__c = 'Visit';
        visit1.Visit_Status__c = 'Complete';
        visit1.Start_Time__c = date.today()-5;
        visit1.End_Time__c = visit1.Start_Time__c.addMinutes(60);
        visit1.Assigned_to__c = u.Id;
        insert visit1;
        
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = acc1.Id;
        visit2.Visit_Type__c = 'Support Direct Visit';
        visit2.Visit_Status__c = 'Complete';
        visit2.Start_Time__c = date.today()-5;
        visit2.End_Time__c = visit2.Start_Time__c.addMinutes(60);
        visit2.Assigned_to__c = u.Id;
        insert visit2;
        
    }
    @IsTest
    static void TestClassModule1(){
        Test.StartTest();
        User user = [SELECT Id, Name,Sales_Role__c,User_Region__c,DefaultCurrencyIsoCode,CompanyName FROM User WHERE UserName = 'test@hoya.com.pcpy'];
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name FROM Account WHERE Hoya_Account_ID__c = 'SO4900999xx' LIMIT 1];
        List<Visits__c> visit = new List<Visits__c>();
        for(Integer i=1;i<=12;i++){
            Visits__c v = new Visits__c();
            v.Assigned_to__c = user.Id;
            v.Visit_Type__c = 'Visit';
            v.Visit_Status__c = 'Complete';
            v.Start_Time__c = Date.today().addMonths(-12);
            v.End_Time__c = v.Start_Time__c.addMinutes(180);
            v.Account__c = acc.Id;
            visit.add(v);
        }

        insert visit;

        List<Visits__c> visit2 = new List<Visits__c>();
        for(Integer i=1;i<=12;i++){
            Visits__c v = new Visits__c();
            v.Assigned_to__c = user.Id;
            v.Visit_Type__c = 'Support Direct Visit';
            v.Visit_Status__c = 'Complete';
            v.Start_Time__c = Date.today().addMonths(-12);
            v.End_Time__c = v.Start_Time__c.addMinutes(180);
            v.Account__c = acc.Id;
            visit2.add(v);
        }
        insert visit2;
        
        CustomerReviewPerfomanceController.getPerformanceDetails(user,true);
        
        Test.StopTest();
    }
}