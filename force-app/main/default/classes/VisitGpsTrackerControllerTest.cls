/**
 * This is a test class for VisitGpsTrackerController
 *
 @author cdupre
 @created 2018-09-25
 *
 */
@isTest
public class VisitGpsTrackerControllerTest {
	static testMethod void testCtrl(){
        Test.startTest();
        Account acc = new Account();
        acc.Name='Location tracking test account';
        acc.hoya_account_id__c='xxxcduTest';
        acc.RecordTypeId='012b00000000P38';
        insert acc;
        System.debug('[VisitGpsTrackerControllerTest]account created');
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.id;
        visit.MKT_No_campaign_presented__c=true;
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        System.debug('[VisitGpsTrackerControllerTest]visit created');
        ApexPages.StandardController sc = new ApexPages.StandardController(visit);
        VisitGpsTrackerController ctrl = new VisitGpsTrackerController(sc);
        ctrl.initTracker();
        System.debug('[VisitGpsTrackerControllerTest]TEST OK');
        Test.stopTest();
    }
}