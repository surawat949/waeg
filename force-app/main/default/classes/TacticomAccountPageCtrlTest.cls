@isTest
public class TacticomAccountPageCtrlTest {
    static testMethod void testCtrl() {

         Test.startTest();
         
         Account hlfr = new account();
         hlfr.name='HLFR tacticom test';
         hlfr.tacticom_hlfr__c = 'Sub-area 1';
         hlfr.hoya_account_id__c = 'FR010000';
         insert hlfr;

         Account sof = new account();
         sof.name = 'SOF tacticom test';
         sof.tacticom_sof__c = 'Sub-area 2';
         sof.hoya_account_id__c = 'SO33000001';
         insert sof;

         Door__c door = new Door__c();
         door.Name='Door Tacticom test';
         door.geolocation__Latitude__s = -0.4499211834313624;
         door.geolocation__Longitude__s = 46.31938397907691;
         door.Main_Account__c = hlfr.id;
         insert door;

         hlfr.door__c = door.id;
         sof.door__c = door.id;
         update hlfr;
         update sof;

         ApexPages.StandardController sc = new ApexPages.StandardController(hlfr);

         TacticomAccountPageController ctrl = new TacticomAccountPageController(sc);
         system.assert(true);
         Test.stopTest();
    }
}