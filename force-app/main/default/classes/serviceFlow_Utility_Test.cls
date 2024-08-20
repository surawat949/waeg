@isTest public class serviceFlow_Utility_Test {
    public static Id accontRecordTypeName = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Eye Doctor').getRecordTypeId();
    public static Id caseRecordTypeName = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();
    public static Id taskRecordTypeName = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();

    @isTest public static void fetchUserConfigDetailsTest(){       
        Account accObj = new Account(
            RecordTypeId = accontRecordTypeName,
            Name = '4151982 - Rachyls Eyes 4 U [View Hierarchy]',
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
        caseObj.Ticket_created_date__c = system.now();
        caseObj.serviceFlow_Due_Date__c = system.now() + 1;
        caseObj.Description = 'test hoya';
        caseObj.SFlow_Subject__c = 'Job status';
        caseObj.Origin = 'E-Mail';
        caseObj.serviceFlow_Customer_Email__c = 'test@yopmail.com';
        caseObj.Date_Meridiem__c = 'AM';
        caseObj.User_country__c = 'USA';
        caseObj.SFlow_Subject__c = 'Job status';
        caseObj.SFlow_Sub_Subject__c = 'Outsource';
        caseObj.RecordTypeId = caseRecordTypeName;
        caseObj.serviceFlow_Parameters_checked__c = 'Hard;Tinting';
        caseObj.serviceFlow_Account_Shop_email_address__c = 'testUser@hoya.com';
        insert caseObj;
        List<sObject> caseList = new List<Case>{caseObj}; 
        serviceFlow_QualityReturnTemplate_Ctrl.fetchUserConfigDetails(caseObj.Id); 
        serviceFlow_QualityReturnTemplate_Ctrl.doUpsertCase(caseList,'esclate_Next_Level');
        serviceFlow_QualityReturnTemplate_Ctrl.doUpsertCase(caseList,'save_send_email');
        
        PageReference pageRef = Page.serviceFlow_VF_QualityReturn_Pdf; 
         
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', caseObj.Id); 
        pageRef.getParameters().put('caseEmailBody', JSON.serialize(caseObj));
        ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);
        serviceFlow_Vf_QualityReturn_Pfd_Ctrl pdfConroller = new serviceFlow_Vf_QualityReturn_Pfd_Ctrl(sc);
        
        PageReference pageRef1 = Page.serviceFlow_VF_QualityReturn_Pdf; 
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('Id', caseObj.Id); 
        pageRef1.getParameters().put('caseEmailBody',null);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseObj);
        serviceFlow_Vf_QualityReturn_Pfd_Ctrl pdfConroller1 = new serviceFlow_Vf_QualityReturn_Pfd_Ctrl(sc1);
        
        serviceFlow_LookupSearchCtrl.getResults('Account','Hoya_Account_ID__c','4151');
    }
}