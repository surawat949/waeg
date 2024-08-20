global with sharing class VisitGpsTrackerController {
    public List<Map<String,Double>> startlocations { get; private set;} 
    public List<Map<String,Double>> stoplocations { get; private set;} 
    public List<Map<String,Double>> accountLocations { get; private set;} 
    public Visits__c visit {get;set;}
    public Account account {get;set;}
                                               
    private ApexPages.StandardController sc;
    public VisitGpsTrackerController(ApexPages.StandardController stdController){
        System.debug('Constructor VisitGpsTrackerController');
        this.visit = [select id, name
                      , Start_location_time__c, Stop_Location_Time__c, Start_Location_Latitude__c , Start_Location_Longitude__c
                      , Stop_Location_Latitude__c, Stop_Location_Longitude__c
                      , Visit_notes__c, Start_Shop_Distance__c, Stop_Shop_Distance__c, Start_Stop_Distance__c
                      from Visits__c where id=:stDController.getRecord().Id];
        this.sc = stdController;
        String accountId = [select Account__c from Visits__c where id =: visit.id].Account__c;
        System.debug('Visit ' + visit.id + ', account ' + accountId);
        account = [select id, name, shippingLongitude, shippingLatitude, shippingStreet, shippingCity, shippingPostalCode from Account where id =:accountId];
        initTracker();
    }
    
    public PageReference initTracker() {
        String lat, lon;
        System.debug('initTracker from visit ' + this.visit.id);

        
        // Convert to locations that can be mapped
        startlocations = new List<Map<String,Double>>();
        stoplocations = new List<Map<String,Double>>();
        accountLocations = new List<Map<String,Double>>();

        if(visit.Start_Location_Latitude__c!=null && visit.Start_Location_Latitude__c!=0){
            startlocations.add(
                new Map<String,Double>{ 'latitude' => visit.Start_Location_Latitude__c, 'longitude' => visit.Start_Location_Longitude__c}
            );
        }
        if(visit.Stop_Location_Latitude__c!=null && visit.Stop_Location_Latitude__c!=0){
            stoplocations.add(
                new Map<String,Double>{ 'latitude' => visit.Stop_Location_Latitude__c, 'longitude' => visit.Stop_Location_Longitude__c}
            );
        }
        accountLocations.add(
            new Map<String,Double>{ 'latitude' => account.ShippingLatitude, 'longitude' => account.ShippingLongitude}
        );
        
        return null;
    }
    
}