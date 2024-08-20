/**
* @description       : Test class for TaskTriggerHandler
* @author            : Mohan G (Encora)
* @group             : 
* @last modified on  : 02-17-2022
* @last modified by  : Mohan G (Encora)
* @Class             : TaskTriggerHandler_Test
**/
@isTest
public class TaskTriggerHandler_Test {
    public static Id taskCreateRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('serviceFlow_AgentCreateTask').getRecordTypeId();
    public static Id taskEditRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('serviceFlow_AgentEditTask').getRecordTypeId();
    
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
        
        Task taskObj = New Task();
        taskObj.RecordTypeId = taskEditRecordTypeId;
        taskObj.serviceFlow_Contact_Name__c = null;
        //taskObj.serviceFlow_Contact_First_Name__c = 'test First Name';
        //taskObj.serviceFlow_Contact_Last_Name__c = 'test Last Name';
        //taskObj.serviceFlow_Contact_Number__c = '9876543210';
        //taskObj.serviceFlow_Contact_Email__c = 'testUser@hoya.com';
        insert taskObj;
    }
    
    public Static testmethod void createContactTest(){
        User usRec = [SELECT Id FROM User WHERE username ='testUser@hoya.com'];
        system.runAs(usRec) {
            Task taskObj = [SELECT Id, serviceFlow_Contact_Name__c FROM Task LIMIT 1];            
        }
    }   
}