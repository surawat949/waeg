@isTest
private class TrgCampaign_AIU_addWorkspace2MobConfig {
 /*
    static testMethod void myUnitTest() {
		
		Account a = new Account();
		a.Name = 'test';
		insert a;
		System.debug(a);
    	
    	//Profile p = [select Id from Profile limit 1];
    	User uu = new User();
    	uu.Username='ds@sdd.com';
    	uu.LastName = 'dds';
    	uu.Email='ds@sdd.com';
    	uu.Alias='ds';
    	uu.CommunityNickname = 'w';
    	uu.TimeZoneSidKey  ='Europe/Dublin';
    	uu.LocaleSidKey = 'en_GB';
    	uu.EmailEncodingKey ='ISO-8859-1';
    	uu.ProfileId = '00eb0000000lainAAA';
    	uu.LanguageLocaleKey='en_US';
    	insert uu;
    	System.debug(uu);
    	
    	ContentWorkspace cw = [select Id FROM ContentWorkspace limit 1];
    	System.debug(cw);
    	
        //User u = [SELECT Id, ProfileId FROM User where id=:cc.OwnerId limit 1];
		integer countNo = 0;
		String mvamconfgId = '';
		
		MobileVizArt__Mobile_Configuration__c m = new MobileVizArt__Mobile_Configuration__c();
		//m.OwnerId = uu.Id;
		m.MobileVizArt__Profiles__c = '00eb0000000lainAAA';
		insert m;
		System.debug(m);
		
		System.debug([select Id from MobileVizArt__Mobile_Content__c where MobileVizArt__Mobile_Configuration__c =: m.Id ]);
		
		Test.startTest();
    	Campaign cc = new Campaign();
		cc.Name = 'a';
		cc.Campaign_Description__c = 'a';
		cc.CurrencyIsoCode = 'EUR';
		cc.OwnerId = uu.Id;
		cc.Content_Workspace_Id__c = cw.Id;
		insert cc;
		System.debug(cc);
		Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
		Account a = new Account();
		a.Name = 'test';
		insert a;
		System.debug(a);
    	
    	//Profile p = [select Id from Profile limit 1]; 
    	User uu = new User();
    	uu.Username='ds@sdd.com';
    	uu.LastName = 'dds';
    	uu.Email='ds@sdd.com';
    	uu.Alias='ds';
    	uu.CommunityNickname = 'w';
    	uu.TimeZoneSidKey  ='Europe/Dublin';
    	uu.LocaleSidKey = 'en_GB';
    	uu.EmailEncodingKey ='ISO-8859-1';
    	uu.ProfileId = '00eb0000000lairAAA';
    	uu.LanguageLocaleKey='en_US';
    	insert uu;
    	System.debug(uu);
    	
        //User u = [SELECT Id, ProfileId FROM User where id=:cc.OwnerId limit 1];
		integer countNo = 0;
		String mvamconfgId = '';
		
		MobileVizArt__Mobile_Configuration__c m = new MobileVizArt__Mobile_Configuration__c();
		m.OwnerId = uu.Id;
		m.MobileVizArt__Profiles__c = '00eb0000000lairAAA';
		insert m;
		
    	List<ContentWorkspace> list_cw = [select Id FROM ContentWorkspace];
    	System.debug(list_cw);
		
		MobileVizArt__Mobile_Content__c mm = new MobileVizArt__Mobile_Content__c();
		mm.MobileVizArt__Mobile_Configuration__c = m.Id;
		mm.MobileVizArt__Workspace__c = list_cw.get(0).Id;
		insert mm;
		System.debug(mm);
		
		MobileVizArt__Mobile_Content__c mmm = new MobileVizArt__Mobile_Content__c();
		mmm.MobileVizArt__Mobile_Configuration__c = m.Id;
		mmm.MobileVizArt__Workspace__c = list_cw.get(0).Id;
		insert mmm;
		System.debug(mmm);
		
		System.debug([select Id from MobileVizArt__Mobile_Content__c where MobileVizArt__Mobile_Configuration__c =: m.Id ]);
	
		Test.startTest();
    	Campaign cc = new Campaign();
		cc.Name = 'a';
		cc.Campaign_Description__c = 'a';
		cc.CurrencyIsoCode = 'EUR';
		cc.OwnerId = uu.Id;
		cc.Content_Workspace_Id__c = list_cw.get(0).Id;
		insert cc;
		System.debug(cc);
		Test.stopTest();
    }
*/
}