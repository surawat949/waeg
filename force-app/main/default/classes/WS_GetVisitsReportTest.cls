@isTest
public class WS_GetVisitsReportTest {
@TestSetup
    static void makeData(){
        User brazilUser = [select Id from User where CompanyName = 'HLBR' AND IsActive = true limit 1];

        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='TE-3399999xx';
        acc.OwnerId = brazilUser.Id;
        insert acc; 
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.Id;
        visit.Start_Time__c = DateTime.newInstance(2024,02,01);
        visit.End_Time__c = DateTime.newInstance(2024,02,03);
        visit.Visit_Status__c = 'Complete';
        visit.Assigned_to__c = brazilUser.Id;
        insert visit;
    }
    @isTest 
    static void testgetVisitsReport() {
        Test.startTest();	
        RestRequest request = new RestRequest();        
        RestResponse response = new RestResponse();
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetVisitsReport';
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = response;
        // No Body 400
        WS_GetVisitsReport.getVisitsReport();
        String responseBody = response.responseBody.toString();
        System.assertEquals('Request Body is empty.', responseBody);
        
        VisitsDateRange range =new VisitsDateRange();
        
		range.startDate  = '01/02/2024';
        range.endDate   = '10/02/2024';
		String myJSON = JSON.serialize(range);
        request.requestBody = Blob.valueof(myJSON);

        WS_GetVisitsReport.getVisitsReport();
        responseBody = response.responseBody.toString();
        //completed visits
        VisitsDateRange range2 =new VisitsDateRange();
        
		range2.startDate  = '01/02/2024';
        range2.endDate   = '10/02/2024';
        range2.status = 'Complete';
		String myJSON2= JSON.serialize(range2);
        request.requestBody = Blob.valueof(myJSON2);

        WS_GetVisitsReport.getVisitsReport();
        responseBody = response.responseBody.toString();
        
         // Missing attributes
 		VisitsDateRange range1 =new VisitsDateRange();
        range1.startDate  = '01/02/2024';
        String myJSON1 = JSON.serialize(range1);
		request.requestBody = Blob.valueof(myJSON1);

        WS_GetVisitsReport.getVisitsReport();
        responseBody = response.responseBody.toString();
        System.assertEquals('Missing Fields (Start Date, End Date)', responseBody);        
        WS_GetVisitsReport.getVisitsReport(); 
        
       	Test.stopTest();
    }
    private class VisitsDateRange{
        public String startDate {get;set;}
        public String endDate {get;set;}
        public String status {get;set;}
    }
}