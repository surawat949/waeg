@isTest
public class WS_GetUserPerformanceYTDTest {
    @TestSetup
    static void makeData(){
        User brazilUser = [select Id from User where CompanyName = 'HLBR' AND IsActive = true AND Sales_Role__c IN ('AMS','AMV','ASM','KAM','NMM','NSM','RSM') limit 1];
        
        Budget_by_ASM__c budget = new Budget_by_ASM__c();
        budget.LookupUser__c= brazilUser.Id;
        budget.OwnerId = brazilUser.Id;
        budget.On_PIP__c = false;
        budget.PIP_not_Appropriate__c  = false;
        insert budget;        
    }
	@isTest 
    static void testGetUserPerformanceReport() {
        Test.startTest();	
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/GetUserPerformanceYTD';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;
        WS_GetUserPerformanceYTD.getPerformanceYTDReport();
        String responseBody = response.responseBody.toString();
       	Test.stopTest();
    }
   
}