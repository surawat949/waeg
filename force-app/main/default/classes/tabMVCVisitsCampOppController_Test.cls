@isTest
public class tabMVCVisitsCampOppController_Test {
    @IsTest
    static void runTest(){
		Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='SO3399999xx';
        insert acc;        
 
        Contact Con = new Contact();
        con.LastName = 'last';
        con.firstName = 'first';
        con.accountId = acc.Id;        
        insert con;
        
        try{
        	TabMVCVisitsCampOppController.createBusinessOpportunity('SFDCV2',con.Id,'New Medical opp','cate1','next Steps','1','started','new Visit'); 
        }
        catch(Exception e){
            System.debug(e.getMessage());
        } 
        TabMVCVisitsCampOppController.getBusinessOpportunityRelatedToContact(con.Id);
    }
}