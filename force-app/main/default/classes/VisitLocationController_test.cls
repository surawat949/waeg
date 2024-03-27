/**
 * This is a test class for VisitLocationController
 *
 @author cdupre
 @created 2018-09-25
 *
 */
@isTest
public class VisitLocationController_test {
    static testMethod void testCtrl(){
        Test.startTest();
        Account acc = new Account();
        acc.Name='Location test account';
        acc.hoya_account_id__c='xxxcduTest';
        acc.RecordTypeId='012b00000000P38';
        insert acc;
        System.debug('[VisitLocationController_test]account created');
        Visits__c visit = new Visits__c();
        visit.Account__c = acc.id;
        visit.MKT_No_campaign_presented__c=true;
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
        System.debug('[VisitLocationController_test]visit created');
        ApexPages.StandardController sc = new ApexPages.StandardController(visit);
        VisitLocationController ctrl = new VisitLocationController(sc);
        ctrl.doStart();
        ctrl.doStop();
        System.debug('[VisitLocationController_test]TEST OK');
        Test.stopTest();
        
    }

}