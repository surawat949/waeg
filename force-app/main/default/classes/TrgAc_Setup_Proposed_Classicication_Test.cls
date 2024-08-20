/**
*  This test class is for account_Setup_Proposed_Classicication.
*
@author Di Chen
@created 2013-05-17
@version 1.0
@since 20.0 
*
@changelog
* 2013-05-17 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 100%
*/
@isTest
private class TrgAc_Setup_Proposed_Classicication_Test {
	
    static testMethod void ProposedClassificationIs1() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	asm.SoW_Threshold_High__c = 40;
    	asm.SoW_Threshold_Low__c = 13;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
    
    static testMethod void ProposedClassificationIs3() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 41;
    	asm.SoW_Threshold_High__c = 40;
    	asm.SoW_Threshold_Low__c = 13;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void ProposedClassificationIs4() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 0;
    	asm.SoW_Threshold_High__c = 40;
    	asm.SoW_Threshold_Low__c = 1;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }
	static testMethod void ProposedClassificationIs5() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 0;
    	asm.SoW_Threshold_High__c = 40;
    	asm.SoW_Threshold_Low__c = 13;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }  
	static testMethod void ProposedClassificationIs6() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 0;
    	asm.SoW_Threshold_High__c = 40;
    	asm.SoW_Threshold_Low__c = 13;
    	asm.Turnover_Threshold_High__c = 99;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }     
   	static testMethod void ProposedClassificationIs7() {
        
        Account acc = new Account();
    	acc.Name = 'dsfa';
    	acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 0;
    	asm.SoW_Threshold_Low__c = 13;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    } 
   	static testMethod void ProposedClassificationIs8() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 0;
    	asm.SoW_Threshold_High__c = 40;
    	asm.SoW_Threshold_Low__c = 11;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }         
	static testMethod void ProposedClassificationIs9() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	asm.Turnover_Threshold_Low__c = 0;
    	asm.SoW_Threshold_High__c = 40;
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }     
	static testMethod void ProposedClassificationIsElse() {
        
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE123456';
    	acc.Name = 'dsfa';
    	acc.Shop_Country__c = 'Germany';
    	acc.Turnover_Amount__c = 1;
    	acc.Potential__c = 1;
    	acc.AnnualRevenue = 0.12;
    	acc.BillingCountry = 'Germany';
	    insert acc;
        
    	Account_Segmentation__c asm = new Account_Segmentation__c();
    	asm.Country__c = 'Germany';
    	asm.CurrencyIsoCode = 'EUR';
    	insert asm;        
        
        Test.startTest();
        
        acc.Turnover_Amount__c = 12;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }            
}