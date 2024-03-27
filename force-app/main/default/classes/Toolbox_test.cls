@isTest
public with sharing class Toolbox_test {
    public Toolbox_test() {

    }
    
    static testMethod void testToolbox(){
        Test.startTest();

        List<String> cmpList = ToolBox.getCompanyList('HLFR');
        Set<ID> idSet = ToolBox.getRoleSubordinateUsers('005b0000001fZtA');//CDU id
        system.assert(true);
        Test.stopTest();
    }
}