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
        'Type__c'           => 'Visit_Type__c',
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
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   d          insert, update or delete
    @param   str        list of new Event
    *
    @return  void
    *
    @changelog
    * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
    * - Created
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
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param   d          insert, update or delete
    @param   str        list of new Event
    *
    @return  void
    *
    @changelog
    * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
    * - Created
    */    
    public static void calculateTriggerOnVisit(String mode , list<Visits__c> visitNew , list<Visits__c> visitOld) {
        if(mode == MODE_INSERT) {
            User currentuser = [Select u.Profile.Name, u.ProfileId From User u where Id = :UserInfo.getUserId()];
            if(currentuser.Profile.Name == 'System Administrator') {
                //return;
            }
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
            /*set<Id> set_eId = new set<Id>();
            for(Visits__c v : visitOld) {
                set_eId.add(v.Activity_Id__c);
            }
            
            list<Event> list_delete = [Select Id, Visit_Id__c from Event where id in: set_eId];
            delete list_delete;*/
        }
    }

    /**
    * This static method is used to create or delete Visit_Task__c 
    *
    @author  Yuda Zheng
    @created 2013-04-30
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param      mode            String value of insert or update
    @param      visits          List of Visit_Task__c
    *
    @changelog
    * 2013-04-30 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */    
    public static void createOrDeleteVisitTask(list<Visits__c> visits, String mode){
        list<Visit_Task__c> createVisitTasks;
        list<Visit_Task__c> deleteVisitTasks;
         
        // start added by Jian Yin <jian.yin@itbconsult.com> 2013-08-26
        set<Id> set_visitAcctIds = new set<Id>();
        map<Id, Visits__c> map_vId_visits = new map<Id, Visits__c>();
        for(Visits__c v : visits){
            if(!map_vId_visits.containsKey(v.Id)){
                map_vId_visits.put(v.Id, v);
                set_visitAcctIds.add(v.Account__c);
            }
        }
        
        list<Task> tasks = new list<Task>();
        if(set_visitAcctIds.size() > 0){
            tasks = [select Id, WhatId, ActivityDate, Subject, Promtion_Group_Task_ID__c from Task where WhatId in :set_visitAcctIds ];
        }
        
        map<Visits__c, list<Task>> map_visits_listTask = new map<Visits__c, list<Task>>();
        //Begin added by Lei Tang 2016-06-07 fix query more 101 
        set<String> set_visitids = new set<String>();
        set<String> set_taskids = new set<String>();
        //End added by Lei Tang 2016-06-07 fix query more 101 
        for(Id id : map_vId_visits.keySet()){
            list<Task> list_task = new list<Task>();
            for(Task t : tasks){
                if(map_vId_visits.get(id).Account__c == t.WhatId){
                    list_task.add(t);
                    // added by Lei Tang 2016-06-07 fix query more 101 
                    set_taskids.add(String.valueOf(t.Id).substring(0,15));
                }
            }
            if(!map_visits_listTask.containsKey(map_vId_visits.get(id))){
                map_visits_listTask.put(map_vId_visits.get(id), list_task);
            }
            // added by Lei Tang 2016-06-07 fix query more 101 
            set_visitids.add(map_vId_visits.get(id).Id);
        }
        
        //added by Lei Tang 2016-06-07 fix query more 101 
        map<String, Visit_Task__c> map_key_VisitTask = getVisitTaskNew(set_visitids, set_taskids);
        system.debug('!@# map_key_VisitTask :'+map_key_VisitTask);
        if(map_visits_listTask!=null){
            for(Visits__c visit : map_visits_listTask.keySet()){
                if(!map_visits_listTask.get(visit).isEmpty()){
                    for(Task task : map_visits_listTask.get(visit)){
                        Visit_Task__c visitTask;
                        //check if start time of Visit is before due date of Task and Promtion_Group_Task_ID is not empty
                        if(task.Promtion_Group_Task_ID__c != null && task.Promtion_Group_Task_ID__c.trim() != '' && visit.Start_Time__c < task.ActivityDate){
                            //create new Visit_Task__c when create new visit or update visit if the Visit_Task__c doesn't exist
                            
                            //changed by Lei Tang 2016-06-07 fix query more 101 
                            //if(mode == MODE_INSERT || getVisitTask(visit.Id, task.Id) == null){
                            Visit_Task__c oldvisitTask = null;
                            if(map_key_VisitTask.get(visit.Id+';'+String.valueOf(task.Id).substring(0,15)) != null) {
                                oldvisitTask = map_key_VisitTask.get(visit.Id+';'+String.valueOf(task.Id).substring(0,15));
                            }
                            if(mode == MODE_INSERT || oldvisitTask == null){
                                //create new Visit_Task__c
                                visitTask = new Visit_Task__c();
                                //set hyperlink
                                String hyperlink = URL.getSalesforceBaseUrl().toExternalForm();
                                hyperlink = hyperlink.replace('-api', '') + '/' + String.valueOf(task.Id).substring(0,15) + '?retURL=%2F' + String.valueOf(visit.Account__c).substring(0,15);
                                visitTask.Link_to_the_Task__c = hyperlink;      
                                //set Name to Subject of Task 
                                visitTask.Name=task.Subject;
                                //set Visit__c to Id of Visit__c
                                visitTask.Visit__c = visit.Id;
                                //create Visit_Task__c list for insert
                                if(createVisitTasks == null){
                                    createVisitTasks = new list<Visit_Task__c>();
                                }   
                                //add new Visit_Task__c to create list
                                createVisitTasks.add(visitTask);
                            }
                        }
                        else{
                            //delete Visit_Task__c when update visit if the Visit_Task__c exists
                            system.debug('!@# mode :'+mode);
                            if(mode == MODE_UPDATE){
                                //get Visit_Task__c by visitId and taskId
                                //changed by Lei Tang 2016-06-07 fix query more 101 
                                system.debug('!@# key :'+visit.Id+';'+String.valueOf(task.Id).substring(0,15));
                                if(map_key_VisitTask.get(visit.Id+';'+String.valueOf(task.Id).substring(0,15)) != null) {
                                    visitTask = map_key_VisitTask.get(visit.Id+';'+String.valueOf(task.Id).substring(0,15));
                                }
                                system.debug('!@# visitTask :'+visitTask);
                                //visitTask = getVisitTask(visit.Id, task.Id);
                                if(visitTask != null){
                                    //create Visit_Task__c list for delete
                                    if(deleteVisitTasks == null){
                                        deleteVisitTasks = new list<Visit_Task__c>();
                                    }
                                    //add Visit_Task__c to delete list
                                    deleteVisitTasks.add(visitTask);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //create Visit_Task__c
        if(createVisitTasks != null && createVisitTasks.size() > 0){
            insert createVisitTasks;
        }
        //delete Visit_Task__c
        if(deleteVisitTasks != null && deleteVisitTasks.size() > 0){
            // 22/11/2023: commenting this to avoid deletion of all visits/events and associated records.
            //delete deleteVisitTasks;    
        }
    }
    
    /*
    ***This method to create Visit APAC Task for render map (lightning map).***
        @author  Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
        @created 2022-05-02
        @version 1.0
        @since   49.0 (Force.com ApiVersion)
    *
        @param      apacList            Id of Visit_Task_APAC__c
        @param      v                   Id of Visits__c
    *
        @return     vListAPAC

    */
    
    public static void CreateVisitMapAPAC(List<Visits__c> newList){

        Set<Id> accSet = new Set<Id>();
        List<Visit_Task_APAC__c> vListAPAC = new List<Visit_Task_APAC__c>();

        for(Visits__c v : newList){
            accSet.add(v.Account__c);
        }

        for(Visits__c v : newList){
            if(v.Start_Location_Latitude__c!=null && v.Stop_Location_Latitude__c == null){

                Visit_Task_APAC__c apacList = new Visit_Task_APAC__c();
                apacList.Visit__c = v.Id;
                apacList.Account__c = v.Account__c;
                apacList.CurrencyIsoCode = v.CurrencyIsoCode;
                apacList.OwnerId = v.Assigned_to__c;
                apacList.Visit_Start_Type__c = 'START';
                apacList.Checked_Location_Time__c = v.Start_Time__c;
                apacList.Description__c = 'Created from Trigger | Start Location';
                apacList.Start_Location_Lattitude__c = v.Start_Location_Latitude__c;
                apacList.Start_Location_Longitude__c = v.Start_Location_Longitude__c;
                apacList.Visit_Notes__c = v.Visit_Notes__c;
                apacList.Visit_Reason__c = v.Visit_Reason_APAC__c;
                apacList.Visit_Reason_Global__c = v.Visit_Reason__c;
                apacList.Call_to_action_notes__c = v.Call_To_Action_Notes__c;
                apacList.Visit_Status__c = v.Visit_Status__c;
                apacList.Visit_Type__c = v.Visit_Type__c;

                vListAPAC.add(apacList);

            }else if(v.Start_Location_Latitude__c == null && v.Stop_Location_Latitude__c == null){

                Visit_Task_APAC__c apacList = new Visit_Task_APAC__c();
                apacList.Visit__c = v.Id;
                apacList.Account__c = v.Account__c;
                apacList.CurrencyIsoCode = v.CurrencyIsoCode;
                apacList.OwnerId = v.Assigned_to__c;
                apacList.Visit_Start_Type__c = 'SHOP';
                apacList.Checked_Location_Time__c = v.CreatedDate;
                apacList.Description__c = 'Created from Trigger | Start Location';
                apacList.Visit_Notes__c = v.Visit_Notes__c;
                apacList.Visit_Reason__c = v.Visit_Reason_APAC__c;
                apacList.Visit_Reason_Global__c = v.Visit_Reason__c;
                apacList.Call_to_action_notes__c = v.Call_To_Action_Notes__c;
                apacList.Visit_Status__c = v.Visit_Status__c;
                apacList.Visit_Type__c = v.Visit_Type__c;
                apacList.Shop_Street__c = v.Shop_Street__c;
                apacList.Shop_City__c = v.Shop_City__c;
                apacList.Shop_State__c = v.Shop_State__c;
                apacList.Shop_Country__c = v.Shop_Country__c;
                apacList.Start_Location_Lattitude__c = v.Shop_Latitude__c;
                apacList.Start_Location_Longitude__c = v.Shop_Longitude__c;

                vListAPAC.add(apacList);

            }else if(v.Stop_Location_Latitude__c!=null && v.Start_Location_Latitude__c != null){
                Visit_Task_APAC__c apacList = new Visit_Task_APAC__c();
                
                apacList.Visit__c = v.Id;
                apacList.Account__c = v.Account__c;
                apacList.CurrencyIsoCode = v.CurrencyIsoCode;
                apacList.OwnerId = v.Assigned_to__c;
                apacList.Visit_Start_Type__c = 'STOP';
                apacList.Checked_Location_Time__c = v.Start_Time__c;
                apacList.Description__c = 'Created from Trigger | Stop Location';
                apacList.Start_Location_Lattitude__c = v.Stop_Location_Latitude__c;
                apacList.Start_Location_Longitude__c = v.Stop_Location_Longitude__c;
                apacList.Visit_Notes__c = v.Visit_Notes__c;
                apacList.Visit_Reason__c = v.Visit_Reason_APAC__c;
                apacList.Visit_Reason_Global__c = v.Visit_Reason__c;
                apacList.Call_to_action_notes__c = v.Call_To_Action_Notes__c;
                apacList.Visit_Status__c = v.Visit_Status__c;
                apacList.Visit_Type__c = v.Visit_Type__c;

                vListAPAC.add(apacList);

            }else{
                //return nothing;
            }
            
        }
        if(vListAPAC.size()>0){insert vListAPAC;}
    }

    public static void updateVisitMapAPAC (List<Visits__c> newList, Map<Id, Visits__c> oldMap){
        Map<Id, Visits__c> visitIdToVisitMap = new Map<Id, Visits__c>();
        List<Visit_Task_APAC__c> vtpToInsert = new List<Visit_Task_APAC__c>();
        for(Visits__c v : newList){
            if(oldMap!=null){
                visitIdToVisitMap.put(v.Id, v);
            }
        }
        
        for(Visit_Task_APAC__c vtp : [SELECT Id, Name, Visit__c, Account__c, CurrencyIsoCode, OwnerId,
                                        Visit_Start_Type__c,  Checked_Location_Time__c,
                                        Description__c, Start_Location_Lattitude__c, 
                                        Start_Location_Longitude__c, Visit_Notes__c, Visit_Reason__c,
                                        Visit_Reason_Global__c, Call_to_action_notes__c,
                                        Visit_Status__c, Visit_Type__c
                                        FROM Visit_Task_APAC__c 
                                        WHERE Visit__c IN: visitIdToVisitMap.keySet() 
                                        ORDER BY Name DESC LIMIT 1])
        {
            Visit_Task_APAC__c vp = new Visit_Task_APAC__c();
            if(visitIdToVisitMap.containsKey(vtp.Visit__c)){
                //vp.Id = vtp.Id;
                if((visitIdToVisitMap.get(vtp.Visit__c).Start_Location_Latitude__c != null) && (visitIdToVisitMap.get(vtp.Visit__c).Stop_Location_Latitude__c==null)){
                    vp.Account__c = visitIdToVisitMap.get(vtp.Visit__c).Account__c;
                    vp.Visit__c = visitIdToVisitMap.get(vtp.Visit__c).Id;
                    vp.CurrencyIsoCode = visitIdToVisitMap.get(vtp.Visit__c).CurrencyIsoCode;
                    vp.OwnerId = visitIdToVisitMap.get(vtp.Visit__c).Assigned_to__c;
                    vp.Visit_Start_Type__c = 'START';
                    vp.Checked_Location_Time__c = visitIdToVisitMap.get(vtp.Visit__c).Start_Time__c;
                    vp.Description__c = 'Create from trigger | START Location';
                    vp.Start_Location_Lattitude__c = visitIdToVisitMap.get(vtp.Visit__c).Start_Location_Latitude__c;
                    vp.Start_Location_Longitude__c = visitIdToVisitMap.get(vtp.Visit__c).Start_Location_Longitude__c;
                    vp.Visit_Notes__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Notes__c;
                    vp.Visit_Reason__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Reason_APAC__c;
                    vp.Visit_Reason_Global__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Reason__c;
                    vp.Call_to_action_notes__c = visitIdToVisitMap.get(vtp.Visit__c).Call_To_Action_Notes__c;
                    vp.Visit_Status__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Status__c;
                    vp.Visit_Type__c = visitIdToVisitMap.get(vtp.Visit__c).visit_Type__c;
                    //vp.Call_to_action_notes__c = visitIdToVisitMap.get(vtp.Visit__c).Name;
                    vtpToInsert.add(vp);
                }else if((visitIdToVisitMap.get(vtp.Visit__c).Start_Location_Latitude__c == null) && (visitIdToVisitMap.get(vtp.Visit__c).Stop_Location_Latitude__c==null)){
                    vp.Account__c = visitIdToVisitMap.get(vtp.Visit__c).Account__c;
                    vp.Visit__c = visitIdToVisitMap.get(vtp.Visit__c).Id;
                    vp.CurrencyIsoCode = visitIdToVisitMap.get(vtp.Visit__c).CurrencyIsoCode;
                    vp.OwnerId = visitIdToVisitMap.get(vtp.Visit__c).Assigned_to__c;
                    vp.Visit_Start_Type__c = 'SHOP';
                    vp.Checked_Location_Time__c = visitIdToVisitMap.get(vtp.Visit__c).Start_Time__c;
                    vp.Description__c = 'Create from trigger | SHOP Location';
                    vp.Visit_Notes__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Notes__c;
                    vp.Visit_Reason__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Reason_APAC__c;
                    vp.Visit_Reason_Global__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Reason__c;
                    vp.Call_to_action_notes__c = visitIdToVisitMap.get(vtp.Visit__c).Call_To_Action_Notes__c;
                    vp.Visit_Status__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Status__c;
                    vp.Visit_Type__c = visitIdToVisitMap.get(vtp.Visit__c).visit_Type__c;
                    vp.Shop_Street__c = visitIdToVisitMap.get(vtp.Visit__c).Shop_Street__c;
                    vp.Shop_City__c = visitIdToVisitMap.get(vtp.Visit__c).Shop_City__c;
                    vp.Shop_State__c = visitIdToVisitMap.get(vtp.Visit__c).Shop_State__c;
                    vp.Shop_Country__c = visitIdToVisitMap.get(vtp.Visit__c).Shop_Country__c;
                    vp.Start_Location_Lattitude__c = visitIdToVisitMap.get(vtp.Visit__c).Shop_Latitude__c;
                    vp.Start_Location_Longitude__c = visitIdToVisitMap.get(vtp.Visit__c).Shop_Longitude__c;
                    //vp.Call_to_action_notes__c = visitIdToVisitMap.get(vtp.Visit__c).Name;
                    vtpToInsert.add(vp);
                }else if((visitIdToVisitMap.get(vtp.Visit__c).Start_Location_Latitude__c != null) && (visitIdToVisitMap.get(vtp.Visit__c).Stop_Location_Latitude__c!=null)){
                    vp.Account__c = visitIdToVisitMap.get(vtp.Visit__c).Account__c;
                    vp.Visit__c = visitIdToVisitMap.get(vtp.Visit__c).Id;
                    vp.CurrencyIsoCode = visitIdToVisitMap.get(vtp.Visit__c).CurrencyIsoCode;
                    vp.OwnerId = visitIdToVisitMap.get(vtp.Visit__c).Assigned_to__c;
                    vp.Visit_Start_Type__c = 'STOP';
                    vp.Checked_Location_Time__c = visitIdToVisitMap.get(vtp.Visit__c).Start_Time__c;
                    vp.Description__c = 'Create from trigger | STOP Location';
                    vp.Start_Location_Lattitude__c = visitIdToVisitMap.get(vtp.Visit__c).Stop_Location_Latitude__c;
                    vp.Start_Location_Longitude__c = visitIdToVisitMap.get(vtp.Visit__c).Stop_Location_Longitude__c;
                    vp.Visit_Notes__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Notes__c;
                    vp.Visit_Reason__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Reason_APAC__c;
                    vp.Visit_Reason_Global__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Reason__c;
                    vp.Call_to_action_notes__c = visitIdToVisitMap.get(vtp.Visit__c).Call_To_Action_Notes__c;
                    vp.Visit_Status__c = visitIdToVisitMap.get(vtp.Visit__c).Visit_Status__c;
                    vp.Visit_Type__c = visitIdToVisitMap.get(vtp.Visit__c).visit_Type__c;
                    //vp.Call_to_action_notes__c = visitIdToVisitMap.get(vtp.Visit__c).Name;
                    vtpToInsert.add(vp);
                }
               
            }
        }
        if(!vtpToInsert.isEmpty()){
            insert vtpToInsert;
        }

    }
    
    /**
    * This static method is used to get Visit_Task__c 
    *
    @author  Yuda Zheng
    @created 2013-04-30
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param      visitId         Id of Visit
    @param      taskId          Id of Task
    *
    @return     Visit_Task__c
    *
    @changelog
    * 2013-04-30 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */  
    public static Visit_Task__c getVisitTask(Id visitId, Id taskId ){
        String tasklink = '%' + String.valueOf(taskId).substring(0,15) + '%';
        //get Visit_Task__c list by visitId and taskId
        list<Visit_Task__c> visitTasks = [select Id from Visit_Task__c where Visit__c =: visitId and Link_to_the_Task__c like: tasklink];
        return visitTasks.size() > 0 ? visitTasks[0] : null;
    }
    
    /**
    * This static method is used to get Visit_Task__c 
    *
    @author  Lei Tang
    @created 2016-06-07
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param      set_visitIds         Ids of Visit
    @param      set_taskIds          Ids of Task
    *
    @return     map<String, Visit_Task__c>
    *
    @changelog
    * 2016-06-07 Lei Tang <lei.tang@oinio.com>
    * - Created
    */  
    public static map<String, Visit_Task__c> getVisitTaskNew(set<String> set_visitids, set<String> set_taskids){
        map<String, Visit_Task__c> map_key_VisitTask = new map<String, Visit_Task__c>();
        if(set_visitids.size() == 0 || set_taskids.size() == 0) {
            return map_key_VisitTask;
        }
        String hyperlink = URL.getSalesforceBaseUrl().toExternalForm().replace('-api', '')+'/';
 
        for(Visit_Task__c visitTask : [select Id, Visit__c, Link_to_the_Task__c  from Visit_Task__c where Visit__c IN :set_visitids]) {
            if(visitTask.Link_to_the_Task__c != null && visitTask.Link_to_the_Task__c != '') {
                String taskid = visitTask.Link_to_the_Task__c.replace(hyperlink, '');
                taskid = taskid.substring(0, taskid.indexOf('?'));
                if(set_taskids.contains(taskid)) {
                    String key = visitTask.Visit__c+';'+taskid;
                    map_key_VisitTask.put(key,visitTask);
                }
                
            }
        }
        return map_key_VisitTask;
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
    public static void calculateTriggerOnEvent(String mode , list<Event> eventNew , list<Event> eventOld) {
        System.debug('XXXX CALL calculateTriggerOnEvent:' + mode + ', eventOld size=' + eventOld.size());
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
        
        else if(mode == MODE_DELETE) {
            /*set<Id> set_vId = new set<Id>();
            System.debug('XXXX in delete mode');
            for(Event e : eventOld)
            {
                if(e.Visit_Id__c != null) set_vId.add(e.Visit_Id__c);
                System.debug('Add visit Id ' + e.Visit_Id__c);
            }
            if(!set_vId.isEmpty())
            {
                list<Visits__c> list_delete = [Select Id, Activity_Id__c from Visits__c where id in: set_vId];
               //for(Visits__c v : list_delete){
               //     v.Visit_Status__c = 'Cancelled';
               // }
                System.debug('XXXX update ' + set_vId.size() + ' visits to cancel');
                delete list_delete;
            }*/
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
    public static Event syncEventFromVisit(Event e, Visits__c v, Boolean isUpdate, map<Id, Account> map_accId_account, String companyName) {
        
        boolean isApac = ToolBox.isApac(companyName);

        for(String key : map_eFields_vFields.keySet()) {
            if(!(isUpdate && key == 'WhatId') && v.get(map_eFields_vFields.get(key)) != null) {
                // Added by Tangyong Li on the Jun. 2nd 2016.
                if(key == 'Subject' && companyName!='HLSI' && companyName!='HLSH' && companyName!='HOLA' && companyName!='HLCA' && companyName!='VEUS'){
                    e.put(key, Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                               //map_accId_account.get(v.Account__c).shop_name__c + ', ' +
                               Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +  v.get(map_eFields_vFields.get(key)) + ', ' +
                               Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).Shop_Street__c) + ',' +Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c)  
                               );
                
                } else if(key == 'Subject' && isApac) {
                    //CDU HLSI_Visit_Objective2__c multiple picklist, value is not accessible (don't know exactly why)
                    //replace by static word: HLSI Reason
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
                    e.put('subject', Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).hoya_account_id__c) + ', ' +
                           Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).name) + ', ' +
                           Toolbox.stripToEmpty(map_accId_account.get(v.Account__c).shop_city__c) 
                           + ', ' + Toolbox.stripToEmpty(v.Visit_Reason_APAC__c)
                           );

                } else if (key=='Subject'){
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
    * This method is used to sync task activity date.
    *
    @author  Bin Yuan   
    @created 2013-07-15
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param  map<Id, Date> map_visitId2sync_Date
    *
    *
    @changelog
    * 2013-07-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */  
    public static void syncTaskActivityDate(map<Id, Date> map_visitId2sync_Date) {
        map<Id, Date> map_visitTaskId_Date = new map<Id, Date>();
        list<Task> list_task2Update = new list<Task>();
        for(Visit_Task__c vTask :[Select Id, Visit__c From Visit_Task__c Where Visit__c IN : map_visitId2sync_Date.keySet()]) {
            map_visitTaskId_Date.put(vTask.Id, map_visitId2sync_Date.get(vTask.Visit__c));
        }
        if(map_visitTaskId_Date.isEmpty()) {
            return;
        }
        for(Task sTask : [Select ActivityDate, Visit_Task_ID__c From Task Where Visit_Task_ID__c IN : map_visitTaskId_Date.keySet()]) {
            sTask.ActivityDate = map_visitTaskId_Date.get(sTask.Visit_Task_ID__c);
            list_task2Update.add(sTask);
        }
        if(!list_task2Update.isEmpty()) {
            update list_task2Update;
        }
    }
       
   /**
    * This method is used to sync task status.
    *
    @author  Bin Yuan   
    @created 2013-07-15
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param  map<Id, Date> map_visitId2sync_Date
    *
    *
    @changelog
    * 2013-07-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */  
    public static void syncTaskStatus(set<Id> set_Id2syncStatus) {
        set<Id> set_visitTaskIds = new set<Id>();
        list<Task> list_task2Update = new list<Task>();
        
        if(set_Id2syncStatus==null || set_Id2syncStatus.isEmpty()){
            return;
        }

        for(Visit_Task__c vTask :[Select Id, Visit__c From Visit_Task__c Where Visit__c IN : set_Id2syncStatus]) {
            set_visitTaskIds.add(vTask.Id);
        }
        if(set_visitTaskIds.isEmpty()) {
            return;
        }
        system.debug('XXX ' + set_visitTaskIds + 'size=' + set_visitTaskIds.size());
        List<Task> tmpList;
        if(set_visitTaskIds.size()==1){
            System.debug('xxx case 1');
            Id tId = (new list<Id>(set_visitTaskIds)[0]);
            tmpList = [Select ActivityDate, Status From Task Where Visit_Task_ID__c!= null and Visit_Task_ID__c =: tId];
        } else {
            System.debug('xxx case many');
            tmpList = [Select ActivityDate, Status From Task Where Visit_Task_ID__c!= null and Visit_Task_ID__c IN : set_visitTaskIds];
        }
        if(tmpList !=null && !tmpList.isEmpty()){
            for(Task sTask : tmpList) {
                sTask.Status = 'Abgeschlossen';
                list_task2Update.add(sTask);
            }
            if(!list_task2Update.isEmpty()) {
                update list_task2Update;
            }
        }
    }
       
   /**
    * This method is used to sync task status.
    *
    @author  Bin Yuan   
    @created 2013-07-15
    @version 1.0
    @since   25.0 (Force.com ApiVersion)
    *
    @param  map<Id, Date> map_visitId2sync_Date
    *
    *
    @changelog
    * 2013-07-15 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */  
    public static void syncTaskStatusCancel(set<Id> set_Id2syncStatus) {
        set<Id> set_visitTaskIds = new set<Id>();
        list<Task> list_task2Update = new list<Task>();
        
        for(Visit_Task__c vTask :[Select Id, Visit__c From Visit_Task__c Where Visit__c IN : set_Id2syncStatus]) {
            set_visitTaskIds.add(vTask.Id);
        }
        if(set_visitTaskIds.isEmpty()) {
            return;
        }
        for(Task sTask : [Select ActivityDate, Status From Task Where Visit_Task_ID__c IN : set_visitTaskIds]) {
            sTask.Status = 'Verschoben';
            list_task2Update.add(sTask);
        }
        if(!list_task2Update.isEmpty()) {
            update list_task2Update;
        }
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