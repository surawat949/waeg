@isTest
public with sharing class HOYAConstants_Test {
    public HOYAConstants_Test() {

    }

    public static TestMethod void testConstants() {
        
        Test.startTest();
        System.assertEquals('Please choose portal to send email', HOYAConstants.CHOOSE_PORTAL);
        Test.stopTest();
    }
}