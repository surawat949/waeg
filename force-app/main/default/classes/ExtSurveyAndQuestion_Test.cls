/**
 * changed log : 2023-11-20
 * updated by : surawat sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 * since api 55.0
 * test for ExtSurveyAndQuestion
 * cod coverage : 75%
 */
@isTest(SeeAllData=true)
private class ExtSurveyAndQuestion_Test {

    static testMethod void myUnitTest() {
    	Survey__c newSurvy = new Survey__c();
		newSurvy.Name = 'TestSurvey' ;
		insert newSurvy;
       
		Survey__c sur = new Survey__c();
		sur.Name = 'TestSurvey' ;
		insert sur;
		
		Survey__c sc = [Select Id,Name from Survey__c limit 1];
		String surveyId = sc.Id;
		
		Apexpages.currentPage().getParameters().put('id',newSurvy.Id);
		
		User u = [Select Id, Name From User limit 1];
		//Case c = [select Id From Case limit 1];
		Case c = new Case();
		c.CurrencyIsoCode ='EUR';
		c.Status = 'Neu';
		c.Origin = 'E-Mail';
		insert c;
		
		Apexpages.currentPage().getParameters().put('caId',c.Id);
		
		Survey_Question__c questionToUpdate = new Survey_Question__c();
        questionToUpdate.Survey__c = newSurvy.id;
        questionToUpdate.Name = 'tttt';
        questionToUpdate.Question__c = 'test the que?';
        questionToUpdate.OrderNumber__c=12;
        questionToUpdate.Choices__c='a';
        questionToUpdate.Type__c='Single Select-Vertical';
        questionToUpdate.Weight__c = 1;
		questionToUpdate.Score__c = '1122';
		questionToUpdate.Class__c = 'zxcvzxcv';
		questionToUpdate.Is_Calculable__c = false;

        insert questionToUpdate;
		
		String questionReference = questionToUpdate.Id;
		
		Survey__c insertedsurvey = [Select id,name from Survey__c where id =: sur.id];
		ApexPages.StandardController stdContr1=new ApexPages.StandardController(newSurvy);
		ExtSurveyAndQuestion newContr = new ExtSurveyAndQuestion(stdContr1);
		
		newContr.questionType = 'Multi-Select-Vertical';
		newContr.questionReference = questionToUpdate.Id;
		newContr.qQuestion = questionToUpdate.Name;
		String qQuestion = questionToUpdate.Name;
		
		Survey_Question__c sq = [Select Id,Name, Score__c, Weight__c, Class__c, Is_Calculable__c From Survey_Question__c limit 1];
		List<String> qOrder = new List<String>();
		qOrder.add(sq.Id);
        
		List<String> resp = new List<String>();
		resp.add('121212');
		resp.add(u.Id);
		resp.add(newSurvy.Id);
		resp.add(c.Id);
		
		Test.startTest();
		newContr.addQuestion();
		newContr.back();
		newContr.changeCalculable();
		//newContr.controllerSavQuestion();
		newContr.deleteRefresh();
		newContr.editQuestion();
		newContr.getAQuestion();
		newContr.getResponses();
		newContr.makeNewQuestionLink();
		newContr.previewQuestion();
		newContr.refreshQuestionList();
		newContr.resultPage();
		newContr.save();
		newContr.saveAndNewQuestion();
		newContr.setSurveyNameAndThankYou(newSurvy.Id);
		newContr.setupQuestionFields();
		newContr.setupQuestionList();
		newContr.thankYouPage();
		newContr.updateSurveyName();
		//newContr.updateSurveyThankYouAndLink();
		newContr.updateUrl();

		ExtSurveyAndQuestion.getResponses(resp);
		ExtSurveyAndQuestion.updateQuestionOrder(qOrder);
		
		Test.stopTest();
		

		/*
		ApexPages.StandardController stdContr2=new ApexPages.StandardController(newSurvy);
		ExtSurveyAndQuestion newContr2=new ExtSurveyAndQuestion(stdContr2);
		newContr2.makeNewSurvey();
		newContr2.doSurveyReset();
		*/
    }

	static testMethod void myUnitTest2() {
		Survey__c newSurvy = new Survey__c();
		newSurvy.Name = 'TestSurvey' ;
		insert newSurvy;
       
		Survey__c sur = new Survey__c();
		sur.Name = 'TestSurvey' ;
		insert sur;
		String surveyId = newSurvy.Id;
		
		Survey_Question__c questionToUpdate = new Survey_Question__c();
        questionToUpdate.Survey__c = newSurvy.id;
        questionToUpdate.Question__c = 'test the que?';
        questionToUpdate.OrderNumber__c=12;
        questionToUpdate.Choices__c='a';
        questionToUpdate.Type__c='Single Select-Vertical';
        questionToUpdate.Weight__c = 1;
        
		Survey_Question__c newQue2=new Survey_Question__c();
        newQue2.Survey__c = newSurvy.id;
        newQue2.Name = 'testtest';
        newQue2.Question__c = 'test the que?';
        newQue2.OrderNumber__c=12;
        newQue2.Choices__c='a';
        newQue2.Type__c='Single Select-Horizontal';
        newQue2.Weight__c = 1;
        insert newQue2;

		
		Survey__c insertedsurvey = [Select id,name from Survey__c where id =: sur.id];
		ApexPages.StandardController stdContr1=new ApexPages.StandardController(newSurvy);
		ExtSurveyAndQuestion newContr = new ExtSurveyAndQuestion(stdContr1);
		
		newContr.questionType = 'Multi-Select-Vertical';
		newContr.questionReference = newQue2.Id;
		String questionReference = newQue2.Id;
		String qQuestion = newQue2.Name;
		newContr.qQuestion = newQue2.Name;
		
		
		Survey_Question__c newQue=new Survey_Question__c();
        newQue.Survey__c = newSurvy.id;
        newQue.Question__c = 'test the que?';
        newQue.OrderNumber__c=12;
        newQue.Choices__c='a';
        newQue.Type__c='Single Select-Vertical';
        newQue.Weight__c = 1;
        insert newQue;
        
		Survey_Question__c newQue1=new Survey_Question__c();
        newQue1.Survey__c = newSurvy.id;
        newQue1.Question__c = 'test the que?';
        newQue1.OrderNumber__c=12;
        newQue1.Choices__c='a';
        newQue1.Type__c='Multi-Select-Vertical';
        newQue1.Weight__c = 1;
        insert newQue1;
        
        
		Survey_Question__c newQue3=new Survey_Question__c();
        newQue3.Survey__c = newSurvy.id;
        newQue3.Question__c = 'test the que?';
        newQue3.OrderNumber__c=12;
        newQue3.Choices__c='a';
        newQue3.Type__c='Free Text';
        newQue3.Weight__c = 1;
        insert newQue3;
        /*
        Survey_Classification__c sc = new Survey_Classification__c();
        sc.Survey__c = surveyId;
        sc.Name = 'sss';
        sc.CurrencyIsoCode = 'EUR';
        insert sc;
        */
        
        
        Test.startTest();
        
		newContr.previewQuestion();
		//newContr.updateSurveyName();
		//newContr.controllerSavQuestion();
        
		ExtSurveyAndQuestion.question q = new ExtSurveyAndQuestion.question(newQue);
		
		ExtSurveyAndQuestion.question q1 = new ExtSurveyAndQuestion.question(newQue1);
		
		ExtSurveyAndQuestion.question q2 = new ExtSurveyAndQuestion.question(newQue2);
		
		ExtSurveyAndQuestion.question q3 = new ExtSurveyAndQuestion.question(newQue3);
		
		ExtSurveyAndQuestion.ChoiceScore c = new ExtSurveyAndQuestion.ChoiceScore(1,'as;asd','2');
		
		ExtSurveyAndQuestion.deleteQuestion(newQue.Id);
		
		Test.stopTest();
		
	}
	static testMethod void myUnitTest4() {
		Survey__c newSurvy = new Survey__c();
		newSurvy.Name = 'TestSurvey' ;
		insert newSurvy;
       
		Survey__c sur = new Survey__c();
		sur.Name = 'TestSurvey' ;
		insert sur;
		String surveyId = newSurvy.Id;
		
		Survey_Question__c questionToUpdate = new Survey_Question__c();
        questionToUpdate.Survey__c = newSurvy.id;
        questionToUpdate.Question__c = 'test the que?';
        questionToUpdate.OrderNumber__c=12;
        questionToUpdate.Choices__c='a';
        questionToUpdate.Type__c='Single Select-Vertical';
        questionToUpdate.Weight__c = 1;
        
		Survey_Question__c newQue2=new Survey_Question__c();
        newQue2.Survey__c = newSurvy.id;
        newQue2.Name = 'testtest';
        newQue2.Question__c = 'test the que?';
        newQue2.OrderNumber__c=12;
        newQue2.Choices__c='a';
        newQue2.Type__c='Single Select-Horizontal';
        newQue2.Weight__c = 1;
        insert newQue2;

		
		Survey__c insertedsurvey = [Select id,name from Survey__c where id =: sur.id];
		ApexPages.StandardController stdContr1=new ApexPages.StandardController(newSurvy);
		ExtSurveyAndQuestion newContr = new ExtSurveyAndQuestion(stdContr1);
		
		newContr.questionType = 'Single Select-Horizontal';
		newContr.questionReference = newQue2.Id;
		String questionReference = newQue2.Id;
		String qQuestion = newQue2.Name;
		newContr.qQuestion = newQue2.Name;
		
		
		Survey_Question__c newQue=new Survey_Question__c();
        newQue.Survey__c = newSurvy.id;
        newQue.Question__c = 'test the que?';
        newQue.OrderNumber__c=12;
        newQue.Choices__c='a';
        newQue.Type__c='Single Select-Horizontal';
        newQue.Weight__c = 1;
        insert newQue;
        
		Survey_Question__c newQue1=new Survey_Question__c();
        newQue1.Survey__c = newSurvy.id;
        newQue1.Question__c = 'test the que?';
        newQue1.OrderNumber__c=12;
        newQue1.Choices__c='a';
        newQue1.Type__c='Single Select-Horizontal';
        newQue1.Weight__c = 1;
        insert newQue1;
        
		Survey_Question__c newQue3=new Survey_Question__c();
        newQue3.Survey__c = newSurvy.id;
        newQue3.Question__c = 'test the que?';
        newQue3.OrderNumber__c=12;
        newQue3.Choices__c='a';
        newQue3.Type__c='Single Select-Horizontal';
        newQue3.Weight__c = 1;
        insert newQue3;
        /*
        Survey_Classification__c sc = new Survey_Classification__c();
        sc.Survey__c = surveyId;
        sc.Name = 'sss';
        sc.CurrencyIsoCode = 'EUR';
        insert sc;
		*/
        
        Test.startTest();
        
		newContr.previewQuestion();
		//newContr.updateSurveyName();
		//newContr.controllerSavQuestion();
        
		ExtSurveyAndQuestion.question q = new ExtSurveyAndQuestion.question(newQue);
		
		ExtSurveyAndQuestion.question q1 = new ExtSurveyAndQuestion.question(newQue1);
		
		ExtSurveyAndQuestion.question q2 = new ExtSurveyAndQuestion.question(newQue2);
		
		ExtSurveyAndQuestion.question q3 = new ExtSurveyAndQuestion.question(newQue3);
		
		ExtSurveyAndQuestion.ChoiceScore c = new ExtSurveyAndQuestion.ChoiceScore(1,'as;asd','2');
		
		ExtSurveyAndQuestion.deleteQuestion(newQue.Id);
		
		Test.stopTest();
		
	}
	static testMethod void myUnitTest3() {
		Survey__c newSurvy = new Survey__c();
		newSurvy.Name = 'TestSurvey' ;
		insert newSurvy;
       
		Survey__c sur = new Survey__c();
		sur.Name = 'TestSurvey' ;
		insert sur;
		String surveyId = newSurvy.Id;
		
		Survey_Question__c questionToUpdate = new Survey_Question__c();
        questionToUpdate.Survey__c = newSurvy.id;
        questionToUpdate.Question__c = 'test the que?';
        questionToUpdate.OrderNumber__c=12;
        questionToUpdate.Choices__c='a';
        questionToUpdate.Type__c='Free Text';
        questionToUpdate.Weight__c = 1;
        
		Survey_Question__c newQue2=new Survey_Question__c();
        newQue2.Survey__c = newSurvy.id;
        newQue2.Name = 'testtest';
        newQue2.Question__c = 'test the que?';
        newQue2.OrderNumber__c=12;
        newQue2.Choices__c='a';
        newQue2.Type__c='Free Text';
        newQue2.Weight__c = 1;
        insert newQue2;

		
		Survey__c insertedsurvey = [Select id,name from Survey__c where id =: sur.id];
		ApexPages.StandardController stdContr1=new ApexPages.StandardController(newSurvy);
		ExtSurveyAndQuestion newContr = new ExtSurveyAndQuestion(stdContr1);
		
		newContr.questionType = 'Free Text';
		newContr.questionReference = newQue2.Id;
		String questionReference = newQue2.Id;
		String qQuestion = newQue2.Name;
		newContr.qQuestion = newQue2.Name;
		
		
		Survey_Question__c newQue=new Survey_Question__c();
        newQue.Survey__c = newSurvy.id;
        newQue.Question__c = 'test the que?';
        newQue.OrderNumber__c=12;
        newQue.Choices__c='a';
        newQue.Type__c='Free Text';
        newQue.Weight__c = 1;
        insert newQue;
        /*
        Survey_Classification__c sc = new Survey_Classification__c();
        sc.Survey__c = surveyId;
        sc.Name = 'sss';
        sc.CurrencyIsoCode = 'EUR';
        insert sc;
        */
        
        
        Test.startTest();
        
		newContr.previewQuestion();
		//newContr.updateSurveyName();
		//newContr.controllerSavQuestion();
        
		ExtSurveyAndQuestion.question q = new ExtSurveyAndQuestion.question(newQue);

		ExtSurveyAndQuestion.question q2 = new ExtSurveyAndQuestion.question(newQue2);

		ExtSurveyAndQuestion.ChoiceScore c = new ExtSurveyAndQuestion.ChoiceScore(1,'as;asd','2');
		
		ExtSurveyAndQuestion.deleteQuestion(newQue.Id);
		
		Test.stopTest();
		
	}

}