/**
 * This web service is used to send the Accounts with Visits started in last 30 days Report for HLBR
 * 
 */
@RestResource(urlMapping = '/GetLast30DayVisitsReport')
global class WS_GetLast30DayVisitsReport {
    global WS_GetLast30DayVisitsReport(){
        
    }
    @HttpPost
    global static void getVisitsReport() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        } 		
        String userJson = RestContext.request.requestBody.toString();
        VisitsDateRange dateRange;
        try {
            dateRange = (VisitsDateRange) JSON.deserialize(userJson, VisitsDateRange.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
        System.debug(dateRange.endDate);        
        if ( String.isBlank(dateRange.startDate) || String.isBlank(dateRange.endDate)) {
            res.responseBody = Blob.valueOf('Missing Fields (Start Date, End Date)');
            res.statusCode = 400;
            return;
        }
        try{
            Date startRange = date.parse(dateRange.startDate);
            Date endRange = date.parse(dateRange.endDate);
            Integer d = startRange.day();
            Integer mo = startRange.month();
            Integer yr = startRange.year();
            
            DateTime startDate = DateTime.newInstance(yr, mo, d);
            
            Integer endDay = endRange.day();
            Integer endmo = endRange.month();
            Integer endyr = endRange.year();
            
            DateTime endDate = DateTime.newInstance(endyr, endmo, endDay);
        
            List<Visits__c> visits =new List<Visits__c>();
            visits = [SELECT Id,Name,Visit_assigned_to__c,Visit_Status__c,Start_Time__c,
                           Hoya_Account_ID__c,Account__r.Name,Account__r.DMU__c,Account__r.Shop_State__c,
                           Account__r.Shop_City__c,Visit_Type__c,Account__r.RecordType.DeveloperName,Account__r.Segmentation_Box__c,
                           Account__r.Manual_Segment__c,Account__r.Last_month_sales__c
                           FROM Visits__c WHERE Start_Time__c >=: startDate AND Start_Time__c <=: endDate AND (NOT (Account__r.Name LIKE '%AUSENCIA%'))
                           AND Account__r.Owner.CompanyName='HLBR'];
            List<VisitsWrapper> visitWrapperLst = new List<VisitsWrapper>();
            if(visits.size() > 0){
                for(Visits__c visit: visits){
                    VisitsWrapper wrapper = new VisitsWrapper();
                    wrapper.visitsAssignedTo = visit.Visit_assigned_to__c;
                    wrapper.visitStatus = visit.Visit_Status__c;
                    wrapper.start = visit.Start_Time__c;
                    wrapper.hoyaAccountId = visit.Hoya_Account_ID__c;
                    wrapper.accountName = visit.Account__r.Name;
                    wrapper.decisionMakerName = visit.Account__r.DMU__c;
                    wrapper.accountState = visit.Account__r.Shop_State__c;
                    wrapper.accountCity = visit.Account__r.Shop_City__c;
                    wrapper.visitId = visit.Name;
                    wrapper.visitType = visit.Visit_Type__c;
                    wrapper.accountRecordType = visit.Account__r.RecordTypeId;
                    wrapper.segment = visit.Account__r.Segmentation_Box__c;
                    wrapper.localManualSegmentation = visit.Account__r.Manual_Segment__c;
                    wrapper.lastMonthSales = visit.Account__r.Last_month_sales__c;
                    visitWrapperLst.add(wrapper);
                }
            }
            res.responseBody = Blob.valueOf(JSON.serialize(visitWrapperLst));
            res.statusCode = 200;
        }
        Catch(Exception e){
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }        
    }
    
    public class VisitsWrapper{
        public String visitsAssignedTo {get;set;}
        public String visitStatus {get;set;}
        public DateTime start {get;set;}
        public String hoyaAccountId {get;set;}
        public String accountName {get;set;}
        public String decisionMakerName {get;set;}
        public String accountState {get;set;}
        public String accountCity {get;set;}
        public String visitId {get;set;}
        public String visitType {get;set;}
        public String accountRecordType {get;set;}
        public String segment {get;set;}
        public String localManualSegmentation {get;set;}
        public Decimal lastMonthSales {get;set;}
        
    }
    global class VisitsDateRange{
        public String startDate {get;set;}
        public String endDate {get;set;}
    }
}