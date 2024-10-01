/**
 * Created by thomas.schnocklake on 04.01.18.
 */

 global without sharing class VisitPlanningController {
    @AuraEnabled
    public static List<Visits__c> getVisits (Datetime periodStart, Datetime periodEnd) {
        System.debug('periodStart: ' + periodStart);
        System.debug('periodEnd: ' + periodEnd);

        List<Visits__c> visits = [
                SELECT Id, Name, Start_Time__c, End_Time__c, Duration_Minutes__c, Is_All_Day_Event__c, Visit_Notes__c, Visit_Type__c, Visit_Reason__c, Actions_executed__c, Private__c, View__c, Assigned_to__c, Show_time_as__c, Visit_Status__c,
                        Visit_Objective_follow_up_notes__c, Call_To_Action__c, Cold_call__c, Visited_but_not_seen__c, Call_To_Action_Notes__c, Account__r.Shop_City__c, Account__r.Hoya_Account_ID__c,
                        MKT_Acquisition_Pa__c, MKT_Hoya_YOU__c, MKT_Hoya_Coatings_promotion__c, MKT_Hot_or_Cold__c, MKT_Yuniku__c, MKT_Seiko_Sensity__c, MKT_Enroute_Campaign__c, MKT_Local_Campaign__c, SUN_Campaign_including_SENSITY__c, MKT_No_campaign_presented__c, MKT_Incentive_trips_Contracts_assignment__c, MKT_PAL_and_Functional_Lens__c, MKT_New_Products__c, Account__c, Account__r.Id, Account__r.Name, Account__r.ShippingPostalCode, Account__r.Actual_Classification__c, Account__r.Contract_Expiration__c, Account__r.Channel__c, Account__r.Visit_Frequency_Status__c, Account__r.AMT_gross_sales__c, Account__r.Quantity__c,
                        Contact__c, Contact__r.Id, Contact__r.Name, Contact__r.AccountId, Contact__r.FirstName, Contact__r.LastName, Contact__r.RecordTypeId, Contact__r.Title, Contact__r.IsDeleted,
            			SEIKO_LIFESTYLE_PRODUCTS__c, SEIKO_BRAND__c, SEIKO_COATING__c, SEIKO_EXCELLENCE__c, Sync_III__c,MySelf__c, SEIKO_PREMIUM_PAL__c, SEIKO_VISION_SPECIALIST__c, Orgreen_Yuniku__c,
            			Coaching_Visit__c, Segmentation_Box__c,miyosmart__c, Send_Email__c,
                        HVNA_Appointment__c, HVNA_Customer_Goal__c, HVNA_Visit_Objective__c,Secondary_Tactic__c, HVNA_Visit_Type__c,HVNA_Subject__c,HLFR_Origine_France_Garantie__c, Campaign_Name__c, 
                        Opportunity__c, Campaign__c, Visit_Opp_New_Close_Date__c, Visit_Campaign_Present__c, Visit_Campaign_Interested__c, Campaign2__c,
                        Campaign3__c, Visit_Campaign_Present_2__c, Visit_Campaign_Present_3__c, Visit_Campaign_Interested_2__c, Visit_Campaign_Interested_3__c
                FROM Visits__c 
                where Visit_Status__c != 'Cancelled'
                AND Assigned_to__c = :UserInfo.getUserId()
                AND End_Time__c > :periodStart
                AND Start_Time__c < :periodEnd

        ];
        return visits;
    }

    //CDU getuserevent implementation
    @AuraEnabled
    public static List<Event> getUserEvents(Datetime periodStart, Datetime periodEnd) {
        System.debug('userEvent periodStart: ' + periodStart);
        System.debug('userEvent periodEnd: ' + periodEnd);
        List<Event> events = [
            select Id, StartDateTime, EndDateTime, Subject, Type, WhoId, RecordTypeId, EventSubtype, Description, IsAllDayEvent
            from Event where OwnerId = :UserInfo.getUserId()
            AND EndDateTime > :periodStart
            AND StartDateTime < :periodEnd
            AND Visit_Id__c = null
        ];
        System.debug('Nb userEvent=' + events.size());
        return events;
    }
    @AuraEnabled
    public static List<Event> getUserIdEvents(Datetime periodStart, Datetime periodEnd, Id userId) {
        System.debug('userEvent periodStart: ' + periodStart);
        System.debug('userEvent periodEnd: ' + periodEnd);
        System.debug('userEvent ID: ' + userId);
        List<Event> events = [
            select Id, StartDateTime, EndDateTime, Subject, Type, WhoId, RecordTypeId, EventSubtype, Description, IsAllDayEvent
            from Event where OwnerId = :userId
            AND EndDateTime > :periodStart
            AND StartDateTime < :periodEnd
            /*AND Visit_Id__c = null*/
        ];
        System.debug('Nb userEvent=' + events.size());
        return events;
    }
    //CDU end of getuserEvent
    
    @AuraEnabled
    public static String getUserCompany(String userId){
        System.debug('USERID=' + userID);
        String uid = userId;
        if(uid==null){uid=UserInfo.getUserId();}
        User result = [select companyName, Sales_Role__c from User where id=:uid];
        //System.debug('USER.COMPANY=' + result.companyName);
        return result.CompanyName;
    }

    @AuraEnabled
    public static String getUserRegion(String userId){
        System.debug('USERID = '+userId);
        String uid = userId;
        if(uid==null){uid=UserInfo.getUserId();}
        User result = [SELECT User_Region__c FROM User WHERE Id=:uid];
        System.debug('User Region is '+result.User_Region__c);
        return result.User_Region__c;
    }
    
    @AuraEnabled
    public static Visits__c getVisit (String visitId) {

        System.debug('visitId: ' + visitId);
        
        try{
        Visits__c v = [
                SELECT Id, Name, Start_Time__c,Start_location_time__c,Stop_location_time__c,
                        End_Time__c, Duration_Minutes__c,
                        Is_All_Day_Event__c, Visit_Notes__c,
                        Visit_Type__c, Visit_Reason__c, Actions_executed__c,
                        Private__c, View__c, Assigned_to__c, Show_time_as__c, Visit_Status__c,
                        Visit_Objective_follow_up_notes__c,
                        Call_To_Action__c, Cold_call__c,
                        Visited_but_not_seen__c, Call_To_Action_Notes__c,
                        Account__r.Shop_City__c, Account__r.Hoya_Account_ID__c,
                        MKT_Acquisition_Pa__c, MKT_Hoya_YOU__c,miyosmart__c,
                        MKT_Hoya_Coatings_promotion__c, MKT_Hot_or_Cold__c,
                        MKT_Yuniku__c, MKT_Seiko_Sensity__c, MKT_Enroute_Campaign__c,
                        MKT_Local_Campaign__c, MKT_No_campaign_presented__c, MKT_Incentive_trips_Contracts_assignment__c, MKT_PAL_and_Functional_Lens__c, MKT_New_Products__c, 
                        Account__c, Account__r.Id, Account__r.Name,
           				SEIKO_LIFESTYLE_PRODUCTS__c, SEIKO_BRAND__c, SEIKO_COATING__c, SEIKO_EXCELLENCE__c, Sync_III__c,MySelf__c,
            			SEIKO_PREMIUM_PAL__c, SUN_Campaign_including_SENSITY__c, SEIKO_VISION_SPECIALIST__c, Orgreen_Yuniku__c,
                        Account__r.ShippingPostalCode, 
                        Account__r.Actual_Classification__c, Account__r.Contract_Expiration__c, Account__r.Channel__c, Account__r.Visit_Frequency_Status__c, Account__r.AMT_gross_sales__c, Account__r.Quantity__c,
                        Contact__c, Contact__r.Id, Contact__r.Name, Contact__r.AccountId, Contact__r.FirstName, Contact__r.LastName, Contact__r.RecordTypeId, Contact__r.Title, Contact__r.IsDeleted,
            			Coaching_Visit__c, Segmentation_Box__c, Account__r.Segmentation_Box__c, Send_Email__c, 
                        HVNA_Appointment__c, HVNA_Customer_Goal__c, HVNA_Visit_Objective__c,Secondary_Tactic__c, HVNA_Visit_Type__c,HVNA_Subject__c,HLFR_Origine_France_Garantie__c, Campaign_Name__c, 
                        Opportunity__c, Campaign__c, Visit_Opp_New_Close_Date__c, Visit_Campaign_Present__c, Visit_Campaign_Interested__c, Campaign2__c, Campaign3__c,
                        Visit_Campaign_Interested_2__c, Visit_Campaign_Interested_3__c, Visit_Campaign_Present_2__c, Visit_Campaign_Present_3__c 
                FROM Visits__c
                where Id = : visitId
            ];
        
        System.debug('XXX: opportunity=' + v.opportunity__c);
        System.debug('XXX: contact=' + v.Contact__c);

        return v;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    @AuraEnabled
    public static Visits__c upsertVisit (Visits__c visit) {
        if(visit.id==null && visit.Visit_Type__c==null){
            //default type for creation only, otherwise moving visit on calendar may change type
            visit.Visit_Type__c='Visit';
        }
        //System.debug('XXXXXXX UPSERT VISIT: ' + visit.Start_Time__c + ',type=' + visit.Visit_Type__c + ',HLSI obj2=' + visit.Visit_Reason_APAC__c);
        visit.assigned_to__c=UserInfo.getUserId();
        upsert visit;
        return visit;
    }
    @AuraEnabled
    public static void deleteVisit (Visits__c visit) {
        delete visit;
    }

 //   @AuraEnabled
 //   public static List<Account> getAccountsInCache(){
 //       return (List<Account>)Cache.Session.get('vpm.account.list');
 //   }

    @AuraEnabled
    public static List<Account> getAccounts(String listViewId, List<String> fields, String filter, String campaignId,  Boolean campaignPriority , Boolean campaignPresented, String device, Integer mobileListSize, String zonal, String tacticom, String tacticomSeiko, Boolean targetList) {
        List<Account> accountList = new List<Account>();
        Map<String, Schema.SObjectField> accFieldMap;
        accFieldMap = Schema.SObjectType.Account.fields.getMap();
        Map<String, Schema.SObjectField> hvnaFieldMap;
        hvnaFieldMap = Schema.SObjectType.Additionnal_account_data__c.fields.getMap();
        boolean hasCampaign = false;
        boolean targetListTrue = targetList!=null && targetList==true;

        String query = '';//' WHERE OwnerId = \'' + UserInfo.getUserId() + '\'';
        String queryFilter ='';

        String maxrows = '10000';
        if(device=='mobile'){
            maxrows = String.valueOf(mobileListSize);
        }
        //System.debug('device=' + device + ', maxrows=' + maxrows + '(param='+mobileListSize+')');
        if(String.isNotEmpty(filter)){
            //queryFilter = ' and (name like \'%'+filter
            //    +'%\' or hoya_account_id__c like \'%'+filter
            //    +'%\'or shop_postal_code__c like \'%'+filter
            //    +'%\'or shop_city__c like \'%'+filter
            //    +'%\'or shop_name__c like \'%'+filter
            //    +'%\'or shop_state__c like \'%'+filter
            //   +'%\'or Segmentation_Box__c like \'%'+filter+'%\'';
            queryFilter = ' and ( Name like \'%'+filter+'%\'';
                for (VisitPlanningAvailableField__mdt f : [SELECT MasterLabel FROM VisitPlanningAvailableField__mdt])
                {
                    //System.debug('VisitPlanningAvailableField__mdt f = ' + f.MasterLabel);
                    Schema.SObjectField field = accFieldMap.get(f.MasterLabel);
                    //System.debug('YYY '+f.MasterLabel+ ' fieldType =' + field.getDescribe().getType().name());
                    try {
                        if(f.MasterLabel<>'Active Campaigns' && field.getDescribe().getType()<>null 
                        && (field.getDescribe().getType().name()=='STRING' || field.getDescribe().getType().name()=='PICKLIST')){
                            queryFilter = queryFilter + ' or ' + f.MasterLabel + ' like \'%' + filter + '%\'';
                        }
                    } catch (Exception e) {
                        system.debug('VPM Error CSTM_' + f.MasterLabel + ':' +e.getMessage());
                    }
                }

                for (VisitPlanningAvailableHVNAField__mdt h : [SELECT MasterLabel FROM VisitPlanningAvailableHVNAField__mdt])
                {
                    Schema.SObjectField field = hvnaFieldMap.get(h.MasterLabel);
                    try {
                        if(field<>null && field.getDescribe().getType()<>null 
                        && (field.getDescribe().getType().name()=='STRING' || field.getDescribe().getType().name()=='PICKLIST')){
                            queryFilter = queryFilter + ' or Additionnal_account_data__r.' + h.MasterLabel + ' like \'%' + filter + '%\'';
                        }
                    } catch (Exception e) {
                        system.debug('VPM Error CSTM_' + h.MasterLabel + ':' +e.getMessage());
                    }
                }
                queryFilter = queryFilter +')';
                
        }
        System.debug('XXX queryFilter=' + queryFilter);
        /* CDU 08/03/2019: add campaign member search functionality */
        String campaignFilter = '';
        List<Id> accountMemberList = new List<Id>();
        if(String.isNotBlank(campaignId) && campaignId!=null){
            //get account list from Account_Campaing_Member__c
            //System.debug('XXX search account_campaign_member');
            hasCampaign = true;
            for(Account_Campaing_Member__c cm : [select Account_Name__c, Campaign_Priority__c, Campaign_Presented__c, Name from Account_Campaing_Member__c where Central_Campaign__c =:campaignId]){
                
                if( (campaignPriority==null || campaignPriority==false) && (campaignPresented==null || campaignPresented==false)){
                    accountMemberList.add(cm.Account_Name__c);
                } 
                if(campaignPriority==true && cm.Campaign_Priority__c==true){
                    accountMemberList.add(cm.Account_Name__c);
                }
                if(campaignPresented==true && cm.Campaign_Presented__c==false){
                    accountMemberList.add(cm.Account_Name__c);
                }
            }

            if(accountMemberList.size()>0){
                String inId = '(';
                for (Id id : accountMemberList){
                    inId = inId + '\'' + id + '\',';
                }
                inId = inId.substring(0, inId.length()-1) + ')';//remove last ,
                campaignFilter = ' and id in ' + inId;
                queryFilter = queryFilter + campaignFilter;
                 System.debug('XXX campaign request: ' + queryFilter);
            } else {
                //no members found, return empty list
                return accountList;
            }

        }
        if(String.isNotBlank(zonal)){
            queryFilter = queryFilter + ' and zonal__c=\''+zonal+'\' ';
        }

        if(String.isNotBlank(tacticom)){

            queryFilter = queryFilter + ' and tacticom_hlfr__c=\''+tacticom+'\' ';
        }
        if(String.isNotBlank(tacticomSeiko)){

            queryFilter = queryFilter + ' and tacticom_sof__c=\''+tacticomSeiko+'\' ';
        }
        
        if(targetListTrue){
            queryFilter = queryFilter + ' and Target_List__c=true ';
            System.debug('XYZ: ' + queryFilter);
        }

        /* Query generator for list view */
        if (String.isNotBlank(listViewId))
        {
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:Self/services/data/v41.0/sobjects/Account/listviews/' + listViewId + '/describe');
                List<ExternalDataUserAuth> authList = [
                        SELECT Id, UserId, Protocol, Username, User.UserName, Password, AuthProviderId, ExternalDataSourceId, ExternalDataSource.Name
                         FROM ExternalDataUserAuth
                        WHERE ExternalDataSource.Name = :'SelfSelf'
                          AND UserId = : UserInfo.getUserId()
                ];
                if (authList.size() == 0)
                {
                    if(!Test.isRunningTest()) {
                        throw new AuraHandledException('auth');
                    }
                }

                req.setEndpoint('callout:SelfSelf/services/data/v41.0/sobjects/Account/listviews/' + listViewId + '/describe');
                req.setMethod('GET');

                try
                {
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                    System.debug(res.getStatus());
                    System.debug(res.getBody());

                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());

                    System.debug(m.get('whereCondition'));
                    query = (String)m.get('query');
                    System.debug(query);

                    query = query.substring(query.indexOf('FROM Account ')+12);
                }
                catch (Exception ex)
                {
                    if (authList.size() == 1)
                    {
                        throw new AuraHandledException(authList[0].Id);
                    }
                    throw new AuraHandledException('gefangen');
                }

        }
        if(!String.isEmpty(query)){
            query = query.replace('USING SCOPE mine', '');
        }
        System.debug(query);
        //System.debug(fields);
        String fieldString = ' Id';
        for (String field : fields)
        {
            if (field != 'Id'){
                fieldString =  field     + ',' + fieldString;
            }
        }
        System.debug(fieldString);

        
        String salesRole = [select Id, Sales_Role__c from User where id=:UserInfo.getUserId() ].Sales_Role__c;
        if (String.isBlank(listViewId) && String.isBlank(zonal) && String.isBlank(tacticom) && (targetList==null||targetList==false)
                && (campaignPresented==null||campaignPresented==false) && (campaignPriority==null||campaignPriority==false)){
            List<Id> accountShareList = new List<Id>();
            List<Group> relatedGroups = [SELECT Id FROM Group WHERE Id IN (
        									SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId() 
    									)
										];
            if(accountMemberList.size()>0){
                for(AccountShare sh : [select accountId from accountShare where (UserOrGroupId in :relatedGroups or UserOrGroupId=:UserInfo.getUserId()) and id in :accountMemberList limit 2000]){
                    accountShareList.add(sh.accountId);
                }
            } else {
                for(AccountShare sh : [select accountId from accountShare where UserOrGroupId in :relatedGroups or UserOrGroupId=:UserInfo.getUserId() limit 2000]){
                 accountShareList.add(sh.accountId);
        	    }
            }
            
            
            /*
             * CDU: add sharing accounts not owned by user
             * CDU: 15/11/2019: do not add shared account for campaign filter
             */
            if(String.isNotEmpty(filter) && hasCampaign==false && targetList==null){
            	String filter2 = '%'+filter+'%';
             	for(AccountShare sh : [select accountId from accountShare where UserOrGroupId in :relatedGroups and account.owner.id<> :UserInfo.getUserId()
                                    and (account.Hoya_Account_ID__c like :filter2 or account.name like :filter2 or account.Segmentation_box__c like :filter2
                                         or account.shop_postal_code__c like :filter2 or account.shop_city__c like :filter2
                                         or account.shop_name__c like :filter2 or account.shop_state__c like :filter2 )
                                    and account.Account_Status__c<>'Closed'
                                    limit 1000]){
                 accountShareList.add(sh.accountId);
                 }                      
        	}
            //System.debug('accountSharingList size=' + accountShareList.size());
            //CDU: 03/09/2019: wonder if String.isNotBlank(salesRole) is relevant... inactivated for test
            //CDU: 15/11/2019: shared account only if campaign not selected
            if(!accountShareList.isEmpty() && String.isNotBlank(salesRole) && hasCampaign==false && targetList==null){
                String filter2 = '%'+filter+'%';
                if(String.isNotEmpty(filter)){
            		accountList.addAll([select account.Id, account.Name, account.Hoya_Account_ID__c, account.recordtype.name, account.Account_Status__c, account.shop_city__c, phone, Segmentation_Box__c, account.Financial_Status_Identifier__c, recordtypeid
                                    FROM Account Where Id in :accountShareList
                                    and ownerId!=:UserInfo.getUserId()
                                    and (Hoya_Account_ID__c like :filter2 or name like :filter2 or Segmentation_box__c like :filter2
                                         or shop_postal_code__c like :filter2 or shop_city__c like :filter2
                                         or shop_name__c like :filter2 or shop_state__c like :filter2 )
                                    and account.Account_Status__c<>'Closed'
                                        ] );
                } else {
                    accountList.addAll([select Id, Name, Hoya_Account_ID__c, recordtype.name, Account_Status__c, shop_city__c, phone, Segmentation_Box__c, Financial_Status_Identifier__c, recordtypeid
                                    FROM Account Where Id in :accountShareList
                                    and ownerId!=:UserInfo.getUserId() 
                                    and account.Account_Status__c<>'Closed']);
                }
            	System.debug('accountList with sharing size=' + accountList.size());
            }
            
        }

        //System.debug('is asm('+salesRole+'):' + 'ASM'==salesRole);
        String orderby = '';
        Integer pos = query.indexOf('ORDER BY');
        if(pos>=0){
            orderby = query.substring(pos);
        	query = query.substring(0, pos);
        }
        if(device=='mobile'){
            orderby = ' ORDER BY NAME ';
        }
        System.debug('Query without order=' + query);
        System.debug('Orderby=' + orderby);
        if(query.indexOf(' or ')>0 || query.indexOf(' OR ')>0){ query =  query.replace('where', 'where (').replace('WHERE', 'where (') + ') ';}
        
        String companyName = [select Id, Sales_Role__c,CompanyName from User where id=:UserInfo.getUserId()].CompanyName;
        if('ASM'==salesRole && (companyName!='HVNA' && companyName!='HOLA' && companyName!='HLCA' && companyName!='SRX')){
            System.debug('XXXXX 1111');
        	query = 'SELECT ' + fieldString 
                + ' FROM Account WHERE OwnerId = \'' + UserInfo.getUserId() + '\' '
                + queryFilter  + query.replace('where', 'and').replace('WHERE', 'and')  + ' and Account_Status__c<>\'Closed\' ' + orderby +' limit ' + maxrows;
    	} else if(salesRole!=null){
            System.debug('XXXXX 2222');
            Set<Id> userIdList = getRoleSubordinateUsers(UserInfo.getUserId());
            
            String uidCrit = ' and OwnerId in (';
			for(Id uid : userIdList){
                uidCrit = uidCrit + '\'' + uid + '\',';
            }
            uidCrit = uidCrit + '\''+ UserInfo.getUserId() + '\') ';
        	query = 'SELECT ' + fieldString 
                + ' FROM Account where hoya_account_id__c != null ' + queryFilter + uidCrit + query.replace('WHERE', 'and' ).replace('where', ' and ')+ ' and Account_Status__c<>\'Closed\' ' + orderby + ' limit ' + maxrows;
        } else {
            System.debug('XXXXX 3333');
            String roleidCrit = 'WHERE Owner.UserRoleId in (';
            for(ID roleId : getSubordinateRoles(UserInfo.getUserRoleId())){
                 roleidCrit = roleidCrit + '\'' + roleId + '\',';
            }
            roleidCrit = roleidCrit + '\''+ UserInfo.getUserRoleId() + '\') ';

            if(String.isEmpty(UserInfo.getUserRoleId()) || UserInfo.getUserRoleId()=='00Eb0000000HESA'|| String.isNotBlank(listViewId)){
                //add a default crit instead of role crit
                //00Eb0000000HESA = glola role, should see everything, let's work with fake criteria
                roleidCrit = ' where hoya_account_id__c != null ';
            }
            query = 'SELECT ' + fieldString + ' FROM Account ' + roleidCrit + queryFilter + query.replace('WHERE', ' and ').replace('where', ' and ') + ' and Account_Status__c<>\'Closed\' ' + orderby +' limit ' + maxrows;
  
        }
        System.debug('XXXXX=' + query);

        try
        {
            Map<Id,Account> ownerAccountList = new Map<Id, Account>( (List<Account>)Database.query(query));
            List<Account> tmpAccList = new List<Account>();
            for(Id key : ownerAccountList.keySet()){
                if(!accountList.contains(ownerAccountList.get(key))){
                    tmpAccList.add(ownerAccountList.get(key));
                }
            }
            accountList.addAll(tmpAccList);
            System.debug('List size:' + accountList.size());
            //Cache.Session.put('vpm.account.list', accountList);
            return accountList;
        }
        catch (Exception ex)
        {
            System.debug(query);

            throw new AuraHandledException(ex.getMessage());
        }

    }
    
    @AuraEnabled
    public static Object getContactsForAccount(String accountId) {
        List<SelectOption> options = new List<SelectOption>();
        for (Contact c : [Select Id, Name from Contact where AccountId = : accountId])
        {
            options.add(new SelectOption(c.Id,c.Name));
        }
        return toOptionList(options, true);
    }
    /*
    original method from Surawat
    @AuraEnabled
    public static Object getOpportunityByAccountList(String accountId){
        System.debug('call getOpportunityByAccountList -' + accountId);

        List<SelectOption> options = new List<SelectOption>();
        for (Opportunity o : [Select Id, Name, StageName from Opportunity where (AccountId =: accountId) and (IsClosed=false) and (Account.Target_List__c=true) and (Account.Segmentation_box__c='A3' or Account.Segmentation_box__c='B3' or Account.Manual_Segment__c='A3' or Account.Manual_Segment__c='B3') order by CreatedDate desc limit 1])
        {
            options.add(new SelectOption(o.Id, o.Name));

        }
        return toOptionList(options, true);

    }*/
    
    @AuraEnabled
    public static Object getOpportunityByAccountList(String accountId){
        System.debug('call getOpportunityByAccountList -' + accountId);

        String companyName = VisitPlanningController.getCompanyName();
        List<SelectOption> options = new List<SelectOption>();
        if(companyName=='HVNA' || companyName=='HOLA' || companyName=='HLCA'  || companyName=='SRX'){
            for (Opportunity o : [Select Id, Name, StageName, Days_in_the_current_Stage__c from Opportunity where (AccountId =: accountId) and (IsClosed=false)  order by CreatedDate desc limit 1])
            {
                options.add(new SelectOption(o.Id, o.Name));
            }
        } else {
            for (Opportunity o : [Select Id, Name, StageName, Days_in_the_current_Stage__c from Opportunity where (AccountId =: accountId) and (IsClosed=false) and (Account.Target_List__c=true) order by CreatedDate desc limit 1])
            {
                options.add(new SelectOption(o.Id, o.Name));
            }
        }
        return toOptionList(options, true);

    }
    /*
    To compact/budget with Visits__c no need to include with Visit_Opp_Stage_Name__c
    @AuraEnabled
    public static Object getOppStageByAccount(String accountId){
        System.debug('call getOpportunityByAccountList -' + accountId);

        List<SelectOption> options = new List<SelectOption>();
        for (Opportunity o : [Select Id, StageName from Opportunity where (AccountId =: accountId) and (IsClosed=false) and (Account.Target_List__c=true) and (Account.Segmentation_box__c='A3' or Account.Segmentation_box__c='B3' or Account.Manual_Segment__c='A3' or Account.Manual_Segment__c='B3') order by CreatedDate desc limit 1])
        {
            options.add(new SelectOption(o.Id, o.StageName));

        }
        return toOptionList(options, true);

    }
    /*
    To compact with custom fields in Visits__c no need to include Visit_Close_Date__f field into
    @AuraEnabled
    public static Object getOppCloseDateByAccount(String accountId){
        System.debug('call getOpportunityByAccountList -' + accountId);

        List<SelectOption> options = new List<SelectOption>();
        for (Opportunity o : [Select Id, CloseDate from Opportunity where (AccountId =: accountId) and (IsClosed=false) and (Account.Target_List__c=true) and (Account.Segmentation_box__c='A3' or Account.Segmentation_box__c='B3' or Account.Manual_Segment__c='A3' or Account.Manual_Segment__c='B3') order by CreatedDate desc limit 1])
        {
            options.add(new SelectOption(o.Id, string.valueof(o.CloseDate)));

        }
        return toOptionList(options, true);

    }
    */
    @AuraEnabled
    public static List<Account_Campaing_Member__c> getAccCampaignMember(Id accountId, Id campaignId){
        return [select Id, Name, Campaign_Name__c, Date_of_presentation__c, Campaign_Presented__c, Level_interest__c, Not_ineterested_Reason__c, Central_Campaign__c from Account_Campaing_Member__c where Account_Name__c=:accountId and campaign_active__c = true order by CreatedDate desc limit 10];

    }
    
    @AuraEnabled
    public static List<Opportunity> getOpportunityMember(Id accountId){
        system.debug('Opportunity Id is - '+accountId);
        return [Select Id, Name, StageName, NextStep, Description, CloseDate,Days_in_the_current_Stage__c from Opportunity where (AccountId =: accountId) and (IsClosed=false) order by CreatedDate desc limit 1];

    }
   
    @AuraEnabled
    public static List<Opportunity> getOpportunity(Id oppId){
        system.debug('Opportunity Id is - '+oppId);
        return [Select Id, Name, StageName, NextStep, Description, CloseDate,Days_in_the_current_Stage__c from Opportunity where Id=:oppId ];

    }
    @AuraEnabled
    public static Object getCampaignListByAccount(String accountId){
        System.debug('call getCampaignListByAccount -' + accountId);
        if(accountId==null) return null;
        List<SelectOption> options = new List<SelectOption>();
        List<Account_Campaing_Member__c> memberList = [select id,Central_Campaign__c from Account_Campaing_Member__c where Account_Name__c =:accountId and Is_campaign_active__c=true];
        
        if(memberList!=null && memberList.size()>0){
            System.debug('XXX memberListSize =' + memberList.size());
            for(Account_Campaing_Member__c member: memberList){
                List<Campaign> tempList = [select Id,Name from campaign where id =:member.Central_Campaign__c];
                for(Campaign c : tempList){
                    options.add(new SelectOption(c.Id, c.Name));
                    System.debug('XXX add campaign '+ c.Name);
                }
            }
        } else {
            System.debug('XXX memberListSize no result');
        }

        return toOptionList(options, true);
    }

    @AuraEnabled
    public static List<Map<String, String>> getAccountFieldList() {
        List<Map<String, String>> fieldsToReturn = new List<Map<String, String>>();

        Set<String> allowedFieldsSet = new  Set<String>();
        for (VisitPlanningAvailableField__mdt f : [SELECT MasterLabel FROM VisitPlanningAvailableField__mdt])
        {
            allowedFieldsSet.add(f.MasterLabel);
        }
        Schema.DescribeSObjectResult dsor = Account.getSObjectType().getDescribe();
        // the map to be returned with the final data

        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();

        // iterate over the requested fields and get the describe info for each one.
        // add it to a map with field name as key
        for(String field : objectFields.keySet())
        {
            // skip fields that are not part of the object
            Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
            if (dr.isAccessible() && allowedFieldsSet.contains(dr.getLocalName())) {
                Map<String, String> fm = new Map<String, String>();
                fm.put('fieldName', dr.getLocalName());
                fm.put('value', dr.getLocalName());
                fm.put('label', dr.getLabel());
                fm.put('type', dr.getType().name());

                fieldsToReturn.add(fm);
            }
        }
        // CDU 05/06/2019 add HVNA object fields (only for HVNA profiles)
        String companyName = VisitPlanningController.getCompanyName();
        if(companyName=='HVNA' || companyName=='HOLA' || companyName=='HLCA'  || companyName=='SRX'){
            Set<String> allowedHVNAFieldsSet = new  Set<String>();
            for (VisitPlanningAvailableHVNAField__mdt f : [SELECT MasterLabel FROM VisitPlanningAvailableHVNAField__mdt])
            {
                allowedHVNAFieldsSet.add(f.MasterLabel);
            }
            dsor = Additionnal_account_data__c.getSObjectType().getDescribe();
            // the map to be returned with the final data

            Map<String, Schema.SObjectField> objectHVNAFields = dsor.fields.getMap();

            // iterate over the requested fields and get the describe info for each one.
            // add it to a map with field name as key
            for(String field : objectHVNAFields.keySet())
            {
                // skip fields that are not part of the object
                Schema.DescribeFieldResult dr = objectHVNAFields.get(field).getDescribe();
                if (dr.isAccessible() && allowedHVNAFieldsSet.contains(dr.getLocalName())) {
                    Map<String, String> fm = new Map<String, String>();
                    fm.put('fieldName', 'Additionnal_account_data__r.' + dr.getLocalName());
                    fm.put('value', 'Additionnal_account_data__r.' +dr.getLocalName());
                    fm.put('label', dr.getLabel());
                    fm.put('type', dr.getType().name());

                    fieldsToReturn.add(fm);
                }
            }
        }
        System.debug(fieldsToReturn);

        return fieldsToReturn;
    }

    @AuraEnabled
    public static List<ListView> getListViews() {
        /* CDU 11/06/2018 add auto-filter on user id, user should see only his own listview */
        /* SS 23/02/2021 for user should can see in target customer (Opportunity Account List) by their Account, Request from Yung & Samson */
        return [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType, IsSoqlCompatible, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate FROM ListView where (SobjectType = :'Account') and (createdbyid =:UserInfo.getUserId() or DeveloperName = 'Your Opportunities Accounts')];
        //return [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType, IsSoqlCompatible, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate FROM ListView where SobjectType = :'Account' ];
    }

    @AuraEnabled
    public static List<option> getAccountZonalList(){
        /* CUD 20/03/2020, zonal picklist to add on VPM */
        return toOptionList(getOptionsForDescribe(Account.Zonal__c.getDescribe()),false);

    }

    @AuraEnabled
    public static List<option> getAccountTacticomHoyaList(){

        /*SS 2021/03/17, Tacticom picklist-Hoya to add on VPM */
        return toOptionList(getOptionsForDescribe(Account.TACTICOM_HLFR__c.getDescribe()), false);

    }
    @AuraEnabled
    public static List<option> getAccountTacticomSeikoList(){

        /*SS 2021/03/17, Tacticom picklist-Hoya to add on VPM */
        return toOptionList(getOptionsForDescribe(Account.TACTICOM_SOF__c.getDescribe()), false);

    }
    

    @AuraEnabled
    public static List<option> getCampaignInterested(){
        return toOptionList(getOptionsForDescribe(Visits__c.Visit_Campaign_Interested__c.getDescribe()), false);
    }

    @AuraEnabled
    public static List<option> getCampaignInterested2(){
        return toOptionList(getOptionsForDescribe(Visits__c.Visit_Campaign_Interested_2__c.getDescribe()), false);

    }

    @AuraEnabled
    public static List<option> getCampaignInterested3(){

        return toOptionList(getOptionsForDescribe(Visits__c.Visit_Campaign_Interested_3__c.getDescribe()), false);
    }
    
    @AuraEnabled
    public static List<Option> getCampaignList() {
        /* CDU 07/03/2019 add campaign dropbox */
        List<Option> optionList = new List<Option>();
        //optionList.add(new Option('', ''));
        String companyName = VisitPlanningController.getCompanyName();
        if(companyName==null){companyName='EMEA';}
        //CDU 18/03/2020: requested by GT, campaign list on company name only
        //for (Campaign cmp : [SELECT Id,IsActive,Name FROM Campaign where createdby.companyName in : ToolBox.getCompanyList(companyName) and isActive=true]){        
        for (Campaign cmp : [SELECT Id,IsActive,Name FROM Campaign where Campaign_Subsidiary__c = :companyName and isActive=true]){
            optionList.add(new Option(cmp.id, cmp.name));
        }

        // CDU 14/11/2019 need validation to be activate
        //for (Campaign cmp : [SELECT Id,IsActive,Name FROM Campaign where Company_Code__c =:companyName and isActive=true]){
        //    optionList.add(new Option(cmp.id, cmp.name));
        //}
        return optionList;
    }
	/*
    @AuraEnabled
    public static List<Option> getOpportunityStageName2(){
        List<Option> optionList = new List<Option>();
        List<Id> ParentsId = new List<Id>();
        String huntRecId = [select Id, Name from RecordType where sObjectType = 'Opportunity' and Name = 'Hunting Opportunity'].Id;

        for(PicklistValueInfo pick : [SELECT Id, Label,Value, EntityParticle.DeveloperName, EntityParticleId 
                                        FROM PicklistValueInfo 
                                        WHERE (EntityParticle.EntityDefinition.QualifiedApiName = 'Opportunity') 
                                        AND (EntityParticle.DeveloperName = 'StageName') AND (IsActive=true) 
                                        AND (Value='1-Initial Contact' or Value='2-Evaluate' or Value='3-Interest' or Value='4-Trial' or Value='5-Partnership Proposal' or Value='6-Closed Lost-Postpone' or Value='6-Closed Win-On Board') order by value asc limit 100])
        {
            optionList.add(new Option(pick.Id, pick.Value));
        }
        return optionList;
    }
    */
    @AuraEnabled
    public static List<String> getSelectedAccountFieldList()
    {
        List<String> selectedAccountFieldList = new List<String>();
        User u = [SELECT Id, VisitPlannigFieldSelection__c from User where Id =: UserInfo.getUserId()];


        if (String.isBlank(u.VisitPlannigFieldSelection__c))
        {
            selectedAccountFieldList.add('Name');
        }
        else
        {
            selectedAccountFieldList.addAll(u.VisitPlannigFieldSelection__c.split(';'));
        }

        Set<String> allowedFieldsSet = new  Set<String>();
        for (VisitPlanningAvailableField__mdt f : [SELECT MasterLabel FROM VisitPlanningAvailableField__mdt])
        {
            allowedFieldsSet.add(f.MasterLabel);
        }

        for (VisitPlanningAvailableHVNAField__mdt h : [SELECT MasterLabel FROM VisitPlanningAvailableHVNAField__mdt])
        {
            allowedFieldsSet.add('Additionnal_account_data__r.'+h.MasterLabel);
        }
        
        List<String> selectedAccountFieldListToReturn = new List<String>();
        for (String f : selectedAccountFieldList)
        {
            if (allowedFieldsSet.contains(f))
            {
                selectedAccountFieldListToReturn.add(f);
            }
        }
        System.debug('YYYY Loading selected field list:' + selectedAccountFieldListToReturn);
        return selectedAccountFieldListToReturn ;
    }

    @AuraEnabled
    public static void saveSelectedAccountFieldList(List<String> selectedAccountFieldList)
    {
        String s = '';
        for (String selectedAccountField : selectedAccountFieldList)
        {
            s += ';' + selectedAccountField;
            //System.debug('YYYY saving field list' + selectedAccountField);
        }

        update new User(VisitPlannigFieldSelection__c = s.substring(1), Id = UserInfo.getUserId());
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

    public static List<Option> getSRX_ObjectiveOptionList()
    {
        List<Option> optionList = new List<Option>();
       	optionList.add(new Option('Acquisition', 'Acquisition'));
       	optionList.add(new Option('Problem Resolution', 'Problem Resolution'));
       	optionList.add(new Option('Training New Customer', 'Training New Customer'));
       	optionList.add(new Option('Product Mix', 'Product Mix'));
        return optionList;
    }
    public static List<Option> getSRX_OutcomeOptionList()
    {
        List<Option> optionList = new List<Option>();
       	optionList.add(new Option('Improve Mix', 'Improve Mix'));
       	optionList.add(new Option('Problem resolution', 'Problem resolution'));
       	optionList.add(new Option('Problem escalation', 'Problem escalation'));
       	optionList.add(new Option('Business won/Loss', 'Business won/Loss'));
       	optionList.add(new Option('none', 'none'));
        return optionList;
    }
    public static List<Option> getSRX_ActionExecutedOptionList()
    {
        List<Option> optionList = new List<Option>();
        optionList.add(new Option('', ''));
       	optionList.add(new Option('Business_review', 'Business review'));
       	optionList.add(new Option('No_Actions', 'No Actions'));
       	optionList.add(new Option('Problem_solving', 'Problem solving'));
       	optionList.add(new Option('Prospecting', 'Prospecting'));
        return optionList;
    }

    public static List<SelectOption> getOptionsForDescribe(Schema.DescribeFieldResult fieldResult)
    {
        List<SelectOption> options = new List<SelectOption>();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
        {
            if(f.getValue()!='Making Contact' && f.getValue()!='Event Invitation' && f.getValue()!='Panel Visit'
                && f.getValue()!='Detractors' && f.getValue()!='Prescriptions' && f.getValue()!='Other - describe'
                && f.getValue()!='MiyoSmart presentation' && f.getValue()!='Other product presentation'){
                options.add(new SelectOption(f.getValue(), f.getLabel() ));
            }
        }
        return options;
    }


    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Username,Alias,Country,Email,FirstName,LastName,IsActive, profileid 
                FROM User Where id =: userInfo.getUserId()];
        System.debug('XXX user=' + oUser.Username);
        return oUser;
    }

    @AuraEnabled
    public static Object getTranslations()
    {
        System.debug('XXX CAL getTranslations()');
		boolean isSRX = false;
        boolean isHvna = false;
        User result = [select companyName, Sales_Role__c from User where id=:UserInfo.getUserId()];
        isSRX = result.CompanyName == 'SRX';
        isHvna = result.CompanyName == 'HOLA' ||result.CompanyName == 'HLCA' ||result.CompanyName == 'HVNA' ||result.CompanyName =='VEUS'
        ||result.CompanyName == 'HLCATEST' ||result.CompanyName == 'HOLATEST';

        //System.debug('XYZ:' + result.companyName + ', isHvna=' + isHvna);

        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();

        Map<String, Object> ret = new Map<String, Object>();
        ret.putAll((Map<String, Object>)translateSObject('Account', gdMap));
        ret.putAll((Map<String, Object>)translateSObject('Visits__c', gdMap));
        ret.putAll((Map<String, Object>)translateSObject('Account_Campaing_Member__c', gdMap));
        ret.putAll((Map<String, Object>)translateSObject('Opportunity', gdMap));

        Map<String, Object> theMap = new Map<String,Object>();

        theMap.put('Visits__c_Visit_Status__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Status__c.getDescribe()),false));
        
        if(!isSRX){
            theMap.put('Visits__c_Visit_Reason__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Reason__c.getDescribe()),true));//objective
            theMap.put('Visits__c_Call_To_Action__c', toOptionList(getOptionsForDescribe(Visits__c.Call_To_Action__c.getDescribe()),true));//outcome
            theMap.put('Visits__c_Actions_executed__c', toOptionList(getOptionsForDescribe(Visits__c.Actions_executed__c.getDescribe()),true));
            if(isHvna){
                //specific hvna field
                System.debug('XYZ:' + result.companyName + ', load specific picklist, isHvna=' + isHvna);
                theMap.put('Visits__c_Visit_HVNA_Visit_Objective__c', toOptionList(getOptionsForDescribe(Visits__c.HVNA_Visit_Objective__c.getDescribe()),true));
                theMap.put('Visits__c_Visit_Secondary_Tactic__c', toOptionList(getOptionsForDescribe(Visits__c.Secondary_Tactic__c.getDescribe()),true));
                theMap.put('Visits__c_Visit_HVNA_Appointment__c', toOptionList(getOptionsForDescribe(Visits__c.HVNA_Appointment__c.getDescribe()),true));
                theMap.put('Visits__c_HVNA_Visit_Type__c', toOptionList(getOptionsForDescribe(Visits__c.HVNA_Visit_Type__c.getDescribe()),true));
                //theMap.put('Visits__c_HVNA_Visit_Objective__c', toOptionList(getOptionsForDescribe(Visits__c.HVNA_Visit_Objective__c.getDescribe()),true));
                theMap.put('Visits__c_Visit_HVNA_Customer_Goal__c', toOptionList(getOptionsForDescribe(Visits__c.HVNA_Customer_Goal__c.getDescribe()),true));
            } else{
                 theMap.put('Visits__c_Visit_Type__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Type__c.getDescribe()),false));
            }
        } else {
            theMap.put('Visits__c_Visit_Type__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Type__c.getDescribe()),false));
            theMap.put('Visits__c_Visit_Reason__c', getSRX_ObjectiveOptionList());//objective
            theMap.put('Visits__c_Call_To_Action__c', getSRX_OutcomeOptionList());//outcome
            theMap.put('Visits__c_Actions_executed__c', getSRX_ActionExecutedOptionList());
        }
        //SOC specific picklist
        //theMap.put('Visits__c_SOC_Sales_Actions_executed__c', toOptionList(getOptionsForDescribe(Visits__c.SOC_Sales_Actions_executed__c.getDescribe()),true));
        //theMap.put('Visits__c_SOC_Sales_Call_To_Action__c', toOptionList(getOptionsForDescribe(Visits__c.SOC_Sales_Call_To_Action__c.getDescribe()),true));
        //theMap.put('Visits__c_SOC_Sales_Visit_Reason__c', toOptionList(getOptionsForDescribe(Visits__c.SOC_Sales_Visit_Reason__c.getDescribe()),true));
        //theMap.put('Visits__c_SOC_VCC_Action_Exectued__c', toOptionList(getOptionsForDescribe(Visits__c.SOC_VCC_Action_Exectued__c.getDescribe()),true));
        //theMap.put('Visits__c_SOC_VCC_Call_To_Action__c', toOptionList(getOptionsForDescribe(Visits__c.SOC_VCC_Call_To_Action__c.getDescribe()),true));
        //theMap.put('Visits__c_SOC_VCC_Visit_Reason__c', toOptionList(getOptionsForDescribe(Visits__c.SOC_VCC_Visit_Reason__c.getDescribe()),true));
		//HLSH specific picklist
        //theMap.put('Visits__c_HLSH_Action_Excecuted__c', toOptionList(getOptionsForDescribe(Visits__c.HLSH_Action_Excecuted__c.getDescribe()),true));
        //theMap.put('Visits__c_HLSH_Visit_Reason__c', toOptionList(getOptionsForDescribe(Visits__c.HLSH_Visit_Reason__c.getDescribe()),true));
        //theMap.put('Visits__c_HLSH_Visit_Type__c', toOptionList(getOptionsForDescribe(Visits__c.HLSH_Visit_Type__c.getDescribe()),true));
        //HLSI specific picklist
        //theMap.put('Visits__c_HLSI_Visit_Objective2__c', toOptionList(getOptionsForDescribe(Visits__c.HLSI_Visit_Objective2__c.getDescribe()),true));
        //theMap.put('Visits__c_HLSI_Visit_Objective__c', toOptionList(getOptionsForDescribe(Visits__c.HLSI_Visit_Objective__c.getDescribe()),true));
        //theMap.put('Visits__c_HLSI_Call_to_action__c', toOptionList(getOptionsForDescribe(Visits__c.HLSI_Call_to_action__c.getDescribe()),true));
        //theMap.put('Visits__c_HLSI_action_executed__c', toOptionList(getOptionsForDescribe(Visits__c.HLSI_action_executed__c.getDescribe()),true));
        //theMap.put('Visits__c_Visit_Reason_APAC__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Reason_APAC__c.getDescribe()),true));
        //HLHK specific picklist with marketing campaign and should related with Campaign object
        //theMap.put('Account_Zonal__c', toOptionList(getOptionsForDescribe(Account.Zonal__c.getDescribe()),true));
        theMap.put('Account_TACTICOM_HLFR__c', toOptionList(getOptionsForDescribe(Account.TACTICOM_HLFR__c.getDescribe()),true));
        theMap.put('Visits__c_Visit_Campaign_Interested__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Campaign_Interested__c.getDescribe()), true));
        theMap.put('Visits__c_Visit_Campaign_Interested_2__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Campaign_Interested_2__c.getDescribe()), true));
        theMap.put('Visits__c_Visit_Campaign_Interested_3__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Campaign_Interested_3__c.getDescribe()), true));
        ret.put('picklists' , theMap);
        return ret;
    }


    public static Map<String, String> translateSObject(String selectedObject, Map<String, Schema.SObjectType> gdMap)
    {
        Map<String, String> ret = new Map<String, String>();
        Schema.Describesobjectresult dsr = gdMap.get(selectedObject).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();

        List<SelectOption> soList = new List<SelectOption>();
        for(String key : fieldMap.keySet())
        {
            Schema.DescribeFieldResult describe =  fieldMap.get(key).getDescribe();
            ret.put(selectedObject + '_' + describe.getName() , describe.getLabel());
            //System.debug('vTranslation: ' + selectedObject + '_' + describe.getName() + '=' + describe.getLabel());
        }

        return ret;
    }

	public static Set<ID> getRoleSubordinateUsers(Id userId) {

        // get requested user's role
        Id roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where 
          UserRoleId IN :allSubRoleIds]);
        // return the ids as a set so you can do what you want with them
        return users.keySet();

  }

  public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

    Set<ID> currentRoleIds = new Set<ID>();

    // get all of the roles underneath the passed roles
    /*for(UserRole userRole :[select Id from UserRole where ParentRoleId 
      IN :roleIds AND ParentRoleID != null])
    currentRoleIds.add(userRole.Id);*/

    List<UserRole> userRole = [SELECT Id FROM UserRole WHERE ParentRoleId IN: roleIds AND ParentRoleId != null];
    for(UserRole u : userRole){
        currentRoleIds.add(u.Id);
    }

    // go fetch some more rolls!
    if(currentRoleIds.size() > 0)
      currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));

    return currentRoleIds;

  }
    
    public static set<Id> getSubordinateRoles(Id roleId) {
    
        map<Id, set<Id>> parentAndChildren = new map<Id, set<Id>>();
        set<Id> children;
        /*for(UserRole ur : [select Id, ParentRoleId from UserRole]) {
            children = parentAndChildren.containsKey(ur.ParentRoleId) ? parentAndChildren.get(ur.ParentRoleId) : new set<Id>();
            children.add(ur.Id);
            parentAndChildren.put(ur.ParentRoleId, children);
        }*/
        List<UserRole> ur = [SELECT Id, ParentRoleId FROM UserRole];
        for(UserRole u : ur){
            children = parentAndChildren.containsKey(u.ParentRoleId) ? parentAndChildren.get(u.ParentRoleId) : new Set<Id>();
        }
        return getSubordinateRoles(roleID, parentAndChildren);
    }

    public static set<Id> getSubordinateRoles(Id roleId, map<Id, set<Id>> parentAndChildren) {
        set<Id> subordinateRoles = new set<Id>();
        set<Id> remainingSubordinateRoles = new set<Id>();
        if(parentAndChildren.containsKey(roleId)) {
            subordinateRoles.addAll(parentAndChildren.get(roleId));
            for(Id subRoleId : subordinateRoles) {
                remainingSubordinateRoles.addAll(getSubordinateRoles(subRoleId, parentAndChildren));
            }
        }
        subordinateRoles.addAll(remainingSubordinateRoles);
        return subordinateRoles;
    }
    
    
    @AuraEnabled
    public static String getCompanyName(){
        String comp = [select id,Name, companyName from User where id =: userInfo.getUserId()].companyName;
        return comp;
    }
	
    @AuraEnabled
    public static String getUserProfile(){
        String comp = [select id,profile.name, companyName from User where id =: userInfo.getUserId()].profile.name;
        return comp;
    }

    @AuraEnabled
    public static String getUserName(){

        String usename = [select Name from User where Id=:userInfo.getUserId()].Name;
        System.debug('User Name is '+usename);
        return usename;
    }
    
    @AuraEnabled
    public static String getCampaignName(Id campaignId){
        System.debug('XXX search campaign for id = ' + campaignId);
        Campaign c = [select name from Campaign where id =: campaignId];
        System.debug('campaign name IS ' + c.name);
        return c.name;
    }
    
    @AuraEnabled
    public static Account getAccount(String accId){
        //System.debug('call getAccount -' + accid);
        Account acc = [select id,hoya_account_id__c, name from Account where id =: accId];
        //System.debug('account IS ' + acc.Hoya_Account_ID__c);
        return acc;
    }

    @AuraEnabled
    public static List<Account_Campaing_Member__c> getAccCampaign(Id campaignId){
        return [select Id, Date_of_presentation__c, Campaign_Presented__c from Account_Campaing_Member__c where Central_Campaign__c=:campaignId];
    }

    /*
    @AuraEnabled
    public static Opportunity getOpportunityByAccountList(String accid){

        System.debug('call for opportunity Id-' + accid);
        Opportunity opp = [select id, name from Opportunity where AccountId =: accid];
        return opp;

    }
    */
    /*
    @future (callout=true)
    public static void getOpportunityStageList(){
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
        String restAPIURL = sfdcURL + '/services/data/v51.0/ui-api/object-info/Opportunity/picklist-values/0120X000000oghYQAQ/StageName';
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        httpRequest.setEndpoint(restAPIURL);
        httpRequest.setTimeout(20000);
        System.debug(restAPIURL);
        String response = '';
        oppOptions = new List<SelectOption>();
        try {
                 Http http = new Http();
                 HttpResponse httpResponse = http.send(httpRequest);
                 if (httpResponse.getStatusCode() == 200 ) {
                    JSONParser parser = JSON.createParser(JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) ));
                    while(parser.nextValue()!=null){
                        if('value' == parser.getCurrentName()){
                            
                            System.debug('parser.getCurrentName()='+parser.getCurrentName()+','  + parser.getText());
                            oppOptions.add(new SelectOption(parser.getText(),parser.getText()));
                        }
                    }

                 } else {
                       System.debug(' httpResponse ' + httpResponse.getBody() );
                       throw new CalloutException( httpResponse.getBody() );
                 } 
        } catch( System.Exception e) {
                 System.debug('ERROR: '+ e);
                 throw e;
        }
        //System.debug(' ** response ** : ' + response );
        
    }*/

    public static List<SelectOption> oppOptions;
    /*
    public static List<SelectOption> getOpportunityStageName(){
        getOpportunityStageList();
        Integer start = System.Now().millisecond();
        //while(System.Now().millisecond()< start+30) {
        //}
        while(oppOptions==null){
            
        }
        System.debug('option size' + oppOptions.size());
        for(SelectOption option: oppOptions){
            System.debug(option.getValue());
        }
        return oppOptions;
    }*/

    @AuraEnabled
    public static Account getAccountByOpportunity(String oppid){
        System.debug('call getAccountByOpportunity -' + oppid);
        String accId = [select id,AccountId, Name from Opportunity where id =: oppid].AccountId;

        Account a = [select id, hoya_account_id__c, ownerid from account where id=:accId];
        System.debug('account IS ' + accId);
        return a;
    }

        /*
    @AuraEnabled
    public static List<Account> getAccountsMap(){
        List<Account> result = new List<Account>();

        for(Account a : [select Id, Name, Hoya_Account_Id__c, shippingStreet, shippingPostalCode, shippingCity, shippingState, shippingCountry, shippingLatitude, 
                            shippingLongitude from Account order by Name asc limit 20])
        {
            
            result.add(a);
            System.debug('XXX Account name is '+a.Name);
            Double latitude = a.shippingLatitude;
            Double longitude = a.shippingLongitude;
            System.debug('XXX Latitude is '+latitude+' and Longtitude is '+longitude);

            //test for database query
            String soql = 'select Id, Name, Hoya_Account_Id__c, shippingStreet, shippingPostalCode, shippingCity, shippingState, shippingCountry, shippingLatitude, shippingLongitude from Account where Id=\''+a.Id+'\'';
            System.debug('XXX SOQL Id is '+soql);
            List<Account> aList = database.Query(soql);
            result.addAll(aList);

        }
        
        System.debug('Found Account : '+result.size());
        return result;
        
    }
    */
    /*
    @AuraEnabled
    public static void startVisit(Id visitId, Double latitude, Double longitude){
        try {
            System.debug('startVisit(' + visitId +','+latitude + ','+longitude+')');
            Visits__c v=new Visits__c();
            v.id = visitId;
            v.Start_location_time__c = System.Now();
            v.Start_Location_Latitude__c = latitude;
            v.Start_Location_Longitude__c = longitude;
            update v;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void stopVisit(Id visitId, Double latitude, Double longitude){
        try {
            System.debug('stopVisit(' + visitId +','+latitude + ','+longitude+')');
            Visits__c v=new Visits__c();
            v.id = visitId;
            v.Stop_location_time__c = System.Now();
            v.Stop_Location_Latitude__c = latitude;
            v.Stop_Location_Longitude__c = longitude;
            update v;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    */
}