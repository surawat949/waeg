/**
 * ============================================================================================================
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @version : 1.0
 * @api : v.55.0
 * @LastModified : 2023-11-28
 * @LastModifiedBy.Name : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @changed log : 2023-11-28
 *      add new class about MiyoSmart from Contact/Account object and this is support HOLK specific business
 *      addedd : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 *      Yung required : 2023-11-28 new component will manfiest under MiyoSamrt Authorize Dealer.
 *      changed api to v.55.0
 * ============================================================================================================
 */
public with sharing class APACAccountNearAccountController {

    /*
    @AuraEnabled
    public static List<Account> getAccountbyCampaignMember(Id campaignId, Double distance){
        System.debug('XXX Call Account Campaign Member [campaignId '+campaignId+' from distance '+distance+']');
        Account_Campaing_Member__c acccampaign = [select Id, name, Account_Name__c from Account_Campaing_Member__c where Id =:campaignId];
        System.debug('XXX Campaign member is '+acccampaign.Id+' Account is '+acccampaign.Account_Name__c);
        return APACAccountNearAccountController.getAccounts(acccampaign.Account_Name__c, distance, '', 0, 99999999, '');

    }

    ====================================================================
        Explaination for FSV and WEBID/HOYALOG Project - APAC
        SSU - added | 8/4/2022

        About FSV Prject and Hoyalog Web Id Project is part of this class
        For all using Equipment__c and field regard in public class
        Name of API must start with APAC__ mean for custom fields APAC using (may EMEA can adapt in next future)
        If FSV for Name must FSV-XXXXXX (FSV - following with customer Id) and Business type (APAC_Business_Type__c) == 'FSVPROJECT'
        If Hoyalog / WebId must WEBID-XXXXXX (WEBID - following customer Id) and Business type (APAC_Business_Type__c) == 'HOYALOG'
        and associated with Account__c in Equipment__c custom object.
    =====================================================================

    */

    @AuraEnabled
    public static List<Account> getAccountbyCompetitor(Id accountId, Double distance){

        System.debug('XXX Call Account Competitor Member [accountId '+accountId+' from distance'+distance+']');
        Account AccountCompete = [select Id, Name, Account_Status__c, CurrencyIsoCode, Brand__c, AnnualRevenue, First_Competitor_global_name__c, Second_Competitor_global_name__c, First_Competitor_local_name__c, Segmentation_Box__c from Account where Id=:accountId];
        System.debug('XXX Competitor member is '+AccountCompete+' Account is '+AccountCompete.Id+' competitor name : '+AccountCompete.First_Competitor_global_name__c + '2nd competitor name is : '+AccountCompete.Second_Competitor_global_name__c);
        return APACAccountNearAccountController.getAccounts(AccountCompete.Id, distance, '' , 0, 99999999, '', '', '');
    }

    @AuraEnabled
    public static List<Account> getAccounts(Id accountId, Double distance, String oneParam, Double potentialMin, Double potentialMax, String competitorGlobal1, String competitorGlobal2, String Segmentation){
        List<Account> result = new List<Account>();

        if(potentialMin==null){potentialMin=0;}
        if(potentialMax==null){potentialMax=99999999;}

        String critCompetitorGlobal = '';
        String crtiCompetitorSecondGlobal = '';
        String account_status = '';
        String segment = '';

        if(competitorGlobal1!=null&&competitorGlobal1<>''){
            critCompetitorGlobal = ' and First_Competitor_global_name__c like \'%'+competitorGlobal1+'%\' ';
        }
        if(competitorGlobal2!=null && competitorGlobal2<>''){
            crtiCompetitorSecondGlobal = ' and Second_Competitor_global_name__c like \'%'+competitorGlobal2+'%\' ';
        }

        if(Segmentation != null && Segmentation <> ''){
            segment = ' and Segmentation_Box__c like \'%'+Segmentation+'%\' ';
        }

        User u = [select id, companyName from User where Id=:UserInfo.getUserId() ];
        String companyName = u.companyName;

        System.debug('Company name is '+companyName);

        if(companyName == 'HOLK'){
            account_status = ' and Account_Status__c !=  \'Closed\' ';
        }else if(companyName == 'HLSI'){
            account_status = ' and Brand__c != \'Seiko\' ';        
        }

        Account acc = [select name, Id, Brand__c, Account_Status__c, Hoya_account_id__c, phone, shippingStreet, shippingPostalCode, shippingCity, shippingState, shippingCountry, shippingLatitude, shippingLongitude, AnnualRevenue, First_Competitor_global_name__c, First_Competitor_SOW__c, First_Competitor_local_name__c, CurrencyIsoCode, Segmentation_Box__c, potential__c, Visit_Frequency_Flag__c, Last_Visit_date__c, Agreed_Visits__c, Visits_performed__c, recordType.developerName      
        from Account where id=:accountId];

        result.add(acc);
        System.debug('XXX Account Name is '+acc.name);

        Double latitude = acc.shippingLatitude;
        Double longitude = acc.shippingLongitude;

        
        String soql= 'select Id, name, Hoya_account_id__c, Account_Status__c, shippingStreet, shippingPostalCode, shippingCity, shippingState, shippingCountry, shippingLatitude, shippingLongitude, potential__c, First_Competitor_global_name__c, Second_Competitor_global_name__c, First_Competitor_SOW__c, Second_Competitor_SOW__c, Phone, Brand__c, AnnualRevenue, First_Competitor_local_name__c, CurrencyIsoCode, Segmentation_Box__c, Visit_Frequency_Flag__c, Last_Visit_date__c, Agreed_Visits__c, Visits_performed__c, Visit_Frequency_Status__c, recordType.developerName '
            + ' from Account where potential__c>=' + potentialMin.longValue() + ' and potential__c<=' + potentialMax.longValue() + critCompetitorGlobal
            + ' and DISTANCE(shippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+ distance + crtiCompetitorSecondGlobal + account_status + segment ;
        
        System.debug('XXX SOQL is ' + soql);

        List<Account> aList = database.Query(soql);
        System.debug('AList size is '+aList.size());
        result.addAll(aList);
        System.debug('XXX Found account = '+result.size());
        return result;
    }

    @AuraEnabled
    public static List<Account> getAccountsCampaignNearby(Id accountId, Boolean isPresented){
        System.debug('XXX account Id is '+accountId);
        if(isPresented==null){isPresented=true;}
        Account accMember = [select Id, Name, Hoya_account_id__c from Account where Id=:accountId];
        System.debug('XXX acc.Campaign member is '+accMember+' Name is '+accMember.Name);
        return APACAccountNearAccountController.getAccountsCampaign(isPresented, '');

    }

    @AuraEnabled
    public static List<Account> getAccountsCampaign(Boolean isPresented, String oneParam){
        if(isPresented==null){isPresented=true;}

        List<Account> accs = [select Id, hoya_account_id__c, Name, Shipping_Geo_Code_Lat__c, Shipping_Geo_Code_Long__c, shippingStreet, shippingCity, shippingState, shippingPostalCode, shippingCountry, shippingLatitude, shippingLongitude, Phone,
        (select Id, Account_Name__c, Campaign_Presented__c, campaign_active__c 
            from Campaign_Membership__r where Campaign_Presented__c=:isPresented and campaign_active__c=true) 
            from Account where Id in (select account_name__c from Account_Campaing_Member__c where campaign_presented__c=:isPresented and campaign_active__c=true) order by createddate desc limit 500];

        for(Account a:accs ){
            System.debug('XXX Account details is: '+a.hoya_account_id__c+' '+a.Name+' '+a.shippingStreet+' '+a.shippingCity+' '+a.shippingState+' '+a.shippingCountry+' Lat is : '+a.shippingLatitude+' Long is : '+a.shippingLongitude+' and Campaign presented is '+isPresented);
        }
        System.debug('XXX found account(s) in account campaign member is : '+accs.size());
        return accs;
    }

    @AuraEnabled
    public static List<Account_Campaing_Member__c> findAccountsForMap(String campaignId){

        User u = [select Id, Name, CompanyName from User where Id =: userInfo.getUserId()];
        System.debug('XXX get user companyname is '+u.CompanyName);

        if(u.CompanyName == '' || u.CompanyName == null || u.companyName == 'HVC'){
            u.CompanyName = '%';
        }
        System.debug('XXX CompanyName in use for soql is '+u.companyName);

        String cName = '';
        if(campaignId == null || campaignId == ''){
            campaignId = '';
            cName = '%';
        }else if (campaignId != null || campaignId != ''){
            Campaign c = [select Name from Campaign where Id=:campaignId];
            cName = c.Name;
        }
        System.debug('XXX Campaign name = '+cName);

        List<Account_Campaing_Member__c> member = [select Id, Name, Campaign_Presented__c, Central_Campaign__r.Name, Account_Name__r.Hoya_Account_ID__c, Account_Name__r.Name, Account_Name__r.ShippingStreet, Account_Name__r.ShippingCity, Account_Name__r.ShippingState, Account_name__r.ShippingPostalCode, Account_name__r.ShippingLatitude, Account_name__r.ShippingLongitude, Account_Name__r.Phone
            from Account_Campaing_Member__c where (campaign_active__c = true) and (Account_Name__r.ShippingStreet!=null) and (Account_Name__r.ShippingLatitude!=null) and (Account_Name__r.ShippingLongitude!=null) and (Owner_Region__c IN ('APAC', 'EMEA', 'AMERICAS')) and (Account_name__r.Owner.companyName like : u.CompanyName) and (Campaign_Name__c like : cName)  
            order by lastmodifieddate desc limit 5000];
            
            System.debug('XXX found account campaign member = '+member.size());
        
            return member;
    }

    @AuraEnabled
    public static List<Opportunity> getOpportunityByAccount(Id accountId){
        List<Opportunity> opp = [Select Id, Name, StageName from Opportunity 
                                        where (AccountId =: accountId) 
                                        and (IsClosed=false) 
                                        and (Account.Target_List__c=true) 
                                        order by LastModifiedDate desc limit 1];

        for(Opportunity o:opp){
            system.debug('XXX Opportunity Id is '+o.Id+' Name '+o.Name+' Stage Name is '+o.StageName);
        
        }
        System.debug('XXX Found opportunity member = '+opp.size());
        return opp;
    }

    @AuraEnabled
    public static List<Account_Campaing_Member__c> getCampaignMember(Id accountId){
        List<Account_Campaing_Member__c> accMember = [select Id, Name, Campaign_Name__c, 
                                                        Date_of_presentation__c, Campaign_Presented__c, Level_interest__c, 
                                                        Not_ineterested_Reason__c, Central_Campaign__c 
                                                        from Account_Campaing_Member__c 
                                                        where Account_Name__c=:accountId and campaign_active__c = true 
                                                        order by LastModifiedDate desc limit 10];
        for(Account_Campaing_Member__c a:accMember){
            system.debug('XXX Account Campaign Member '+a.Id+' Campaign number : '+a.Name+' Campaign Id : '+a.Campaign_Name__c);
        }
        System.debug('XXX Founc Account Campaign Member = '+accMember.size());
        return accMember;

    }

    @AuraEnabled
    public static List<Opportunity> getOpportunity(Id opportunityId){
        List<Opportunity> oppMember = [select Id, Name, AccountId from Opportunity where Id=:opportunityId];

        if(oppMember!=null && oppMember.size()>0){
            for(Opportunity o:oppMember){
                system.debug('XXX Opportunity Id '+o.Id+' Name = '+o.Name+' AccountId = '+o.AccountId);
                
            }
        }
        return oppMember;

    }

    @AuraEnabled
    public static List<Account_Campaing_Member__c> getOppToCampaignMember(Id opportunityId){
        
        List<Account_Campaing_Member__c> accMember = new List<Account_Campaing_Member__c>();
        Opportunity opp = [select Id, AccountId from Opportunity where Id=:opportunityId];
        System.debug('XXX Get Opportunity Id is '+opp.Id+' Account Id is '+opp.AccountId);
        
        String accountId = opp.AccountId;
        System.debug('XXX Varaiable for Account Id is '+accountId);

        
        List<Account_Campaing_Member__c> a = [select Id, Name, Account_Name__c from Account_Campaing_Member__c where Account_Name__c=:accountId and campaign_active__c=true];
        
        for(Account_Campaing_Member__c tmp:a)
        {
            System.debug('XXX Campaign Id is '+tmp.Id+' Name : '+tmp.Name+' Account Id : '+tmp.Account_Name__c);
        }
        
        System.debug('XXX Campaign Size is '+a.size());
        return a;
    }

    @AuraEnabled
    public static List<Opportunity> getAccount(Id opportunityId){
        List<Opportunity> opac = [select Id, AccountId, Name from Opportunity where Id=:opportunityId];
        if(opac!=null && opac.size()>0){
            for(Opportunity o:opac){
                system.debug('XXX Account Id is '+o.AccountId);
            }
        }else{
            System.debug('Opportunity Id is Null');
        }
        return opac;
    }

    @AuraEnabled 
    public static user fetchUser(){
        // query current user information
        //Reserve in near future, not use right now, may in the future once Cedric back SSU - 2021-08-16
        User oUser = [select id,Name,Username,Alias,Country,Email, companyName, FirstName,LastName,IsActive, profileid 
                FROM User Where id =: userInfo.getUserId()];
        System.debug('XXX user=' + oUser.Username + ' and companyName is '+oUser.companyName);
        return oUser;
    }

    @AuraEnabled
    public static String getCompanyName(){
        //Reserve in near future, not use right now, may in the future once Cedric back SSU - 2021-08-16
        String comp = [select id,Name, companyName from User where id =: userInfo.getUserId()].companyName;
        return comp;
    }

    @AuraEnabled
    public static List<Visits__c> getVisitsForMap(Id recordId){
        List<Visits__c> result = new List<Visits__c>();

        Visits__c v = [select Id, Name, Account__r.Name, Account__r.ShippingCity, 
                        Account__r.ShippingLatitude, Account__r.ShippingLongitude from Visits__c 
                        where Account__c =: recordId order by Name desc limit 1];
        result.add(v);
        System.debug('Visit ID : '+v.Name);

        Double latitude = v.Account__r.ShippingLatitude;
        Double longitude = v.Account__r.ShippingLongitude;
        String ShippingCity = v.Account__r.shippingCity;

        String soql = 'select Id, Name, Account__r.Name, Account__r.Hoya_Account_ID__c,'
                        + ' Account__r.ShippingStreet, Account__r.ShippingCity, Account__r.ShippingState,'
                        + ' Account__r.ShippingPostalCode, Account__r.ShippingCountry, Account__r.ShippingLatitude, Account__r.ShippingLongitude'
                        + ' from Visits__c where Account__r.ShippingCity like \'%'+ShippingCity+'%\' order by Name DESC limit 100';
        System.debug('soql = '+soql);

        List<Visits__c> vList = database.Query(soql);
        result.addAll(vList);
        System.debug('Found visit account '+result.size());
        return result;

    }

    @AuraEnabled
    public static List<Option> getCampaignList() {
       
        List<Option> optionList = new List<Option>();
        String companyName = VisitPlanningController.getCompanyName();
        if(companyName==null || companyName == 'HVC' || companyName == ''){companyName='%';}       
        for (Campaign cmp : [SELECT Id,IsActive,Name FROM Campaign where Campaign_Subsidiary__c LIKE: companyName and isActive=true]){
            optionList.add(new Option(cmp.id, cmp.name));
        }
        return optionList;
    }

    public class Option
    {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;

        public Option(String value, String label)
        {
            this.value = value;
            this.label = label;
        }
    }
    public static List<Option> toOptionList(List<SelectOption> selectOptions, Boolean addEmpty)
    {
        List<Option> optionList = new List<Option>();
        if(addEmpty)
        {
            optionList.add(new Option('', ''));
        }
        for (SelectOption option : selectOptions)
        {
            optionList.add(new Option(option.getValue(), option.getLabel()));
        }
        return optionList;
    }
    /*
    @AuraEnabled
    public static List<Account_Calculator__c> getAccountCalculator(){

        String companyName = VisitPlanningController.getCompanyName();
        if(companyName == '' || companyName == null){companyName = 'HVC';}

        System.debug('Company name is '+companyName);

        List<Account_Calculator__c> a = [select Id, Name, Company_Name__c, 
                                            Pam02_Competitor_1_Hoya__c, 
                                            Pam02_Competitor_1_Pentax__c,
                                            Pam02_Competitor_1_Seiko__c
                                            from Account_Calculator__c 
                                            where Company_Name__c =: companyName];

        return a;
    }
    */
    @AuraEnabled
    public static List<Equipment__c> getEquipmentId(Id recordId){
        //to get AccountId and manipulate for Equipement__c in lightning recordType sObject

        List<Equipment__c> e = [select Id, Name, Product_Type__c, Brand2__c,
                                    Model2__c, Subtype__c, Shipment_Date__c,
                                    SEIKO_Login__c, SEIKO_Password__c,
                                    HAPL_Hoya_Log__c, HAPL_LAM__c,
                                    HAPL_MiyoSmart_Units__c,
                                    HAPL_Others__c, HAPL_Sensity_Samples__c, HAPL_Tint_Samples__c
                                    from Equipment__c where Account__c=:recordId and HW_Brand__c!='HOYA (Tracer)' and 
                                    HW_Brand__c != 'Apple'];

        System.debug('XXX Equipement Size = '+e.size());
        return e;

    }
    @AuraEnabled
    public static List<Equipment__c> getHoyaLogEduipment(Id recordId){
        //This class will get only Hoyalog Tracer
        List<Equipment__c> h = [select Id, Name, HAPL_Hoyalog_Tracer__c, Equipment_Type__c, Model2__c, Brand2__c, 
                                        HAPL_Hoyalog_Serial_Number__c, HW_Brand__c, Shipment_Date__c, Installation_Date__c, 
                                        HAPL_Hoyalog_Term_ID__c from Equipment__c where HW_Brand__c = 'HOYA (Tracer)'
                                        and Account__c =: recordId];
        System.debug('XXX Hoyalog Equipment Size = '+h.size());
        return h;
    }

    @AuraEnabled
    public static List<Equipment__c> getIpadVisualReal(Id recordId){
        //this class will get only Apple visual-real ipad
        List<Equipment__c> i = [select Id, Name, HW_Brand__c, HW_Model__c, HW_Subtype__c, Model2__c, Subtype__c
                                    from Equipment__c where HW_Brand__c = 'Apple' and Account__c =: recordId
                                ];
        System.debug('XXX Hoya Visual Reel, Apple IPAD = '+i.size());
        return i;
    }
    
    @AuraEnabled
    public static List<AccountContactRelation> getContactList(Id recordId){
        try {
            List<RecordType> recordTypeIds = [select Id from RecordType where sObjectType='Contact' and developerName in ('Opthalmologist')];

            List<AccountContactRelation> contactList = [select id, Contact.Title, Roles, ContactId, contact.name, contact.Contact_Record_Type__c, isdirect
            ,Contact.Account.Name, Contact.Account.shippingCity, Contact.Account.ShippingPostalCode,Contact.Education__c, Contact.Salutation
            from AccountContactRelation where accountID =:recordId and Contact.RecordTypeId in :recordTypeIds];

            System.debug('Contact Relation to Account = '+contactList.size());
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteRelationship(Id recordId){
        try {
            AccountContactRelation record = [select Id from AccountContactRelation where Id=:recordId];
            delete record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AccountContactRelation> getAccountLinkToContact(Id recordId){

        //This class for get data for account that link to contact list
        try{
            //AccountId is only for Clinic, for only optometris contacts
            List<Id> contactsIds = new List<Id>();
            for(Contact c : [select Id from Contact where AccountId=: recordId]){
                contactsIds.add(c.Id);
            }
            //Each account get to contacts, list account to contact - AccountContactRelationship
            List<AccountContactRelation> accCList = [select contact.Id, Contact.name, Account.name, Account.id, Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                                        ,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c
                                                        from AccountContactRelation where contactId =:contactsIds and isdirect=false ];
            return accCList;
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AccountContactRelation> getAccountContactbyContactId(Id contactId){
        try {
            List<AccountContactRelation> acList = [select id, contact.Id, Contact.name, Account.name, Account.id, Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                ,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c
                                from AccountContactRelation where contactId =:contactId and isdirect=false ];
            return acList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AccountContactRelation> getClinicByContactId(Id contactId){
        try {
            List<AccountContactRelation> acList = [select id, contact.Id, Contact.name, Account.name, Account.id, Account.brand__c, AccountId, Account.shippingStreet, isdirect
                                ,Account.shippingPostalCode, Account.shippingCity, Account.Seiko_Network__c
                                from AccountContactRelation where contactId =:contactId and isdirect=false and Account.RecordType.Name='Clinic'];
            return acList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Equipment__c> getEuipementsAll(Id recordId){
        try {
            List<Equipment__c> eLists = [SELECT Id, Name, APAC_Web_ID__c, Account__c, APAC_Tracer_Serial_Number__c FROM Equipment__c 
                                    WHERE (Account__c=:recordId) and (APAC_Equip_Business_Type__c = 'HOYALOG')];
            return eLists;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Equipment__c> getFSVProject(Id recordId){
        try {
            List<Equipment__c> FSVList = [SELECT Id, Name, Account__c, APAC_1st_Main_Stock_Lens_Brand__c, 
                                            APAC_Blue_Coat_In_Shop__c, 
                                            APAC_Comment__c, APAC_FSV_Primary_Target__c, APAC_Hoyalog__c,
                                            APAC_Number_of_edging_machine_in_shop__c, APAC_Photochromic_in_shop__c, 
                                            APAC_Stock_In_Shop_Index_1__c, APAC_Stock_In_Shop_Index_2__c, 
                                            APAC_Stock_In_Shop_Index_3__c, APAC_Stock_Lens_Inventory_In_Shop__c, 
                                            APAC_Tracer_Model__c, APAC_Tracer_Serial_Number__c FROM Equipment__c 
                                            WHERE (Account__c =: recordId) AND (APAC_Equip_Business_Type__c = 'FSVPROJECT') order by LastModifiedDate desc limit 1];
            return FSVList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<DataSet> getHoyaIdentifierEMEA(Id recordId){
        List<Id> accId = new List<Id>();

        for(Account acc : [select Id, Name from Account where Id=:recordId]){
            accId.add(acc.Id);
            System.debug('Get data AggreTools from Account Id '+acc.Id);
        }

        List<AggregateResult> result = [select Transaction_Date__c, sum(Quantity__c) qty
                                        from New_Media_Usage__c where Hoya_Account_ID__c =: recordId 
                                        and Tool__c = 'HoyaiLog orders with Hoya iDentifier' and Transaction_date_field__c = LAST_N_MONTHS:24
                                        group by Tool__c, transaction_date__c, Transaction_date_field__c order by Transaction_date_field__c asc];
        List<DataSet> dataset = new List<DataSet>();
        for(AggregateResult ar : result){
            String label = (String)ar.get('Transaction_Date__c');
            Double qty = (Double)ar.get('qty');
            dataset.add(new DataSet(label, qty));

        }
        System.debug('Get dataset for EMEA tool '+dataset);
        return dataset;
    }

    @AuraEnabled
    public static List<DataSet> getHoyaIlogForChart(Id recordId){
        List<Id> accId = new List<Id>();

        for(Account acc : [select Id, Name from Account where Id=:recordId]){
            accId.add(acc.Id);
            System.debug('Get data for Chart Hoyailog order '+acc.Id);
        }

        List<AggregateResult> result = [select Transaction_Date__c, sum(Quantity__c) qty
                                        from New_Media_Usage__c where Hoya_Account_ID__c =: recordId 
                                        and Tool__c = 'HoyaiLog orders' and Transaction_date_field__c = LAST_N_MONTHS:24
                                        group by transaction_date__c, Transaction_date_field__c order by Transaction_date_field__c asc];
        List<DataSet> dataset = new List<DataSet>();
        for(AggregateResult ar : result){
            String label = (String)ar.get('Transaction_Date__c');
            Double qty = (Double)ar.get('qty');
            dataset.add(new DataSet(label, qty));

        }
        System.debug('Get dataset Hoyailog for EMEA '+dataset);
        return dataset;

    }

    @AuraEnabled
    public static List<DataSet> getMediaTools(Id recordId, String tools){

        System.debug('XXX Query Data on '+recordId+' with tools '+tools);
        List<Id> accId = new List<Id>();

        for(Account acc : [select Id, Name from Account where Id=:recordId]){
            accId.add(acc.Id);
            System.debug('Get data for Chart Hoyailog order '+acc.Id);
        }

        List<AggregateResult> result = [select Transaction_Date__c, sum(Quantity__c) qty
                                        from New_Media_Usage__c where Hoya_Account_ID__c =: recordId 
                                        and Tool__c =: tools and Transaction_date_field__c = LAST_N_MONTHS:24
                                        group by transaction_date__c, Transaction_date_field__c order by Transaction_date_field__c asc];
        List<DataSet> dataset = new List<DataSet>();
        for(AggregateResult ar : result){
            String label = (String)ar.get('Transaction_Date__c');
            Double qty = (Double)ar.get('qty');
            dataset.add(new DataSet(label, qty));

        }
        System.debug('Get dataset for tools '+dataset);
        return dataset;
    }

    public class DataSet{
        public DataSet(String label, Double qty){
            this.label = label;
            this.qty = qty;
        }
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public Double qty{get;set;}
    }

   @AuraEnabled
   public static List<Visits__c> getVisitData(Id recordId){
        List<Visits__c> v = [select Id, Name, Account__c, toLabel(Visit_Reason__c), toLabel(Visit_Type__c), Call_To_Action_Notes__c
        ,Visit_Notes__c, Start_Time__c, End_Time__c, Assigned_to__r.Name from Visits__c where Account__c=:recordId order by CreatedDate desc limit 10];
        System.debug('XXX Get Data for recordId '+recordId+' row(s)= '+v.size());
        return v;
   }

   @AuraEnabled
   public static List<Task> getTaskData(Id recordId){
       List<Task> task = [select Id, subject, OwnerId, Owner.Name, ActivityDate, Task_Notes__c, 
                            description, CreatedDate, toLabel(Status)
                            from Task where whatid =: recordId order by LastModifiedDate desc limit 10];
        System.debug('XXX Get Data for record Id '+recordId+' row(s) = '+task.size());
        return task;
   }

    @AuraEnabled
    public static List<Account_Campaing_Member__c> getAccountCampaignMember(Id recordId){
        List<Account_Campaing_Member__c> AccCampMember = [SELECT Id, Name, campaign_active__c, Campaign_Name__c, 
                                                            Campaign_Presented__c, Campaign_End_Date_t__c, Campaign_Interested__c, 
                                                            Campaign_Start_Date_t__c, Campaign_Description_t__c, Level_of_Interest__c, Signed_Contract__c, Level_interest__c 
                                                            FROM Account_Campaing_Member__c WHERE Account_Name__c=:recordId and campaign_active__c=true
                                                            order by CreatedDate desc limit 5];
        System.debug('XXX Get Data for This Account Campaign Member record(s) '+AccCampMember.size());
        return AccCampMember;
    }

    @AuraEnabled
    public static List<Opportunity> getOpportunityEMEA(Id recordId){
        //This class support for opportunity list - EMEA
        List<Opportunity> opp = [select Id, Name, AccountId, Amount, ExpectedRevenue, toLabel(StageName), 
                                    Probability, NextStep, Description, CloseDate, IsClosed, 
                                    Days_in_the_current_Stage__c from Opportunity where AccountId=:recordId 
                                    and IsClosed = false order by LastModifiedDate desc limit 10];
        System.debug('XXX Get Data for Opportunity Object for AccountId '+recordId+' with opportunity '+opp.size());
        return opp;
    }

    @AuraEnabled
    public static List<Task> getTaskForOpp(Id recordId){

        Opportunity o = [select Id, Name from Opportunity where AccountId=:recordId and IsClosed=false order by LastModifiedDate desc limit 1];
        System.debug('XXX Get data for opportunity name '+o.Name+' Opportunity Id '+o.Id);
        
        List<Task> oppTask = [select Subject, toLabel(Status), Owner.Name, ActivityDate, Task_Notes__c, description, CreatedDate from Task where WhatId=:o.Id order by LastModifiedDate desc limit 10];
        System.debug('XXX Get Task for Opportunity '+oppTask.size());
        return oppTask;
    }
   @AuraEnabled
   public static List<Equipment__c> getInstruInShop(Id recordId){
        List<Equipment__c> e = [SELECT Name, Brand2__c, Model2__c, Subtype__c, Shipment_Date__c, Installation_Date__c
                                    FROM Equipment__c WHERE (Account__c=:recordId) AND
                                    (Subtype__c IN ('EyeGenius', 'iPad', 'iPad Apple', 'Kit PDM', 'Measurement', 'PC', 'Refraction', 'Tracer', 'Video Centration System (VCS)', 'Visualreal', 'Visualreal portable', 'Yuniku'))];
        System.debug('XXX Get Instrument in Shop row(s) '+e.size());
        return e;
   }

   @AuraEnabled
   public static List<Equipment__c> getSoftwareInShop(Id recordId){
        List<Equipment__c> c = [SELECT Name, Brand2__c, Model2__c, Subtype__c, Shipment_Date__c, Installation_Date__c 
                                FROM Equipment__c WHERE (Account__c=:recordId) AND 
                                (Subtype__c IN ('IPADapp','Ordering Software','PMS','Software'))];
        System.debug('XXX Get Software In shop row(s) '+c.size());
        return c;
   }

   @AuraEnabled
   public static List<Equipment__c> getEquipmentTool(Id recordId){
        List<Equipment__c> e = [SELECT  Id, Name, Installation_Date__c, Product_Focus__c, APAC_Equip_Business_Type__c
                                FROM Equipment__c WHERE (Account__c=:recordId) AND
                                (Is_Product_Focus__c=true)];
        System.debug('XXX Get Product Focus for row(s) '+e.size());
        return e;
   }

   /*
        This method to use for render visited geocode lattitude/longitude in lightning map
        @Author : Surawat Sakulmontreechai
        @Email : surawat.sakulmontreechai@hoya.com;sakulmontreechai@yahoo.com
        @Version : 1.00
        sine : api force.com v.49.0
        created : 2022-04-27
        return Visit_Task_APAC__c

   */
   
   @AuraEnabled
   public static List<Visit_Task_APAC__c> getVisitTaskMappingMap(String companyName){

        User user = [select Id, Name, CompanyName from User where Id =: userInfo.getUserId()];
        System.debug('User Id is '+user.Id+' : User name is '+user.Name+' : User company is '+user.companyName);

        String company = '';

        if(companyName=='' || companyName==null){
            company = '%';
            System.debug('Company Name is '+company);
        }else if(companyName!=null || companyName!=''){
            company = companyName;
            System.debug('Company Name is '+company);
        }

        List<Visit_Task_APAC__c> visitTaskAPAC = [SELECT Account__c,Checked_Location_Time__c,CurrencyIsoCode,
                                                        Description__c,Id, Name, Account__r.Name, Account__r.Hoya_Account_Id__c,
                                                        OwnerId,Start_Location_Lattitude__c,Start_Location_Longitude__c,
                                                        Visit_Start_Type__c,Visit__c, Visit_Notes__c, Visit_Reason__c, Owner.Name
                                                        FROM Visit_Task_APAC__c WHERE Company_Name__c LIKE:company
                                                        AND Checked_Location_Time__c = LAST_N_DAYS:7
                                                        ORDER BY Checked_Location_Time__c DESC limit 10000];
        
        System.debug('User company name = '+user.CompanyName+' result '+visitTaskAPAC.size());
        return visitTaskAPAC;

   }

   @AuraEnabled
   public static List<Option> getCompanyDataList(){

        List<Option> optionList = new List<Option>();
        for(CompanyNameEnum c : CompanyNameEnum.values()){
            optionList.add(new Option(c.name(), c.name()));
        }

        System.debug('Caompany Option List = '+optionList.size());
        return optionList;
   }

   /**
    * Add below class for get contact id from Contact object
    * to support for Contact fields MiyoSmart fields
    * added : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
    * date : 2023-11-28
    * Required : Chan Yung
    */

    @AuraEnabled
    public static Id getContactIdFromAccount(Id recordId){
        try {
            Id conId = [SELECT Id, AccountId FROM Contact WHERE AccountId=:recordId].Id;
            //System.debug('Contact Id associated to Account is '+conId);
            return conId;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class NumOfContact{
        @AuraEnabled public double ContactNum{get;set;}
    }

    @AuraEnabled
    public static List<NumOfContact> getContactNumber(Id recordId){
        try {
            List<NumOfContact> conNumList = new List<NumOfContact>();
            List<AggregateResult> result = [SELECT COUNT(Id) counting FROM Contact WHERE AccountId=:recordId];
            for(AggregateResult ar:result){
                NumOfContact n = new NumOfContact();
                n.ContactNum = (Double)ar.get('counting');
                conNumList.add(n);
            }
            System.debug('Contact count==>'+conNumList);
            return conNumList;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}