@isTest
public class VisitPlanningV2ControllerTest {
    @isTest
	static void testVPMV2Controller() {
        VisitPlanningV2Controller.getAccountListViews();
        VisitPlanningV2Controller.getCampaignOptions('true');
        VisitPlanningV2Controller.getPicklistValues();
        List<VisitPlanningV2Controller.MyRecordWrapper> wrappers = new List<VisitPlanningV2Controller.MyRecordWrapper>();
        List<String> operands1 = new List<String>{'92010'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper1 = new VisitPlanningV2Controller.MyRecordWrapper('Shop_Postal_Code__c', 'Account Postal Code', operands1, 'GreaterOrEqual');
        wrappers.add(wrapper1);
        List<String> operands2 = new List<String>{'92100'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper2 = new VisitPlanningV2Controller.MyRecordWrapper('Shop_Postal_Code__c', 'Account Postal Code', operands2, 'LessOrEqual');
        wrappers.add(wrapper2);
        List<String> operands3 = new List<String>{'AU'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper3 = new VisitPlanningV2Controller.MyRecordWrapper('Hoya_Account_ID__c', 'Hoya Account ID', operands3, 'StartsWith');
        wrappers.add(wrapper3);
        List<String> operands4 = new List<String>{'Open'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper4 = new VisitPlanningV2Controller.MyRecordWrapper('Account_Status__c', 'Account Status', operands4, 'Equals');
        wrappers.add(wrapper4);
        List<String> operands5 = new List<String>{'THE OPTICAL COMPANY', 'TOSS', 'VISION SPECIALISTS'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper5 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands5, 'Contains');
        wrappers.add(wrapper5);
        List<String> operands6 = new List<String>{'Testing', 'LOSS'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper6 = new VisitPlanningV2Controller.MyRecordWrapper('HAPL_Group_Name__c', 'Group Name', operands6, 'NotContain');
        wrappers.add(wrapper6);
        List<String> operands7 = new List<String>{'1'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper7 = new VisitPlanningV2Controller.MyRecordWrapper('Dunning_Level__c', 'Dunning Level', operands7, 'GreaterThan');
        wrappers.add(wrapper7);
		List<String> operands8 = new List<String>{'2'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper8 = new VisitPlanningV2Controller.MyRecordWrapper('Dunning_Level__c', 'Dunning Level', operands8, 'LessThan');
        wrappers.add(wrapper8);
        List<String> operands9 = new List<String>{'2'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper9 = new VisitPlanningV2Controller.MyRecordWrapper('Dunning_Level__c', 'Dunning Level', operands9, 'NotEqual');
        wrappers.add(wrapper9);
        List<String> operands10 = new List<String>{'5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper10 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands10, 'NotEqual');
        wrappers.add(wrapper10);
        List<String> operands11 = new List<String>{'7.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper11 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands11, 'LessOrEqual');
        wrappers.add(wrapper11);
        List<String> operands12 = new List<String>{'2.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper12 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands12, 'GreaterOrEqual');
        wrappers.add(wrapper12);
        List<String> operands13 = new List<String>{'7.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper13 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands13, 'LessThan');
        wrappers.add(wrapper13);
        List<String> operands14 = new List<String>{'2.5'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper14 = new VisitPlanningV2Controller.MyRecordWrapper('Credits_LY__c', 'Credits_LY__c', operands14, 'GreaterThan');
        wrappers.add(wrapper14);
        List<String> operands15 = new List<String>{'0'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper15 = new VisitPlanningV2Controller.MyRecordWrapper('Payment_issue__c', 'Payment_issue__c', operands15, 'Equals');
        wrappers.add(wrapper15);
        List<String> operands16 = new List<String>{'1'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper16 = new VisitPlanningV2Controller.MyRecordWrapper('Payment_issue__c', 'Payment_issue__c', operands16, 'Equals');
        wrappers.add(wrapper16);
        List<String> operands17 = new List<String>{'wcorvet'};
        VisitPlanningV2Controller.MyRecordWrapper wrapper17 = new VisitPlanningV2Controller.MyRecordWrapper('Owner.Alias', 'Owner.Alias', operands17, 'Equals');
        wrappers.add(wrapper17); 
        Map<String, String> filterCriteria = new Map<String, String> ();
        VisitPlanningV2Controller.fetchData(wrappers,filterCriteria);
        VisitPlanningV2Controller.MyRecordWrapper wrapper18 = new VisitPlanningV2Controller.MyRecordWrapper();
        String value = VisitPlanningV2Controller.parseCurrencyString('123.56');
		System.assertNotEquals(null, value, 'value should not be null');
    }
}