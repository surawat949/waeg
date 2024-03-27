/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @version : 1.0
 * @created date : 2023-12-07
 * @created by : Surawat Sakulmontreechai
 * @description : this test class for test LookupByUrlParamControllerNew - apex class
 */
@IsTest
public with sharing class LookupByControlURLParamNew_Test {
    public static testMethod void testLookupByUrlParamAccount() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.customerName = 'Avaya';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParamInvalidAccount() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.CustomerName = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
     public static testMethod void testLookupByUrlParamInvalidContact() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.CustomerName = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParamPhone() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '1234';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParamWherePhoneNumberIs10Chars() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '1234567891';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');//no record found
    }
    
    
    public static testMethod void testLookupByUrlParamWhereVallidPhoneNumberIs10Chars() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '2125551234';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');//no record found
    }
    
    public static testMethod void testLookupByUrlParamInvalidPhoneNumber() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');//no record found
    }
       
    public static testMethod void testLookupByUrlParamAccountNumber() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.customerNumber = '4321';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParam() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
}