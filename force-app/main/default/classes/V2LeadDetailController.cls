/**
 * Apex Class Name : V2LeadDetailController Class
 * Test Class Name : V2LeadDetailControllerTest
 * @Description: This class contains methods to handle operations related to Lead records, including updating competitors, 
 * changing Lead statuses, converting Leads to Accounts, fetching records based on search criteria, closing related tasks, 
 * and handling related events.
 *
 * @Author Fazurulla Ganganapalli
 * @Date September 2024
 *
 * @Methods:
 * - UpdateCompetitor(String recordId, String firstCompetitorName, String secondCompetitorName): Updates competitor fields for a Lead.
 * - changeLeadStatus(String recordId): Changes the Lead status to 'Information Submitted' and creates a task with a reminder.
 * - changeLeadStatusToAccountCreated(String recordId): Changes the Lead status to 'New Account Created', closes open tasks, and creates a task.
 * - fetchRecords(SearchWrapper inputWrapper): Fetches records based on search criteria, including Account and other custom objects.
 * - convertLead(String leadId): Converts the Lead to an Account, updates the Account and Contact, and transfers visit information.
 * - RejectLeadCloseRelatedTasks(String recordId): Rejects the Lead and closes all related tasks.
 * - getDefaultRecordTypeForEvents(String recordTypeName): Retrieves the default record type for Event objects.
 * - getReportEvents(String leadId): Retrieves the report of events related to a specific Lead.
 * - CloseTasks(List<Task> closeTasks): Closes all tasks related to a Lead.
 * - UpdateAccount(String accountId, Lead lead): Updates the Account with Lead's competitor and strategic value information.
 * - UpdateContact(String contactId, Lead lead): Updates the Contact record associated with the Lead.
 * - TransferVisitsToAccount(String accountId, List<Event> leadEventList): Transfers visits from Lead to Account in a custom object.
 *
 */
public class V2LeadDetailController {
    @AuraEnabled
    public static void UpdateCompetitor(String recordId, String firstCompetitorName, String secondCompetitorName){
        try {
            SObject recordToUpdate = Schema.getGlobalDescribe().get('Lead').newSObject(recordId); 
            if((String.isNotBlank(firstCompetitorName)) || (String.isNotBlank(secondCompetitorName))){
                recordToUpdate.put('X1st_Competitor_Local_name__c', String.valueOf(firstCompetitorName));
                recordToUpdate.put('X2nd_Competitor_Local_name__c', String.valueOf(secondCompetitorName));
            }else{
                recordToUpdate.put('X1st_Competitor_Local_name__c', ''); 
                recordToUpdate.put('X2nd_Competitor_Local_name__c', ''); 
            }
            if(recordToUpdate != null){
                update recordToUpdate;
            }
                
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 
    @AuraEnabled
    public static Task changeLeadStatus(String recordId){
        try {
            Lead leadRec = [Select Id,CreatedDate,Submit_To__c,Company,Status From Lead Where Id=:recordId];     
            leadRec.Status = 'Information Submitted';  
            update leadRec;
            
            DateTime ReminderDateTime = leadRec.CreatedDate.addDays(7);
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
            Task taskRec = new Task(
                Subject = 'Creation of a new Account for '+leadRec.Company,
                WhoId = recordId,
                Priority = 'High',
                OwnerId = leadRec.Submit_To__c,
                Status = 'New',
                ActivityDate = leadRec.CreatedDate.Date().addDays(10),
                Description = 'Please click on the "Related To" link to familiarize yourself with the "Credit Application", to be able to create a new account in the system and to indicate to the salesperson the number of this account.\n' +
                              '' + baseUrl + '/' + leadRec.Id,
                IsReminderSet = true,
                ReminderDateTime = Datetime.newInstance(ReminderDateTime.date(), Time.newInstance(9, 0, 0, 0)),
                RecordTypeId = StandardHoyatask
            );
            insert taskRec;
            return taskRec;
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }
    @AuraEnabled
    public static Task changeLeadStatusToAccountCreated(String recordId){    
        try {            
            Lead leadRec = [Select Id,CreatedDate,Submit_To__c,Company,Status,CreatedById,New_Customer_Number__c,(Select Id,Status from Tasks Where Status != 'Closed') From Lead Where Id=:recordId];     
            leadRec.Status = 'New Account Created';  
            update leadRec;
            CloseTasks(leadRec.Tasks);
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            String StandardHoyatask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('SFDC_V2_Standard_Task').getRecordTypeId();
            Task taskRec = new Task(
                Subject = 'New Account for '+leadRec.Company,
                WhoId = recordId,
                Priority = 'High',
                OwnerId = leadRec.CreatedById,
                Status = 'New',
                Description = ' The new account '+leadRec.New_Customer_Number__c+' has been created in our local system. Once it appears in Salesforce (this may take a few days), please return to your Lead titled '+leadRec.Company+' and click on the "Convert" button so that your visit reports and other collected information are transferred to this new account.\n' +
                              '' + baseUrl + '/' + leadRec.Id,
                RecordTypeId = StandardHoyatask
            );
            insert taskRec;
            return taskRec;
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }   
    @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {    
        try {
        
            Id hvnaActiveCustomerId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('HVNA_Active_Customer').getRecordTypeId();
            Id hvnaProspectId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('HVNA_Prospect').getRecordTypeId();
            Id hvnaRepJournalId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('HVNA_Rep_Journal').getRecordTypeId();
            Id endConsumerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
            Id clinicId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
            Id hoyaEntityId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Hoya_Entity').getRecordTypeId();
            Id eyeDoctorId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Eye_Doctor').getRecordTypeId();
            Set<String> recordtTypeSet = new Set<String>();
            recordtTypeSet.add(hvnaActiveCustomerId);
            recordtTypeSet.add(hvnaProspectId);
            recordtTypeSet.add(hvnaRepJournalId);
            recordtTypeSet.add(endConsumerAccountId);
            recordtTypeSet.add(clinicId);
            recordtTypeSet.add(hoyaEntityId);
            recordtTypeSet.add(eyeDoctorId);
            
            Lead currentLeadRec = [Select Id,Submit_To__c,Account_ID__c From Lead Where Id=:inputWrapper.recordId];
            User currentUser = [SELECT Id, CompanyName FROM User WHERE Id = :UserInfo.getUserId()];
            
            String companyName = currentUser.CompanyName;  
            String profilesToExclude = '%community%' ;    
            if (inputWrapper != null) {
                String fieldsToQuery;
                if (inputWrapper.objectApiName == 'Account') {
                    fieldsToQuery = 'SELECT Id, Hoya_Account_ID__c, Seiko_local_customer_nr__c, Shop_Street__c, Shop_City__c, Brand__c, ';
                } else {
                    fieldsToQuery = 'SELECT Id, Sales_Role__c, CompanyName, ';
                }
    
                if (String.isNotBlank(inputWrapper.fieldApiName)) {
                    fieldsToQuery += inputWrapper.fieldApiName + ', ';
                }
    
                fieldsToQuery = fieldsToQuery.removeEnd(', ');
                String query = fieldsToQuery + ' FROM ' + inputWrapper.objectApiName;
                String filterCriteria = inputWrapper.fieldApiName + ' LIKE \'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 100';
    
                if (String.isNotBlank(inputWrapper.selectedRecordId)) {
                    query += ' WHERE Id = \'' + inputWrapper.selectedRecordId + '\'';
                }else if (String.isNotBlank(inputWrapper.recordId) && String.isNotBlank(currentLeadRec.Submit_To__c) && inputWrapper.objectApiName != 'Account') {
                    query += ' WHERE Id = \'' + currentLeadRec.Submit_To__c + '\'';
                } else {
                    if(inputWrapper.objectApiName == 'Account'){
                        filterCriteria = '(Hoya_Account_ID__c LIKE \'' + 
                        String.escapeSingleQuotes(inputWrapper.searchString.trim()) + 
                        '%\' OR Seiko_local_customer_nr__c LIKE \'' + 
                        String.escapeSingleQuotes(inputWrapper.searchString.trim()) + 
                        '%\' OR Name LIKE \'' + 
                        String.escapeSingleQuotes(inputWrapper.searchString.trim()) + 
                        '%\') LIMIT 100';
                        query += ' WHERE CreatedDate= Last_N_Days:180 AND RecordTypeID Not IN :recordtTypeSet AND ' + filterCriteria;
                    }else if (String.isNotBlank(companyName) && inputWrapper.objectApiName != 'Account') {
                        query += ' WHERE CompanyName = :companyName AND (NOT (Profile.Name LIKE :profilesToExclude ) ) AND ' + filterCriteria;
                    } else {
                        query += ' WHERE ' + filterCriteria;
                    }
                }
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                for (SObject s : Database.query(query)) {
                    ResultWrapper wrap = new ResultWrapper();
                    wrap.id = (String)s.get('Id');
                    wrap.sObjectRecord = s;
                    wrap.IsAccountRecord = (inputWrapper.objectApiName == 'Account') ? true : false;
                    returnWrapperList.add(wrap);
                }
                return returnWrapperList;
            }
            return null;
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }
    
    public class ResultWrapper {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public Boolean IsAccountRecord { get; set; }
        @AuraEnabled public SObject sObjectRecord { get; set; } 
    }
    
    public class SearchWrapper {
        @AuraEnabled public String objectApiName { get; set; }
        @AuraEnabled public String fieldApiName { get; set; }
        @AuraEnabled public String searchString { get; set; }
        @AuraEnabled public String selectedRecordId { get; set; }
        @AuraEnabled public String recordId { get; set; }
    }    
    @AuraEnabled
    public static String convertLead(String leadId) {
        Lead lead = [
            SELECT Id,FirstName,LastName,Salutation, Name, Company, OwnerId,Phone,Address,Email,Channel__c,Description,Status,MobilePhone,
            IsConverted,X1st_Competitor_Local_name__c,X2nd_Competitor_Local_name__c,Is_Already_Ordering_From_HVC__c,
            Account_ID__c,Comment__c,Contact_Role__c,Credit_Application_Is_Completed__c,
            New_Customer_Number__c,Strategic_Value__c,Submit_To__c,(Select Id,Status From Tasks Where Status != 'Closed') FROM Lead WHERE Id = :leadId LIMIT 1
        ];
        List<Event> leadEventList = [Select Id,WhoId,Who.Name,OwnerId,Owner.Name,Type__c,StartDateTime,Status__c,EndDateTime,IsAllDayEvent,Description from Event Where WhoId =:leadId order by StartDateTime desc];
        if (lead.IsConverted || String.IsBlank(lead.Account_Id__c)) {
            throw new AuraHandledException('Erro while converting the lead');
        }
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead.Id);
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus('Lead Converted');
        lc.setAccountId(lead.Account_Id__c);
        lc.setSendNotificationEmail(true);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        if (lcr.isSuccess()) {
            Id accountId = lcr.getAccountId();
            Id contactId = lcr.getContactId();
            if(String.IsNotBlank(accountId)){
                UpdateAccount(accountId,lead);
                TransferVisitsToAccount(accountId,leadEventList); 
            }
            if(String.IsNotBlank(contactId)){
               UpdateContact(contactId, lead);
            }
            CloseTasks(lead.Tasks);           
            return  accountId;         
        } else {
            throw new AuraHandledException('Erro while converting the lead');
        }
    }
    public static void UpdateAccount(String accountId, Lead lead){
        update new Account (
            Id = accountId,
            First_Competitor_local_name__c = lead.X1st_Competitor_Local_name__c,
            Second_Competitor_Local_Name__c = lead.X2nd_Competitor_Local_name__c,
            Strategic_Value_Net_Sales__c = lead.Strategic_Value__c  
        );
    }
    public static void UpdateContact(String contactId, Lead lead){
        update new Contact(
            Id = contactId,            
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(lead.Contact_Role__c).getRecordTypeId(),
            Salutation = lead.Salutation,
            FirstName = lead.FirstName,
            LastName = lead.Lastname
        );
    }
    public static void TransferVisitsToAccount(String accountId, List<Event> leadEventList){
        List<Visits__c> lisOfVisits = new List<Visits__c> ();
        for(Event eventRec : leadEventList){
            Visits__c visitRec = new Visits__c();
            visitRec.Account__c = accountId;
            visitRec.Visit_Type__c = eventRec.Type__c == 'Shop Visit' ? 'Visit' : eventRec.Type__c;
            visitRec.Assigned_to__c = eventRec.OwnerId;
            visitRec.Start_Time__c = eventRec.StartDateTime;
            visitRec.End_Time__c = eventRec.EndDateTime;
            visitRec.Is_All_Day_Event__c = eventRec.IsAllDayEvent;
            visitRec.Visit_Reason__c = 'Account Discovery';
            visitRec.Visit_Objective_follow_up_notes__c = 'Account Discovery';            
            visitRec.Visit_Notes__c = eventRec.Description;
            visitRec.Visit_Status__c = eventRec.Status__c;
            lisOfVisits.add(visitRec);
        }
        if(!lisOfVisits.IsEmpty()){
            insert lisOfVisits;
        }        
    }
    @AuraEnabled
    public static void RejectLeadCloseRelatedTasks(String recordId) {
        Lead leadRec = [Select Id,CreatedDate,Submit_To__c,Company,Status,CreatedById,(Select Id,Status from Tasks Where Status != 'Closed') From Lead Where Id=:recordId];     
        leadRec.Status = 'Information Collection';  
        update leadRec;        
        CloseTasks(leadRec.Tasks);
    }
    public static void CloseTasks(List<Task> closeTasks){
        if(!closeTasks.IsEmpty()){
            for(Task taskRec : closeTasks){
                taskRec.Status = 'Completed';
            }
            update closeTasks;
        }
    }
    @AuraEnabled
    public static String getDefaultRecordTypeForEvents(String recordTypeName){
        return Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
    }
    @AuraEnabled
    public static List<EventWrapper> getReportEvents(String leadId){
        List<EventWrapper> listOfEventWrappers = new List<EventWrapper>();
        Integer i = 1;
        for(Event eventRec : [Select Id,WhoId,Who.Name,OwnerId,Owner.Name,Type__c,StartDateTime,Status__c from Event Where WhoId =:leadId order by StartDateTime desc]){
            EventWrapper eventWrapper = new EventWrapper();
            eventWrapper.Id = eventRec.Id;
            eventWrapper.LeadId = eventRec.WhoId;
            eventWrapper.VisitId = 'Lead Visit-' + i;
            eventWrapper.VisitType = eventRec.Type__c;
            eventWrapper.Start = String.valueOf(eventRec.StartDateTime != null ? eventRec.StartDateTime.date() : null);
            eventWrapper.VisitObjective = 'Account Discovery';
            eventWrapper.Status = eventRec.Status__c;
            listOfEventWrappers.add(eventWrapper);
            i++;
        }
        return listOfEventWrappers;
    } 
    public class EventWrapper {
        @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String LeadId {get;set;}
        @AuraEnabled public String VisitId {get;set;}
        @AuraEnabled public String VisitType {get;set;}
        @AuraEnabled public String Start {get;set;}
        @AuraEnabled public String VisitObjective {get;set;}
        @AuraEnabled public String Status {get;set;}
    }
}