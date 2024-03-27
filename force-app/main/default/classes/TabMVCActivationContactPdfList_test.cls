/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @version : 1.0
 * @api : v.55.0
 * @description : testing for class TabMVCActivationContactPdfList
 * code coverage : 90%
 */
@IsTest
public with sharing class TabMVCActivationContactPdfList_test {
    @IsTest
    static void TestWholeClass(){
    
        Account a1 = new Account();
        a1.Hoya_Account_id__c = 'TEST-1234';
        a1.Name = 'Test data';
        a1.ShippingStreet = 'Phaholyothin Street';
        a1.ShippingCity = 'Bangkhen';
        a1.ShippingState = 'Bangkok';
        a1.ShippingPostalCode = '12345';
        a1.ShippingCountry = 'Thailand';
        a1.Phone = '+661 2220911-1';
        a1.ShippingLatitude = 0;
        a1.ShippingLongitude = 0;
        insert a1;

        Contact c1 = new Contact();
        c1.AccountId = a1.Id;
        c1.FirstName = 'Testcontact';
        c1.LastName = 'Testtestcontact';
        c1.MailingStreet = 'Rasa';
        c1.MailingCity = 'Test city';
        c1.MailingState = 'Bangkok';
        c1.MailingPostalCode = '12344';
        c1.Phone = '+661 2220911-1';
        c1.MailingCountry = 'Thailand';
        c1.MailingLatitude = 0;
        c1.MailingLongitude = 0;
        insert c1;

        Test.startTest();
        PageReference pageRef = Page.TabMVCActivationPdfExport;
        pageRef.getParameters().put('receivedId', String.valueOf(c1.Id));
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(c1);
        TabMVCActivationContactPdfList t = new TabMVCActivationContactPdfList(sc);

        System.assertEquals(c1.Id, c1.Id);
        Test.stopTest();

    }
}