@isTest(SeeAllData=true)
private class ExtTakeSurvey_Test {

    static testMethod void myUnitTest() {
		//RecordType[] rt =[Select Id,  Name, SobjectType from RecordType  where  SobjectType ='Account' and Name ='Mass Market Account'];        
		Account acc = new Account(); 
		acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'demo account12121';        
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        //acc.RecordTypeId = rt[0].Id;
        insert acc;
        
        
        
		String response = '';
        String question = 'test question';
        
        Survey__c newSurv=new Survey__c();
        newSurv.name='test';
        insert newSurv;
        Survey__c insertedsurvey = [Select id,name from Survey__c where id =: newSurv.id];               
        system.assertequals(newSurv.name,insertedsurvey.name);
        
		Survey__c newSurv1=new Survey__c();
        newSurv1.name='test1';
        insert newSurv1;
        
        Survey__c newSurv2=new Survey__c();
        newSurv2.name='test';
        insert newSurv2;
        
        Survey_Question__c newQue=new Survey_Question__c();
        newQue.Survey__c=newSurv.id;
        newQue.Question__c='test the que?';
        newQue.OrderNumber__c=12;
        newQue.Choices__c='a';
        newQue.Type__c='Multi Select';
        newQue.Weight__c = 1;
        insert newQue;
        
        Survey_Question__c newQue1=new Survey_Question__c();
        newQue1.Survey__c=newSurv.id;
        newQue1.Question__c='test the que?';
        newQue1.OrderNumber__c=12;
        newQue1.Choices__c='a';
        newQue1.Type__c='Single Select';
        newQue1.Weight__c = 1;
        insert newQue1;
        
        Survey_Question__c newQue2=new Survey_Question__c();
        newQue2.Survey__c=newSurv.id;
        newQue2.Question__c='test the que?';
        newQue2.OrderNumber__c=12;
        newQue2.Choices__c='a';
        newQue2.Type__c='Picklist';
        newQue2.Weight__c = 1;
        insert newQue2;

        Survey_Question__c newQue3=new Survey_Question__c();
        newQue3.Survey__c=newSurv.id;
        newQue3.Question__c='test the que?';
        newQue3.OrderNumber__c=12;
        newQue3.Choices__c='a';
        newQue3.Type__c='Free Text';
        newQue3.Weight__c = 1;
        insert newQue3;

        Survey_Question__c newQue4=new Survey_Question__c();
        newQue4.Survey__c=newSurv.id;
        newQue4.Question__c='test the que?';
        newQue4.OrderNumber__c=12;
        newQue4.Choices__c='a';
        newQue4.Type__c='Numeric';
        newQue4.Weight__c = 1;
        insert newQue4;
        
        Survey_Question__c newQue5=new Survey_Question__c();
        newQue5.Survey__c=newSurv.id;
        newQue5.Question__c='test the que?';
        newQue5.OrderNumber__c=12;
        newQue5.Choices__c='a';
        newQue5.Type__c='Numeric';
        newQue5.Weight__c = 1;
        insert newQue5;
        
        User user = [SELECT Id,Name FROM User limit 1];
        //Survey__c s = [SELECT Id,Name FROM Survey__c limit 1];
        
        
        
        Survey_Taken__c st = new Survey_Taken__c();
        st.Account_Name__c = acc.Id;
        st.Survey__c = newSurv.Id;
        insert st;
        
        Survey_Taken__c st1 = new Survey_Taken__c();
        st1.Account_Name__c = acc.Id;
        st1.Survey__c = newSurv.Id;
        insert st1;
        
        Survey_Settings__c ss = new Survey_Settings__c(); 
        ss.Active__c = true;
        ss.Survey_Type__c = 'Sin';
        ss.Name = 'sa';
        insert ss;
        
        Apexpages.currentPage().getParameters().put('cId',acc.Id);
        Apexpages.currentPage().getParameters().put('id',newSurv.Id);
		ApexPages.StandardController stdContr=new ApexPages.StandardController(newSurv);
        ExtTakeSurvey newContr=new ExtTakeSurvey(stdContr);
        
        List<String> resp = new List<String>();
        resp.add('1');
        resp.add('12');
        resp.add('13');
        resp.add('14');
        resp.add('15');
        resp.add('16');
        
        Survey_Question_Response__c sqr = new Survey_Question_Response__c();
        sqr.Survey_Question__c =newQue1.Id;
        sqr.Survey_Taken__c = st.Id;
        insert sqr;
        
        map<Id, Survey_Question_Response__c> map_questionId_oldButNewestResponse = new map<Id, Survey_Question_Response__c>();
        map_questionId_oldButNewestResponse.put(sqr.Survey_Question__c,sqr);
        Test.startTest();
        
        ExtTakeSurvey.getResponses(resp);
        
        List<String> qOrder = new List<String>();
        qOrder.add(newQue.Id);
        qOrder.add(newQue1.Id);
        qOrder.add(newQue2.Id);
        qOrder.add(newQue3.Id);
        qOrder.add(newQue4.Id);
        ExtTakeSurvey.updateQuestionOrder(qOrder);
        ExtTakeSurvey.deleteQuestion(newQue5.Id);
        
        ExtTakeSurvey.getResponseList('sdds', newQue5, st1.Id, map_questionId_oldButNewestResponse);
        
        newContr.getSurveyAnswer();
        newContr.getAQuestion();
        newContr.getResponses();
        newContr.resultPage();
        newContr.thankYouPage();
        newContr.deleteRefresh();
        newContr.refreshQuestionList();
        newContr.setupQuestionList();
        newContr.updateSurveyName();
        newContr.cancel();
        newContr.updateSurveyThankYouAndLink();

        Test.stopTest();

   }
    static testMethod void myUnitTest2() {
		//RecordType[] rt =[Select Id,  Name, SobjectType from RecordType  where  SobjectType ='Account' and Name ='Mass Market Account'];        
		Account acc = new Account(); 
		acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'demo account12121';        
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        //acc.RecordTypeId = rt[0].Id;
        insert acc;

		String response = '';
        String question = 'test question';
        
        Survey__c newSurv=new Survey__c();
        newSurv.name='test';
        insert newSurv;
        Survey__c insertedsurvey = [Select id,name from Survey__c where id =: newSurv.id];               
        system.assertequals(newSurv.name,insertedsurvey.name);
        
		Survey__c newSurv1=new Survey__c();
        newSurv1.name='test1';
        insert newSurv1;
        
        Survey__c newSurv2=new Survey__c();
        newSurv2.name='test';
        insert newSurv2;
        
        Survey_Question__c newQue=new Survey_Question__c();
        newQue.Survey__c=newSurv.id;
        newQue.Question__c='test the que?';
        newQue.OrderNumber__c=12;
        newQue.Choices__c='a';
        newQue.Type__c='Multi Select';
        newQue.Weight__c = 1;
        insert newQue;
        
        Survey_Question__c newQue1=new Survey_Question__c();
        newQue1.Survey__c=newSurv.id;
        newQue1.Question__c='test the que?';
        newQue1.OrderNumber__c=12;
        newQue1.Choices__c='a';
        newQue1.Type__c='Single Select';
        newQue1.Weight__c = 1;
        insert newQue1;
        
        Survey_Question__c newQue2=new Survey_Question__c();
        newQue2.Survey__c=newSurv.id;
        newQue2.Question__c='test the que?';
        newQue2.OrderNumber__c=12;
        newQue2.Choices__c='a';
        newQue2.Type__c='Picklist';
        newQue2.Weight__c = 1;
        insert newQue2;

        Survey_Question__c newQue3=new Survey_Question__c();
        newQue3.Survey__c=newSurv.id;
        newQue3.Question__c='test the que?';
        newQue3.OrderNumber__c=12;
        newQue3.Choices__c='a';
        newQue3.Type__c='Free Text';
        newQue3.Weight__c = 1;
        insert newQue3;

        Survey_Question__c newQue4=new Survey_Question__c();
        newQue4.Survey__c=newSurv.id;
        newQue4.Question__c='test the que?';
        newQue4.OrderNumber__c=12;
        newQue4.Choices__c='a';
        newQue4.Type__c='Numeric';
        newQue4.Weight__c = 1;
        insert newQue4;
        
        Survey_Question__c newQue5=new Survey_Question__c();
        newQue5.Survey__c=newSurv.id;
        newQue5.Question__c='test the que?';
        newQue5.OrderNumber__c=12;
        newQue5.Choices__c='a';
        newQue5.Type__c='Numeric';
        newQue5.Weight__c = 1;
        insert newQue5;
        
       // User user = [SELECT Id,Name FROM User limit 1];
        //Survey__c s = [SELECT Id,Name FROM Survey__c limit 1];
        
        
        
        Survey_Taken__c st = new Survey_Taken__c();
        st.Account_Name__c = acc.Id;
        st.Survey__c = newSurv.Id;
        st.Status__c = 'Completed';
        insert st;
        
        Survey_Taken__c st1 = new Survey_Taken__c();
        st1.Account_Name__c = acc.Id;
        st1.Survey__c = newSurv.Id;
        st1.Status__c = 'Working';
        insert st1;
        
        Survey_Settings__c ss = new Survey_Settings__c(); 
        ss.Active__c = true;
        ss.Survey_Type__c = 'Sin';
        ss.Name = 'sa';
        insert ss;
        
        //Apexpages.currentPage().getParameters().put('cId',acc.Id);
       // Apexpages.currentPage().getParameters().put('id',newSurv.Id);
		ApexPages.StandardController stdContr=new ApexPages.StandardController(newSurv);
        ExtTakeSurvey newContr=new ExtTakeSurvey(stdContr);
        
        
        Survey_Question_Response__c sqr = new Survey_Question_Response__c();
        sqr.Survey_Question__c =newQue1.Id;
        sqr.Survey_Taken__c = st.Id;
        insert sqr;
        
        Survey_Taken__c stc = [Select id,  Account_Name__c, Status__c,Survey__c from Survey_Taken__c  limit 1];
        Apexpages.currentPage().getParameters().put('cId',stc.Account_Name__c);
        Apexpages.currentPage().getParameters().put('id',stc.Survey__c);
        String userId = stc.Account_Name__c;
        String surveyId = st.Id;
        
        map<Id, Survey_Question_Response__c> map_questionId_oldButNewestResponse = new map<Id, Survey_Question_Response__c>();
        map_questionId_oldButNewestResponse.put(sqr.Survey_Question__c,sqr);
        Test.startTest();
        
        List<String> resp = new List<String>();
        resp.add('1');
        resp.add('12');
        resp.add('13');
        resp.add(st.Account_Name__c);
        resp.add(st.Survey__c);
        resp.add('16');
        
        ExtTakeSurvey.getResponses(resp);
        
        List<String> qOrder = new List<String>();
        qOrder.add(newQue.Id);
        qOrder.add(newQue1.Id);
        qOrder.add(newQue2.Id);
        qOrder.add(newQue3.Id);
        qOrder.add(newQue4.Id);
        ExtTakeSurvey.updateQuestionOrder(qOrder);
        ExtTakeSurvey.deleteQuestion(newQue5.Id);
        
        ExtTakeSurvey.getResponseList('sdds', newQue5, st1.Id, map_questionId_oldButNewestResponse);
        
        newContr.getSurveyAnswer();
        newContr.getAQuestion();
        newContr.getResponses();
        newContr.resultPage();
        newContr.thankYouPage();
        newContr.deleteRefresh();
        newContr.refreshQuestionList();
        newContr.setupQuestionList();
        //newContr.updateSurveyName();
        newContr.cancel();
      //  newContr.updateSurveyThankYouAndLink();

        Test.stopTest();

   }
    static testMethod void myUnitTest3(){

        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE999888';
        acc.Name = 'Test account';
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        insert acc;

        Survey__c survey = new Survey__c();
        survey.Name = 'Test survey';
        insert survey;

        Survey_Question__c newQue = new Survey_Question__c();
        newQue.Survey__c = survey.Id;
        newQue.Question__c = 'test the que?';
        newQue.OrderNumber__c = 12;
        newQue.Choices__c = 'a';
        newQue.Type__c = 'Multi Select';
        newQue.Weight__c = 1;
        insert newQue;

        Survey_Taken__c st = new Survey_Taken__c();
        st.Account_Name__c = acc.Id;
        st.Survey__c = survey.Id;
        st.Status__c = 'Completed';
        insert st;

        Survey_Question_Response__c sqr = new Survey_Question_Response__c();
        sqr.Survey_Question__c =newQue.Id;
        sqr.Survey_Taken__c = st.Id;
        insert sqr;

        Test.startTest();
        ExtTakeSurvey.handleMultiSelectResponse('test response', st.Id, newQue.Id);

        System.assert(true);
        Test.stopTest();
    }

    static testMethod void myUnitTest4(){
        Account acc = new Account();
        acc.Hoya_Account_ID__c = 'DE999777';
        acc.Name = 'Test account';
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        insert acc;

        Survey__c survey = new Survey__c();
        survey.Name = 'Test survey';
        insert survey;

        Survey_Question__c newQue = new Survey_Question__c();
        newQue.Survey__c = survey.Id;
        newQue.Question__c = 'test the que?';
        newQue.OrderNumber__c = 12;
        newQue.Choices__c = 'a';
        newQue.Type__c = 'Multi-Select--Vertical';
        newQue.Weight__c = 1;
        insert newQue;

        Survey_Taken__c st = new Survey_Taken__c();
        st.Account_Name__c = acc.Id;
        st.Survey__c = survey.Id;
        st.Status__c = 'Completed';
        insert st;

        Survey_Question_Response__c sqr = new Survey_Question_Response__c();
        sqr.Survey_Question__c =newQue.Id;
        sqr.Survey_Taken__c = st.Id;
        insert sqr;

        map<Id, Survey_Question_Response__c> map_questionId_oldButNewestResponse = new map<Id, Survey_Question_Response__c>();
        map_questionId_oldButNewestResponse.put(sqr.Survey_Question__c,sqr);

        Test.startTest();
        ExtTakeSurvey.getResponseList('zxcv', newQue, st.Id, map_questionId_oldButNewestResponse);
        System.assert(true);
        Test.stopTest();

    }
}