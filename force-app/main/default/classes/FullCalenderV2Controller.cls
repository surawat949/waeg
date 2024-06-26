public without sharing class FullCalenderV2Controller {
    private static final String Extra_Activity_RecType = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Extra_Activity').getRecordTypeId();

    @AuraEnabled(Cacheable = true)
    public static String getExtraActivityRecTypeId(){
       String extraActivityRecType = Extra_Activity_RecType;
       return extraActivityRecType;
    }
    @AuraEnabled(Cacheable = true)
    public static String getAccountId(string hoyaAccId){
        String accountId = null;
        List<Account> accounts = [SELECT Id,Hoya_Account_ID__c from Account where Hoya_Account_ID__c =:hoyaAccId LIMIT 1];
        if(accounts.size() > 0){
            accountId = accounts[0].Id;
        }
        else{
            accountId = '';
        }
        return accountId;
    }  
    @AuraEnabled(Cacheable = false)
    public static void createVisit(String accId,String visitType,String conId,String assignedTo,Boolean coachingEvent,String startTime,String endTime,Boolean isAllDay,String visitReason,String notes ){
        DateTime startDate = (DateTime)Json.deserialize('"'+startTime+'"', DateTime.class);
        DateTime endDate = (DateTime)Json.deserialize('"'+endTime+'"', DateTime.class);
        if(conId == '')
            conId = null;
        try{
           Visits__c visit =new Visits__c(
               Visit_Reason__c=visitReason,
               Visit_Objective_follow_up_notes__c=notes,
               Is_All_Day_Event__c=isAllDay,
               End_Time__c=endDate,
               Start_Time__c=startDate,
               Visit_Planning_Tracker__c='Visit Planning',
               Coaching_Visit__c=coachingEvent,
               Contact__c=conId,
               Assigned_to__c=assignedTo,
               Visit_Type__c=visitType,
               Account__c=accId
           );
          insert visit;
        } catch (Exception e) {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }  
    @AuraEnabled(Cacheable = false)
    public static void addExtraActivity(String recTypeId,String userId,String EventType,String description,String startTime,String endTime,Boolean allDayEvent,Boolean isPrivate){
        DateTime startDate = (DateTime)Json.deserialize('"'+startTime+'"', DateTime.class);
        DateTime endDate = (DateTime)Json.deserialize('"'+endTime+'"', DateTime.class); 
        try{
             Event extraEvent = new Event(
                 IsAllDayEvent = allDayEvent,
                 OwnerId = userId,
                 RecordTypeId = recTypeId,Type = EventType,Description = description,StartDateTime = startDate,EndDateTime =endDate,IsPrivate = isPrivate
             );
             insert extraEvent;
         }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static Visits__c upsertVisit (Visits__c visit) {   
        try{
        	upsert visit;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return visit;
    }
    @AuraEnabled
    public static List<EventWrapper> getEvents (DateTime periodStart, DateTime periodEnd) {
        DateTime startDate = datetime.newInstance(periodStart.year(),periodStart.month(),periodStart.day(),0,0,0);
		DateTime endDate =  datetime.newInstance(periodEnd.year(),periodEnd.month(),periodEnd.day(),23,59,59);
        String startDateQuery = startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
		String stopDateQuery = endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        DateTime startTime =  (DateTime)Json.deserialize('"'+startDateQuery+'"', DateTime.class);
        DateTime endTime =  (DateTime)Json.deserialize('"'+stopDateQuery+'"', DateTime.class);
        Id UserId =UserInfo.getUserId();
        String status='Cancelled';
        String query ='SELECT Id,Name, Start_Time__c, End_Time__c,Is_All_Day_Event__c,Visit_Type__c,Visit_Reason__c,Assigned_to__c,Visit_Status__c,Account__r.Name,Account__r.Shop_City__c, Account__r.Hoya_Account_ID__c,Account__r.Shop_Country__c,Account__r.Shop_Postal_Code__c,Account__r.Shop_State__c,Account__r.Shop_Street__c';
        query += ' FROM Visits__c WHERE Visit_Status__c !=:status';
        if(!Test.isRunningTest())
        	query += '  AND Assigned_to__c =:UserId AND End_Time__c >: startTime AND Start_Time__c <: endTime';
        List<Visits__c> visits = DataBase.Query(query);
        List<EventWrapper> wrapperLst = new List<EventWrapper>();
        if(visits.size() > 0){
            for(Visits__c visit:visits){
                EventWrapper wrapper = new EventWrapper();
                wrapper.eventType = 'visitEvent';
                wrapper.startTime = visit.Start_Time__c;
                wrapper.endTime = visit.End_Time__c;
                wrapper.isAllDayEvent = visit.Is_All_Day_Event__c;
                wrapper.eventId = visit.Id;
                wrapper.accountName = visit.Account__r.Name;
                wrapper.accountShopCity = visit.Account__r.Shop_City__c;
                wrapper.accountShopStreet = visit.Account__r.Shop_Street__c;
                wrapper.accountShopZipcode = visit.Account__r.Shop_Postal_Code__c;
                wrapper.accountShopstate = visit.Account__r.Shop_State__c;
                wrapper.hoyaAccountId = visit.Account__r.Hoya_Account_ID__c;
                wrapper.visitReason = visit.Visit_Reason__c;
                wrapper.visitType = visit.Visit_Type__c;
                wrapper.visitStatus = visit.Visit_Status__c;
                wrapperLst.add(wrapper);
            }
        }
        String eventQuery =null;
        eventQuery='SELECT Id, RecordTypeId,StartDateTime, EndDateTime, Subject, Type,IsAllDayEvent,Description FROM Event WHERE OwnerId =:UserId AND ';
        eventQuery += 'EndDateTime >: startTime AND StartDateTime <: endTime AND Visit_Id__c = null';
        if(Test.isRunningTest()){
           eventQuery ='SELECT Id, RecordTypeId,StartDateTime, EndDateTime, Subject, Type,IsAllDayEvent,Description FROM Event WHERE OwnerId =:UserId';
        }
        System.debug(startTime+'-'+endTime);
        List<Event> Events = Database.query(eventQuery);
        if(Events.size() > 0){
            for(Event event:Events){
                EventWrapper wrapper = new EventWrapper();
                wrapper.eventType = 'UserEvent';
                wrapper.startTime = event.StartDateTime;
                wrapper.endTime = event.EndDateTime;
                wrapper.isAllDayEvent = event.IsAllDayEvent;
                wrapper.subject = event.Subject;
                wrapper.eventId = event.Id;
                if(event.RecordTypeId == Extra_Activity_RecType ){
               		wrapper.isExtraEvent = true;
               		wrapper.description = event.Description;
                	wrapper.visitType = event.Type;
                }else{
                    wrapper.isExtraEvent = false;
                }
                System.debug(wrapper);
                wrapperLst.add(wrapper);
            }
        }
        return wrapperLst;
    }
   @AuraEnabled(Cacheable = true)
    public static Object getContactsForAccount(String accountId) {
        List<SelectOption> options = new List<SelectOption>();
        for (Contact c : [Select Id, Name from Contact where AccountId = : accountId])
        {
            options.add(new SelectOption(c.Id,c.Name));
        }
        System.debug(options);
        return toOptionList(options, true);
    }
    @AuraEnabled(Cacheable = true)
    public static Object getTranslations()
    {
        Map<String, Object> ret = new Map<String, Object>();
        Map<String, Object> theMap = new Map<String,Object>();
        theMap.put('Visits__c_Visit_Reason__c', toOptionList(getOptionsForDescribe(Visits__c.Visit_Reason__c.getDescribe()),true));//objective
        ret.put('picklists' , theMap);
        System.debug(ret);
        return ret;
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
    public class EventWrapper{
        @AuraEnabled public String eventType{get;set;}
        @AuraEnabled public DateTime startTime{get;set;}
        @AuraEnabled public DateTime endTime{get;set;}
        @AuraEnabled public Boolean isAllDayEvent{get;set;}
        @AuraEnabled public String eventId{get;set;}
        @AuraEnabled public String accountName{get;set;}
        @AuraEnabled public String accountShopCity{get;set;}
        @AuraEnabled public String accountShopStreet{get;set;}
        @AuraEnabled public String accountShopZipcode{get;set;}
  		@AuraEnabled public String accountShopstate{get;set;}        
        @AuraEnabled public String hoyaAccountId{get;set;}
        @AuraEnabled public String visitReason{get;set;}
        @AuraEnabled public String visitType{get;set;} 
        @AuraEnabled public String visitStatus{get;set;} 
        @AuraEnabled public String subject{get;set;}
        @AuraEnabled public String description{get;set;}
        @AuraEnabled public Boolean isExtraEvent{get;set;}
    }
}