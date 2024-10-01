@IsTest
public class TabVisitsIndicatorControllerTest {
      @TestSetup
      static void makeData(){
        List<Account> accList = new List<Account>();
        
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'SO4900TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.CurrencyIsoCode = 'EUR';
        a1.ShippingStreet = 'Bangkok Street 123';
        a1.ShippingCity = 'Bangkok';
        a1.ShippingState = 'Bangkok';
        a1.ShippingPostalCode = '12345';
        a1.ShippingCountry = 'Thailand';
        a1.Shop_email_address__c = 'test@gmail.com';
        a1.Surveys_Email__c = 'test@yahoo.com';
        a1.Email__c = 'test@hotmail.com';
        a1.Confidential_Email_Address__c = 'test@hanmail.com';
        a1.Strategic_Value_Gross_Sales__c = 0;  
        a1.Strategic_Value_Net_Sales__c=0;  
        //insert a1;
        accList.add(a1);

        
          
        Account a4 = new Account();
        a4.Hoya_Account_ID__c = 'test1';
        a4.Name = 'Test Account';
        a4.Shop_Name__c = 'Test Account';
        a4.CurrencyIsoCode = 'EUR';
        a4.ShippingStreet = 'Bangkok Street 123';
        a4.ShippingCity = 'Bangkok';
        a4.ShippingState = 'Bangkok';
        a4.ShippingPostalCode = '12345';
        a4.ShippingCountry = 'Thailand';
        a4.Shop_email_address__c = 'test@gmail.com';
        a4.Surveys_Email__c = 'test@yahoo.com';
        a4.Email__c = 'test@hotmail.com';
        a4.Confidential_Email_Address__c = 'test@hanmail.com';
        a4.Strategic_Value_Gross_Sales__c = 0;  
        a4.Strategic_Value_Net_Sales__c=0;  
        //insert a4;  
        accList.add(a4);

        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';
        insert c1;

        Account acc2 = new Account(
        Name = 'Test AccTESR',
        Hoya_Account_ID__c = 'TE-012354',
        phone='0103030408',
        Account_Status__c='Closed' 
        );
        //insert acc2;
        accList.add(acc2);


        Account accnew1 = new Account(
        Name = 'Test AccTESR1',
        phone='0103030408',
        Hoya_Account_ID__c='SO4900',
        Strategic_Value_Net_Sales__c=1,
        Account_Status__c='Open'
        );
        //insert accnew1;
        accList.add(accnew1);

        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO4900tcy';
        a2.Name = 'Test Account';
        a2.Agreed_Visits__c = 1;
        a2.Agreed_No_of_Digital_Visits__c = 2;
        a2.Shop_Name__c = 'Test Account';
        a2.CurrencyIsoCode = 'EUR';
        a2.ShippingStreet = 'Bangkok Street 123';
        a2.ShippingCity = 'Bangkok';
        a2.ShippingState = 'Bangkok';
        a2.ShippingPostalCode = '12345';
        a2.Agreed_No_of_Digital_Visits__c=2;  
        a2.ShippingCountry = 'Thailand';
        a2.Shop_email_address__c = 'test@gmail.com';
        a2.Surveys_Email__c = 'test@yahoo.com';
        a2.Email__c = 'test@hotmail.com';
        a2.Confidential_Email_Address__c = 'test@hanmail.com';
        a2.Strategic_Value_Gross_Sales__c = 3;  
        a2.Strategic_Value_Net_Sales__c=12;  
        //insert a2; 
        accList.add(a2);
        insert accList;

        Last_Sales_Statistics__c lastSalesStatisticObjNew1 = new Last_Sales_Statistics__c
            (name = 'test',Account__c = accnew1.id,Lenses_Net_Sales_LFY__c=2);
        insert lastSalesStatisticObjNew1;
          
        Last_Sales_Statistics__c lastSalesStatisticObj1 = new Last_Sales_Statistics__c();
        lastSalesStatisticObj1.name = 'test';
        lastSalesStatisticObj1.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObj1.Account__c = a1.id;
        lastSalesStatisticObj1.Remote_Edging_L3Mo__c=9;
        lastSalesStatisticObj1.Mounting_L3Mo__c=39;
        lastSalesStatisticObj1.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObj1.Other_Digital_Orders_L3Mo__c=49;
        lastSalesStatisticObj1.Lenses_Net_Sales_LFY__c=-1;
        lastSalesStatisticObj1.Lenses_Net_Sales_Last_12Mo__c=-1;
        lastSalesStatisticObj1.Lenses_Gross_Sales_LFY__c=12;
        lastSalesStatisticObj1.Lenses_Gross_Sales_Last_12Mo__c=12;
          
        insert lastSalesStatisticObj1;
        Last_Sales_Statistics__c lastSalesStatisticObjNew = new Last_Sales_Statistics__c();
        lastSalesStatisticObjNew.name = 'test';
        lastSalesStatisticObjNew.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObjNew.Account__c = a4.id;
        lastSalesStatisticObjNew.Remote_Edging_L3Mo__c=9;
        lastSalesStatisticObjNew.Mounting_L3Mo__c=39;
        lastSalesStatisticObjNew.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObjNew.Other_Digital_Orders_L3Mo__c=49;
        lastSalesStatisticObjNew.Lenses_Net_Sales_LFY__c=11;
        lastSalesStatisticObjNew.Lenses_Net_Sales_Last_12Mo__c=12;
        lastSalesStatisticObjNew.Lenses_Gross_Sales_LFY__c=12;
        lastSalesStatisticObjNew.Lenses_Gross_Sales_Last_12Mo__c=12;
          
        insert lastSalesStatisticObjNew;  
        
        
        Last_Sales_Statistics__c lastSalesStatisticObj2 = new Last_Sales_Statistics__c();
        lastSalesStatisticObj2.name = 'test';
        lastSalesStatisticObj2.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObj2.Account__c = a2.id;
        lastSalesStatisticObj2.Remote_Edging_L3Mo__c=9;
        lastSalesStatisticObj2.Mounting_L3Mo__c=39;
        lastSalesStatisticObj2.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObj2.Other_Digital_Orders_L3Mo__c=49;
        lastSalesStatisticObj2.Lenses_Net_Sales_LFY__c=21;
        lastSalesStatisticObj2.Lenses_Net_Sales_Last_12Mo__c=-1;
        lastSalesStatisticObj2.Lenses_Gross_Sales_LFY__c=19;
        lastSalesStatisticObj2.Lenses_Gross_Sales_Last_12Mo__c =19;
          
        insert lastSalesStatisticObj2;
          
        Campaign c = new Campaign();
        c.Name = 'TEST-Campaign';
        c.StartDate = System.today();
        c.EndDate = System.today()+30;
        c.CurrencyIsoCode = 'EUR';
        c.CurrencyIsoCode = 'EUR';
        c.IsActive = true;
        insert c;

        Account_Campaing_Member__c cc = new Account_Campaing_Member__c();
        cc.Account_Name__c = a2.Id;
        cc.Central_Campaign__c = c.Id;
        cc.Campaign_Start_Date_t__c = c.StartDate;
        cc.Campaign_End_Date_t__c = date.valueOf(system.now()+2);
        cc.Target__c = true;
        cc.Campaign_Presented__c = false;
        insert cc;  
        
        Campaign c12 = new Campaign();
        c12.Name = 'TEST-Campaign';
        c12.StartDate = System.today();
        c12.EndDate = System.today()+30;
        c12.CurrencyIsoCode = 'EUR';
        c12.CurrencyIsoCode = 'EUR';
        c12.IsActive = false;
        insert c12;

        Account_Campaing_Member__c cc1 = new Account_Campaing_Member__c();
        cc1.Account_Name__c = a1.Id;
        cc1.Central_Campaign__c = c12.Id;
        cc1.Campaign_Start_Date_t__c = c.StartDate;
        cc1.Campaign_End_Date_t__c = date.valueOf(system.now()-2);
        cc1.Target__c = true;
        cc1.Campaign_Presented__c = false;
        insert cc1;  
        
        List<Visits__c> visitList = new List<Visits__c>();
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a2.Id;
        visit2.contact__c = c1.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Start_Time__c = date.today()-4;
        visit2.End_Time__c = date.today()-2;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Complete';
        visit2.Visitfreqchk_c__c='1';
        visit2.Visit_Type__c='Visit';
        visit2.End_Time__c=system.now();
        //insert visit2;
        visitList.add(visit2);

        Visits__c visit3 = new Visits__c();
        visit3.Account__c = a2.Id;
        visit3.contact__c = c1.Id;
        visit3.Visit_Type__c = 'Visit';
        visit3.CurrencyIsoCode = 'EUR';
        visit3.Visit_Status__c = 'Complete';
        visit3.Start_Time__c = date.today()-3;
        visit3.End_Time__c = date.today()-2;
        visit3.Assigned_to__c = UserInfo.getUserId();
        //insert visit3;
        visitList.add(visit3);
        Visits__c visit4 = new Visits__c();
        visit4.Account__c = a2.Id;
        visit4.contact__c = c1.Id;
        visit4.Visit_Type__c = 'Visit';
        visit4.Visit_Status__c = 'Planned';
        visit4.Start_Time__c = date.today()-5;
        visit4.End_Time__c = date.today()+1;
        visit4.Assigned_to__c = UserInfo.getUserId();
        //insert visit4;   
        visitList.add(visit4);
        insert visitList;
        Account_Life_Cycle__c listOfALC = new Account_Life_Cycle__c();
        listOfALC.Account__c = accList[0].id;
        listOfALC.Active__c = true;
        insert listOfALC;
        
    }
    
     @IsTest
    static void testmultipleClass1(){
        Test.StartTest();       
        Account acc3 = [SELECT Id, Hoya_Account_ID__c,Strategic_Value_Net_Sales__c,Strategic_Value_Gross_Sales__c, Name, Shop_Name__c, CurrencyIsoCode, OwnerId, 
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,
                        Shop_email_address__c, Surveys_Email__c, Email__c,
                        Confidential_Email_Address__c FROM Account
                        WHERE Hoya_Account_ID__c = 'SO4900tcy' LIMIT 1];
        Visits__c visitObj=[SELECT ID,Start_Time__c from Visits__c where Start_Time__c<:system.today() and Visit_Status__c ='Complete' limit 1];
        Account acc1 = [SELECT Id,Account_Status__c FROM Account Where Name = 'Test AccTESR'];
        TabVisitsIndicatorController.getAIIndicators(acc1.Id);
        TabVisitsIndicatorController.getAIIndicators(acc3.Id);
        TabVisitsIndicatorController.tecticomIndicators(acc3.id,'A','Test','English');       
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass1_2(){
        Test.StartTest();
        Account acc4 = [SELECT Id, Hoya_Account_ID__c,Strategic_Value_Net_Sales__c, Name,Strategic_Value_Gross_Sales__c, Shop_Name__c, CurrencyIsoCode, OwnerId, 
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,
                        Shop_email_address__c, Surveys_Email__c, Email__c,
                        Confidential_Email_Address__c FROM Account
                        WHERE Hoya_Account_ID__c = 'test1' LIMIT 1];
        List<Last_Sales_Statistics__c> statsList2 = [Select Id, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c = :acc4.Id];
        Visits__c visitObj=[SELECT ID,Start_Time__c from Visits__c where Start_Time__c<:system.today() and Visit_Status__c ='Complete' limit 1];
        TabVisitsIndicatorController.getAIIndicators(acc4.Id);
        acc4.Strategic_Value_Net_Sales__c=1;
        update acc4;
        statsList2[0].Lenses_Net_Sales_LFY__c=2;
        update statsList2[0];
        TabVisitsIndicatorController.getAIIndicators(acc4.Id);
        visitObj.Account__c = acc4.id;
        visitObj.Start_Time__c = system.today()-170;
		visitObj.End_Time__c = system.today()-171;
        visitObj.Visit_Status__c = 'Complete';
        update visitObj;
         TabVisitsIndicatorController.tecticomIndicators(acc4.id,'A','Test','English');
        visitObj.Account__c = acc4.id;
        visitObj.Start_Time__c = system.today()+3;
        visitObj.End_Time__c = system.today()+5;
        visitObj.Visit_Status__c = 'Planned';
        update visitObj;
        TabVisitsIndicatorController.tecticomIndicators(acc4.id,'A','Test','English');
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass5(){
        Test.StartTest();
         Account acc = [SELECT Id, Hoya_Account_ID__c,Strategic_Value_Net_Sales__c, Name,Strategic_Value_Gross_Sales__c, Shop_Name__c, CurrencyIsoCode, OwnerId,
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,
                        Shop_email_address__c, Surveys_Email__c, Email__c,
                        Confidential_Email_Address__c FROM Account
                        WHERE Hoya_Account_ID__c = 'SO4900TEST001' LIMIT 1];
        TabVisitsIndicatorController.getAIIndicators(acc.Id);
        Visits__c visitObj=[SELECT ID,Start_Time__c from Visits__c where Start_Time__c<:system.today() and Visit_Status__c ='Complete' limit 1];
        visitObj.Start_Time__c= system.today()-3;
        update visitObj;
        acc.Hoya_Account_ID__c = 'test';
        update acc;
        TabVisitsIndicatorController.getAIIndicators(acc.Id);
        Test.StopTest();
    }
    
    @IsTest
    static void testmultipleClass2(){
        Test.StartTest();
        Account acc1 = [SELECT Id,Account_Status__c FROM Account Where Name = 'Test AccTESR'];
        Visits__c visitObj=[SELECT ID,Start_Time__c,Visitfreqchk_c__c from Visits__c where Visit_Status__c ='Complete' limit 1];
        Account_Campaing_Member__c accountCam = [SELECT ID,campaign_active__c,Campaign_Presented__c,Campaign_End_Date_t__c From
                                                 Account_Campaing_Member__c
                                                 WHERE campaign_active__c = false and Campaign_Presented__c=false];
        TabVisitsIndicatorController.tecticomIndicators(acc1.id,'A','Test','English');
        acc1.TACTICOM_SOF__c ='Sub-area 1';
        update acc1;
        TabVisitsIndicatorController.getAIIndicators(acc1.Id);        
        visitObj.Visitfreqchk_c__c = '2';
        update visitObj;
        Test.StopTest();
    } 
    @IsTest
    static void testmultipleClass2_2(){
        Test.StartTest();
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shop_Name__c, CurrencyIsoCode, OwnerId,
                        ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,
                        Shop_email_address__c, Surveys_Email__c, Email__c,
                        Confidential_Email_Address__c FROM Account
                          LIMIT 1];
        acc.Agreed_Visits__c = 1;
        acc.Agreed_No_of_Digital_Visits__c=1;
        update acc;
        TabVisitsIndicatorController.getAIIndicators(acc.Id);
        TabVisitsIndicatorController.tecticomIndicators(acc.id,'A','Test','English');
        List<Last_Sales_Statistics__c> statsList = [Select Id, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c = :acc.Id AND Lenses_Net_Sales_Last_12Mo__c<0];
        TabVisitsIndicatorController.getAIIndicators(acc.id);
        acc.Strategic_Value_Gross_Sales__c=1;
        update acc;
        statsList[0].Lenses_Gross_Sales_Last_12Mo__c=2;
        update statsList[0];
        TabVisitsIndicatorController.getAIIndicators(acc.id);
        acc.Strategic_Value_Net_Sales__c=1;
        update acc;
        statsList[0].Lenses_Net_Sales_LFY__c=2;
        update statsList[0];
        TabVisitsIndicatorController.getAIIndicators(acc.id);
        Test.StopTest();
    }
     @IsTest
    static void testmultipleClass4(){
        Test.StartTest();
        Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Name = 'Test AccTESR1'];
        TabVisitsIndicatorController.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    
     @IsTest
    static void testmultipleClass3(){
        Test.StartTest();
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO4900TEST011';
        a2.Name = 'Test Account';
        a2.Shop_Name__c = 'Test Account';
        a2.CurrencyIsoCode = 'EUR';
        a2.Strategic_Value_Gross_Sales__c=12;
        insert a2;
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a2.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Start_Time__c = date.today()-3;
        visit2.End_Time__c = date.today()-2;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Complete';
        visit2.Visitfreqchk_c__c='1';
        visit2.Visit_Type__c='Visit';
        visit2.End_Time__c=system.now();
        //insert visit2;
        List<Visits__c> visList = new List<visits__c>();
		visList.add(visit2);
        Visits__c visit3 = new Visits__c();
        visit3.Account__c = a2.Id;
        visit3.Visit_Type__c = 'Visit';
        visit3.CurrencyIsoCode = 'EUR';
        visit3.Visit_Status__c = 'Complete';
        visit3.Start_Time__c = date.today()-2;
        visit3.End_Time__c = date.today();
        visit3.Assigned_to__c = UserInfo.getUserId();
        //insert visit3;
        visList.add(visit3);
        Visits__c visit4 = new Visits__c();
        visit4.Account__c = a2.Id;
        visit4.Visit_Type__c = 'Visit';
        visit4.Visit_Status__c = 'Planned';
        visit4.Start_Time__c = date.today()-6;
        visit4.End_Time__c = date.today();
        visit4.Assigned_to__c = UserInfo.getUserId();
        //insert visit4; 
        visList.add(visit4);
        insert visList;

        TabVisitsIndicatorController.tecticomIndicators(a2.Id,'A','test','English');
        Test.StopTest();

    }
    
    @IsTest
    static void test60Days(){
        Test.StartTest();
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO490060';
        a2.Name = 'Test 60';
        a2.Shop_Name__c = 'Test Account 60';
        a2.CurrencyIsoCode = 'EUR';
        a2.Tacticom_SOF__c = 'Sub-area 1';
        insert a2;
        // only 60 days scenario
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a2.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.Start_Time__c = date.today()+2;
        visit2.End_Time__c = date.today()+5;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Planned';
        visit2.Visitfreqchk_c__c='1';
        insert visit2;
        TabVisitsIndicatorController.tecticomIndicators(a2.Id, 'A', a2.Tacticom_SOF__c, 'English');
        TabVisitsIndicatorController.tecticomIndicators(a2.Id, 'A', '', 'English');
        Test.StopTest();

    }
    
    @IsTest
    static void test60_180Days(){
        Test.StartTest();
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO490060';
        a2.Name = 'Test 60';
        a2.Shop_Name__c = 'Test Account 60';
        a2.CurrencyIsoCode = 'EUR';
        a2.Tacticom_SOF__c = 'Sub-area 1';
        //a2.Strategic_Value_Gross_Sales__c=12;
        insert a2;
        // 180 days scenario
        Visits__c visit180 = new Visits__c();
        visit180.Account__c = a2.Id;
        visit180.Visit_Type__c = 'Visit';
        visit180.Start_Time__c = Date.today() - 170;
        visit180.End_Time__c = date.today()-165;
        visit180.Assigned_to__c = UserInfo.getUserId();
        visit180.Visit_Status__c ='Complete';
        insert visit180;
        TabVisitsIndicatorController.tecticomIndicators(a2.Id, 'A1', '', 'English');
        TabVisitsIndicatorController.tecticomIndicators(a2.Id, '', '', 'English');
        
        // 180 + 60 days scenario
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a2.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.Start_Time__c = date.today()+2;
        visit2.End_Time__c = date.today()+5;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Planned';
        visit2.Visitfreqchk_c__c='1';
        insert visit2;
        TabVisitsIndicatorController.tecticomIndicators(a2.Id, 'A', '', 'English');
        TabVisitsIndicatorController.tecticomIndicators(a2.Id, 'A', a2.Tacticom_SOF__c, 'English');
        Test.StopTest();

    }
        

}