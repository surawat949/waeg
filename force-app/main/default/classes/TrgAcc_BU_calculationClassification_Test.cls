/**
*  This test class is for Account_BU_calculationClassification.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 84%
*/
@isTest
private class TrgAcc_BU_calculationClassification_Test {

	static testMethod void testBU1() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 101;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c = 66;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }    
	static testMethod void testBU2() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 44;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c = 66;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }        
    static testMethod void testBU3() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 12;
    	acc.Potential__c = 12;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c = 13;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }    
	static testMethod void testBU4() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 101;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c = 201;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }       
	static testMethod void testBU5() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	//acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 141;
    	//acc.BillingCountry = 'Germany';
    	//acc.ShippingCountry  = 'Germany';
    	//acc.Shop_Country__c  = 'Germany';
    	acc.Proposed_Classification__c = '1';
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c = 201;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }       
	static testMethod void testBU6() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 141;
    	acc.AnnualRevenue = 0;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 421;
    	asm.SoW_Threshold_Low__c = 42.1;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }       
	static testMethod void testBU7() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 141;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 3;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 421;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 40;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU8() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 141;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 2;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 421;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 40;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU9() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 3;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 421;
    	asm.SoW_Threshold_Low__c = 50;
    	asm.SoW_Threshold_High__c = 60;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU10() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 3;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 421;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 40;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU11() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 3;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 421;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 30;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU12() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 20;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 21;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 30;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU13() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 3;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 21;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 30;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void testBU14() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 3;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 21;
    	asm.SoW_Threshold_Low__c = 10;
    	asm.SoW_Threshold_High__c = 20;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }

	static testMethod void testBU15() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.BillingCountry = 'Germany';
    	acc.ShippingCountry  = 'Germany';
    	acc.Turnover_Amount__c = 30;
    	acc.AnnualRevenue = 1;
    	acc.Potential__c = 2;
	    insert acc;
    	
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 21;
    	asm.SoW_Threshold_Low__c = 40;
    	asm.SoW_Threshold_High__c = 75;
    	asm.Turnover_Threshold_High__c = 22;
    	insert asm;
    	
        Test.startTest();
        
    	acc.Turnover_Amount__c  = 222;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
}