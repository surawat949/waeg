@isTest public class serviceFlow_SendEmailToManagersTest { 
    @isTest public static void testSendEmailToManagers()  
    { 
        Test.startTest();  
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
            
            serviceFlow_Activities_Tracking__c sobj1 = new serviceFlow_Activities_Tracking__c(
              Name = 'Track and Trace  435347',                   
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
              ECP_patient_order_number__c = '3453495',               
              Sub_Subject__c = 'Multiple breakage',                 
              Number_of_Jobs__c = '77',                             
              Hoya_Account_ID__c = 'SO4400100911',                  
              Deleted_Object_Type__c = 'Task',                      
              Created_Date__c = system.today(),         
              Remainder_Send_Date__c = system.today().addDays(-10),  
              Delete_Record_Date__c = system.today().addDays(-30)   
            );
            List<serviceFlow_Activities_Tracking__c> activitiesToInsert = new List<serviceFlow_Activities_Tracking__c>();
            activitiesToInsert.add(sobj);
            activitiesToInsert.add(sobj1);
            insert activitiesToInsert;  
            serviceFlow_SendEmailToManagers obj = new serviceFlow_SendEmailToManagers(); 
            DataBase.executeBatch(obj,10);     
            obj.execute(null);   
        Test.stopTest(); 
    } 
     @isTest public static void testSendEmailToManagers1()  
    { 
        Test.startTest();  
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
            
            serviceFlow_Activities_Tracking__c sobj1 = new serviceFlow_Activities_Tracking__c(
              Name = 'Track and Trace  435347',                   
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
              ECP_patient_order_number__c = '3453495',               
              Sub_Subject__c = 'Multiple breakage',                 
              Number_of_Jobs__c = '77',                             
              Hoya_Account_ID__c = 'SO4400100911',                  
              Deleted_Object_Type__c = 'Task',                      
              Created_Date__c = system.today(),         
              Remainder_Send_Date__c = system.today().addDays(-10),  
              Delete_Record_Date__c = system.today().addDays(-30)   
            );
            List<serviceFlow_Activities_Tracking__c> activitiesToInsert = new List<serviceFlow_Activities_Tracking__c>();
            activitiesToInsert.add(sobj);
            activitiesToInsert.add(sobj1);
            insert activitiesToInsert;   
            
            serviceFlow_SendEmailUtility.getDefaultManagers();
            serviceFlow_SendEmailUtility.sendEmailToManagers(new List < String > {usersToInsert.get(0).Email},'test');
            serviceFlow_SendEmailUtility.getManagerEmailsBasedOnCountry(new Set<String> {'South Africa'});
            serviceFlow_SendEmailUtility.finish(new Map < String, List < serviceFlow_Activities_Tracking__c >> {'South Africa' => activitiesToInsert});
            
        Test.stopTest(); 
    } 
}