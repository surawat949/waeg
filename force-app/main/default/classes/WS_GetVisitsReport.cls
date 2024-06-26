/**
 * This web service is used to send the Accounts with Visits Report for HLBR
 * 
 */
@RestResource(urlMapping = '/GetVisitsReport')
global class WS_GetVisitsReport {
    public WS_GetVisitsReport(){}
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
            if(!String.isBlank(dateRange.status) && dateRange.status == 'Complete'){
                visits = [SELECT Id,Account__r.Industry,Visit_assigned_to__c,Assigned_to_Sales_Role__c,Account__r.Name,Hoya_Account_ID__c,Account__r.DMU__c,
                                 Account__r.Shop_Name__c,Account__r.RecordType.DeveloperName,Visit_Status__c,Visit_Type__c,Visit_Reason__c,Start_Time__c,End_Time__c,Name,Visit_Notes__c,
                                 Account__r.Segmentation_Box__c,Account__r.Manual_Segment__c,Account__r.Visionary_Alliance__c,Account__r.Myo_Smart_AuthorizeDealer__c,Account__r.Agreed_Visits__c,Account__r.Visit_Frequency_Status__c,
                          		 CreatedDate,LastModifiedDate,LastActivityDate,Start_Day__c,Visit_completed_date__c,Account__r.Shop_State__c,
                                 Account__r.Shop_City__c FROM Visits__c WHERE Visit_Status__c='Complete'
                                 AND Start_Time__c >=: startDate AND Start_Time__c <=: endDate AND Account__r.Owner.CompanyName='HLBR'];
                List<CompletedVisitsWrapper> visitWrapperLst = new List<CompletedVisitsWrapper>();
                if(visits.size() > 0 ){
                    for(Visits__c visit : visits){
                        CompletedVisitsWrapper wrapper = new CompletedVisitsWrapper();
                        wrapper.industry = visit.Account__r.Industry;
                        wrapper.visitAssignedTo = visit.Visit_assigned_to__c;
                        wrapper.assignedToSalesRole = visit.Assigned_to_Sales_Role__c;
                        wrapper.accountName = visit.Account__r.Name;
                        wrapper.hoyaAccountId = visit.Hoya_Account_ID__c;
                        wrapper.decisionMakerName = visit.Account__r.DMU__c;
                        wrapper.shopName = visit.Account__r.Shop_Name__c;
                        wrapper.accountRecordType = visit.Account__r.RecordType.DeveloperName;
                        wrapper.visitStatus = visit.Visit_Status__c;
                        wrapper.visitType = visit.Visit_Type__c;
                        wrapper.visitMainObjective = visit.Visit_Reason__c;
                        wrapper.startTime = visit.Start_Time__c;
                        wrapper.endTime = visit.End_Time__c;
                        wrapper.visitId = visit.Name;
                        wrapper.visitNotes = visit.Visit_Notes__c;
                        wrapper.segment = visit.Account__r.Segmentation_Box__c;
                        wrapper.localManualSegmentation = visit.Account__r.Manual_Segment__c;
                        wrapper.visionaryAlliance = visit.Account__r.Visionary_Alliance__c;
                        wrapper.miyosmartAuthiorizedDealer = visit.Account__r.Myo_Smart_AuthorizeDealer__c;
                        wrapper.directVisitsPlanned = visit.Account__r.Agreed_Visits__c;
                        wrapper.directVisitsfrequency = visit.Account__r.Visit_Frequency_Status__c;
                        wrapper.visitCreatedDate = visit.CreatedDate;
                        wrapper.visitModifiedDate = visit.LastModifiedDate;
                        wrapper.visitLastActivityDate = visit.LastActivityDate;
                        wrapper.startDay = visit.Start_Day__c;
                        wrapper.visitCompletedDate = visit.Visit_completed_date__c;
                        wrapper.accountState = visit.Account__r.Shop_State__c;
                        wrapper.accountCity = visit.Account__r.Shop_City__c;
                        visitWrapperLst.add(wrapper);                
                    }
                } 
                res.responseBody = Blob.valueOf(JSON.serialize(visitWrapperLst));
                res.statusCode = 200;
            }
            else{
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
                        wrapper.accountRecordType = visit.Account__r.RecordType.DeveloperName;
                        wrapper.segment = visit.Account__r.Segmentation_Box__c;
                        wrapper.localManualSegmentation = visit.Account__r.Manual_Segment__c;
                        wrapper.lastMonthSales = visit.Account__r.Last_month_sales__c;
                        visitWrapperLst.add(wrapper);
                    }
                }
                res.responseBody = Blob.valueOf(JSON.serialize(visitWrapperLst));
                res.statusCode = 200;
            }           
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
    public class CompletedVisitsWrapper{
        public String industry {get;set;}
        public String visitAssignedTo {get;set;}
        public String assignedToSalesRole {get;set;}
        public String accountName {get;set;}
        public String hoyaAccountId {get;set;}
        public String decisionMakerName {get;set;}
        public String shopName {get;set;}
        public String accountRecordType {get;set;}
        public String visitStatus {get;set;}
        public String visitType {get;set;}
        public String visitMainObjective {get;set;}
        public DateTime startTime {get;set;}
        public DateTime endTime {get;set;}
        public String visitId {get;set;}
        public String visitNotes {get;set;}
        public String segment {get;set;}
        public String localManualSegmentation {get;set;}
        public String visionaryAlliance {get;set;}
        public Boolean miyosmartAuthiorizedDealer {get;set;}
        public Decimal directVisitsPlanned {get;set;}
        public String directVisitsfrequency {get;set;}
        public DateTime visitCreatedDate {get;set;}
        public DateTime visitModifiedDate {get;set;}
        public DateTime visitLastActivityDate {get;set;}
        public Date startDay {get;set;}
        public DateTime visitCompletedDate {get;set;}        
        public String accountState {get;set;}
        public String accountCity {get;set;}
    }
    global class VisitsDateRange{
        public String startDate {get;set;}
        public String endDate {get;set;}
        public String status {get;set;}
    }
}