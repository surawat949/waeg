/*
* @Author : Austin A
* @Class name : VisitPlanningV2ControllerTest
* Created date : 2024-04-23
* @Created by : Austin A
* @Description : Test class for VisitPlanningV2Controller
*/
@isTest
public class VisitPlanningV2ControllerTest {
    @isTest
	static void testVPMV2Controller() {
        VisitPlanningV2Controller.getAccountListViews();
        VisitPlanningV2Controller.getCampaignOptions('true');
        Map<String,String> objectFields = new Map<String, String>{'TACTICOM_SOF__c' =>'Account'};
        List<Map<String, String>> objectFieldMap = new List<Map<String, String>>{objectFields};
        //VisitPlanningV2Controller.getPicklistValues(objectFieldMap);
        String filterLogic = '1 AND 2';
        List<VisitPlanningV2Controller.MyRecordWrapper> wrappers = new List<VisitPlanningV2Controller.MyRecordWrapper>();
        List<String> operands1 = new List<String>{'92010'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper1 = new VisitPlanningV2Controller.MyRecordWrapper('Shop_Postal_Code__c', 'Account Postal Code', operands1, 'GreaterOrEqual',filterLogic);
        wrappers.add(wrapper1);
        List<String> operands2 = new List<String>{'92100'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper2 = new VisitPlanningV2Controller.MyRecordWrapper('Shop_Postal_Code__c', 'Account Postal Code', operands2, 'LessOrEqual',filterLogic);
        wrappers.add(wrapper2);
        List<String> operands3 = new List<String>{'AU'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper3 = new VisitPlanningV2Controller.MyRecordWrapper('Hoya_Account_ID__c', 'Hoya Account ID', operands3, 'StartsWith',filterLogic);
        wrappers.add(wrapper3);
        List<String> operands4 = new List<String>{'Open'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper4 = new VisitPlanningV2Controller.MyRecordWrapper('Account_Status__c', 'Account Status', operands4, 'Equals',filterLogic);
        wrappers.add(wrapper4);
        List<String> operands5 = new List<String>{'THE OPTICAL COMPANY', 'TOSS', 'VISION SPECIALISTS'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper5 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands5, 'Contains',filterLogic);
        wrappers.add(wrapper5);
        List<String> operands6 = new List<String>{'Testing', 'LOSS'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper6 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'NotContain',filterLogic);
        wrappers.add(wrapper6);
        List<String> operands7 = new List<String>{'1'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper7 = new VisitPlanningV2Controller.MyRecordWrapper('Dunning_Level__c', 'Dunning Level', operands7, 'GreaterThan',filterLogic);
        wrappers.add(wrapper7);
		List<String> operands8 = new List<String>{'2'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper8 = new VisitPlanningV2Controller.MyRecordWrapper('Dunning_Level__c', 'Dunning Level', operands8, 'LessThan',filterLogic);
        wrappers.add(wrapper8);
        List<String> operands9 = new List<String>{'2'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper9 = new VisitPlanningV2Controller.MyRecordWrapper('Dunning_Level__c', 'Dunning Level', operands9, 'NotEqual',filterLogic);
        wrappers.add(wrapper9);
        List<String> operands10 = new List<String>{'5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper10 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands10, 'NotEqual',filterLogic);
        wrappers.add(wrapper10);
        List<String> operands11 = new List<String>{'7.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper11 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands11, 'LessOrEqual',filterLogic);
        wrappers.add(wrapper11);
        List<String> operands12 = new List<String>{'2.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper12 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands12, 'GreaterOrEqual',filterLogic);
        wrappers.add(wrapper12);
        List<String> operands13 = new List<String>{'7.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper13 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands13, 'LessThan',filterLogic);
        wrappers.add(wrapper13);
        List<String> operands14 = new List<String>{'2.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper14 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands14, 'GreaterThan',filterLogic);
        wrappers.add(wrapper14);
        List<String> operands15 = new List<String>{'0'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper15 = new VisitPlanningV2Controller.MyRecordWrapper('Payment_issue__c', 'Payment_issue__c', operands15, 'Equals',filterLogic);
        wrappers.add(wrapper15);
        List<String> operands16 = new List<String>{'1'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper16 = new VisitPlanningV2Controller.MyRecordWrapper('Payment_issue__c', 'Payment_issue__c', operands16, 'Equals',filterLogic);
        wrappers.add(wrapper16);
        List<String> operands17 = new List<String>{'wcorvet'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper17 = new VisitPlanningV2Controller.MyRecordWrapper('Owner.Alias', 'Owner.Alias', operands17, 'Equals',filterLogic);
        wrappers.add(wrapper17); 
        VisitPlanningV2Controller.MyRecordWrapper wrapper18 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'LessOrEqual',filterLogic);
        wrappers.add(wrapper18);
        VisitPlanningV2Controller.MyRecordWrapper wrapper19 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'NotEqual',filterLogic);
        wrappers.add(wrapper19);
        VisitPlanningV2Controller.MyRecordWrapper wrapper20 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'GreaterThan',filterLogic);
        wrappers.add(wrapper20);
        VisitPlanningV2Controller.MyRecordWrapper wrapper21 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'LessThan',filterLogic);
        wrappers.add(wrapper21);
        VisitPlanningV2Controller.MyRecordWrapper wrapper22 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'GreaterOrEqual',filterLogic);
        wrappers.add(wrapper22);
        VisitPlanningV2Controller.MyRecordWrapper wrapper23 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'EndsWith',filterLogic);
        wrappers.add(wrapper23);
        Test.StartTest();
        Account a2 = new Account();
        a2.Hoya_Account_ID__c = 'SO490060';
        a2.Name = 'Test 60';
        a2.Shop_Name__c = 'Test Account 60';
        a2.CurrencyIsoCode = 'EUR';
        a2.Tacticom_SOF__c = 'Sub-area 1';
        insert a2;
        Campaign c = new Campaign();
        c.Name = 'TEST-Campaign';
        c.StartDate = System.today();
        c.EndDate = System.today()+30;
        c.CurrencyIsoCode = 'EUR';
        c.CurrencyIsoCode = 'EUR';
        c.IsActive = true;
        insert c;
        Account_Campaing_Member__c cc = new Account_Campaing_Member__c();
        cc.Account_Name__c = a2.Id;
        cc.Central_Campaign__c = c.Id;
        cc.Campaign_Start_Date_t__c = c.StartDate;
        cc.Campaign_End_Date_t__c = date.valueOf(system.now()+2);
        cc.Target__c = true;
        cc.Campaign_Presented__c = false;
        insert cc;  
        String listViewName = 'All Accounts';
        Map<String, String> filterCriteria = new Map<String, String> ();
        filterCriteria.put('Campaign_Membership__r.Campaign_Presented__c','true');
        filterCriteria.put('Campaign_Membership__r.Campaign_Priority__c','true');
        filterCriteria.put('Campaign_Membership__r.Central_Campaign__c',c.id);
        filterCriteria.put('Account_Life_Cycles__r.Stage__c','Discover');
        String jsonString = '{"info":{"filterLogicString":"1 AND 2","filteredByInfo":[{"fieldApiName":"Shop_Postal_Code__c","label":"Account Postal Code","operandLabels":["92010"],"operator":"GreaterOrEqual"},{"fieldApiName":"Shop_Postal_Code__c","label":"Account Postal Code","operandLabels":["92100"],"operator":"LessOrEqual"}],"scope":{"apiName":"mine","entity":null,"label":"My account teams","relatedEntity":null}}}';
        VisitPlanningV2Controller.fetchData(wrappers,filterCriteria,listViewName,jsonString);
        VisitPlanningV2Controller.fetchData(wrappers,filterCriteria,'My_Accountsnew',jsonString);
        VisitPlanningV2Controller.fetchData(wrappers,filterCriteria,'My_Account_Teams',jsonString);
        
        List<String> filters = new List<String>{'Lenses_Net_Sales_Last_12Mo__c > 500','TACTICOM_SOF__c = \'Not Selected\'','TACTICOM_SOF__c = \'\'','CHCUSTCLASSIFICATIONID__c = \'Chain\'','Account_Status__c != \'Closed\''};

        VisitPlanningV2Controller.replacePlaceholders(filterLogic,filters);
        VisitPlanningV2Controller.MyRecordWrapper wrapperNan = new VisitPlanningV2Controller.MyRecordWrapper();
        String value = VisitPlanningV2Controller.parseCurrencyString('123.56');
        Test.StopTest();
		System.assertNotEquals(null, value, 'value should not be null');
        
        
    }
}