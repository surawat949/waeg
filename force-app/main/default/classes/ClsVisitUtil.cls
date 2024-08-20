/**
 *  Contains a set of static methods used in synchronization between Visits__c and Event
 *
 @author    Peng Zhu
 @created   2013-03-26
 @version   1.0
 @since     25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-04-15 Yud Zheng <yuda.zheng@itbconsult.com>
 * - add function getWeekendDays to get weekend days in the specified date of Month
 * - add function isWeekend to check if the specified date is weekend
 * - add function getCompletedVisits to get the completed visits whose end time is in the month of given date 
 * - add public map map_Month
 * 2013-04-30 Yud Zheng <yuda.zheng@itbconsult.com>
 * - add function createOrDeleteVisitTask to create or delete Visit_Task__c
 * - add function getVisitTask to get Visit_Task__c
 * 2013-03-26 Peng Zhu <peng.zhu@itbconsult.com>
 * - Created
 */
public without sharing class ClsVisitUtil {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    public static final String MODE_INSERT = 'INSERT';
    public static final String MODE_UPDATE = 'UPDATE';
    public static final String MODE_DELETE = 'DELETE';
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   /**
    * map to holds standard fields of event => fields of visit for synchronization
    */
    private static final map<String, String> map_eFields_vFields = new map<String, String>{
        'Status__c'         => 'Visit_Status__c',
        //'Type__c'           => 'Visit_Type__c',
        'IsAllDayEvent'     => 'Is_All_Day_Event__c',
        'OwnerId'           => 'Assigned_to__c',
        //'CreatedById'         => 'CreatedById',
        //'ActivityDate'        => 'Visit_Date__c',
        'Description'       => 'Visit_Notes__c',
        //'DurationInMinutes' => 'Duration_Minutes__c',
        //'Email'           => 'Email__c',
        'EndDateTime'       => 'End_Time__c',
        //'LastModifiedById'    => 'LastModifiedById',
        //'Location'            => '',
        'WhoId'             => 'Contact__c',
        //'Phone'           => 'Phone__c',
        //'IsPrivate'       => '',
        'WhatId'            => 'Account__c',
        'ShowAs'            => 'Show_time_as__c',
        'StartDateTime'     => 'Start_Time__c',
        'Subject'           => 'Visit_Reason__c'
        //'ActivityDateTime'    => '',
        //'Type'                => 'Visit_Type__c'
        
    };
    
    public static final map<String, String> map_Month = new map<String, String>{
        '1'         => 'January',
        '2'         => 'February',
        '3'         => 'March',
        '4'         => 'April',
        '5'         => 'May',
        '6'         => 'June',
        '7'         => 'July',
        '8'         => 'August',
        '9'         => 'September',
        '10'        => 'October',
        '11'        => 'November',
        '12'        => 'December'
    };
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to calculate Start_Date_Time__c and End_Date_Time__c for Visits__c
    *
    @author  Peng Zhu
    @created 2013-03-28
    */ 
    public static Datetime calculateDateTimeValue(Date d, String str) {
        Integer year = d.year();
        Integer month = d.month();
        Integer day = d.day();
        Integer hour = Integer.valueOf(str.substring(0, 2));
        Integer minute = Integer.valueOf(str.substring(3, 5));
        Integer second = 0;
        
        Datetime returnValue = Datetime.newInstance(year, month, day, hour, minute, second);
        return returnValue;
    }
    
   
   /**
    * This method is used to calculate visit
    *
    @author  Peng Zhu
    @created 2013-03-28
    */    
    public static void calculateTriggerOnVisit(String mode , list<Visits__c> visitNew , list<Visits__c> visitOld) {
        // TODO: Code below not required as its just inserting new events for each visit.
        //FIXME: Check for HVNA if they really need event records per visit
        Boolean IsInsert = false;        
        if(mode == MODE_INSERT) {
            // Added by Tangyong Li on the Jun. 2nd 2016.
            map<Id, Account> map_accId_account = fetchAccountMap(visitNew); // Get all accounts of event.
            
            map<Id, Event> map_vId_event = new map<Id, Event>();
            
            String companyName = [SELECT companyName FROM User where id=:UserInfo.getUserId()].companyName;
            for(Visits__c v : visitNew) {
                Event e = new Event();
                e.Visit_Id__c = v.Id;
                e.visit__c = v.Id;
                e.WhatId = v.Account__c; //SSU Added - 2021/08/21 | For first created in Visits__c and associated with RelatedTo (WhatId) field in Event object.
                e.ownerId = v.assigned_to__c;

                map_vId_event.put(v.Id, syncEventFromVisit(e, v, false, map_accId_account, companyName));
            }
            if(!map_vId_event.isEmpty()) {
                System.debug(map_vId_Event.values());
                insert map_vId_Event.values();
                list<Visits__c> list_update = new list<Visits__c>();
                for(Visits__c v: [select id, Activity_Id__c, Start_Time__c, End_Time__c, Original_End_Plan__c, Original_Start_Plan__c from Visits__c where id in: map_vId_event.keySet()]) {
                    if(v.Activity_Id__c == null || v.Activity_Id__c != map_vId_event.get(v.id).id){
                        v.Activity_Id__c = map_vId_event.get(v.id).id;
                        list_update.add(v);
                    }
                }
                update list_update;
            }
        }
        // TODO: Code below not required as its just inserting new events for each visit.
        //FIXME: Check for HVNA if they really need event records per visit  
        else if(mode == MODE_UPDATE) {
            map<id, Visits__c> map_eId_visit = new map<id, Visits__c>();
            for(Visits__c v : visitNew)
            {
                map_eId_visit.put(v.Activity_Id__c, v);
            }
            map<id, Event> map_eId_event = fetchEventMap(map_eId_visit.keySet());
            // Added by Tangyong Li on the Jun. 2nd 2016.
            map<Id, Account> map_accId_account = fetchAccountMap(visitNew);// Get all accounts of event.
            
            list<Event> list_update = new list<Event>();
            
            String companyName = [SELECT companyName FROM User where id=:UserInfo.getUserId()].companyName;
            for(id eId : map_eId_event.keySet()) {
                list_update.add(syncEventFromVisit(map_eId_event.get(eId), map_eId_visit.get(eId), true, map_accId_account, companyName));
            }
            System.debug(list_update);
            update list_update;
        }
        
        else if(mode == MODE_DELETE) {
        }
    }

    /**
    * methode to fetch Visit Report records with fields to synchroize with Event
    *
    @author  Yuda Zheng
    @created 2013-07-30
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param      set_vpIds           Id of Visit
    *
    @return     Visits__c map
    *
    @changelog
    * 2013-07-30 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */  
    // TODO:  This method needs to be removed. Used in event insert / update sync to Visits
    public static map<id, Visits__c> fetchVisitMap(set<id> set_vpIds) {
        map<id, Visits__c> map_vpId_vp = new map<id, Visits__c>();
        set<String> set_vpFields = new set<String>();
        set_vpFields.addAll(map_eFields_vFields.values());
        String query = 'select Id, ' + concatFieldsForQuery(set_vpFields)  + ' from Visits__c where Id in ' +  concatIdsForQueryIn(set_vpIds); //+ ', OwnerId '
        list<Visits__c> list_found = Database.query(query);
        if(list_found != null && !list_found.isEmpty()) {
            for(Visits__c v : list_found) {
                map_vpId_vp.put(v.Id, v);
            }
        }       
        return map_vpId_vp;
    }
    
    /**
    * methode to synchronize a Visit with an Event
    *
    @author  Yuda Zheng
    @created 2013-07-30
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param      event           Event
    @param      visit           Visits__c
    @param      isUpdate        Boolean
    *
    @return     Visits__c
    *
    @changelog
    * 2013-07-30 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */  
    // TODO:  This method needs to be removed. Used for Event update/insert sync to Visit
    public static Visits__c syncVisitFromEvent(Event event, Visits__c v, Boolean isUpdate) {
        for(String key : map_eFields_vFields.keySet()) {
            if(!(isUpdate && key == 'WhatId') && event.get(key) != null && key != 'Subject') {
                v.put(map_eFields_vFields.get(key), event.get(key));
            }
            
            if(!isUpdate) v.Visit_Status__c = 'Planned';
            if(v.Visit_Status__c == null) v.Visit_Status__c = 'Planned';
            
        }
        return v;       
    }
    
    /**
    * This method is used to calculate Event
    *
    @author  Yuda Zheng
    @created 2013-07-30
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   mode           insert, update or delete
    @param   eventNew       list of new Event
    @param   eventOld       list of old Event
    *
    @return  void
    *
    @changelog
    * 2013-07-30 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */   
    // TODO: Below method call can be removed while cleanup. We dont want to update visits anymore based on event update
    public static void calculateTriggerOnEvent(String mode , list<Event> eventNew , list<Event> eventOld) {
        if(mode == MODE_INSERT) {
            map<Id, Visits__c> map_eId_Visit = new map<Id, Visits__c>();
            for(Event e : eventNew) {
                if(e.RecordTypeId != '0120X0000001ENSQA2'){
                    //CDU 2020/02/11, Exclude HVNA event record type
                    Visits__c v = new Visits__c();
                    v.Activity_Id__c = e.Id;
                    /* CDU 07/09/2017: add init on MKT_No_campaign_presented__c, required since 07/2017 */
                    /* 12/03/2018: new calendar dev: inactivate default no_campaign presented on visit */
                    //v.MKT_No_campaign_presented__c=true;
                    map_eId_Visit.put(e.Id, syncVisitFromEvent(e, v, false));
                }
            }
            if(!map_eId_Visit.isEmpty()) {
                insert map_eId_Visit.values();
                list<Event> list_update = new list<Event>();
                for(Event e: [select id, Visit_Id__c from Event where id in: map_eId_Visit.keySet()]) {
                    if(e.Visit_Id__c == null || e.Visit_Id__c != map_eId_Visit.get(e.Id).Id){
                        e.Visit_Id__c = map_eId_Visit.get(e.Id).Id;
                        list_update.add(e);
                    }
                }
                update list_update;
            }
        }
            
        else if(mode == MODE_UPDATE) {
            map<id, Event> map_vId_event = new map<id, Event>();
            for(Event e : eventNew)
            {   
                if(e.Visit_Id__c != null){
                    map_vId_event.put(e.Visit_Id__c, e);
                }
            }
            
            if(!map_vId_event.isEmpty())
            {
                map<id, Visits__c> map_vId_visit = fetchVisitMap(map_vId_event.keySet());
                
                list<Visits__c> list_update = new list<Visits__c>();
                for(id vId : map_vId_visit.keySet()) {
                    list_update.add(syncVisitFromEvent(map_vId_event.get(vId), map_vId_visit.get(vId), true));
                }
                update list_update;
            }
        }
    }
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
   /**
    * This method is used to synchronize an Event with a Visit 
    *
    @author  Peng Zhu
    @created 2013-03-28
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   mode           insert, update or delete
    @param   eventNew       list of new Event
    @param   eventOld       list of old Event
    *
    @return  void
    *
    @changelog
    * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
    * - Created
    */ 
    // TODO: This complete method needs to be removed as its just trying to create or update an event on visit ins/upd
    // FIXME: Check for HVNA stuff with country if they really need event records
    public static Event syncEventFromVisit(Event e, Visits__c v, Boolean isUpdate, map<Id, Account> map_accId_account, String companyName) {
        
        boolean isApac = ToolBox.isApac(companyName);

        for(String key : map_eFields_vFields.keySet()) {
            // FIXME: Remove below what id and add subject here
            if(!(isUpdate && key == 'WhatId') && v.get(map_eFields_vFields.get(key)) != null) {
                // executed always for Insert + for update only executed for subject technically
                // Added by Tangyong Li on the Jun. 2nd 2016.
                if(key == 'Subject' && companyName!='HLSI' && companyName!='HLSH' && companyName!='HOLA' && companyName!='HLCA' && companyName!='VEUS'){
                    // Update event subject for non apac to: hoya acc Id , name , <Actual subj>, Street , City
                    e.put(key, Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                               //map_accId_account.get(v.Account__c).shop_name__c + ', ' +
                               Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +  v.get(map_eFields_vFields.get(key)) + ', ' +
                               Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).Shop_Street__c) + ',' +Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c)  
                               );
                
                } else if(key == 'Subject' && isApac) {
                    //CDU HLSI_Visit_Objective2__c multiple picklist, value is not accessible (don't know exactly why)
                    //replace by static word: HLSI Reason
                    // Update event subject for apac to: hoya acc Id , name , City+ Visit APAC Objective
                    e.put('subject', Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                               Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +
                               Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c) 
                               //+ ', HLSI Reason' /*+ v.get('HLSI_Visit_Objective2__c')*/
                               + Toolbox.stripToEmpty(v.Visit_Reason_APAC__c)
                               );
                }     
            }else{ 
                if(key == 'Subject' && (companyName=='HOLA' || companyName=='HLCA'|| companyName=='VEUS')) {
                     e.put('subject', Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                           Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +
                           Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c) 
                           //+ ', ' + Toolbox.stripToEmpty(v.HVNA_Visit_Objective__c)
                           );
                            e.HOLA_Appointment__c = v.HVNA_Appointment__c;
                            e.HOLA_Customer_Goal__c = v.HVNA_Customer_Goal__c;
                            //e.HOLA_Appointment__c = v.HVNA_Customer_Goal__c;
                            e.HOLA_Call_Objectives__c = v.HVNA_Visit_Objective__c;
                            e.HOLA_Activity_Type__c = v.HVNA_Visit_Type__c;
                            e.Secondary_Call_Objective__c = v.Secondary_Tactic__c;
                } else if(key == 'Subject' && isApac) {
                    // FIXME: Not required IMO
                    e.put('subject', Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                           Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +
                           Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c) 
                           + ', ' + Toolbox.stripToEmpty(v.Visit_Reason_APAC__c)
                           );

                } else if (key=='Subject'){
                    // FIXME: Not required IMO
                    //CDU 27/07/2020 seems missing for HAPL. probably some other countries
                    e.put('subject',Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                    //map_accId_account.get(v.Account__c).shop_name__c + ', ' +
                    Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +
                    Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).Shop_Street__c) + ', ' +
                    Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c));
                } else {
                    String value=map_eFields_vFields.get(key);
                    if(value==null || value==''){
                        value = ' '; 
                    }
                    e.put(key, v.get(value));
                }
            }
        }
        
        e.ActivityDateTime = v.Start_Time__c;
        e.StartDateTime = v.Start_Time__c;
        e.EndDateTime = v.End_Time__c;
        e.Status__c = v.Visit_Status__c;
        e.description = v.visit_notes__c;

        if((companyName=='HOLA' || companyName=='HLCA')){
            e.HOLA_Time_of_Log__c = v.Start_Time__c;
            //CDU 14/06/2021 - HVNA user have what id not initialized on event creation, -> force it here
            e.WhatId=v.Account__c;
            e.Type = v.HVNA_Visit_Type__c; //SSU 2021/08/04 Amend field api to Type (fieldname : Type - Event) cause Leigh Ann working on this field.
            //e.Type__c = v.HVNA_Visit_Type__c;
        }
        if(v.Is_All_Day_Event__c==true){
            e.DurationInMinutes=null;
        } else {
            if(v.End_Time__c!=null && v.Start_Time__c!=null) {
                long duration  = (v.End_Time__c.getTime()-v.Start_Time__c.getTime())/60000;
                e.DurationInMinutes=duration.intValue();
            } else {
                e.DurationInMinutes = 60;
            }
        }
        e.visit__c = v.id;
        if(v.Assigned_to__c!=null){
            e.ownerId = v.Assigned_to__c;
        }
        return e;       
    }
    
   /**
    * This method is used to fetch Account for update subject of event
    *
    * @author  Qiang Liu
    * @created 2016-06-02
    * @version 1.0
    * @since   25.0 (Force.com ApiVersion)
    *
    * @param   list_visits     
    *
    * @return  map_accId_account     
    *
    * @changelog
    * 2016-06-02 Qiang Liu <qiang.liu@itbconsult.com>
    * - Created
    */
    public static map<Id, Account> fetchAccountMap(list<Visits__c> list_visits){
        //map to store AcoountId and Account 
        map<Id, Account> map_accId_account = new map<Id, Account>();
        //set to store accountId from Visits__c
        set<Id> set_accIds = new set<Id>();
        for(Visits__c visit : list_visits){
            set_accIds.add(visit.Account__c);
        }
        for(Account acct : [SELECT hoya_account_id__c, shop_name__c, shop_city__c, Shop_Street__c,name
                            FROM Account
                            WHERE Id in : set_accIds]){
            map_accId_account.put(acct.Id, acct);
        }
        return map_accId_account;
    }
    
   /**
    * This method is used to synchronize Events from Account update
    *
    * @author  Qiang Liu
    * @created 2016-06-03
    * @version 1.0
    * @since   25.0 (Force.com ApiVersion)
    *
    * @param   list_accts
    *
    * @changelog
    * 2016-06-03 Qiang Liu <qiang.liu@itbconsult.com>
    * - Created
    */
    public static void syncEventFromAccount(list<Account> list_accts){
        //map to store Account Id and Account
        map<Id, Account> map_accId_account = new map<Id, Account>();
        for(Account acct : list_accts){
            map_accId_account.put(acct.Id, acct);
        }
        //map to store Event Id and Visit
        map<id, Visits__c> map_eId_visit = new map<id, Visits__c>();
        for(Visits__c v : [SELECT Activity_Id__c, Visit_Reason__c 
                           FROM Visits__c 
                           WHERE Account__c in : map_accId_account.keySet()]){
            if(v.Activity_Id__c != null){
                map_eId_visit.put(v.Activity_Id__c, v);
            }
        }
        if(map_accId_account.size() == 0) {
            return;
        }
        System.debug('===== map_eId_visit=' + map_eId_visit);
        //list to store Events have to synchronize from the Accounts After update
        list<Event> list_Events = new list<Event>();
        for(Event e : [SELECT Subject, AccountId, Visit_Id__c 
                       FROM Event 
                       WHERE AccountId in : map_accId_account.keySet() and RecurrenceActivityId = null]){
            String hoya_account_id = map_accId_account.get(e.AccountId).hoya_account_id__c == null ? '' : map_accId_account.get(e.AccountId).hoya_account_id__c;
            //String shop_name = map_accId_account.get(e.AccountId).shop_name__c == null ? '' : map_accId_account.get(e.AccountId).shop_name__c;
            String shop_name = map_accId_account.get(e.AccountId).name == null ? '' : map_accId_account.get(e.AccountId).name;
            String shop_city = map_accId_account.get(e.AccountId).shop_city__c == null ? '' : map_accId_account.get(e.AccountId).shop_city__c;
            String Visit_Reason = map_eId_visit.get(e.Id) == null || map_eId_visit.get(e.Id).Visit_Reason__c == null ? '' : map_eId_visit.get(e.Id).Visit_Reason__c;
            e.Subject = Toolbox.stripToEmpty(hoya_account_id) + ', ' +
                        Toolbox.stripToEmpty(shop_name) + ', ' +
                        Toolbox.stripToEmpty(shop_city) + ', ' +
                        Toolbox.stripToEmpty(Visit_Reason);
            list_Events.add(e);
        }
        System.debug('===== list_Events=' + list_Events);
        if(list_Events.size() > 0) {
            update list_Events;
        }
    }
    
   /**
    * This method is used to concat fields (String) for query. return field1,field2,field3...
    *
    @author  Peng Zhu
    @created 2013-03-28
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   set_fields     
    *
    @return  output     
    *
    @changelog
    * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
    * - Created
    */ 
    public static String concatFieldsForQuery(set<String> set_fields){
        if(set_fields == null || set_fields.isEmpty()) return '';
        String output = '';
        for(String s : set_fields) {
            if(s != null && s.trim() != '') output += s + ', ';
        }
        if(output.endsWith(', ')) output = output.substring(0, output.length() - 2);
        return output;
    }
    
   /**
    * This method is used to concat Strings for query. return ('...', '...', ...), also for Ids
    *
    @author  Peng Zhu
    @created 2013-03-28
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   set_fields     
    *
    @return  output     
    *
    @changelog
    * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
    * - Created
    */  
    public static String concatIdsForQueryIn(set<id> set_ids){
        if(set_ids == null || set_ids.isEmpty()) return '(\'\')';
        String output = '(';
        for(String s : set_ids) {
            if(s != null && s.trim() != '') output += '\'' + s + '\'' + ', ';
        }
        if(output.endsWith(', ')) output = output.substring(0, output.length() - 2);
        output += ')';
        if(output == '()') output = '(\'\')'; 
        return output;
    }
       
   /**
    * This method is used to fetch Event records with fields to synchroize with Visit
    *
    @author  Peng Zhu
    @created 2013-03-28
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   set_fields     
    *
    @return  output     
    *
    @changelog
    * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
    * - Created
    */  
    public static map<id, Event> fetchEventMap(set<id> set_eventIds) {
        map<id, Event> map_EventId_Event = new map<id, Event>();
        String query = 'select Id, ' + concatFieldsForQuery(map_eFields_vFields.keySet()) + ' from Event where Id in ' +  concatIdsForQueryIn(set_eventIds);
        System.debug('query string is '+query);
        list<Event> list_found = Database.query(query);
        if(list_found != null && !list_found.isEmpty()) {
            for(Event e : list_found) {
                map_EventId_Event.put(e.Id, e);
            }
        }       
        return map_EventId_Event;
    }

    /**
    * This method is get weekend days in the specified date of Month
    *
    @author  Yuda Zheng
    @created 2013-04-14
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param          Date specified date
    *
    @return         Integer weekend days
    *
    *
    @changelog
    * 2013-04-14 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static Integer getWeekendDays(Date currentDate) {
        Integer weekendDays = 0;
        DateTime startDateInMonth = (DateTime)currentDate.toStartOfMonth();
        DateTime endDateInMonth = (DateTime)startDateInMonth.addDays(Date.daysInMonth(currentDate.year(), currentDate.month()));
        
        while(startDateInMonth < endDateInMonth){
            if (isWeekend(startDateInMonth)){
                weekendDays += 1;
            }
            startDateInMonth = startDateInMonth.addDays(1);
        }

        return weekendDays;
    }
    
    /**
    * This method is check if the specified date is weekend
    *
    @author  Yuda Zheng
    @created 2013-04-14
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param          DateTime specified date time
    *
    @return         Boolean ture:is weekend, false:is not weekend
    *
    *
    @changelog
    * 2013-04-14 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static Boolean isWeekend(DateTime currentDate) {
        if (currentDate.format('E') == 'Sat' || currentDate.format('E') == 'Sun'){
            return true;
        }
        return false;
    }
    
    /**
    * This method is get the completed visits whose end time is in the month of given date 
    *
    @author  Yuda Zheng
    @created 2013-04-15
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param          Date specified date
    @param          Set<Id>  Ids of user who complete the visit
    *
    @return         List<Visits__c> list of Visits__c
    *
    *
    @changelog
    * 2013-04-15 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static List<Visits__c> getCompletedVisits(Date currentDate, Set<Id> set_userId) {
        List<Visits__c> list_Visits = new List<Visits__c>();
        DateTime startDateInMonth = (DateTime)currentDate.toStartOfMonth();
        DateTime endDateInMonth = (DateTime)startDateInMonth.addDays(Date.daysInMonth(currentDate.year(), currentDate.month()));
        
        for(Visits__c visit : [select Id, End_Time__c, Assigned_to__c from Visits__c where Assigned_to__c in: set_userId and Visit_Status__c = 'Complete' and End_Time__c >=: startDateInMonth and  End_Time__c <=: endDateInMonth]) {
            list_Visits.add(visit);
        }
        
        return list_Visits;
    }
    
    /**
    * This method is get the date of first visits which is not calculated by Visit KPI
    *
    @author  Yuda Zheng
    @created 2013-05-22
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    *
    @return         Date        End_Time__c of Visits__c
    *
    *
    @changelog
    * 2013-05-22 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static Date getFirstUnCalculatedVisitDate() {
        //End_Time__c of Visits__c
        Date visitEndTime = null;
        
        //get the earliest Visits__c
        for(Visits__c visit : [select Id, End_Time__c from Visits__c order by End_Time__c asc limit 1]) {
            if(visit.End_Time__c !=null){
                visitEndTime = Date.newinstance(visit.End_Time__c.year(), visit.End_Time__c.month(), visit.End_Time__c.day());
            }
        }
        
        //check if there is a Visit KPI in the month of End_Time__c
        if(visitEndTime !=null && checkVisitKPIExists(visitEndTime)){
            return null;
        }
        
        return visitEndTime;
    }
    
    /**
    * This method is check if there is a Visit KPI in the month of given date
    *
    @author  Yuda Zheng
    @created 2013-05-22
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param          Date     specified Date
    *
    @return         Boolean      true: exists/false: not exists
    *
    *
    @changelog
    * 2013-05-22 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static Boolean checkVisitKPIExists(Date visitEndTime) {
        //if Visit KPI exists
        Boolean isExists = false;
        //start month of Visit__c End_Time__c
        Date startVisitKPIDate = visitEndTime.toStartOfMonth();
        //End month of Visit__c End_Time__c
        Date endVisitKPIDate = startVisitKPIDate.addMonths(1);
        
        //get Visit KPI between startVisitKPIDate and endVisitKPIDate
        if(VisitKPI_Settings__c.getInstance('RunWithHistoryData') !=null && VisitKPI_Settings__c.getInstance('RunWithHistoryData').isActive__c){
            isExists = false;
        }else {
            for(VISIT_KPI__c visitKPI : [select Id, Date__c from VISIT_KPI__c where Date__c >=: startVisitKPIDate and Date__c <: endVisitKPIDate limit 1]){
                isExists = true;
            }
        }
        return isExists;
    }

    public static void updateContactRecords(Set<Id> conIdSet) {
        Map<Id, Visits__c> conToVisitMap = new Map<Id, Visits__c>();
        List<Visits__c> visitsList = [Select Id, Contact__c, Start_Time__c, End_Time__c,Visit_Status__c From Visits__c Where Contact__c IN :conIdSet AND Visit_Status__c = 'Complete' AND visit_Type__c = 'Visit' AND Visited_but_not_seen__c = False];
        // above queried record will not have records being processed through trigger in current transaction hence below line.
        for (Visits__c eachVisit : visitsList) {
            if (eachVisit.contact__c != null) {
                if (conToVisitMap.get(eachVisit.contact__c) == null) {
                    conToVisitMap.put(eachVisit.contact__c, eachVisit);
                } else {
                    if (eachVisit.Start_Time__c > conToVisitMap.get(eachVisit.contact__c).Start_Time__c) {
                        conToVisitMap.put(eachVisit.contact__c, eachVisit);
                    }
                }
            }
        }
        List<Contact> updateList = new List<Contact>();
        for (Id eachId : conToVisitMap.keySet()) {
            Contact con = new Contact(Id = eachId);
            Datetime dT = conToVisitMap.get(eachId).Start_Time__c;
            con.Last_contact_visit_date__c = date.newinstance(dT.year(), dT.month(), dT.day());
            updateList.add(con);
        }
        if (!updateList.isEmpty()) {
            update updateList;
        }

    }
     
     

    //********************************* -=END private methods=- ***********************************
    
}