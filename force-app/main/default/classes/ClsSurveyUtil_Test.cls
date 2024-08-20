@isTest
private class ClsSurveyUtil_Test {

    static testMethod void myUnitTest() {
    	Map<id,Map<String, List<ClsQuestion>>> map_surveyId_class_questions = new Map<id,Map<String, List<ClsQuestion>>>();
 		Map<id,Map<String,String>> map_surveyId_classOrType_fields = new Map<id,Map<String,String>>();
 		
 		Map<id,set<String>> map_surveyId_types = new Map<id,set<String>>();
 		Set<Id> set_questionIds = new Set<id>();
 		
 		Survey__c newSurv=new Survey__c();
        newSurv.name='test';
        insert newSurv;
        
        Map<String,String> m = new Map<String,String>();
        m.put('dsds','dsds');
        map_surveyId_classOrType_fields.put(newSurv.Id,m);
        
		Account acc = new Account(); 
		acc.Hoya_Account_ID__c = 'DE123456';
        acc.Name = 'demo account12121';        
        acc.type = 'outlet';        
        acc.CurrencyIsoCode = 'EUR';       
        acc.BillingStreet = 'test street';        
        acc.BillingCountry = 'test country';        
        acc.BillingCity = 'test city';
        insert acc;
    	
   		Survey_Taken__c s = new Survey_Taken__c();
   		s.Account_Name__c = acc.Id;
   		s.Survey__c = newSurv.Id;
   		insert s;
   		
   		Survey_Field_Mapping__c sfm = new Survey_Field_Mapping__c();
   		sfm.Survey__c = newSurv.Id;
   		sfm.Object__c ='Account';
   		insert sfm; 
   		map_surveyId_classOrType_fields.put(sfm.Id,m);
   		
   		Survey_Question__c sq = new Survey_Question__c();
   		sq.Survey__c =newSurv.Id;
   		sq.OrderNumber__c=2;
   		sq.Weight__c =1;
   		insert sq;
   		map_surveyId_classOrType_fields.put(sq.Id,m);
   		
   		Survey_Question_Response__c  sqr = new Survey_Question_Response__c();
   		sqr.Survey_Taken__c = s.Id;
   		sqr.Survey_Question__c = sq.Id;
   		insert sqr;
   		Survey_Calculatation_Table__c sct = new Survey_Calculatation_Table__c();
   		sct.Survey__c= newSurv.Id;
   		sct.Unique_Name__c = 'sd';
   		insert sct;
   		map_surveyId_classOrType_fields.put(sct.Id,m);
   		   		
   		String classfication = '';
   		Double point =1;
   		List<ClsQuestion> list_questions = new List<ClsQuestion>();
   		//list_questions.add('sdsdsds','sfsdf');
   		
   		map<Id,Id> map_stId_accId = new map<Id,Id>();
   		map_stId_accId.put(s.Id,s.Account_Name__c);
   		map<Id,Id> map_stId_surId = new map<Id,Id>();
   		map_stId_surId.put(s.Id,s.Survey__c);
   		List<id> list_stId = new List<id>();
   		list_stId.add(s.Id);
   		
   		Map<String, String> map_className_classLevel = new Map<String, String>();
   		map_className_classLevel.put('qwe','asd');
   		//map_className_classLevel.put(newSurv.Id,newSurv.Id);
   		

		ClsSurveyUtil csu1 = new ClsSurveyUtil(map_stId_accId,map_stId_surId,list_stId);
		ClsSurveyUtil csu = new ClsSurveyUtil(s.Account_Name__c,s.Survey__c,s.Id);
		
		map_surveyId_class_questions.put(s.Survey__c, new Map<String, List<ClsQuestion>>());
		
		csu.calcSurveyTakens();
		
		csu.getPoint(list_questions, newSurv.Id);
		csu.loadAccounts();
		csu.loadClassfications();
		csu.loadClassFields();
		csu.loadSurveyQuestionResponse();
		csu.loadTypes(); 
		csu.updateClassfication(classfication, point, newSurv.Id, acc);
		String uniqueName = newSurv.Id;
		 
		uniqueName += csu.getAllClassLevels();
		//csu.getAllClassLevels();
		//csu.updateObject();
		String stype = 'sd';
		csu.updateType(stype, newSurv.Id, acc);        
    }
}