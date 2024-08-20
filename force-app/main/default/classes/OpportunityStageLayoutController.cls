public with sharing class OpportunityStageLayoutController {
    public OpportunityStageLayoutController() {
    }

    @AuraEnabled
    public static Opportunity getOpportunity(Id recordId){
        System.debug('XXX loading opportunity ' + recordId);
        Opportunity result = [Select name, AccountId, stageName, type, X6_Mo_KAM__c,Account_Last_Activity__c,Additional_Information__c,Agreement_with_Competitor__c,Amount_Definition__c,Close_Date_Note__c,
            Competitive_Supplier__c,
            Days_in_the_current_Stage__c,Days_Remain_To_Close__c,Days_since_the_beginning__c,DB_Competitor__c,Estimated_Agreement_Buyout__c,Expected_Sales__c,
            KAM_Engagement_Date__c,Link_Account_Number__c,LY_Q1_Sales__c,LY_Q2_Sales__c,LY_Q3_Sales__c,LY_Q4_Sales__c,Monthly_Incremental_Sales_FY20__c,
            Monthly_Incremental_Sales_FY21__c,Number_of_Employees__c,Opportunity_Number__c,Opportunity_Program__c,Opportunity_Program_Goal__c,Opp_Owner_Equals_Acct_Owner__c,
            Potential_Revenue__c,Projected_Revenue_Apr__c,Projected_Revenue_Aug__c,Projected_Revenue_Dec__c,Projected_Revenue_Feb__c,HOLA_Projected_Revenue_FY20__c,Proj_Rev_FY20_Incl_Opp_Prog__c,
            Q1_Amount__c,Q2_Amount__c,Q3_Amount__c,Q4_Amount__c,VEUS_Quantity_Pairs__c,Revenue_Driver__c,SRX_ASP__c,Strategic_Value__c,
            Total_Amount__c,Wallet__c,Wallet_Linked__c,Date_1st_appointment__c,Contact_s_name_s_registered_in_SFDC__c,Healthcare_networks_identified_for_SOF__c
            ,Key_reasons_for_switching_supplier__c,Key_reasons_for_keeping_current_supplier__c,SVS_Contract_Project_Given__c,
            Optician_level_of_interest__c, Optician_level_of_interest_2__c, Optician_level_of_interest_3__c, Optician_level_of_interest_4__c,
            Optician_level_of_interest_5__c, Optician_level_of_interest_6__c, Optician_level_of_interest_7__c, Optician_level_of_interest_8__c,
            SV_Premium_design__c, SV_Good_design__c, SV_Better_design__c, SV_Best_design__c,
            PAL_Premium_design__c, PAL_Good_design__c, PAL_Better_design__c, PAL_Best_design__c,
            Seiko_Vision_Simulator__c,Seiko_Xchanger_display__c,Seiko_Shop_in_shop__c,SVS_investment_value__c,Date_of_1st_proposal__c,
            Action_plan_4__c,Seiko_monthly_support_to_investment__c,Seiko_support_in__c,Seiko_support_duration_in_Mo__c,Identified_blocking_points__c,
            Pricelist_selected__c, Commintment_on_annual_turnover__c, Margin_simulation_done__c, Commintment_on__c, Retail_prices_calculated__c,
            Other_Investments__c, Seiko_Tracer__c, Seiko_Vision_Xperience_column__c, Seiko_Vision_Xperience_iPAD__c,
            Remaining_blocking_points__c,Action_plan_5__c
            from Opportunity where Id=:recordId];
        System.debug('XXX return Opportunity ' + recordId);
        return result;
    }
    @AuraEnabled
    public static Account getAccount(Id recordId){
        System.debug('XXX loading Account ' + recordId);
        Account result = [select Id, name, Hoya_Account_ID__c, NumberOfEmployees, First_Competitor_local_name__c, Second_Competitor_Local_Name__c
            ,First_Competitor_SOW__c, Second_Competitor_SOW__c, Number_of_sales_desk__c
            , First_Competitor_global_name__c,Second_Competitor_global_name__c, ownerId
            , shop_name__c, Shop_street__c, Shop_Postal_Code__c, Shop_City__c, Phone, Last_Visit_date__c, AnnualRevenue
            , TACTICOM_HLFR__c, TACTICOM_SOF__c, TACTICOM_Owner__c
            , Financial_Status__c, Credit_Risk__c,Payment_issue__c,Paymen_Relief_Status__c
            from Account where id=:recordId];
        System.debug('XXX return Account ' + recordId);
        return result;
    }

    @AuraEnabled
    public static Seiko_data__c getSeikoData(Id accId){
        System.debug('XXX loading Seiko Data ' + accId);
        Seiko_data__c result = [select Id, name, Segmentation__c,SEIKO_Catalogues__c, SEIKO_catalogues_training__c
,SEIKO_Products_1rst_training__c, SEIKO_Products_1rst_training_date__c, Seiko_track_trace_daily_email__c, Seiko_track_trace_email_activation__c
,SEIKO_Track_Trace__c,SEIKO_Track_Trace_activation__c,SVS_Sample_boxes__c,SVS_Sample_boxes_setting_up__c,SVS_Newsletters__c,SVS_Newsletters_activation__c,SVS_Store_locator__c, SVS_Store_locator_activation__c

,SVS_Starting_kit__c,Starting_kit_setting_up__c, SVS_Communication_kit__c, SVS_Communication_kit_setting_up__c
,SVS_Marketing_campaigns__c, SVS_Marketing_campaigns_activation__c, SVS_Purchase_Registration__c, SVS_Purchase_Registration_activation__c
            from Seiko_data__c where Account__c=:accId];
        System.debug('XXX return Seiko Data ' + result.Id);
        return result;
    }

    @AuraEnabled
    public static Integer getNumberOfVisits(Id recordId){
        Integer n = 0;
        System.debug('XXXX numberOfVisits for ' + recordId);
        try {
            List<Visits__c> vl= [select id from Visits__c where Opportunity__c =: recordId];
            n=vl.size();
            System.debug('XXXX numberOfVisits=' + n);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return n;
    }
    /**
     * Changed log : 
     * Due task no.968-unused custom object.
     * Agreed to remove SEIKO_Order__c and related class.
     * Below class should remove due for this custom object removed.
     * Surawat add - 2023/11/22
     */
    /*
    @AuraEnabled
    public static Task createTask(Id orderId){
        //System.debug('XXXXX Call createTask');
        Seiko_Order__c order = [select Id, Assigned_to__c, Opportunity__c, account__c, Special_comment__c, Date_of_demand__c from SEIKO_Order__c where id=:orderId];
        Account acc = [select name from Account where id=:order.account__c];
        Task task = new Task();
        task.RecordTypeId = [select Id,Name from RecordType where sObjectType='Task' and Name='Standard Task'].Id;
        //task.WhoId = acc.Id;
        task.Priority = 'Hoch';
        task.OwnerId = order.Assigned_to__c;
        task.WhatId=orderId;
        task.Status = 'New';
        task.Type ='Task';
        task.Task_Notes__c='During my last SVS prospecting visit, this Client expressed the need to test SEIKO lenses. So please register this free test order for and inform me of the exact date of delivery to the store.Thank you for your kind support.';
        task.Subject = 'Free trial Seiko lenses';
        task.Description = order.Special_comment__c;
        task.ActivityDate = order.Date_of_demand__c.addDays(3);
        task.IsReminderSet = true;
        //System.debug('XXXXX before task insert');
        insert task;
        System.debug('XXXXX after task insert' + task.Id);
        return task;
    }*/
    @AuraEnabled
    public static void closeOpportunity(Id oppId, boolean win)
    {
        System.debug('XXXX try to close ' +oppId + ' ' + win);
        Opportunity o = [select id, stageName from Opportunity where id=:oppId];
        System.debug('XXXXX stage = ' + o.stageName);
        if(win){
            o.StageName ='[SVS] Closed Won';
        } else {
            o.StageName='[SVS] Closed Lost';
        }
        System.debug('XXXX before update' );
        update o;
        System.debug('XXXX after update');
    }

    @AuraEnabled
    public static void closeAtolOpportunity(Id oppId, boolean win)
    {
        Opportunity o = [select id, stageName from Opportunity where id=:oppId];
        System.debug('XXXXX stage = ' + o.stageName);
        if(win){
            o.StageName ='6-Closed Won';
        } else {
            o.StageName='6-Closed Lost';
        }
        update o;
        System.debug('XXXX after update');
    }
    @AuraEnabled
    public static void updateOnBoardingAccount(Id accountId) {
        System.debug('XXXX update account ' + accountId);
        Account acc = [select id,Onboarding_Customer__c,Onboarding_date__c from Account where id=:accountId];
        acc.Onboarding_Customer__c = true;
        acc.Onboarding_date__c = System.today();
        System.debug('XXXX do update now');
        update acc;
    }
    @AuraEnabled
    public static void enrollSVS(Id accountId) {
        System.debug('XXXX enrollSVS update account ' + accountId);
        Account acc = [select id,Seiko_Network__c,SVS_sign_in__c,Onboarding_date__c from Account where id=:accountId];
        acc.Seiko_Network__c = 'Seiko Vision Specialist';
        acc.SVS_sign_in__c = System.today();
        System.debug('XXXX do update now');
        update acc;
    }
    @AuraEnabled
    public static String getCompanyName(){
        System.debug('XXXX call getCompanyName ');
        String comp = [select id,Name, companyName from User where id =: userInfo.getUserId()].companyName;
        System.debug('XXXX return getCompanyName ' + comp);
        return comp;
    }
}