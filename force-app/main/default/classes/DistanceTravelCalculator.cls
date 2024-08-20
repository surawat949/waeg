public class DistanceTravelCalculator {
	// Method to calculate distances
    public static Map<Id, Map<String, AggregateDistanceTravel>> calculateWeeklyDistances(DateTime currentDate, Set<Id> assignedUsers) {
        Map<Id, Map<String, AggregateDistanceTravel>> userWeeklyDistances = new Map<Id, Map<String, AggregateDistanceTravel>>();
        
        // Calculate the start and end dates for the last 12 full weeks before the current week
        Date curDate = currentDate.Date().toStartOfWeek();
        System.debug('Passed Date'+curDate);
        Date endDate = curDate; 
        Date startDate = endDate.addDays(-83).toStartOfWeek(); 
        System.debug('Start Date from vists queried'+startDate);
         System.debug('Till Date from vists queried'+endDate);
        List<Visits__c> visits = [select Id, End_Time__c, Assigned_to__c,Account__c,Visit_Type__c,Account__r.ShippingLatitude,
                                  Account__r.ShippingLongitude from Visits__c where Assigned_to__c IN :assignedUsers AND 
                                  Visit_Status__c = 'Complete' AND End_Time__c >=:startDate AND End_Time__c <= :endDate AND 
                                  Visit_Type__c = 'Visit' order by End_Time__c asc];

        Map<String, List<Visits__c>> weekVisitsMap = new Map<String, List<Visits__c>>();
		System.debug('visits'+visits);
        System.debug('visitsize'+visits.size());
        // Group visits by week
        for (Visits__c visit : visits) {
            System.debug('visitRec'+visit);
            Id userId = visit.Assigned_to__c;
            if (userId == null) continue;
            if(!ClsVisitUtil.isWeekend(visit.End_Time__c)){
                String weekStart = getWeekStart(visit.End_Time__c);
                 System.debug('weekStart'+weekStart);
                if (!userWeeklyDistances.containsKey(userId)) {
                    userWeeklyDistances.put(userId, new Map<String, AggregateDistanceTravel>());
                }
                System.debug('userWeeklyDistances'+userWeeklyDistances);
                Map<String, AggregateDistanceTravel> weeklyDistances = userWeeklyDistances.get(userId);
                if (!weeklyDistances.containsKey(weekStart)) {
                    weeklyDistances.put(weekStart, new AggregateDistanceTravel());
                }
                System.debug('weeklyDistances'+weeklyDistances);
                AggregateDistanceTravel aggregateDistanceTravel = weeklyDistances.get(weekStart);
                if (aggregateDistanceTravel.lastLat == null || aggregateDistanceTravel.lastLon == null) {
                    if (visit.Account__r.ShippingLatitude != null && visit.Account__r.ShippingLongitude != null) {
                        aggregateDistanceTravel.lastLat = visit.Account__r.ShippingLatitude;
                        aggregateDistanceTravel.lastLon = visit.Account__r.ShippingLongitude;
                    }
                } else {
                    if (visit.Account__r.ShippingLatitude != null && visit.Account__r.ShippingLongitude != null && visit.Account__r.ShippingLatitude != 0 && visit.Account__r.ShippingLongitude != 0) {
                        Decimal distance = calculateDistance(aggregateDistanceTravel.lastLat, aggregateDistanceTravel.lastLon, visit.Account__r.ShippingLatitude, visit.Account__r.ShippingLongitude);
                        System.debug('aggregateDistanceTravel lat'+aggregateDistanceTravel.lastLat);
                        System.debug('aggregateDistanceTravel long'+aggregateDistanceTravel.lastLon);
                        System.debug('visit lat'+visit.Account__r.ShippingLatitude);
                        System.debug('visit long'+visit.Account__r.ShippingLongitude);
                        System.debug('distance'+distance);
                        aggregateDistanceTravel.totalDistance += distance;
                        aggregateDistanceTravel.customerCount += 1;
                        aggregateDistanceTravel.lastLat = visit.Account__r.ShippingLatitude;
                        aggregateDistanceTravel.lastLon = visit.Account__r.ShippingLongitude;
                    }
                }
            }
        }
        
        for (Id userId : userWeeklyDistances.keySet()) {
            Map<String, AggregateDistanceTravel> weeklyDistances = userWeeklyDistances.get(userId);
            for (String weekStart : weeklyDistances.keySet()) {
                AggregateDistanceTravel aggregateDistanceTravel = weeklyDistances.get(weekStart);
                aggregateDistanceTravel.lastLat = null;
                aggregateDistanceTravel.lastLon = null;
            }
        }
        return userWeeklyDistances;
    }
	// Method to calculate distance between locations
    public static Decimal calculateDistance(Decimal lat1, Decimal long1,Decimal lat2,Decimal long2) {
       	Location loc1 = Location.newInstance(lat1,long1);
        Location loc2 = Location.newInstance(lat2,long2);
        return Location.getDistance(loc1, loc2, 'km');
    }
    // Method to get start of the week
    public static String getWeekStart(Datetime curDatetime) {
        Date tempdate = curDatetime.date();
        Date startOfWeek = tempdate.toStartOfWeek();
        // Adjust if the week spans into a new month
        if (startOfWeek.month() != tempdate.month()) {
            startOfWeek = startOfWeek.addDays(7);
        }
        return startOfWeek.format();
    }

    // Inner class to hold aggregate distance and travel count
    public class AggregateDistanceTravel {
        public Decimal totalDistance { get; set; }
        public Integer customerCount { get; set; }
        public Decimal lastLat { get; set; }
        public Decimal lastLon { get; set; }

        public AggregateDistanceTravel() {
            this.totalDistance = 0;
            this.customerCount = 0;
            this.lastLat = null;
            this.lastLon = null;
        }

        public AggregateDistanceTravel(Decimal totalDistance, Integer customerCount) {
            this.totalDistance = totalDistance;
            this.customerCount = customerCount;
            this.lastLat = null;
            this.lastLon = null;
        }
    }
}