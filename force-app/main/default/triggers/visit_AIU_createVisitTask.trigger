/**
 *  This trigger is used to create a new visit task when visit date is before due date and Promtion_Group_Task_ID is not empty
 *
 @author    Yuda Zheng
 @created   2013-04-29
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-04-29 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 */
trigger visit_AIU_createVisitTask on Visits__c (after insert, after update) {
    //************************* BEGIN Pre-Processing **********************************************
    //Added by Bin Yuan due to update Task ActivityDate if visit start date is changed
    map<Id, Date> map_visitId2sync_Date = new map<Id, Date>();
    set<Id> set_Id2syncStatus = new set<Id>();
    set<Id> set_Id2syncStatusCancel = new set<Id>();
    Set<Id> conIdSet = new Set<Id>();
    //End
    //************************* END Pre-Processing ************************************************
    
    //************************* BEGIN Before Trigger **********************************************
    
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************

    if(trigger.isAfter) {
        list<Visits__c> newVisits;
        List<Visits__c> newVisitsAPAC ;
        //create new VisitTask after create Visit
        if(trigger.isInsert){
            newVisits = trigger.new;
            ClsVisitUtil.createOrDeleteVisitTask(newVisits, ClsVisitUtil.MODE_INSERT);
            ClsVisitUtil.CreateVisitMapAPAC(Trigger.new);

            //ClsVisitUtil.CreateTaskFromVisit(Trigger.new);
            //ClsVisitUtil.CreateVisitMapAPAC(newVisits);
        }
        //create or delete VisitTask after when the Start_Time__c of Visit is modified
        else if(trigger.isUpdate){
            newVisits = new list<Visits__c>();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            //add the visit whose Start_Time__c has be modified to the visit list

            for(Visits__c visit : trigger.new){
                
                if(visit.Start_Time__c != trigger.oldMap.get(visit.id).Start_Time__c)
                {
                    newVisits.add(visit);
                    map_visitId2sync_Date.put(visit.Id, visit.Start_Time__c.date());
                }
                if(visit.Visit_Status__c != trigger.oldMap.get(visit.id).Visit_Status__c && (visit.Visit_Status__c == 'Complete' || visit.Visit_Status__c == 'Cancelled'))
                {
                    set_Id2syncStatus.add(visit.Id);
                }
                /*
                if((visit.Assigned_to__r.Email!=null || visit.Assigned_to__r.Email!='') && (visit.Call_To_Action_Notes__c!=null || visit.Call_To_Action_Notes__c!='') && (visit.Visit_Status__c=='Complete')){
                    String email = [select Id, Name, Email from User where Id=:visit.Assigned_to__c].Email;
                    System.debug('User Email is '+email);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add(email);
                    mail.setToAddresses(sendTo);

                    mail.setReplyTo('surawat.sakulmontreechai@hoya.com');
                    mail.setSenderDisplayName(visit.Assigned_to__r.Name);

                    List<String> ccTo = new List<String>();
                    ccTo.add('sakulmontreechai@yahoo.com');
                    mail.setCcAddresses(ccTo);

                    mail.setSubject('Call to action note '+visit.Name);
                    String body = 'You have notification for call to action note to take care.'+'<br/>';
                    body += 'Please take care for this action note <br/>';
                    body += '<strong>'+visit.Call_To_Action_Notes__c+'</strong>';
                    mail.setHtmlBody(body);
                    mails.add(mail);
                }
                Messaging.sendEmail(mails);
                */
            }
            ClsVisitUtil.createOrDeleteVisitTask(newVisits, ClsVisitUtil.MODE_UPDATE);
            ClsVisitUtil.updateVisitMapAPAC(Trigger.new, Trigger.oldMap);

            //ClsVisitUtil.doVisitAfterupdate(Trigger.new, Trigger.oldMap);
            
            String companyName = [select companyName from User where id=:UserInfo.getUserId()].companyName;
            if(companyName=='HLBR'){
                //HLBR User should not update scheduled time when visit is complete
                Map<Id, Visits__c> oldVisitMap = new Map<Id, Visits__c>();
                for(Visits__c visit : trigger.old){
                    oldVisitMap.put(visit.Id, visit);
                }
                for(Visits__c visit : trigger.new){
                    Visits__c oldVisit = oldVisitMap.get(visit.Id);
                    if(visit.Visit_Status__c=='Complete' && oldVisit.Visit_Status__c=='Complete'){
                        if(oldVisit.Start_Time__c!=visit.Start_Time__c ||oldVisit.End_Time__c!=visit.End_Time__c){
                            //visit.addError('You do not have permission to change the visit date');
                            visit.addError('Não é possível alterar a data e o horário da visita após a sua conclusão.');
                        }
                    }
                }
            }
        }
        for (Visits__c eachVisit : trigger.new) {
            if (eachVisit.Visit_Status__c == 'Complete' && eachVisit.visit_Type__c == 'Visit' && !eachVisit.Visited_but_not_seen__c && eachVisit.Contact__c != null) {
                conIdSet.add(eachVisit.Contact__c);
            }
        }
    }

    if(!map_visitId2sync_Date.isEmpty()) {
        ClsVisitUtil.syncTaskActivityDate(map_visitId2sync_Date);
    }
    
    if(!set_Id2syncStatus.isEmpty()) {
        ClsVisitUtil.syncTaskStatus(set_Id2syncStatus);
    }

    if (!conIdSet.isEmpty()) {
        ClsVisitUtil.updateContactRecords(conIdSet);
    }

    //************************* END After Trigger *************************************************
}