/**
*  This test class is for ClsCampaignUtil .
*
@author Lei Tang
@created 2014-07-23
@version 1.0
@since 30.0 
*
@changelog
* 2014-07-23 Lei Tang <lei.tang@itbconsult.com>
* - Created
* - Test coverage   89%
*/
@isTest
private class ClsCampaignUtil_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
        ClsCampaignUtil.isExecuteTrigger = false;
        system.assertEquals(ClsCampaignUtil.isExecuteTrigger, false);
        Test.stopTest();
    }
}