@IsTest
public class tabShowPadControllerTest {
     @TestSetup
      static void makeData(){
        list<Account> listOfAccount = new list<Account>();
        Account a1 = new Account();
        a1.Hoya_Account_ID__c = 'SO4900TEST001';
        a1.Name = 'Test Account';
        a1.Shop_Name__c = 'Test Account';
        a1.Lenses_Net_Sales_Last_12Mo__c =1;
        listOfAccount.add(a1);
        //insert a1;
          
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO4900TEST5565';
        a2.Name = 'Test Account';
        a2.Shop_Name__c = 'Test Account';
        a2.Lenses_Net_Sales_Last_12Mo__c =0;
        //insert a2; 
        listOfAccount.add(a2);
         
        Account acc2 = new Account(
            Name = 'Test AccTESR',
            Hoya_Account_ID__c = 'TE-012355',
            phone='0103030408',
           Lenses_Net_Sales_Last_12Mo__c =1,
            Account_Status__c='Closed'
            
        );
        listOfAccount.add(acc2);
        insert listOfAccount;  
        list<Contact> listOfContact = new list<Contact>();
        DateTime currentDate = DateTime.now();
        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'test-TEST001';
        c1.LastName = 'testtest';
        c1.Salutation = 'Mr.';
        c1.Title = 'test-data';
        c1.Email = 'xxx@gmail.com';
        c1.Phone = '123456789';
        DateTime sixMonthsAgo = currentDate.addMonths(-6).addDays(2);
        c1.ShowpadForSF__Showpad_Last_Activity_Date__c  = sixMonthsAgo;
        //c1.ShowpadForSF__Showpad_Last_View_Date__c = currentDate.addMonths(-3);
        c1.ShowpadForSF__Showpad_Last_View_Date__c = system.today()-3;
        listOfContact.add(c1); 
        Contact c2 = new Contact();
        c2.AccountId = a2.Id;
        c2.FirstName = 'test-TEST001';
        c2.LastName = 'testtest';
        c2.Salutation = 'Mr.';
        c2.Title = 'test-data';
        c2.Email = 'xxx@gmail.com';
        c2.Phone = '123456789';
        c2.ShowpadForSF__Showpad_Last_Activity_Date__c  = sixMonthsAgo;
        //c1.ShowpadForSF__Showpad_Last_View_Date__c = currentDate.addMonths(-3);
        c2.ShowpadForSF__Showpad_Last_View_Date__c = system.today()+3;
        listOfContact.add(c2);
        insert listOfContact;
        
        list<Visits__c> listOfVisit = new list<Visits__c>();
        Visits__c visit2 = new Visits__c();
        visit2.Account__c = a1.Id;
        visit2.contact__c = c1.Id;
        visit2.Visit_Type__c = 'Visit';
        visit2.CurrencyIsoCode = 'EUR';
        visit2.Start_Time__c = date.today()-3;
        visit2.Assigned_to__c = UserInfo.getUserId();
        visit2.Visit_Status__c='Complete';
        visit2.Visitfreqchk_c__c='1';
        visit2.Visit_Type__c='Visit';
        visit2.End_Time__c=system.now();
        listOfVisit.add(visit2);
        Visits__c visit3 = new Visits__c();
        visit3.Account__c = a1.Id;
        visit3.contact__c = c1.Id;
        visit3.Visit_Type__c = 'Visit';
        visit3.CurrencyIsoCode = 'EUR';
        visit3.Start_Time__c = date.today()+3;
        visit3.Assigned_to__c = UserInfo.getUserId();
        visit3.Visit_Status__c='Complete';
        visit3.Visitfreqchk_c__c='1';
        visit3.Visit_Type__c='Visit';
        visit3.End_Time__c=system.now()+7;
        listOfVisit.add(visit3);
        insert listOfVisit;
      }
    @IsTest
    static void testmultipleClass2(){
        Test.StartTest();  
		    Account acc1 = [SELECT Id,Account_Status__c FROM Account Where Name = 'Test AccTESR'];
		    Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
		    List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, 
                                  ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: acc2.ID];
			tabShowPadController.getAIIndicators(acc2.Id);
			listContact[0].ShowpadForSF__Showpad_Last_Activity_Date__c= system.today()+2;
			update listContact;
			tabShowPadController.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass3(){
        Test.StartTest();
		    Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
		    acc2.Lenses_Net_Sales_Last_12Mo__c=-1;
		    List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, 
									  ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: acc2.ID];
			update acc2;
		    tabShowPadController.getAIIndicators(acc2.Id);
            listContact[0].ShowpadForSF__Showpad_Last_View_Date__c= system.today()+3;
            update listContact;
            tabShowPadController.getAIIndicators(acc2.Id);
            listContact[0].ShowpadForSF__Showpad_Last_Activity_Date__c= system.today()+3;
            update listContact;
            tabShowPadController.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass4(){
       Test.StartTest();
		    Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST001'];
		    List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, 
									  ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: acc2.ID];
            listContact[0].AccountId=null;
			update listContact;
			tabShowPadController.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass5(){
        Test.StartTest();  
			Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'SO4900TEST5565'];
			List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, 
										  ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: acc2.ID];
		    tabShowPadController.getAIIndicators(acc2.Id);
			acc2.Lenses_Net_Sales_Last_12Mo__c=12;
			update acc2;
			tabShowPadController.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
    @IsTest
    static void testmultipleClass6(){
        Test.StartTest();  
        Account acc2 = [SELECT Id,Account_Status__c FROM Account Where Hoya_Account_ID__c = 'TE-012355'];
        tabShowPadController.getAIIndicators(acc2.Id);
        Test.StopTest();
    }
}