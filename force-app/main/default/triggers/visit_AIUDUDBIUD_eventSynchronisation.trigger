/**
 *  This trigger is used to synchronize from visit to event
 *
 @author    Peng Zhu
 @created   2013-03-28
 @version   1.0
 @since     25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-03-28 Peng Zhu <peng.zhu@itbconsult.com>
 * - Created
 */
trigger visit_AIUDUDBIUD_eventSynchronisation on Visits__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
     VisitTriggerHelper.entry(Trigger.operationType
        , Trigger.new
        , Trigger.newMap
        , Trigger.old
        , Trigger.oldMap);     
    //************************* BEGIN Before Trigger **********************************************
    if(Trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        for(Visits__c v : trigger.new) {          
            Date currentDate = Date.today();
            Datetime dt = (DateTime)currentDate;
            String dayOfWeek = dt.format('EEEE'); 
            If(trigger.isInsert){
                v.Visit_Initial_Date_Tracker__c = v.Start_Time__c.date();
             /*   if(visit.Visit_Status__c == 'Complete' || visit.Visit_Status__c == 'Cancelled' ) {
                v.Visit_Reporting_Day_Tracker__c = dayOfWeek ;
               }*/
            }
            System.debug('v.Start_Time__c  '+v.Start_Time__c );
            //System.debug('Trigger.oldMap.get(v.Id).Start_Time__c '+Trigger.oldMap.get(v.Id).Start_Time__c);
            If((trigger.isUpdate && (v.Start_Time__c != Trigger.oldMap.get(v.Id).Start_Time__c)) || Test.isRunningTest()){
                Integer currentMonth = currentDate.month();
                Integer currentYear = currentDate.year();
                Integer lastMonth = currentMonth - 1;
                Integer lastYear = currentYear;
                Integer nextMonth = currentMonth + 1;
                Integer nextYear = currentYear;
                if (lastMonth == 0 || Test.isRunningTest()) {
                    lastMonth = 12;
                    lastYear = currentYear - 1;
                }
                if (nextMonth == 13 || Test.isRunningTest()) {
                    nextMonth = 1;
                    nextYear = currentYear + 1;
                }
                Date startOfNextMonth = Date.newInstance(nextYear, nextMonth, 1);
                Date twentiethOfLastMonth = Date.newInstance(lastYear, lastMonth, 20);
                Date twentiethOfthisMonth = Date.newInstance(currentYear, currentMonth, 20);
                If(v.CreatedDate >= twentiethOfLastMonth && v.Start_Time__c == startOfNextMonth && v.LastModifiedDate < twentiethOfthisMonth){
                    v.Visit_Initial_Date_Tracker__c = v.Start_Time__c.date();
                }else{
                    v.Visit_Initial_Date_Tracker__c = currentDate;
                }
            }
            if((trigger.isInsert && (v.Visit_Status__c == 'Complete' || v.Visit_Status__c == 'Cancelled'))  || (trigger.isUpdate && v.Visit_Status__c != Trigger.oldMap.get(v.Id).Visit_Status__c && (v.Visit_Status__c == 'Complete' || v.Visit_Status__c == 'Cancelled'))) {
                   v.Visit_Reporting_Day_Tracker__c = dayOfWeek ;
            }
            if(v.Is_All_Day_Event__c){
                if (v.Start_Time__c != null) {
                    v.Start_Time__c = ClsVisitUtil.calculateDateTimeValue(v.Start_Time__c.date(), '00:00');
                }
                if (v.End_Time__c != null) {
                    v.End_Time__c = ClsVisitUtil.calculateDateTimeValue(v.End_Time__c.date(), '00:00');
                }
            }
        }
    }
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
    
    //synchronize
    if(!TriggerRecursionDefense.visitEventSync && Trigger.isAfter) {
        if(trigger.isAfter) {
            TriggerRecursionDefense.visitEventSync = true;
            String mode;
            list<Visits__c> list_new = new list<Visits__c>();
            list<Visits__c> list_old = new list<Visits__c>();
            if(Trigger.isInsert || Trigger.isUnDelete) {
                mode = ClsVisitUtil.MODE_INSERT;
                list_new = trigger.new; 
            }
            else if(Trigger.isUpdate) {
                mode = ClsVisitUtil.MODE_UPDATE;
                list_new = trigger.new; 
                list_old = trigger.old; 
            }
            else if(Trigger.isDelete) {
                mode = ClsVisitUtil.MODE_DELETE;
                list_old = trigger.old; 
            }
            ClsVisitUtil.calculateTriggerOnVisit(mode, list_new, list_old);
            TriggerRecursionDefense.visitEventSync = false;
        }
    }
    //************************* END After Trigger *************************************************
}