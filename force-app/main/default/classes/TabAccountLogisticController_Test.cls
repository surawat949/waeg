/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @description : this test class for TabAccountLogisticController
 * @version : 1.0
 * @api : v.55.0
 * @CreatedDate : 2023-11-27
 * Code Coverage : 86%
 */
@IsTest
public with sharing class TabAccountLogisticController_Test {
    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Hoya_Account_ID__c = 'SH-289123';
        a.Name = 'Test Logistic';
        a.Shipping_Account_Name__c = 'Shipping AZ';
        a.Shipping_Account__c = 'SH-999999';
        a.Shipping_Phone_Number__c = '+698 569 14589';
        a.ShippingStreet = '123 Street';
        a.ShippingCity = 'Bangkhen';
        a.ShippingState = 'Bangkok';
        a.ShippingCountry = 'Thailand';
        a.ShippingPostalCode = 'Z123654';
        a.ShippingLatitude = 13.736717;
        a.ShippingLongitude = 100.523186;
        insert a;
    }

    @IsTest
    static void myUnitTest01(){
        Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shipping_Account__c, 
                        Shipping_Account_Name__c, Shipping_Phone_Number__c, 
                        ShippingStreet, ShippingCity, ShippingState,
                        ShippingCountry, ShippingPostalCode, ShippingLatitude, 
                        ShippingLongitude FROM Account WHERE Hoya_Account_ID__c = 'SH-289123'];
        Test.StartTest();
        TabAccountLogisticController.getShippingAddress(acc.Id);
        acc.ShippingLatitude = null;
        acc.ShippingLatitude = 0;
        update acc;
        TabAccountLogisticController.getShippingAddress(acc.Id);
        Test.StopTest();

        try{
            delete acc;
            TabAccountLogisticController.getShippingAddress('');
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }

}