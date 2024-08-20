/**
 *  This trigger is used to calculate total day, 
 
 d Visits etc before insert and update VISIT_KPI__c
 *
 @author    Yuda Zheng
 @created   2014-04-14
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-04-14 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 */
trigger VisitKPI_BIU_calculateDays on VISIT_KPI__c (before insert, before update) {
    Set<Id> set_userId = new Set<Id>();
    Map<Id, Id> map_userId_visitKPIId = new Map<Id, Id>();
    Map<Id, User> map_visitKPIId_user = new Map<Id, User>();
    Map<Id, decimal> map_visitKPIId_daysOff = new Map<Id, decimal>();
    Map<Id, list<Visits__c>> map_visitKPIId_visits = new Map<Id, list<Visits__c>>();
    Map<Id, VISIT_KPI__c> mapOfUserIdVisitKpi = new Map<Id, VISIT_KPI__c>();
    Boolean isKpiInsert;
    Boolean isKpiUpdate;
    Map<Id, VISIT_KPI__c> mapOfUserIdOldVisitKpi = new Map<Id, VISIT_KPI__c>();

    Map<Id, User> map_users = new Map<Id, User>();
    String currentYear = '';
    String currentMonth = '';
    Date currentDate;
    Set<String> set_country = new Set<String>();
    Set<String> set_region = new Set<String>();
    System.debug('DistanceUpdateforMonthBatch.skipTrigger'+DistanceUpdateforMonthBatch.skipTrigger);
    if(DistanceUpdateforMonthBatch.skipTrigger){
        return;
    }    
    for(VISIT_KPI__c visitKPI : trigger.new){
        set_userId.add(visitKPI.Area_Sales_Manager__c);
        map_userId_visitKPIId.put(visitKPI.Area_Sales_Manager__c, visitKPI.Id);
        /* Pim 2018-06-20 Begin */
        /* map_userId_visitKPIId.put(visitKPI.ownerid, visitKPI.Id);   (doesn't work) */
        /* Pim 2018-06-20 End */            
        map_visitKPIId_daysOff.put(visitKPI.Id, 0);
        if(currentYear == ''){
            currentYear = String.valueOf(visitKPI.Year__c);
        }
        if(currentMonth == ''){
            currentMonth = ClsVisitUtil.map_Month.get(String.valueOf(visitKPI.Month__c));
        }
        if(currentDate == null){
            if(visitKPI.Date__c != null){
                currentDate = visitKPI.Date__c;
            }
            else{
                currentDate = Date.today().toStartOfMonth();
            }
        }
    }
    
    for(User user : [select Id, Sales_District_Area__c, Country__c, Name from User where id in: set_userId]){
        if(map_userId_visitKPIId != null && map_userId_visitKPIId.get(user.Id) != null){
            map_visitKPIId_user.put(map_userId_visitKPIId.get(user.Id), user);
        }
        set_country.add(user.Country__c);
        set_region.add(user.Sales_District_Area__c);
        map_users.put(user.id, user);
    }
            
    String queryTimeOff = 'select Id, Days_Off__c, Country__c, Sales_District_Area__c from Time_off_Territory__c where Year__c =: currentYear and Month__c =: currentMonth and Country__c in: set_country and Sales_District_Area__c in: set_region';   
    for(Time_off_Territory__c timeOffTerritory : Database.query(queryTimeOff)) {
        if(timeOffTerritory.Country__c != null && timeOffTerritory.Sales_District_Area__c != null){
            for(String visitKPIId : map_visitKPIId_user.keySet()){
                if(map_visitKPIId_user.get(visitKPIId).get('Country__c') != null && map_visitKPIId_user.get(visitKPIId).get('Country__c') == timeOffTerritory.Country__c 
                && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') != null && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') == timeOffTerritory.Sales_District_Area__c){
                    map_visitKPIId_daysOff.put(visitKPIId, timeOffTerritory.Days_Off__c);
                }
            }
        }else if(timeOffTerritory.Country__c != null && timeOffTerritory.Sales_District_Area__c == null){
            for(String visitKPIId : map_visitKPIId_user.keySet()){
                
                /** Comment out by juillet yuan 2015-01-20 to fetch time off terrortory according to user's country and district--------------start
                if(map_visitKPIId_user.get(visitKPIId).get('Country__c') != null && map_visitKPIId_user.get(visitKPIId).get('Country__c') == timeOffTerritory.Country__c 
                && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') != null && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') != timeOffTerritory.Sales_District_Area__c){
                *** Comment out by juillet yuan 2015-01-20 to fetch time off terrortory according to user's country and district--------------end**/
                
                if(map_visitKPIId_user.get(visitKPIId).get('Country__c') != null && map_visitKPIId_user.get(visitKPIId).get('Country__c') == timeOffTerritory.Country__c 
                && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') == null && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') == timeOffTerritory.Sales_District_Area__c){
                    map_visitKPIId_daysOff.put(visitKPIId, timeOffTerritory.Days_Off__c);
                }
            }
        }else if(timeOffTerritory.Country__c == null && timeOffTerritory.Sales_District_Area__c != null){
            for(String visitKPIId : map_visitKPIId_user.keySet()){
                
                /** Comment out by juillet yuan 2015-01-20 to fetch time off terrortory according to user's country and district--------------start
                if(map_visitKPIId_user.get(visitKPIId).get('Country__c') != null && map_visitKPIId_user.get(visitKPIId).get('Country__c') != timeOffTerritory.Country__c 
                && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') != null && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') == timeOffTerritory.Sales_District_Area__c){
                *** Comment out by juillet yuan 2015-01-20 to fetch time off terrortory according to user's country and district--------------end**/
                
                if(map_visitKPIId_user.get(visitKPIId).get('Country__c') == null && map_visitKPIId_user.get(visitKPIId).get('Country__c') == timeOffTerritory.Country__c 
                && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') != null && map_visitKPIId_user.get(visitKPIId).get('Sales_District_Area__c') == timeOffTerritory.Sales_District_Area__c){
                    map_visitKPIId_daysOff.put(visitKPIId, timeOffTerritory.Days_Off__c);
                }
            }
        }
    }

    DateTime startDateInMonth = (DateTime)currentDate.toStartOfMonth();
    DateTime endDateInMonth = (DateTime)startDateInMonth.addDays(Date.daysInMonth(currentDate.year(), currentDate.month()));

    
    /**for(Visits__c visit : ClsVisitUtil.getCompletedVisits(currentDate, set_userId)){
        if(!map_visitKPIId_visits.containsKey(map_userId_visitKPIId.get(visit.Assigned_to__c))){
            map_visitKPIId_visits.put(map_userId_visitKPIId.get(visit.Assigned_to__c), new list<Visits__c>());
            map_visitKPIId_visits.get(map_userId_visitKPIId.get(visit.Assigned_to__c)).add(visit);
        }
    }**/

    map<Id, map<String, Integer>> map_user_info = new map<Id, map<String, Integer>>();
    map<Id, set<Integer>> map_user_workdayVisits = new map<Id, set<Integer>>();
    //CDU 23/06/2020 Add digital visit counter
    map<Id, set<Integer>> map_user_workdayDigitalVisits = new map<Id, set<Integer>>();
   //Stores both digital and direct visits without the duplication
    map<Id, set<date>> map_user_workdayTotalVisits = new map<Id, set<date>>();
    //Stores visits with assigned user and visit
    Map<Id, Set<Date>> map_user_visits = new Map<Id, Set<Date>>(); 
    
    for(Visits__c visit : [select Id, End_Time__c, Assigned_to__c, Visit_Type__c,Account_Shipping_Latitude__c,Account_Shipping_Longitude__c  from Visits__c where Assigned_to__c IN :set_userId and Visit_Status__c = 'Complete' and End_Time__c >=: startDateInMonth and  End_Time__c <=: endDateInMonth and Visit_Type__c in ('Visit', 'Digital Visit')]) {
        if(!map_user_info.containsKey(visit.Assigned_to__c)) {
            map_user_info.put(visit.Assigned_to__c, new map<String, Integer>{
                'workdayVisits' => 0,
                'weekendVisits' => 0,
                'workdayDigitalVisits' => 0,
                'weekendDigitalVisits' => 0
            });
        }
        if(!map_user_workdayVisits.containsKey(visit.Assigned_to__c)) {
            map_user_workdayVisits.put(visit.Assigned_to__c, new set<Integer>());
        }
        if(!map_user_workdayDigitalVisits.containsKey(visit.Assigned_to__c)) {
            map_user_workdayDigitalVisits.put(visit.Assigned_to__c, new set<Integer>());
        }
        if(!map_user_workdayTotalVisits.containsKey(visit.Assigned_to__c)) {
            map_user_workdayTotalVisits.put(visit.Assigned_to__c, new set<date>());
        }
        map<String, Integer> map_key_info = map_user_info.get(visit.Assigned_to__c);
        Integer weekendVisits = map_key_info.get('weekendVisits');
        Integer workdayVisits = map_key_info.get('workdayVisits');
        Integer weekendDigitalVisits = map_key_info.get('weekendDigitalVisits');
        Integer workdayDigitalVisits = map_key_info.get('workdayDigitalVisits');

        set<Integer> set_workdayVisits = map_user_workdayVisits.get(visit.Assigned_to__c);
        set<Integer> set_workdayDigitalVisits = map_user_workdayDigitalVisits.get(visit.Assigned_to__c);
        set<date> set_totalworkdayVisits = map_user_workdayTotalVisits.get(visit.Assigned_to__c);
        if(ClsVisitUtil.isWeekend(visit.End_Time__c)){
            if(visit.Visit_Type__c == 'Digital Visit'){
                weekendDigitalVisits++;
            } else {
                weekendVisits++;
            }
        }
        else{
            if(visit.Visit_Type__c == 'Visit'){
                set_workdayVisits.add(visit.End_Time__c.day());
                workdayVisits++;
            }
            if(visit.Visit_Type__c == 'Digital Visit'){
                set_workdayDigitalVisits.add(visit.End_Time__c.day());
                workdayDigitalVisits++;
            }
            
            if(!map_user_visits.containsKey(visit.Assigned_to__c)) {
            map_user_visits.put(visit.Assigned_to__c, new set<Date>());
            } else {
            // If the map already contains end times for the assigned user, check if the current visit's end time is already in the set
             Set<Date> endDate = map_user_visits.get(visit.Assigned_to__c);
             if (!endDate.contains(visit.End_Time__c.date())) {
            // If the end date is not in the set, add it and increment the counter
            endDate.add(visit.End_Time__c.date());
            map_user_visits.put(visit.Assigned_to__c, endDate);
            set_totalworkdayVisits.add(visit.End_Time__c.date());
            }
          }
        }
        map_key_info.put('weekendVisits', weekendVisits);
        map_key_info.put('workdayVisits', workdayVisits);
        map_key_info.put('weekendDigitalVisits', weekendDigitalVisits);
        map_key_info.put('workdayDigitalVisits', workdayDigitalVisits);
        map_user_info.put(visit.Assigned_to__c, map_key_info);

        map_user_workdayVisits.put(visit.Assigned_to__c, set_workdayVisits);
        map_user_workdayDigitalVisits.put(visit.Assigned_to__c, set_workdayDigitalVisits);
        map_user_workdayTotalVisits.put(visit.Assigned_to__c,set_totalworkdayVisits);
    }
    Map<Id, Map<String, DistanceTravelCalculator.AggregateDistanceTravel>> userWeeklyDistances = DistanceTravelCalculator.calculateWeeklyDistances(currentDate,set_userId);
    Map<Id, Decimal> userAverageDistances = new Map<Id, Decimal>();
    System.debug('userWeeklyDistances'+userWeeklyDistances);
    for (Id userId : userWeeklyDistances.keySet()) {
         System.debug('userWeeklyDistance userId'+userId);
          System.debug('userWeeklyDistance Map'+userWeeklyDistances.get(userId));
        Map<String, DistanceTravelCalculator.AggregateDistanceTravel> weeklyDistances = userWeeklyDistances.get(userId);
         Decimal totalDistance = 0;
         Integer totalcustomerCount = 0;
          for (DistanceTravelCalculator.AggregateDistanceTravel aggregateDistanceTravel : weeklyDistances.values()) {
              totalDistance += aggregateDistanceTravel.totalDistance;
              totalCustomerCount += aggregateDistanceTravel.customerCount;
          }
         System.debug('totalDistance'+totalDistance);
         System.debug('totalCustomerCount'+totalCustomerCount);
         Decimal averageDistance = (totalCustomerCount > 0) ? (totalDistance / totalCustomerCount) : 0;
         System.debug('averageDistance'+averageDistance);
         userAverageDistances.put(userId, averageDistance);
     }
   // System.debug('weekVisitsMap'+weekVisitsMap);

    /*
     * CDU 2019/01/09 add counter coaching call for visit KPI
     */
    Map<Id, Integer> map_user_coachingVisit = new Map<Id, Integer>();
    AggregateResult[] groupedResults = [select count(Id) nbvisit, Assigned_to__c  from Visits__c 
                           where Assigned_to__c IN :set_userId and Visit_Status__c = 'Complete' and End_Time__c >=: startDateInMonth and  End_Time__c <=: endDateInMonth and Visit_Type__c = 'Coaching'
                           group by Assigned_to__c];
    for(AggregateResult ar : groupedResults){
        map_user_coachingVisit.put(Id.valueOf(String.valueOf(ar.get('Assigned_to__c'))), Integer.valueOf(ar.get('nbvisit')));
    }
    /*
     * CDU 2020/06/05 add counter digital_visit__c
     */
    Map<Id, Integer> map_user_digitalVisit = new Map<Id, Integer>();
    AggregateResult[] groupedDigitalResults = [select count(Id) nbvisit, Assigned_to__c  from Visits__c 
                           where Assigned_to__c IN :set_userId and Visit_Status__c = 'Complete' and End_Time__c >=: startDateInMonth and  End_Time__c <=: endDateInMonth and Visit_Type__c = 'Digital Visit'
                           group by Assigned_to__c];
    for(AggregateResult ar : groupedDigitalResults){
        map_user_digitalVisit.put(Id.valueOf(String.valueOf(ar.get('Assigned_to__c'))), Integer.valueOf(ar.get('nbvisit')));
    }
    //----------------------------------------
    for(VISIT_KPI__c visitKPI : trigger.new){
        
        decimal weekendVisits = 0;
        decimal workdayVisits = 0;
        decimal weekendDigitalVisits = 0;
        decimal workdayDigitalVisits = 0;
        set<Integer> set_workdayVisits = new set<Integer>();
        set<Integer> set_workdayDigitalVisits = new set<Integer>();
        set<date> set_totalworkdayTotalVisits = new set<date>();
       
        if(map_user_info.containsKey(visitKPI.Area_Sales_Manager__c)) {
            map<String, Integer> map_key_info = map_user_info.get(visitKPI.Area_Sales_Manager__c);
            weekendVisits = map_key_info.get('weekendVisits');
            workdayVisits = map_key_info.get('workdayVisits');
            weekendDigitalVisits = map_key_info.get('weekendDigitalVisits');
            workdayDigitalVisits = map_key_info.get('workdayDigitalVisits');
            set_workdayVisits = map_user_workdayVisits.get(visitKPI.Area_Sales_Manager__c);
            set_workdayDigitalVisits = map_user_workdayDigitalVisits.get(visitKPI.Area_Sales_Manager__c);
            set_totalworkdayTotalVisits = map_user_workdayTotalVisits.get(visitKPI.Area_Sales_Manager__c);
        }
        //set coaching call counter
        if(map_user_coachingVisit.containsKey(visitKPI.Area_Sales_Manager__c)) {
            visitKPI.coaching_visit__c = map_user_coachingVisit.get(visitKPI.Area_Sales_Manager__c);
        }
        //set digital visit counter 
        if(map_user_digitalVisit.containsKey(visitKPI.Area_Sales_Manager__c)) {
            visitKPI.digital_visit__c = map_user_digitalVisit.get(visitKPI.Area_Sales_Manager__c);
        }
      
        //set current date
        visitKPI.Date__c = currentDate;
        //set Total days of current Month
        visitKPI.Total_days_per_Month__c = Date.daysInMonth(currentDate.year(), currentDate.month());
        //set Weekend days of current Month
        visitKPI.Weekend_Days__c = ClsVisitUtil.getWeekendDays(currentDate);
        //set Days Off
        visitKPI.Days_Off__c = map_visitKPIId_daysOff.get(visitKPI.Id);
        /**
        for(User user : [select Id, Sales_District_Area__c, Country__c, Name from User where id =: visitKPI.Area_Sales_Manager__c]){
            region = user.Sales_District_Area__c;
            country = user.Country__c;
            userName = user.Name;
        }
        String queryTimeOff = 'select Id, Days_Off__c from Time_off_Territory__c where Year__c = \'' + String.valueOf(visitKPI.Year__c) + '\' and Month__c = \'' + ClsVisitUtil.map_Month.get(String.valueOf(visitKPI.Month__c)) + '\'';
        
        if(country != null){
            queryTimeOff += ' and Country__c = \'' + country  + '\'';
        }
        if(region != null){
            queryTimeOff += ' and Sales_District_Area__c = \'' + region  + '\'';
        }   
        system.debug('queryTimeOff:' + queryTimeOff);
        //}for(Time_off_Territory__c timeOffTerritory : [select Id, Days_Off__c from Time_off_Territory__c where (Country__c =: country or Sales_District_Area__c =: region) and Year__c =: String.valueOf(visitKPI.Year__c) and Month__c =: ClsVisitUtil.map_Month.get(String.valueOf(visitKPI.Month__c))]) {
        for(Time_off_Territory__c timeOffTerritory : Database.query(queryTimeOff)) {
            visitKPI.Days_Off__c = timeOffTerritory.Days_Off__c;
        }
        **/

        //get the completed visits
        /*String usrId = visitKPI.Area_Sales_Manager__c;
        for(Visits__c visit : [select Id, End_Time__c from Visits__c where Assigned_to__c =: usrId and Visit_Status__c = 'Complete' and End_Time__c >=: startDateInMonth and  End_Time__c <=: endDateInMonth]) {
            if(ClsVisitUtil.isWeekend(visit.End_Time__c)){
                weekendVisits++;
            }
            else{
                set_workdayVisits.add(visit.End_Time__c.day());
                workdayVisits++;
            }
        }*/
        
        //set Individual Days in Field
        visitKPI.Individual_Days_in_Field__c = set_workdayVisits.size();
        visitKPI.Individual_Digital_Days_in_Field__c = set_workdayDigitalVisits.size();
        //set Weekend Visits
        visitKPI.Weekend_Visits__c = weekendVisits;
        //set Visits completed
        visitKPI.Visits_completed__c = workdayVisits + weekendVisits;
        visitKPI.Digital_Visits_completed__c = workdayDigitalVisits + weekendDigitalVisits;
        //Total visit days for both direct and digital visits without duplicate days
        visitKPI.Sum_of_Visits_Days_in_Field__c = set_totalworkdayTotalVisits.size();
        //set Vist KPI name with „User_Country__c“, „Year__c“, „Month__c“, „Area_Sales_Manager__c“
        String uCountry = map_users.get(visitKPI.Area_Sales_Manager__c).Country__c;
        String uName = map_users.get(visitKPI.Area_Sales_Manager__c).Name;
        //CDU 07/01/2019 disable 
        /*if(map_visitKPIId_user != null && map_visitKPIId_user.get(visitKPI.Id) != null){
            if(map_visitKPIId_user.get(visitKPI.Id).get('Country__c') != null){
                uCountry = String.valueOf(map_visitKPIId_user.get(visitKPI.Id).get('Country__c'));
            }
            if(map_visitKPIId_user.get(visitKPI.Id).get('Name') != null){
                uName = String.valueOf(map_visitKPIId_user.get(visitKPI.Id).get('Name'));
            }
        }*/
        //CDU 07/01/2019 disable end
        visitKPI.Name = uCountry + ',' + currentYear + ',' + currentMonth + ',' + uName;
        visitKPI.Unique_Identifier__c = uCountry + '_' + currentYear + '_' + currentMonth + '_' + uName;
        visitKPI.ownerId = visitKPI.Area_Sales_Manager__c;
        visitKPI.X12WeekAverageDistanceCovered__c = userAverageDistances.containsKey(visitKPI.Area_Sales_Manager__c)? userAverageDistances.get(visitKPI.Area_Sales_Manager__c) : 0;
    
    mapOfUserIdVisitKpi.put(visitKPI.Area_Sales_Manager__c,visitKPI); 
    if(trigger.isUpdate) {
        mapOfUserIdOldVisitKpi.put(Trigger.oldMap.get(visitKPI.Id).Area_Sales_Manager__c,trigger.oldMap.get(visitKPI.Id));
    }    
    }
     //Call a method to calculate 3 month,6 month and 12 month fields calculation
    if(Trigger.IsInsert && Trigger.isBefore){
        isKpiInsert = true;
        VisitKPILastMonthCalculation.calculateAndStoreKPI(mapOfUserIdVisitKpi,isKpiInsert,false,null);
    }
    
    if(Trigger.IsUpdate && Trigger.isBefore) {
        isKpiUpdate =true;
        VisitKPILastMonthCalculation.calculateAndStoreKPI(mapOfUserIdVisitKpi,false,isKpiUpdate,mapOfUserIdOldVisitKpi);
    }
}