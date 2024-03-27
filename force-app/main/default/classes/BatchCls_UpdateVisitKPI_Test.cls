/**
 *  - Test class for BatchCls_UpdateVisitKPI
 *  - Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 *  - Created date : 2023-11-17
 *  - Since api : v.55.0
 */
@isTest(SeeAllData=true)
public class BatchCls_UpdateVisitKPI_Test {

    @isTest
    static void UnitTest01(){
        List<Account> acc = new List<Account>();
        List<Visits__c> visitList = new List<Visits__c>();
        List<User> usrList = new List<User>();
        List<VISIT_KPI__c> vkpiList = new List<VISIT_KPI__c>();
        List<VisitKPI_Settings__c> vSetting = new List<VisitKPI_Settings__c>();
        String profileId = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        for(Integer i=0;i<50;i++){
            User u = new User();
            u.FirstName = 'This';
            u.LastName = 'Test'+String.valueOf(i);
            u.Username = 'test@hoya.com.wage.invalid'+String.valueOf(i);
            u.Email = 'test@hoya.com.waeg.invalid'+String.valueOf(i);
            u.Visit_counter__c = true;
            u.CompanyName = 'HAPL';
            u.TimeZoneSidKey = 'Asia/Bangkok';
            u.LocaleSidKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            u.LanguageLocaleKey = 'en_US';
            u.Alias = 'VTest'+String.valueOf(i);
            u.ProfileId = profileId;
            usrList.add(u);

        }
        insert usrList;
        for(Integer i=0;i<50;i++){
            Account a = new Account();
            a.Name = 'Test'+string.valueOf(i);
            a.Hoya_Account_ID__c = 'TE-001-'+string.valueOf(i);
            a.OwnerId = usrList[i].Id;
            acc.add(a);
        }
        insert acc;
         
        for(Integer i=0;i<50;i++){
            Visits__c visits = new Visits__c();
            visits.Account__c = acc[i].Id;
            visits.Assigned_to__c = usrList[i].Id;
            visits.Start_Time__c = System.today()-2;
            visits.End_Time__c = System.today()-1;
            visits.Visit_Status__c = 'Complete';
            visitList.add(visits);
        }
        insert visitList;

        for(Integer i=0;i<50;i++){
            VISIT_KPI__c v = new VISIT_KPI__c();
            v.Area_Sales_Manager__c = usrList[i].Id;
            v.Name = 'test'+String.valueOf(i);
            v.Date__c = Date.today();
            vkpiList.add(v);
        }
        insert vkpiList;

        for(Integer i=0;i<50;i++){
            VisitKPI_Settings__c ss = new VisitKPI_Settings__c();
            ss.Name = 'Test'+string.valueOf(i);
            ss.isActive__c = true;
            vSetting.add(ss);
        }
        insert vSetting;

        Test.StartTest();
        BatchCls_UpdateVisitKPI obj = new BatchCls_UpdateVisitKPI(System.today(), System.now());
        DataBase.executeBatch(obj);
        Test.StopTest();
        
    }
}