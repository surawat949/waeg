@isTest
private class ClsReportFinderUtil_Test {

    static testMethod void myUnitTest() {
    	ClsReportFinderUtil crfu = new ClsReportFinderUtil();
		Dom.Document doc;
		String reportName = 'testsssssssssssss';
		Test.startTest();
		crfu.findReportId(reportName);
		Test.stopTest();
    }
}