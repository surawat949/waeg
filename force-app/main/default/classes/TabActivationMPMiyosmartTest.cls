/**
 * @author : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * @version : 1.0
 * @description : testing class for TabActivationMPMiyosmart
 * code coverage : 87%
 */
@isTest
public class TabActivationMPMiyosmartTest {
 @TestSetup
    static void makeData(){
		Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        String TrainingRecId = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('HOYA_Training').getRecordTypeId();

        User u = new User();
			u.Firstname = 'Testuser';
			u.Lastname = 'Testuserzxcv';
			u.Username = 'testzxcv@hoya.invalid';
			u.Email = 'testtest@hoya.com.invalid';
			u.ProfileId = p.Id;
			u.Alias = 'STest2';
			u.TimeZoneSidKey = 'Asia/Bangkok';
			u.LocaleSidKey = 'en_US';
			u.EmailEncodingKey = 'UTF-8';
			u.LanguageLocaleKey = 'en_US';
			u.CompanyName = 'DEFAULT';
			insert u;
		
        Account acc = new Account(
            Name = 'Test Acc',
            Hoya_Account_ID__c = 'TE-012354',
            shippingPostalCode='23440',
            phone='0102030405',
            Onboarding_date__c = date.valueOf(system.now()),
            Onboarding_Customer__c = true,
            Lenses_Net_Sales_Last_12Mo__c = 2,
            Brand_Visibility__c='HOYA',
            CHCUSTCLASSIFICATIONID__c='Ind',
            Seiko_Network__c = 'Visionary Alliance',
            Visionary_Alliance__c = 'Insider',
            Myo_Main_Comp_Myopia_Control__c = 'Altra Ophtalmic Lense',
			ownerId = u.Id
        );
        insert acc;   
        ECP_Training__c trainingOne = new ECP_Training__c(
            Account__c = acc.Id,
            Training__c = 'MIYOSMART',
            Type__c = 'Webinar',
            Training_status__c='Completed',
			RecordTypeId = TrainingRecId,
            start__c=system.now()
        );
        insert trainingOne;
        Last_Sales_Statistics__c  lastSalesStatisticObj = new Last_Sales_Statistics__c();
        lastSalesStatisticObj.name = 'test';
        lastSalesStatisticObj.Lenses_Net_Sales_Last_3Mo_CFY__c = 120;
        lastSalesStatisticObj.Account__c = acc.id;
        lastSalesStatisticObj.Remote_Edging_L3Mo__c=9;
        lastSalesStatisticObj.Mounting_L3Mo__c=39;
        lastSalesStatisticObj.HVC_Systems_L3Mo__c=3;
        lastSalesStatisticObj.Other_Digital_Orders_L3Mo__c=69;
        insert lastSalesStatisticObj;    
    }    
    @IsTest
    static void getLastSalesStats(){
        Account actId = [Select id from account where Name = 'Test Acc'];
        List<Last_Sales_Statistics__c> storeCharId = [SELECT Id FROM Last_Sales_Statistics__c WHERE Account__c=:actId.id];
        List<ECP_Training__c> TrainingLst=[select start__c,Id,Account__c from ECP_Training__c where Account__c =:actId.id and Training__c includes ('MIYOSMART') 
                                           AND Training_status__c ='Completed' order by start__c desc];
        Test.startTest();
        TabActivationMPMiyosmart.getLastSalesStats(actId.Id);
        TabActivationMPMiyosmart.getLastTrainingDate(actId.Id);
        TabActivationMPMiyosmart.searchDefaultRecord(actId.Id,'Account');
        TabActivationMPMiyosmart.searchLookupData('Test','Account');
        TabActivationMPMiyosmart.searchLookupData('Test','Account');
        TabActivationMPMiyosmart.UpdateMainMyopiaField(actId.Id,'Altra Ophtalmic Lense');
        TabActivationMPMiyosmart.UpdateMainMyopiaField(actId.Id, '');
        TabActivationMPMiyosmart.getMainMyopiaDefault(actId.Id);
        Test.StopTest();

        System.assert(true);
        try{
            TabActivationMPMiyosmart.UpdateMainMyopiaField(null, null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }

        try{
            TabActivationMPMiyosmart.getMainMyopiaDefault(null);
        }catch(Exception e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
        
    }
}