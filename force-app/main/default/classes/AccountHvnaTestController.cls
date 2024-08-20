@isTest
public class AccountHvnaTestController {
    public static testMethod void testHvnaController() {
        Test.startTest();
        //create account for test
        List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name='hvna test account';
        a.Hoya_Account_ID__c='USTEST54321';
        a.OwnerId = UserInfo.getUserId();
        a.CurrencyIsoCode = 'EUR';
        accList.add(a);
        Account b = new Account();
        b.Name='hvna test account2';
        b.Hoya_Account_ID__c='US';
        b.OwnerId = UserInfo.getUserId();
        b.CurrencyIsoCode = 'EUR';
        b.Actuals_April_Current_Year__c=100;
        accList.add(b);
        insert accList;
        update a;
        System.debug('1.AccountHvnaTestController - Account created, id=' + a.id + '('+a.Additionnal_account_data__c+')');
        //control additional account data
        if(a.Additionnal_account_data__c==null){
            System.debug('2.AccountHvnaTestController - additional account data is null xxxxxx');
            Additionnal_account_data__c aad = [select id from Additionnal_account_data__c where hoya_account_id__c = :a.hoya_account_id__c];//new Additionnal_account_data__c();
            System.debug('3.AccountHvnaTestController - aad.id=' + aad.id);
            a.additionnal_account_data__c = aad.id;
            update a;
            System.debug('4.AccountHvnaTestController - account update success');
        } else {
            System.debug('***** Additional account data created successfully *****');
        }
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        if(sc==null){
            System.debug('xxxxxx Standard controller is null xxxxxx');
        } 
        
        //System.debug('5.AccountHvnaFindProviderController - Test.AccountHvnaFindProviderController start');
        AccountHvnaFindProviderController ctrl1 = new AccountHvnaFindProviderController(sc);
        ctrl1.edit();
        ctrl1.save();
        
        //System.debug('6.AccountHvnaCollectionsController - Test.AccountHvnaFindProviderController start');
        AccountHvnaCollectionsController ctrl2 = new AccountHvnaCollectionsController(sc);
        ctrl2.edit();
        ctrl2.save();
        
        //System.debug('7.AccountHvnaConcessionDealController - Test.AccountHvnaFindProviderController start');
        AccountHvnaConcessionDealController ctrl3 = new AccountHvnaConcessionDealController(sc);
        //ctrl3.edit();
        ctrl3.save();
        
        //System.debug('8.AccountHvnaCouponController - Test.AccountHvnaFindProviderController start');
        AccountHvnaCouponController ctrl4 = new AccountHvnaCouponController(sc);
        ctrl4.save();
        
        //System.debug('9.AccountHvnaDescriptionController - Test.AccountHvnaFindProviderController start');
        AccountHvnaDescriptionController ctrl5 = new AccountHvnaDescriptionController(sc);
        ctrl5.save();
        
        //System.debug('10.AccountHvnaFlagsController - Test.AccountHvnaFindProviderController start');
        AccountHvnaFlagsController ctrl6 = new AccountHvnaFlagsController(sc);
        ctrl6.save();
        
        //System.debug('11.accountHvnaInformationController - Test.AccountHvnaFindProviderController start');
        accountHvnaInformationController ctrl7 = new accountHvnaInformationController(sc);
        ctrl7.save();
        
        //System.debug('12.AccountHvnaLeadsController - Test.AccountHvnaFindProviderController start');
        AccountHvnaLeadsController ctrl8 = new AccountHvnaLeadsController(sc);
        ctrl8.save();
        
        //System.debug('13.AccountHvnaMarketingPgmController - Test.AccountHvnaFindProviderController start');
        AccountHvnaMarketingPgmController ctrl9 = new AccountHvnaMarketingPgmController(sc);
        ctrl9.save();
        
        //System.debug('14.AccountHvnaOyeController - Test.AccountHvnaFindProviderController start');
        AccountHvnaOyeController ctrl10 = new AccountHvnaOyeController(sc);
        ctrl10.save();
        
        //System.debug('15.AccountHvnaPracticePreferenceController - Test.AccountHvnaFindProviderController start');
        AccountHvnaPracticePreferenceController ctrl11 = new AccountHvnaPracticePreferenceController(sc);
        ctrl11.save();
        
        //System.debug('16.AccountHvnaPracticeProfileController - Test.AccountHvnaFindProviderController start');
		AccountHvnaPracticeProfileController ctrl12 = new AccountHvnaPracticeProfileController(sc);
        ctrl11.save();
        
        //System.debug('17.AccountHvnaSalesPageController - Test.AccountHvnaFindProviderController start');
        AccountHvnaSalesPageController ctrl13 = new AccountHvnaSalesPageController(sc);
        ctrl13.getConversionRate();
        ctrl13.save();
        
        QvQueryPageController ctrl14 = new QvQueryPageController(sc);
        QvSalesAccountWithSameParentController ctrl15 = new QvSalesAccountWithSameParentController(sc);
        
        AccountHolkSpecificController ctrl16 = new AccountHolkSpecificController(sc);
        System.debug('18.all Tests done with success');
        Test.stopTest();
    }
}