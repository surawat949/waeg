@isTest
private class ExtGSurveys_Test {

    static testMethod void myUnitTest() {
    	Survey__c newSurvy = new Survey__c();
		newSurvy.Name = 'TestSurvey' ;
       
		Survey__c sur = new Survey__c();
		sur.Name = 'TestSurvey' ;
		insert sur;
		Survey__c insertedsurvey = [Select id,name from Survey__c where id =: sur.id];
		ApexPages.StandardController stdContr1=new ApexPages.StandardController(newSurvy);
		ExtGSurveys newContr = new ExtGSurveys(stdContr1);
		newContr.survey.name = 'DemoSurvey';
		newContr.makeNewSurvey();
		newContr.doSurveyReset();
		
		ApexPages.StandardController stdContr2=new ApexPages.StandardController(newSurvy);
		ExtGSurveys newContr2=new ExtGSurveys(stdContr2);
		newContr2.makeNewSurvey();
		newContr2.doSurveyReset();

		Survey__c newSurvey2 = new Survey__c();
		newSurvey2.Name = 'TestSurvey-2';
		insert newSurvey2;

		ExtGSurveys.deleteSurvey(newSurvey2.Id);
    }
}