/**
 * @description       : 
 * @author            : 
 * @group             : 
 * @last modified on  : 01-25-2022
 * @last modified by  : Mohan G (Encora)
**/
public class TaskTriggerHandler {
     //SSU add and create on 2-Apr-2021
    //Trigger helper for Task generate from approval process.
    public static Id taskCreateRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('serviceFlow_AgentCreateTask').getRecordTypeId();
    public static Id taskEditRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('serviceFlow_AgentEditTask').getRecordTypeId();
    public static Id customerServiceContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('serviceFlow_Customer_Service_Contact').getRecordTypeId();

    /*public static void ReturnRelateId(List<Task> newList){
       
        List<Id> ParentsId = new List<Id>();
        String taskRecTypeId = [select Id, Name from RecordType where sObjectType='Task' and Name='APAC Standard Hoya Task'].Id;
        
        for(Task thistask : newList){
            
            ParentsId.add(thistask.WhatId);
        }
        
        Map<Id, RejectAndReturn_CS__c> theReturns = new Map<Id, RejectAndReturn_CS__c>([select Id, Name, OwnerId, CurrencyIsoCode from RejectAndReturn_CS__c where Id IN:ParentsId]);
        //Map<Id, CRF_Form__c> CRF = new Map<Id, CRF_Form__c>([select Id, Name, OwnerId, CurrencyIsoCode from CRF_Form__c where Id IN:ParentsId]);
        
        for(Task thistask : newList){
            
            //thistask.OwnerId = theReturns.get(thistask.WhatId).OwnerId;
            //thistask.RecordTypeId = taskRecTypeId; - to remove in this line cause will affect to all task created.
            
            if(thistask.Subject == 'This lens reject id was approved'){
                
                thistask.CurrencyIsoCode = theReturns.get(thistask.WhatId).CurrencyIsoCode;
                thistask.RejectReturn__c = theReturns.get(thistask.WhatId).Id;
                thistask.Subject = 'This lens reject id : '+theReturns.get(thistask.WhatId).Name+' was approved.';
                thistask.RecordTypeId = taskRecTypeId;
                //thistask.Description = 'This R&R was approved by your manager.';
                
            }else if(thistask.Subject == 'This lens reject id was not approved'){
                thistask.CurrencyIsoCode = theReturns.get(thistask.WhatId).CurrencyIsoCode;
                thistask.RejectReturn__c = theReturns.get(thistask.WhatId).Id;
                thistask.Subject = 'This lens reject id : '+theReturns.get(thistask.WhatId).Name+' was NOT approved.';
                thistask.RecordTypeId = taskRecTypeId;
                //thistask.Description = 'This R&R was NOT approved by your manager.';
                
            }else if(thistask.Subject == 'This reject lens was approved.'){
                thistask.CurrencyIsoCode = theReturns.get(thistask.WhatId).CurrencyIsoCode;
                thistask.RejectReturn__c = theReturns.get(thistask.WhatId).Id;
                thistask.Subject = 'This lens reject id : '+theReturns.get(thistask.WhatId).Name+' was approved.';
                thistask.RecordTypeId = taskRecTypeId;
                //thistask.Description = 'This R&R was approved by your manager.';
                
            }else if(thistask.Subject == 'This reject lens was NOT approved.'){
                thistask.CurrencyIsoCode = theReturns.get(thistask.WhatId).CurrencyIsoCode;
                thistask.RejectReturn__c = theReturns.get(thistask.WhatId).Id;
                thistask.Subject = 'This lens reject id : '+theReturns.get(thistask.WhatId).Name+' was NOT approved.';
                thistask.RecordTypeId = taskRecTypeId;
                //thistask.Description = 'This R&R was NOT approved by your manager.';
                
            }else if(thistask.Subject == 'Task to Hui Peng Lim'){
                thistask.CurrencyIsoCode = theReturns.get(thistask.WhatId).CurrencyIsoCode;
                thistask.RejectReturn__c = theReturns.get(thistask.WhatId).Id;
                thistask.Subject = 'This R&R require for C/N, R&R ID : '+theReturns.get(thistask.WhatId).Name;
                thistask.RecordTypeId = taskRecTypeId;
                //Task to Hui Peng Lim when user require for C/N
            }else{
                thistask.Subject = thistask.Subject;
                //thistask.Description = 'Unknown error was happened, please contact your system administrator.';
            }
            
        }
     }*/
      
      
     //serviceFlow - Method to create contact if the contact is not found in the current contact list
     public static void createContact(List<Task> newList) {
        /*
        map<id, Contact> taskToContactMap = New map<id, Contact>();
        list<task> taskUpdateList = New list<task>();

        for(task taskObj : newList) {
            if(taskObj.recordtypeId == taskCreateRecordTypeId || taskObj.recordtypeId == taskEditRecordTypeId && string.isBlank(taskObj.serviceFlow_Contact_Name__c) 
               && (string.isNotBlank(taskObj.serviceFlow_Contact_First_Name__c) || string.isNotBlank(taskObj.serviceFlow_Contact_Last_Name__c)
                  || string.isNotBlank(taskObj.serviceFlow_Contact_Number__c) || string.isNotBlank(taskObj.serviceFlow_Contact_Email__c))) {
                contact conObj = New contact();
                conObj.FirstName = taskObj.serviceFlow_Contact_First_Name__c;
                conObj.LastName = taskObj.serviceFlow_Contact_Last_Name__c;
                conObj.Phone = taskObj.serviceFlow_Contact_Number__c;
                conObj.Email = taskObj.serviceFlow_Contact_Email__c;
                conObj.RecordTypeId = customerServiceContactRecordTypeId;
                conObj.AccountId = taskObj.AccountId;
                taskToContactMap.put(taskObj.Id, conObj);
            }
        }

        if(!taskToContactMap.isEmpty()) {
            insert taskToContactMap.values();
        }

        for(task taskObj : [SELECT Id, serviceFlow_Contact_Name__c, WhoId FROM Task WHERE ID IN :taskToContactMap.keySet()]) {
            task taskRec = New task();
            taskRec.Id = taskObj.Id;
            taskRec.serviceFlow_Contact_Name__c = taskToContactMap.get(taskObj.Id).Id;
            taskRec.WhoId = taskToContactMap.get(taskObj.Id).Id;
            taskUpdateList.add(taskRec);
        }

        if(!taskUpdateList.isEmpty()) {
            update taskUpdateList;
        }
        */
    }
    
  }