trigger pss_ContactTrigger on Contact (before insert, after insert, before update, after update, after delete) 
{
   /* if (Trigger.isAfter && Trigger.isInsert) 
    {
        pss_ContactTriggerHelper.UpdateAccount(Trigger.New);   
    }
    */
    
    if(Trigger.isBefore && Trigger.isInsert){
        pss_ContactTriggerHelper.doHOLKCreateAccTemplateBeforeInsert(Trigger.new);
        //pss_ContactTriggerHelper.UpdateSyncFlag(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        pss_ContactTriggerHelper.doHOLKCreateAccTemplateAfterInsert(Trigger.new);
    }    
        
  /*  if (Trigger.isAfter && Trigger.isDelete) 
    {
        pss_ContactTriggerHelper.CreateContactDelRecord(Trigger.oldMap);   
    }
    */
    /*
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        //pss_ContactTriggerHelper.UpdateSyncFlag(Trigger.new);
        //pss_ContactTriggerHelper.UpdateContactFlag(Trigger.New,Trigger.oldMap);
        //pss_ContactTriggerHelper.UpdateAccount(Trigger.New);   
    }
    */
    if(Trigger.isUpdate && Trigger.isAfter){
        pss_ContactTriggerHelper.doHOLKUpdateContact(Trigger.new, Trigger.oldMap);
        pss_ContactTriggerHelper.doHOLKUpdateAfterUpdate(Trigger.new, Trigger.oldMap);
    }


    ContactTriggerHelper.entry(
        Trigger.operationType,
        Trigger.new,
        Trigger.newMap,
        Trigger.old,
        Trigger.oldMap
    ); 
    
}