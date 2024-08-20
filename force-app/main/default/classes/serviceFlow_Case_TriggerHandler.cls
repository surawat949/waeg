/**
 * @description       : Helper method for case trigger
 * @author            : Mohan G (Encora)
 * @group             : 
 * @last modified on  : 02-17-2022
 * @last modified by  : Mohan G (Encora)
**/
public class serviceFlow_Case_TriggerHandler {
    public static Id caseCreateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ServiceFlow_Case_Create').getRecordTypeId();
    public static Id caseEditRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ServiceFlow_Case_Edit').getRecordTypeId();
    public static Id taskEditRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('serviceFlow_AgentEditTask').getRecordTypeId();
    public static Id customerServiceContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('serviceFlow_Customer_Service_Contact').getRecordTypeId();

    public static void afterInsertMethod(List<case> newList, Map<Id, case> newMap) {
        Boolean recurseAfterInsert = true;
        if(recurseAfterInsert) {
            if(isServiceFlowUser()) {
                recurseAfterInsert = false;
                createTask(newList);
                createContact(newList);
                //invokeAutoResponseRules(newMap.keySet());
                sendEmailToAccountShopEmail(newList, newMap.keySet());
            }
        }        
    } 

    public static void afterUpdateMethod(List<case> newList, Map<Id, case> newMap, List<case> oldList, Map<Id, case> oldMap) {
        Boolean recurseAfterUpdate = true;
        if(recurseAfterUpdate) {
            if(isServiceFlowUser()) {
                recurseAfterUpdate = false;
                createTaskOnCaseUpdate(newList, newMap, oldMap);
            }
        }
    }

    public static void createTask(List<case> newList) {
        list<Task> taskInsertList = New list<Task>();
        for(case caseObj : newList) {
            System.debug('====1'+ caseObj.serviceFlow_Send_a_reminder__c);
            System.debug('====2'+ caseObj.recordtypeId );
            System.debug('====3'+ caseCreateRecordTypeId);
            System.debug('====3'+ caseEditrecordTypeId);
            if (caseObj.serviceFlow_Send_a_reminder__c && 
               (caseObj.recordtypeId == caseCreateRecordTypeId || caseObj.recordtypeId == caseEditrecordTypeId)) {
                Task newTask = New Task();
                newTask.WhatId = caseObj.Id;
                newTask.Account__c = caseObj.AccountId;
                //newTask.ActivityDate = date.valueOf(caseObj.serviceFlow_Due_Date__c);
                newTask.OwnerId = caseObj.OwnerId;
                newTask.RecordTypeId = taskEditRecordTypeId;
                newTask.ReminderDateTime = date.valueOf(caseObj.Ticket_created_date__c)+1;
                newTask.serviceFlow_User_Country__c = caseObj.User_country__c;
                newTask.SFlow_Subject__c = caseObj.SFlow_Subject__c;
                newTask.SFlow_Sub_Subject__c = caseObj.SFlow_Sub_Subject__c;
                newTask.Subject = caseObj.SFlow_Subject__c;
                newTask.serviceFlow_Origin__c = caseObj.origin;
                newTask.Status = 'New';
                newTask.Description = caseObj.Description;
                newTask.IsReminderSet = true;
                system.debug(caseObj.serviceFlow_Due_Date__c.date() + ' -- ' + system.today() + ' -- ' + caseObj.CreatedDate);
                if(caseObj.serviceFlow_Due_Date__c.date() != system.today()) {
                    system.debug('came for reccurence');
                    newTask.IsRecurrence = true;
                    newTask.RecurrenceStartDateOnly = date.valueOf(caseObj.Ticket_created_date__c)+1;
                    newTask.RecurrenceEndDateOnly = date.valueOf(caseObj.serviceFlow_Due_Date__c);
                    newTask.RecurrenceType = 'RecursDaily';
                    newTask.RecurrenceInterval = 1;
                }
                taskInsertList.add(newTask);
            }
        }
        if(!taskInsertList.isEmpty()) {
            insert taskInsertList;
        }
    }

    public static void createTaskOnCaseUpdate(List<case> newList, Map<Id, case> newMap, Map<Id, case> oldMap) {
        list<Case> caseListToCreateTask = New list<Case>();
        Set<Id> caseIdsWithTask = new Map<Id, AggregateResult>([SELECT WhatId Id FROM Task WHERE WhatId IN :newList AND TaskSubtype = 'Task' GROUP BY WhatId]).keySet();
        System.debug(caseIdsWithTask);

        for(case newCase : newList) {
            if(newCase.serviceFlow_Send_a_reminder__c && newCase.serviceFlow_Send_a_reminder__c != oldMap.get(newCase.Id).serviceFlow_Send_a_reminder__c
               && !caseIdsWithTask.contains(newCase.Id)) {
                caseListToCreateTask.add(newCase);
            }
        }

        if(!caseListToCreateTask.isEmpty()) {
            createTask(caseListToCreateTask);
        }
    }

    /*public static void invokeAutoResponseRules(set<Id> caseIdSet){
        List<case> caseUpdateList = New List<Case>();        
        for(case caseObj : [SELECT Id, recordtypeId FROM Case WHERE Id IN :caseIdSet]) {
            if (caseObj.recordtypeId == caseCreateRecordTypeId || caseObj.recordtypeId == caseEditrecordTypeId) {
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerAutoResponseEmail = true;
                caseObj.setOptions(dmo);
                caseUpdateList.add(caseObj);
            }
        }
        if(!caseUpdateList.isEmpty()) {
            Database.update(caseUpdateList);
        }
    }*/

    public static boolean isServiceFlowUser (){
        boolean serviceflowUser = false;
        List<PermissionSetAssignment> psetList = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() 
                                                  AND PermissionSet.Name = 'serviceFlow_ComponentVisibility'];
        if(!psetList.isEmpty()) {
            serviceflowUser = true;
        }
        return serviceflowUser;
    }

    public static void createContact(List<case> newList) {
        map<id, Contact> caseToContactMap = New map<id, Contact>();
        list<case> caseUpdateList = New list<case>();

        for(case caseObj : newList) {
            if((caseObj.recordtypeId == caseCreateRecordTypeId || caseObj.recordtypeId == caseEditrecordTypeId) 
                && caseObj.serviceFlow_Different_to_account_info__c && string.isBlank(caseObj.ContactId)) {
                contact conObj = New contact();
                conObj.FirstName = caseObj.serviceFlow_Contact_First_Name__c;
                conObj.LastName = caseObj.serviceFlow_Contact_Last_Name__c;
                //conObj.Phone = caseObj.serviceFlow_Contact_Number__c;
                conObj.Email = caseObj.serviceFlow_Contact_Email__c;
                conObj.RecordTypeId = customerServiceContactRecordTypeId;
                conObj.AccountId = caseObj.AccountId;
                caseToContactMap.put(caseObj.Id, conObj);
            }
        }

        if(!caseToContactMap.isEmpty()) {
            insert caseToContactMap.values();
        }

        for(case caseObj : [SELECT Id, ContactId FROM Case WHERE ID IN :caseToContactMap.keySet()]) {
            case caseRec = New case();
            caseRec.Id = caseObj.Id;
            caseRec.ContactId = caseToContactMap.get(caseObj.Id).Id;
            caseRec.serviceFlow_Contact_Email__c = '';
            caseRec.serviceFlow_Contact_First_Name__c = '';
            caseRec.serviceFlow_Contact_Last_Name__c = '';
            //caseRec.serviceFlow_Contact_Number__c = '';
            caseUpdateList.add(caseRec);
        }

        if(!caseUpdateList.isEmpty()) {
            update caseUpdateList;
        }
    }

    public static void sendEmailToAccountShopEmail(List<case> newList, set<Id> newIdSet) {
        map<string, EmailTemplate> countryToEmailMap = new map<string, EmailTemplate>();
        map<string, string> templateToCountryMap = new map<string, string>();
        map<id,string> idToOwnerNameMap = New map<id,string>();
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        list<case> caseUpdateList = New list<case>();
        OrgWideEmailAddress owea = [SELECT Id, Address, DisplayName 
                                    FROM OrgWideEmailAddress WHERE Address='ordine.lenti@hoya.it'];
        string body;
        

        for(serviceFlow_Country_and_Template_Config__mdt cTemp : serviceFlow_Country_and_Template_Config__mdt.getAll().values()){
            templateToCountryMap.put(cTemp.serviceFlow_Template_Name__c, cTemp.MasterLabel);
        }        
        system.debug('templateToCountryMap -- ' + templateToCountryMap);    
        for(EmailTemplate emTemp : [SELECT Id, Name, Subject, Description, HtmlValue, DeveloperName, Body 
                                    FROM EmailTemplate WHERE 
                                    Name LIKE '%serviceFlow Case Creation Email Notification to Customer%']){           
            if(!templateToCountryMap.isEmpty()) {
                if(templateToCountryMap.containsKey(emTemp.Name)) {
                    countryToEmailMap.put(templateToCountryMap.get(emTemp.Name), emTemp);
                }
            }
        }    
        system.debug('countryToEmailMap -- ' + countryToEmailMap);
        for(case caseObj : [SELECT Id, OwnerId, Send_Email__c, serviceFlow_Account_Shop_email_address__c, 
                            recordtypeId, serviceFlow_Different_to_account_info__c, CaseNumber, User_country__c, Owner.Name
                            //TYPEOF Owner WHEN User THEN Country_for_Customer_Support__c, Name END
                            FROM Case WHERE Id IN: newIdSet]) {
            if(countryToEmailMap.containsKey(caseObj.User_country__c)) {
                body = countryToEmailMap.get(caseObj.User_country__c).HtmlValue;
            }
            /*if(caseObj.Owner instanceof User){
                User usInstance = caseObj.Owner;
                if(!countryToEmailMap.isEmpty()) {
                    body = countryToEmailMap.get(usInstance.Country_for_Customer_Support__c).HtmlValue;
                }
            }*/

            if(caseObj.Send_Email__c || caseObj.serviceFlow_Different_to_account_info__c
               && (caseObj.recordtypeId == caseCreateRecordTypeId || caseObj.recordtypeId == caseEditrecordTypeId)) {
                idToOwnerNameMap.put(caseObj.Id, caseObj.Owner.Name);
                   if(string.isNotBlank(body)) {
                       body = body.replace('{!Case.Thread_Id}', '').replace('{!Case.CaseNumber}', caseObj.CaseNumber).replace('{!Case.OwnerFullName}', idToOwnerNameMap.get(caseObj.Id));
                   }
                case caseRec = New case();
                caseRec.Id = caseObj.Id;
                caseRec.serviceFlow_Email_sent_to_Customer__c = body;
                caseUpdateList.add(caseRec);
            }
        }

        for(case caseObj : newList){
            if(caseObj.Send_Email__c || caseObj.serviceFlow_Different_to_account_info__c
               && (caseObj.recordtypeId == caseCreateRecordTypeId || caseObj.recordtypeId == caseEditrecordTypeId)) {
                
                //Preparing to send email
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                   if(countryToEmailMap.containsKey(caseObj.User_country__c)) {
                       mail.setSubject(countryToEmailMap.get(caseObj.User_country__c).subject.replace('{!Case.CaseNumber}', caseObj.CaseNumber).replace('{!Case.Thread_Id}', ''));                       
                   }
                mail.setHtmlBody(body);
                mail.setSaveAsActivity(true);
                if(caseObj.User_country__c == 'Italy' && owea != null) {
                    mail.setOrgWideEmailAddressId(owea.Id);
                } else {
                    mail.setInReplyTo(UserInfo.getUserEmail());
                }
                mails.add(mail);

                //Email Message insertion details
                EmailMessage eMessage = New EmailMessage();
                if(caseObj.Send_Email__c && !caseObj.serviceFlow_Different_to_account_info__c ) {
                    mail.setToAddresses(new String[]{caseObj.serviceFlow_Account_Shop_email_address__c});
                    eMessage.ToAddress = caseObj.serviceFlow_Account_Shop_email_address__c;
                } else if(string.isNotBlank(caseObj.ContactId)) {
                    mail.setTargetObjectId(caseObj.ContactId);
                    eMessage.ToAddress = caseObj.ContactEmail;
                } else if(string.isNotBlank(caseObj.serviceFlow_Contact_Email__c)) {
                    mail.setToAddresses(new String[]{caseObj.serviceFlow_Contact_Email__c});
                    eMessage.ToAddress = caseObj.serviceFlow_Contact_Email__c;
                }
                eMessage.EmailTemplateId = countryToEmailMap.get(caseObj.User_country__c).Id;
                if(caseObj.User_country__c == 'Italy' && owea != null) {
                    eMessage.FromAddress = owea.Address;
                } else {
                    eMessage.FromAddress = UserInfo.getUserEmail();
                }
                eMessage.FromName = UserInfo.getName();
                eMessage.HtmlBody = body;
                eMessage.ParentId = caseObj.Id;
                eMessage.RelatedToId = caseObj.Id;
                eMessage.Subject = countryToEmailMap.get(caseObj.User_country__c).subject.replace('{!Case.CaseNumber}', caseObj.CaseNumber).replace('{!Case.Thread_Id}', '');                
                emailMessageList.add(eMessage);
            }
        }

        if(!mails.isEmpty()) {
            List<Messaging.SendEmailResult> emailSentResultList = Messaging.sendEmail(mails);
            for (Messaging.SendEmailResult mr : emailSentResultList) {
                if (mr.isSuccess()) {
                    if(!caseUpdateList.isEmpty()) {
                        update caseUpdateList;
                    }
                    if(!emailMessageList.isEmpty()) {
                        insert emailMessageList;
                    }
                } else {
                    for(Messaging.SendEmailError err : mr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }        
    }
}