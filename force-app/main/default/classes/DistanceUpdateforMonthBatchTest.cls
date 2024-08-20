@isTest
public class DistanceUpdateforMonthBatchTest {
	@TestSetup
    static void makeData(){
         Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User u = new User();
        u.Firstname = 'Testdata';
        u.Lastname = 'Datatest';
        u.Username = 'data@hoya.com.invalid';
        u.Email = 'data@hoya.com.invalid';
        u.ProfileId = p.Id;
        u.Alias = 'data2';
        u.TimeZoneSidKey = 'Asia/Bangkok';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.CompanyName = 'THAI';
        u.Country__c = 'Thailand';
        u.Sales_District_Area__c = 'Region-1';
        u.Sales_Role__c = 'ASM';
        u.IsActive = true;
        u.Visit_Counter__c = true;
        insert u;
		List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Hoya_Account_ID__c = 'TE-001';
        a.Name = 'Test';
        a.ownerId = u.Id;
        a.Shop_Street__c = '101 OLD SHORT HILLS RD 430';
        a.Shop_City__c = 'W ORANGE';
        a.Shop_State__c = 'NJ';
        a.Shop_Country__c = 'US';
        a.ShippingLatitude = 40.761797;
        a.ShippingLongitude = -74.302766;
        accList.add(a);
        Account acc2 = new Account();
        acc2.Hoya_Account_ID__c = 'TE-002';
        acc2.Name = 'Test';
        acc2.ownerId = u.Id;
        acc2.Shop_Street__c = '594 BROADWAY';
        acc2.Shop_City__c = 'BAYONNE';
        acc2.Shop_State__c = 'NJ';
        acc2.Shop_Country__c = 'US';
        acc2.ShippingLatitude = 40.667222;
        acc2.ShippingLongitude = -74.115086;
        accList.add(acc2);
        insert accList;
        DateTime dt = DateTime.newInstance(2024, 5, 1, 14, 30, 0);
		DateTime dt1 = DateTime.newInstance(2024, 4, 16, 14, 30, 0);
        DateTime dt2 = DateTime.newInstance(2024, 4, 17, 14, 30, 0);
        List<Visits__c> visitList = new List<Visits__c>();
        Visits__c v = new Visits__c();
        v.Account__c = a.Id;
        v.Start_Time__c = dt1;
        v.End_Time__c = dt1.addHours(1);
        v.Visit_Status__c = 'Complete';
        v.Assigned_to__c = u.Id;
        visitList.add(v);
        Visits__c v2 = new Visits__c();
        v2.Account__c = acc2.Id;
        v2.Start_Time__c = dt2;
        v2.End_Time__c = dt2.addHours(1);
        v2.Visit_Status__c = 'Complete';
        v2.Assigned_to__c = u.Id;
        visitList.add(v2);
        insert visitList;
         VISIT_KPI__c visitKPI = new VISIT_KPI__c();
        visitKPI.Area_Sales_Manager__c = u.Id;
        visitKPI.Date__c = dt.Date();
        insert visitKPI;
    }
      @isTest
    static void testDistanceCalculationBatch(){
        Date testDate = Date.newInstance(2024, 5, 1);
         Test.startTest();
        System.debug('testDate'+testDate);
        // Instantiate the batch class
        DistanceUpdateforMonthBatch batch = new DistanceUpdateforMonthBatch(testDate);
        
        // Execute the batch
        Database.executeBatch(batch);
        VISIT_KPI__c DistanceCoveredKPI = [Select Id,Name,Date__c,X12WeekAverageDistanceCovered__c from VISIT_KPI__c];
        Assert.areEqual(18.99,DistanceCoveredKPI.X12WeekAverageDistanceCovered__c.setScale(2, RoundingMode.HALF_UP),'Average mismatched');
        Test.stopTest();

    }
}