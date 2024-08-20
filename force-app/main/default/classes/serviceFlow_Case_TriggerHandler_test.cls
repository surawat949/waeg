/**
* @description       : controller method for case serviceFlow_AgentNavigator.cmp
* @author            : Mohan G (Encora)
* @group             : 
* @last modified on  : 01-15-2022
* @last modified by  : Mohan G (Encora)
* @Class             : serviceFlow_AgentNavigatorCtrl
**/
@isTest
public class serviceFlow_Case_TriggerHandler_test {
    public static Id accontRecordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Eye Doctor').getRecordTypeId();
    //public static Id caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
    public static Id caseRecordTypeName = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ServiceFlow_Case_Create').getRecordTypeId();
    public static Id taskRecordTypeName = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
    
    @testSetup static void setup() {
        
        Profile p = [select Id FROM Profile WHERE Name = 'System Administrator']; 
        
        User adminUser = new user(alias = 'test123', email='testUser@hoya.com',
                                  emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_IN', profileid = p.Id, country='India',
                                  timezonesidkey='Asia/Kolkata', username='testUser@hoya.com',
                                  Country_for_Customer_Support__c = 'USA'); 
        insert adminUser;
        
        system.runAs(adminUser){
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'serviceFlow_ComponentVisibility'];
            insert new PermissionSetAssignment(AssigneeId = adminUser.Id, PermissionSetId = ps.Id);
        }
        
        List<Case> testCases = new List<Case>();
        Account accObj = new Account(
            RecordTypeId = accontRecordTypeName,
            Name = '4151982 - Rachyls Eyes 4 U [View Hierarchy]',
            Shop_Name__c = 'Rachyls Eyes 4 U',
            //Responsible_Customer_Service_Agent__c = '0059E00000BS1zG',
            Account_Status__c = 'Open',
            Phone = '844-736-5773',
            Hoya_Account_ID__c = '4151982',
            NumberOfEmployees = 10,
            DMU__c = 'The Big Nacho Rachyl',
            First_Competitor_global_name__c = 'HOYA',
            First_Competitor_local_name__c = 'HOYA',
            CHCUSTCLASSIFICATIONID__c = 'Ind',
            CHINTERNATIONALGROUP__c = 0,
            Visionary_Alliance__c = 'none',
            Language__c = 'en-us',
            Portal__c = 'usportal',
            Myo_Smart_AuthorizeDealer__c = true,
            Myo_Smart_TrainingComplete__c = false,
            Myo_Kids_Corner__c = true,
            Hoya_Local_Mkt_Campaign_1__c = false,
            Hoya_Local_Mkt_Campaign_2__c = false,
            Onboarding_Customer__c = false,
            Target_List__c = false,
            Potential__c = 0.00,
            Payment_issue__c = false,
            Agreed_Visits__c = 0,
            Financial_Status__c = 'Regular',
            Hunting_Status__c = 'C'
        );
        insert accObj;
        
        Contact conObj = new Contact(
            AccountId = accObj.Id,
            Email = 'testuserhoya@yopmail.com',
            Do_not_visit__c = false,
            Phone = '844-736-5773',
            DoNotCall = false,
            HasOptedOutOfEmail = false,
            HasOptedOutOfFax = false,
            Language_Pick__c = 'English ‎(US)‎',
            Invite_Portal_Email__c = 'HOYA Hub',
            Send_Registration_Email_Flag__c = false,
            LastName = 'test User'
        );
        insert conObj;
        
        Case caseObj = New Case();
        caseObj.Status = 'New';
        caseObj.AccountId = accObj.Id;
        caseObj.ContactId = conObj.Id;
        caseObj.serviceFlow_Case_Type__c = 'Complaints';
        caseObj.Priority = 'Medium';
        caseObj.Send_Email__c = true;
        caseObj.serviceFlow_Send_a_reminder__c = true;
        caseObj.Ticket_created_date__c = system.now();
        caseObj.serviceFlow_Due_Date__c = system.now() + 1;
        caseObj.Description = 'test hoya';
        caseObj.SFlow_Subject__c = 'Job status';
        caseObj.Origin = 'E-Mail';
        caseObj.User_country__c = 'USA';
        caseObj.SFlow_Subject__c = 'Job status';
        caseObj.SFlow_Sub_Subject__c = 'Outsource';
        caseObj.RecordTypeId = caseRecordTypeName;
        caseObj.OwnerId = adminUser.Id;
        caseObj.serviceFlow_Account_Shop_email_address__c = 'testUser@hoya.com';
        insert caseObj;
        
        Case caseObj1 = New Case();
        caseObj1.Status = 'New';
        caseObj1.AccountId = accObj.Id;
        caseObj1.serviceFlow_Case_Type__c = 'Complaints';
        caseObj1.Priority = 'Medium';
        caseObj1.Send_Email__c = false;
        caseObj1.serviceFlow_Send_a_reminder__c = false;
        caseObj1.serviceFlow_Different_to_account_info__c = true;
        caseObj1.Ticket_created_date__c = system.now();
        caseObj1.serviceFlow_Due_Date__c = system.now() + 1;
        caseObj1.Description = 'test hoya';
        caseObj1.SFlow_Subject__c = 'Job status';
        caseObj1.Origin = 'E-Mail';
        caseObj1.User_country__c = 'USA';
        caseObj1.SFlow_Subject__c = 'Job status';
        caseObj1.SFlow_Sub_Subject__c = 'Outsource';
        caseObj1.RecordTypeId = caseRecordTypeName;
        caseObj1.OwnerId = adminUser.Id;
        caseObj1.serviceFlow_Account_Shop_email_address__c = '';
        caseObj1.serviceFlow_Contact_First_Name__c = 'test';
        caseObj1.serviceFlow_Contact_Last_Name__c = 'user';
        //caseObj1.serviceFlow_Contact_Number__c = '9876543210';
        caseObj1.serviceFlow_Contact_Email__c = 'testUser@hoya.com';
        //insert caseObj1;

    }
    
    public Static testmethod void afterInsertMethodTest(){
        User usRec = [SELECT Id FROM User WHERE username ='testUser@hoya.com'];
        system.runAs(usRec) {
            Case caseObj = [SELECT Id FROM Case LIMIT 1];
            caseObj.Id = null;
            caseObj.serviceFlow_Send_a_reminder__c = true;
            insert caseObj;            
        }
    }
    
    public Static testmethod void afterUpdateMethodTest(){
        User usRec = [SELECT Id FROM User WHERE username ='testUser@hoya.com'];
        system.runAs(usRec) {
            Case caseObj = [SELECT Id FROM Case LIMIT 1];
            caseObj.Id = null;
            caseObj.serviceFlow_Send_a_reminder__c = false;
            insert caseObj;
            
            caseObj.serviceFlow_Send_a_reminder__c = true;
            update caseObj;            
        }
    }
}