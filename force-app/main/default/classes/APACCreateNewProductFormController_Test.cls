/**
 * @description         :   Testing class for APACCreateNewProductFormController.cls
 * @Author              :   Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
 * @group               :
 * @created date        :   2023-05-26
 * @created by          :   Surawat Sakulmontreechai
 * @Lastmodified date   :   2023-05-26
 * @Lastmodified by     :   Surawat Sakulmontreechai
 * 
 */
@isTest
public with sharing class APACCreateNewProductFormController_Test {
    public APACCreateNewProductFormController_Test() {

    }

    @TestSetup
    static void makeData(){
        APAC_Product__c a = new APAC_Product__c();
        a.APAC_Company_Entity__c = 'HOLM';
        a.APAC_Request_Type__c = 'New Product Introduction';
        a.APAC_Product_Name__c = 'TEST';
        a.APAC_Product_Code__c = '111111';
        a.APAC_Product_Coating__c = 'HARD-HV';
        a.CurrencyIsoCode = 'EUR';
        insert a;

        APAC_Product__c a1 = new APAC_Product__c();
        a1.APAC_Company_Entity__c = 'HOLM';
        a1.APAC_Request_Type__c = 'Product Conversion';
        a1.APAC_Product_Name__c = 'TEST2';
        a1.APAC_Product_Code__c = '222222';
        a1.APAC_Product_Coating__c = 'HARD-VP';
        a1.CurrencyIsoCode = 'EUR';
        insert a1;

        APAC_Product__c a2 = new APAC_Product__c();
        a2.APAC_Company_Entity__c = 'ILENS';
        a2.APAC_Request_Type__c = 'Product Removal';
        a2.APAC_Product_Name__c = 'TEST3';
        a2.APAC_Product_Code__c = '333333';
        a2.APAC_Product_Coating__c = 'HARD-SFT';
        a2.CurrencyIsoCode = 'EUR';
        insert a2;

        APAC_Product__c a3 = new APAC_Product__c();
        a3.APAC_Company_Entity__c = 'ILENS';
        a3.APAC_Request_Type__c = 'Product Removal';
        a3.APAC_Product_Name__c = 'TEST4';
        a3.APAC_Product_Code__c = '44444';
        a3.APAC_Product_Coating__c = 'HARD-SFT';
        a3.Approval_Status__c = true;
        a3.CurrencyIsoCode = 'EUR';
        insert a3;
    }

    @isTest
    static void testwholeData(){
        Id recordId = [SELECT Id FROM APAC_Product__c WHERE APAC_Product_Code__c='111111' LIMIT 1].Id;
        Id recordId2 = [SELECT Id FROM APAC_Product__c WHERE APAC_Product_Code__c='44444' LIMIT 1].Id;
        //Id recordId3 = [SELECT Id FROM APAC_Product__c WHERE APAC_Product_Code__c='555555' LIMIT 1].Id;
        APAC_Product__c a = [SELECT Id, Name FROM APAC_Product__c WHERE APAC_Product_Code__c='111111' LIMIT 1];
        
        Test.StartTest();
        APACCreateNewProductFormController.getListViews();
        APACCreateNewProductFormController.getVisitRequesType(recordId);
        APACCreateNewProductFormController.getVisitRequesType(null);
        APACCreateNewProductFormController.getProductListRecord(recordId);
        APACCreateNewProductFormController.getProductListRecord(null);
        APACCreateNewProductFormController.getApprovedString(recordId);
        APACCreateNewProductFormController.getApprovedString(recordId2);
        Test.StopTest();

        try{
            APACCreateNewProductFormController.getApprovedString(null);
        }catch(Exception e){
            return;
        }
        
        System.assert(false, 'a dml exception was expected but was not thrown');
    }
}