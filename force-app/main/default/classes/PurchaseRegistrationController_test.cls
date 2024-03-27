@IsTest
public with sharing class PurchaseRegistrationController_test {
    public PurchaseRegistrationController_test() {
    }
    @isTest
    static void runPurchaseRegistrationCtrl(){

        Test.startTest();
        Account a = new Account();
        a.Name='registration test account';
        a.hoya_account_id__c='US3399999xx';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'xyz';
        c.LastName = 'azerty';
        c.email = 'aabb@gmail.com';
        c.AccountId = a.Id;

        insert c;

        Purchase_Registration__c p = new Purchase_Registration__c();
        p.DeliveryDate__c = System.today();
        p.winner__c=false;
        p.Contact__c = c.Id;
        p.MembersOnlyParticipate__c = true;
        p.Hash__c ='ldfg holkxfghjxck ighj xkcgjvhbx kjghsdklifhsdo';

        insert p;

        
        Account a2 = new Account();
        a2.Name='registration test account';
        a2.CurrencyIsoCode = 'EUR';
        a2.hoya_account_id__c='SO3599999xx';
        insert a2;
        
        Contact c2 = new Contact();
        c2.FirstName = 'xyz1134';
        c2.LastName = 'azerty1451';
        c2.email = 'aabb1@gmail451.com';
        c2.AccountId = a2.Id;
        insert c2;
        
        List<Purchase_Registration__c> plistTest = new   List<Purchase_Registration__c>();
        
        Purchase_Registration__c p2 = new Purchase_Registration__c();
        p2.DeliveryDate__c = System.today();
        p2.winner__c=false;
        p2.Contact__c = c2.Id;
        p2.MembersOnlyParticipate__c = true;
        p2.Absolute_Sifting_Question__c=16;
        p2.Hash__c ='ldfg holkxfghjxck i2hj xkcgjvhbx kjghsdklifhsdd';
        plistTest.add(p2);
        
        
        Purchase_Registration__c p3 = new Purchase_Registration__c();
        p3.DeliveryDate__c = System.today();
        p3.winner__c=false;
        p3.Contact__c = c2.Id;
        p3.MembersOnlyParticipate__c = true;
        p3.Absolute_Sifting_Question__c=16;
        p3.Hash__c ='ldfg holkxfgijxck i2hj xkcgjvhbx kjghsdklifhsdd';

        plistTest.add(p3);
        
        insert plistTest;
        
        PurchaseRegistrationController.getCountryList();
        PurchaseRegistrationController.getSeikoNetworkList();
        PurchaseRegistrationController.GetWinnerList(false, '');
        PurchaseRegistrationController.getPickaWinner('France', '01', '2021', '', '');
        PurchaseRegistrationController.getPickaWinner('France', '01', '2021', 'SVS', '');
        PurchaseRegistrationController.getPickaWinner('France', '01', '2021', '', 'AO');
        PurchaseRegistrationController.getPickaWinner('France', '01', '2021', 'SVS', 'AO');
             
        PurchaseRegistrationController.pickWinnerRandomly('France', '01', '2021', 'test@gmail.com');
        PurchaseRegistrationController.createCsvAndEmail(p,plistTest,'test@gmail.com', '01', '2021', 'France');
        
        PurchaseRegistrationController.removeWinner(p.Id);
        
        try{
            PurchaseRegistrationController.checkRegistrationCode('xxx', 'country');
        } catch(Exception e){
            System.debug(e);
        }
    }
}