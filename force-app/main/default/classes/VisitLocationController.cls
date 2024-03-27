global with sharing class VisitLocationController {
   
    public List<Map<String,Double>> locations { get; private set; }

    private ApexPages.StandardController sc;
    public Visits__c visit {get;set;}
    public Account account {get;set;}
    public Double userLatitude {get;set;}
    public Double userLongitude {get;set;}
    public String visitNote{get;set;}
    
	public VisitLocationController(ApexPages.StandardController stdController){
        System.debug('Constructor VisitLocationController');
        this.visit = [select id, name
                      , Start_location_time__c, Stop_Location_Time__c, Start_Location_Latitude__c , Start_Location_Longitude__c
                      , Stop_Location_Latitude__c, Stop_Location_Longitude__c
                      , Visit_notes__c, Start_Shop_Distance__c, Stop_Shop_Distance__c
                      from Visits__c where id=:stDController.getRecord().Id];
        this.sc = stdController;
        String accountId = [select Account__c from Visits__c where id =: visit.id].Account__c;
        System.debug('Visit ' + visit.id + ', account ' + accountId);
        account = [select id, name, shippingLongitude, shippingLatitude, shippingStreet, shippingCity, shippingPostalCode from Account where id =:accountId];
        currentPosition = String.valueOf(account.shippingLatitude+','+account.ShippingLongitude);
        System.debug(currentPosition);
        findNearBy();
    }
    
    public String currentPosition { 
        get {
           // if (String.isBlank(currentPosition)) {
           //     currentPosition = '48.91370127008423,2.3818564752299'; 
           // }
            return currentPosition;
        }
        set; 
    }
    
    public Boolean resultsAvailable {
        get {
            if(locations == Null) {
                return false;
            }
            return true;
        }
    }
    
    public PageReference findNearby() {
        String lat, lon;
        System.debug('FindNearBy fo visit ' + this.visit.id);

        // FRAGILE: You'll want a better lat/long parsing routine
        // Format: "<latitude>,<longitude>" (must have comma, but only one comma)
        List<String> latlon = currentPosition.split(',');
        lat = latlon[0].trim();
        lon = latlon[1].trim();

        // SOQL query to get the nearest warehouses
        String queryString =
           'SELECT Id, Name, ShippingLatitude, ShippingLongitude ' +
           'FROM Account ' +
           //'WHERE DISTANCE(ShippingAddress, GEOLOCATION('+lat+','+lon+'), \'mi\') < 1 ' +
           //'LIMIT 3'
           ' WHERE id=\''+this.account.id+'\''
           ;

        // Run the query
        List <Account> warehouses = database.Query(queryString);
        
        if(0 < warehouses.size()) {
            // Convert to locations that can be mapped
            locations = new List<Map<String,Double>>();
            for (Account wh : warehouses) {
                locations.add(
                    new Map<String,Double>{
                        'latitude' => wh.ShippingLatitude, 
                        'longitude' => wh.ShippingLongitude
                    }
                );
            }
        }
        else {
            System.debug('No results. Query: ' + queryString);
        }
                
        return null;
    }
    

    public PageReference doStart()
    {
        PageReference pr= new PageReference('/lightning/r/Visits__c/'+this.visit.id+'/view');
        this.visit.Start_Location_Latitude__c=userLatitude;
        this.visit.Start_Location_Longitude__c=userLongitude;
        this.visit.Start_location_time__c = System.now();
        this.visit.Start_Shop_Distance__c = getDistance(userLatitude, userLongitude, this.account.shippingLatitude, this.account.shippingLongitude);
        System.debug('[update]start latitude=' + this.visit.Start_Location_Latitude__c);
        System.debug('[update]start longitude=' + this.visit.Start_Location_Longitude__c);
        update this.visit;
        return pr;
    }
    
    public PageReference doStop()
    {
        PageReference pr= new PageReference('/lightning/r/Visits__c/'+this.visit.id+'/view');
        this.visit.Stop_Location_Latitude__c=userLatitude;
        this.visit.Stop_Location_Longitude__c=userLongitude;
        this.visit.Stop_Location_Time__c = System.now();
        this.visit.End_Time__c = this.visit.Stop_Location_Time__c;
        this.visit.Start_Time__c = this.visit.Start_Location_Time__c;
        this.visit.Visit_Status__c='Complete';
        this.visit.Visit_Notes__c=visitNote;
        this.visit.Stop_Shop_Distance__c = getDistance(userLatitude, userLongitude, this.account.shippingLatitude, this.account.shippingLongitude);
        this.visit.Start_Stop_Distance__c = getDistance(userLatitude, userLongitude, this.visit.Start_Location_Latitude__c, this.visit.Start_Location_Longitude__c);
        System.debug('[update]stop latitude=' + this.visit.Stop_Location_Latitude__c);
        System.debug('[update]stop longitude=' + this.visit.Stop_Location_Longitude__c);
        update this.visit;
        return pr;
    }
    
    private Decimal getDistance(Decimal lat1, Decimal long1, Decimal lat2, Decimal long2){
        Location loc1 = Location.newInstance(lat1, long1);
		Location loc2 = Location.newInstance(lat2, long2);
        return Location.getDistance(loc1, loc2, 'km');
    }
}