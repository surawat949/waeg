@isTest public class serviceFlow_DeleteActivitiesTest { 
    @testSetup static void setup() {
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUserA = new User(
            Alias = 'standard', Email='standarduser@testorg.com',  
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pro.Id, Country_for_Customer_Support__c = 'South Africa',
            TimeZoneSidKey='America/Los_Angeles', UserName='testUserA@testorganise.com'); 
        
        User testUserB = new User(
            Alias = 'standard', Email='standarduser@testorg.com',  
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pro.Id, Country_for_Customer_Support__c = 'South Africa',
            TimeZoneSidKey='America/Los_Angeles', UserName='testUserB@testorganise.com'); 
        
        testUserA.ManagerID = testUserB.id;
        testUserB.ManagerID = testUserA.id;
        
        List<User> usersToInsert = new List<User>();
        usersToInsert.add(testUserA);
        usersToInsert.add(testUserB);
        insert usersToInsert;
        
        serviceFlow_Activities_Tracking__c sobj = new serviceFlow_Activities_Tracking__c(
          Name = 'Track and Trace  435345',                   
          Status__c = 'Closed',                                 
          Call_Type__c = 'Inbound',                             
          Assigned_To__c = UserInfo.getUserId(),                   
          Record_Type__c = 'serviceFlow_AgentCreateCall',       
          Priority__c = 'Normal',                               
          Task_Subtype__c = 'Call',                             
          Origin__c = 'Telephone',                              
          Due_Date__c = system.today(),             
          Comments__c = 'test record please ignore',            
          User_Country__c = 'South Africa',                     
          Hoya_reference_number__c = '435345',                  
          Subject__c = 'Track and Trace',                       
          ECP_patient_order_number__c = '345345',               
          Sub_Subject__c = 'Multiple breakage',                 
          Number_of_Jobs__c = '77',                             
          Hoya_Account_ID__c = 'SO4400100911',                  
          Deleted_Object_Type__c = 'Task',                      
          Created_Date__c = system.today(),         
          Remainder_Send_Date__c = system.today().addDays(-10),  
          Delete_Record_Date__c = system.today().addDays(-30)   
        );
        insert sobj;
    }
    @isTest public static void testSendEmailToManagers()  
    { 
        List<serviceFlow_Activities_Tracking__c> listOfActivities = [Select Id,User_Country__c,Hoya_reference_number__c,Subject__c,
            ECP_patient_order_number__c,Sub_Subject__c,Number_of_Jobs__c,Hoya_Account_ID__c,Deleted_Object_Type__c,Remainder_Send_Date__c,
            Delete_Record_Date__c,Assigned_To__c,Task_Subtype__c From serviceFlow_Activities_Tracking__c 
        ];
         
        Test.startTest();  
            serviceFlow_DeleteActivities deletedRecs = new serviceFlow_DeleteActivities();
            DataBase.executeBatch(deletedRecs,10); 
            deletedRecs.execute(null);
                      
        Test.stopTest(); 
        system.assertEquals('South Africa', listOfActivities.get(0).User_Country__c);
    } 
}