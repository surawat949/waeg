/*
     * @Author : Mohan Krishna
     * @Class name : UserLogic_Test
     * Created date : 2023-04-20
     * Updated date : 
     * @Created by : Mohan Krishna
     * @Description : Test class for UserLogic.cls apex class
 */

@isTest
public class UserLogic_Test {
    
  
    @TestSetup
    public static void makeData(){

        String RecTypeId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
        String MasterTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and Name='Master'].Id;
        String CopyTempId = [select Id, Name from RecordType where sObjectType='Account_Template__c' and DeveloperName='Copy'].Id;

        Account_Template__c master = new Account_Template__c();
        master.RecordTypeId = MasterTempId;
        master.Name = 'HOLK-Test-master';
        insert master;

        Account a = new Account();
        a.Hoya_Account_Id__c = 'SK1112';
        a.Name = 'Test-sk';
        a.CurrencyIsoCode = 'EUR';
        a.Portal__c='beseikoportal';
        insert a;

        Account a1 = new Account();
        a1.Hoya_Account_Id__c = 'SK1113';
        a1.Name = 'Test-sk2';
        a1.currencyisocode = 'EUR';
        insert a1;

        Account_Template__c copy = new Account_Template__c();
        copy.Name = 'holk-test-copy';
        copy.Account__c = a.Id;
        copy.Default__c = true;
        copy.Master_Template__c = master.Id;
        copy.Active_Authorization_Template__c = true;
        copy.RecordTypeId = CopyTempId;
        insert copy;

        Contact c = new Contact();
        c.FirstName = 'testh';
        c.LastName = 'lasth';
        c.Account_Template__c = copy.Id;
        c.AccountId = a.Id;
        c.Email = 'test@hotmail.com';
        c.Created_on_portal__c=true;
        c.Invite_Portal_Email__c='  VI, HLC, Hoya Hub';
        c.Language_Pick__c='en-us';
        c.RecordTypeId = RecTypeId;
        insert c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'testl';
        c1.LastName = 'lastl';
        c1.Account_Template__c = copy.Id;
        c1.AccountId = a.Id;
        c1.Email = 'test1@hotmail.com';
        c1.Created_on_portal__c=false;
        c1.Invite_Portal_Email__c='HOYA Learning Center';
        c1.Language_Pick__c='en-us';
        c1.RecordTypeId = RecTypeId;
        insert c1;

        Profile p = [select Id from Profile where Name = 'Customer Community Plus User' limit 1];

        User u = new User();
        u.FirstName = 'Testcommunity1';
        u.LastName = 'Testlastcomm1';
        u.Email = 'testyyy@gmail.com.invalid';
        u.UserName = 'testyyy@tradeportal.hoya.com.waeg';
        u.profileid = p.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testzxcv';
        u.EmailEncodingKey = 'UTF-8';
        u.ContactId = c.Id;
        u.Reset_Password_Token__c='KJWHE7346873';
        insert u;

        System.debug('User-->99'+u);

    }

    
    @isTest
    public static void sendEmailHandlerTest(){
                
        User u1 = [Select id,Reset_Password_Token__c,Reset_Password_Context__c from user WHERE UserName='testyyy@tradeportal.hoya.com.waeg' LIMIT 1];
        u1.Reset_Password_Token__c='LJWHE7346875';
        update u1;
                
        Contact c=[Select id,Created_on_portal__c,Account.name,Account.Portal__c,Contact_Record_Type__c,Account_Template__c,Account_Portal__c,Invite_Portal_Email__c from contact where FirstName = 'testh'];
        System.debug('Contact Details-->'+c);
        
        List<User> newList=[SELECT Id, Profile.Name, Reset_Password_Token__c, 
                            Reset_Password_Context__c, Username, ContactId, Contact.Id, 
                            Contact.Created_on_portal__c, Contact.Contact_Record_Type__c, 
                            Contact.Account_Template__c, Contact.Account_Portal__c, 
                            Contact.Invite_Portal_Email__c, 
                            Contact_Language__c FROM User WHERE ContactId =: c.Id];
       
       System.debug('newLIST-->'+newList);
       
       Map<Id, User> oldObjectsMap=new  Map<Id, User>([Select Id,Profile.Name,Reset_Password_Token__c,Reset_Password_Context__c, Username, ContactId,
                            Contact.Created_on_portal__c,Contact.Contact_Record_Type__c, Contact.Account_Template__c,
                            Contact.Account_Portal__c, Contact.Invite_Portal_Email__c, Contact_Language__c from user where UserName='testyyy@tradeportal.hoya.com.waeg']); 
       Test.startTest();

       UserLogic.sendEmailHandler(newList,oldObjectsMap);
       
       u1.Reset_Password_Context__c = 'PasswordReset';
       u1.Reset_Password_Token__c = null;
       update u1;

       UserLogic.sendEmailHandler(newList,oldObjectsMap);
       
       
       u1.Reset_Password_Context__c = 'NewEmployee';
       u1.Reset_Password_Token__c = null;
       update u1;
       
       UserLogic.sendEmailHandler(newList,oldObjectsMap);
      

       Test.stopTest();
    }
    
    
    @isTest
    public static void sendEmailHandlerResetPasswordTest(){
       
       Test.startTest();                     
             
       Account a=[SELECT Id,Portal__c,Hoya_Account_Id__c FROM Account WHERE Hoya_Account_Id__c='SK1112'];
       a.Portal__c ='exportportal';
       update a;
       
       Contact c=[Select id,Created_on_portal__c,Account.name,Account.Portal__c,Contact_Record_Type__c,Account_Template__c,Account_Portal__c,Invite_Portal_Email__c from contact where FirstName = 'testh'];
       c.Invite_Portal_Email__c = 'HOYA Contact Lenses ';
       update c;

       User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       System.runAs (thisUser) {
        User u1 = [Select id,Reset_Password_Token__c,Reset_Password_Context__c from user WHERE UserName='testyyy@tradeportal.hoya.com.waeg' LIMIT 1];
        u1.Reset_Password_Token__c='LJWHE7346875';
        update u1;
       }

        c.Invite_Portal_Email__c = 'Costco Portal';
        update c;
        System.runAs (thisUser) {
        User u1 = [Select id,Reset_Password_Token__c,Reset_Password_Context__c from user WHERE UserName='testyyy@tradeportal.hoya.com.waeg' LIMIT 1];
        u1.Reset_Password_Token__c='MJWHE7346875';
        update u1;
       }
       
       Test.stopTest();

    
    }
    
    
     @isTest
    public static void sendEmailHandlerNewEmployeeTest(){
       Test.startTest();                     
      
       Account a=[SELECT Id,Portal__c,Hoya_Account_Id__c FROM Account WHERE Hoya_Account_Id__c='SK1112'];
       a.Portal__c ='exportportal';
       update a;
       
       Contact c=[Select id,Created_on_portal__c,Account.name,Account.Portal__c,Contact_Record_Type__c,Account_Template__c,Account_Portal__c,Invite_Portal_Email__c from contact where FirstName = 'testh'];
       c.Invite_Portal_Email__c = 'HOYA Learning Center';
       update c;
       
       User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

       System.runAs (thisUser) {
        User u1 = [Select id,Reset_Password_Token__c,Reset_Password_Context__c from user WHERE UserName='testyyy@tradeportal.hoya.com.waeg' LIMIT 1];
        u1.Reset_Password_Token__c=null;
        u1.Reset_Password_Context__c='NewEmployee';
        update u1;
       }
       
       Test.stopTest();

    
    }
    
    
    @isTest
    public static void sendEmailAfterInsertNewEmployeeTest(){
       Test.startTest();                     
      
       
       Contact c1=[Select id,Created_on_portal__c,Account.name,Account.Portal__c,Contact_Record_Type__c,Account_Template__c,Account_Portal__c,Invite_Portal_Email__c from contact where FirstName = 'testl'];
        
        Profile p1 = [select Id from Profile where Name = 'Customer Community Plus User' limit 1];

        User u = new User();
        u.FirstName = 'Testcommunity2';
        u.LastName = 'Testlastcomm2';
        u.Email = 'test@gmail.com.invalid';
        u.UserName = 'test@tradeportal.hoya.com.waeg';
        u.profileid = p1.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testzxcv';
        u.EmailEncodingKey = 'UTF-8';
        u.ContactId = c1.Id;
        u.Reset_Password_Token__c='TJWHE7346876';
        insert u; 
        
       
            
       Test.stopTest();
 }   


@isTest
    public static void updateIsServiceUserTest(){
       Test.startTest();                                   
        Profile p1 = [select Id from Profile where Name = 'Standard User' limit 1];

        User u = new User();
        u.FirstName = 'Testuser';
        u.LastName = 'Testlastuser';
        u.Email = 'test1@gmail.com.invalid';
        u.UserName = 'test1@tradeportal.hoya.com.waeg';
        u.profileid = p1.Id;
        u.LocaleSidkey = 'en_US';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.CompanyName = 'HVC';
        u.Alias = 'testxcv';
        u.EmailEncodingKey = 'UTF-8';
        u.UserPermissionsSupportUser = true;
        insert u;       
        
        
        u.UserPermissionsSupportUser =false;
        update u;    
       Test.stopTest();
 }   

}