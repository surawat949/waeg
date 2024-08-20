/* Controller associated with pages rendering the survey.
 * Used by SurveyPage, ResultsPage, TakeSurvey
 *
 @author Haobo Song
 @created 2011-10-25
 @version 1.0
 @since 20.0
 *
 @changelog
 * 2012-08-17 Haobo Song <haobo.song@itbconsult.com>
 * - Migrated from old system 
 * 2011-10-25 Haobo Song <haobo.song@itbconsult.com>
 * - Migrated from old system
 */ 
global virtual without sharing class ExtTakeSurvey {
	
	public String buttonMode					{get;set;}//added by yinfeng.guo 2012-08-20 -> control the button whether show or hide
	public String surveyTakenStatus				{get;set;}//added by yinfeng.guo 2012-08-20 -> the status of the survey taken
	
    public String  qQuestion                      {get; set;}
    public Boolean qRequired                      {get; set;}
    public String  qChoices                       {get; set;}
    public String surveyName                        {get; set;}
    public String surveyHeader                {get; set;}
    public String surveyId                          {get; set;} 
    public String renderSurveyPreview           {get; set;}  
    public String questionName                    {get; set;}  
    public String questionType                    {get; set;}
    public Boolean questionRequired             {get; set;}
    public List<SelectOption> singleOptions   {get; set;}   
    public List<ClsQuestion> allQuestions        {get; set;}
    public List<String> responses                   {get; set;}
    public Integer allQuestionsSize               {get; set;}
    public String  templateURL                {get; set;}
    public String  surveyThankYouText         {get; set;}
    public String  surveyThankYouURL          {get; set;}
    public String  caseId                     {get; set;}
    public String  userId                     {get; set;}
    public Boolean  surveyReviewed                {get;set;}

    /* Retrieves the list of questions, the survey name, after retrieving the 
       necessary parameters from the url.
     */

    public ExtTakeSurvey(ApexPages.StandardController stdController) {
        // Get url parameters
        surveyId = Apexpages.currentPage().getParameters().get('id');
        caseId   = Apexpages.currentPage().getParameters().get('caId');
        userId = Apexpages.currentPage().getParameters().get('cId');
        String surveyReviewedVar = Apexpages.currentPage().getParameters().get('isReviewed'); 
        if(surveyReviewedVar != null && surveyReviewedVar == '1') 
            surveyReviewed = true; 
        else 
            surveyReviewed = false; 
    
        if(userId != null) 
            surveyThankYouURL='/' + userId;
        if(caseId ==null || caseId.length()<5){ 
            caseId = 'none';
        }
        // By default the preview is not showing up
        renderSurveyPreview = 'false';

        if (surveyId != null){ 
            // Retrieve all necessary information to be displayed on the page
            allQuestions = new List<ClsQuestion>();
            setSurveyNameAndThankYou(surveyId);
            //allQuestionsSize = setupQuestionList();
            //added by yinfeng.guo <yinfeng.guo@itbconsult.com> -> get surveys from custom setting
            set<String> set_surveys = new set<String>();
            //below line modified by yinfeng.guo 2012-12-07 add : Survey_Settings__c.getInstance('Kundenklassifizierung') != null   : fix error for change set in PROD
            /* if(Survey_Settings__c.getInstance('Kundenklassifizierung') != null && Survey_Settings__c.getInstance('Kundenklassifizierung').Active__c == true && Survey_Settings__c.getInstance('Kundenklassifizierung').Survey_Type__c != null){
            	for(String s : Survey_Settings__c.getInstance('Kundenklassifizierung').Survey_Type__c.split(',')){
            		if(s.trim() != '') set_surveys.add(s.trim());
            	}
            } commented by xia 2013-01-31*/
            //added by xia 2013-01-31
            for(Survey_Settings__c ss: Survey_Settings__c.getAll().values()){
            	if(ss.Active__c && ss.Survey_Type__c != null){
            		for(String s : ss.Survey_Type__c.split(',')){
	            		if(s.trim() != '') set_surveys.add(s.trim());
	            	}	
            	}
            }
            //added by yinfeng.guo <yinfeng.guo@itbconsult.com> -> get surveys from custom setting
            
            Survey__c sv = [Select id, Name from Survey__c where id = :surveyId limit 1];
            if(sv != null && set_surveys.contains(sv.Name.trim())) { //&& sv.Name.trim().equals('Kundenklassifizierung'     comment out by yinfeng.guo
                surveyThankYouText = system.Label.Survey_Taken_Message; 
                buttonMode = '4';
            }
            GetInitSurveyTaken(); //added by yinfeng.guo 2012-08-20
        }
    }

    /* Called during the setup of the page. 
       Retrieve questions and responses from DB and inserts them in 2 lists. */
    public Integer setupQuestionList(){
        getAQuestion();
        return allQuestions.size();
    }


    /** Sets the survey's name variable
     *  param: sID  The survey ID as specified in the DB
     */
    public void setSurveyNameAndThankYou(String sId){
        Survey__c s = [SELECT Name, Id,
                  // TODO, URL__c, thankYouText__c, thankYouLink__c, 
                  Survey_Header__c FROM Survey__c WHERE Id =:sId];
        surveyName = s.Name;
        surveyHeader = s.Survey_Header__c;
        //TODO templateURL = s.URL__c+'id='+sId;//+'&cId={!Contact.Id}'+'&caId='+'{!Case.id}';
        templateURL = 'id='+sId;
        //TODO surveyThankYouText = s.thankYouText__c;
        //TODO surveyThankYouURL = s.thankYouLink__c;
    }

    public Pagereference updateSurveyName(){
        Survey__c s = [SELECT Name, Id 
            //TODO , URL__c, thankYouText__c, thankYouLink__c 
            FROM Survey__c WHERE Id =:surveyId];
        s.Name = surveyName;
        try{
            update s;
        }catch (Exception e){
            Apexpages.addMessages(e);
        }
        return null;
    } 

    public Pagereference cancel(){
        return new PageReference('/' + userId);
    } 

    public Pagereference updateSurveyThankYouAndLink(){
        Survey__c s = [SELECT Name, Id 
            //TODO  , URL__c, thankYouText__c, thankYouLink__c 
            FROM Survey__c WHERE Id =:surveyId];
        //TODO s.thankYouText__c = surveyThankYouText;
        //TODO s.thankYouLink__c = surveyThankYouURL;
        try{
            update s;
        }catch(Exception e){
            Apexpages.addMessages(e);
        }
        return null;
    }

    /** When requested from the page - when the user clicks on 'Update Order' -
      this function will reorganize the list so that it is displayed in the new order
     */
    public Pagereference refreshQuestionList(){
        setupQuestionList();
        return null;
    }


    Webservice static String getResponses(List<String> resp) {

        if(resp.size()<=2)
            return 'false';

        String userId = resp.get(resp.size()-3);
        String surveyId = resp.get(resp.size()-2);
        String caseId = resp.get(resp.size()-1);

        if(caseId.toUpperCase()=='NONE'||caseId == null || caseId.length()<3)
            caseId = null;

        if(userId.toUpperCase() == 'NONE')
            userId = null;
        List <Survey_Taken__c> stList;
        try{
        	//Start 2012-08-17 Add by Bin Yuan -> add the new field "Status__c"
            stList = [Select id,  Account_Name__c, Status__c //TODO ,Taken__c contact__c
            //End 2012-08-17 Add by Bin Yuan
                from Survey_Taken__c where Account_Name__c =:userId AND Survey__c= :surveyId]; // TODO AND Case__c= :caseId];
        }catch(Exception e){
            return 'problem';
        }
        Survey_Taken__c st;
        if(stList == null || stList.size()==0)
            return 'problem';
        else
            st = stList[0];
		
		///* added by yinfeng.guo 2012-11-10 fix bug : exist mutiple same survey takens  
		list<Survey_Taken__c> list_surveyTaken2Delete = new list<Survey_Taken__c>();
		for(Survey_Taken__c staken : stList){
			if(staken.Id != st.Id) list_surveyTaken2Delete.add(staken);
		}
		if(!list_surveyTaken2Delete.isEmpty()) delete list_surveyTaken2Delete;
		//*/
        resp.remove(resp.size()-1);
        resp.remove(resp.size()-1);
        resp.remove(resp.size()-1);

        List<Survey_Question__c> allQuestions = [Select Id, Type__c, Required__c, Choices__c from Survey_Question__c Where Survey__c=:surveyId order by OrderNumber__c];
		Integer questionAmount = allQuestions.size();
		Integer j = 0;
        List<String> questionsId = new List<String>();

        for (Survey_Question__c q : allQuestions)
            questionsId.add(q.Id);
		
		//START 2012-08-01 added by Yuanyuan
        //new response list  
        List <Survey_Question_Response__c> list_sqr2upsert = new List<Survey_Question_Response__c>();
		
		//map<Id, list<Survey_Question_Response__c>> map_questionId_list_oldButNewestResponse = new map<Id, list<Survey_Question_Response__c>>();
		
		//map<String, map<Id, list<Survey_Question_Response__c>>> map_questionType_questionId_list_oldButNewestResponse = new map<String, map<Id, list<Survey_Question_Response__c>>>();
		map<Id, Survey_Question_Response__c> map_questionId_oldButNewestResponse = new map<Id, Survey_Question_Response__c>();
		
		list<Survey_Question_Response__c> list_oldOtherResponse = new list<Survey_Question_Response__c>();
		
		Datetime newestDate;
		
		for(Survey_Question_Response__c sqr : [SELECT Id, 
													 Response__c, 
													 Survey_Question__c,
													 Survey_Question__r.Type__c,
													 Survey_Taken__c,
													 Survey_Taken__r.Account_Name__c,
													 CreatedDate,
													 LastModifiedDate
											  FROM Survey_Question_Response__c 
											  where Survey_Taken__r.Account_Name__c = :userId
											  AND Survey_Question__c IN :questionsId
											  ORDER BY CreatedDate DESC]){
			if(j == 0){
				newestDate = sqr.LastModifiedDate;
				j++;
			}
			
			if(newestDate == sqr.LastModifiedDate && sqr.Response__c != 'NO RESPONSE' && sqr.Survey_Question__r.Type__c != 'Multi-Select--Vertical'){//don't create response for a question without answer
				map_questionId_oldButNewestResponse.put(sqr.Survey_Question__c, sqr);
			}
			else{
				list_oldOtherResponse.add(sqr);
			}								  	
		}
		Savepoint sp = Database.setSavePoint(); 
		if(list_oldOtherResponse.size() != 0){
			try{
				delete list_oldOtherResponse;
			}
			catch(exception e){}
		}
		Integer i = 0;
		String surveyTakerId = String.valueOf(st.Id);
		for(String r:resp) {
            if(!checkRequired(r, allQuestions[i])){
                return 'false';             
            }
            list_sqr2upsert.addAll(getResponseList(r, allQuestions[i], surveyTakerId, map_questionId_oldButNewestResponse));
            i++;
        }
		
		
		//list_sqr2upsert = getResponseList(resp, allQuestions, String.valueOf(st.Id), map_questionId_list_oldButNewestResponse);
		//END 2012-08-01 added by Yuanyuan
		//2012-08-01 comment out by Yuanyuan Zhang use new static method getResponseList 
        /*
        Integer i = 0;
        
        for(String r:resp) {
            if(!checkRequired(r, allQuestions[i])){
                return 'false';             
            }
            if(allQuestions[i].Type__c=='Multi-Select--Vertical'){
                sqrList.addAll(handleMultiSelectResponse(r, String.valueOf(st.Id), questionsId[i], map_questionId_oldButNewestResponse));
            }
            else{
                Survey_Question_Response__c sqr = new Survey_Question_Response__c();
                sqr.Survey_Taken__c = st.Id;
                sqr.Response__c = r;
                sqr.Survey_Question__c = questionsId[i];
                sqrList.add(sqr);
            }
            i++;
            //insert sqr;

        }
        */
        
        Survey__c sv = [Select id, Name from Survey__c where id = :surveyId limit 1];
        set<id> set_sqrIds = new set<id>();
        for(Survey_Question_Response__c sqr: list_sqr2upsert){
        	set_sqrIds.add(sqr.id);
        }
        list<Survey_Question_Response__c> list_sqrDelete = new list<Survey_Question_Response__c>();
        
		for(Survey_Question_Response__c s : [select id, name from Survey_Question_Response__c where Survey_Taken__c = : st.Id]) {
			if(!set_sqrIds.contains(s.id)) list_sqrDelete.add(s);
		}
        delete list_sqrDelete; 
        system.debug('@@@@####$$$$:'+list_sqr2upsert);
        upsert list_sqr2upsert;
        
        
        //if(sv != null && sv.Name.trim().equals('Kundenklassifizierung')) {
            //updateCustomer(userId, sqrList); 
            /* 2012-06-04 modified by Xia Tong <xia.tong@itbconsult.com> -- START*/
            //ClsCustomerClassfication customerClassfication = new ClsCustomerClassfication(userId, surveyId);
            //customerClassfication.updateObject();
           
            /*added by DFL 2012-06-20 START */
            List<Account> list_accounts; // DFL
           
            ClsSurveyUtil cls = new ClsSurveyUtil(userId,surveyId,st.Id);
            //cls.calcSurveyTakens();
            list_accounts = cls.calcSurveyTakens(); //DFL
            //if(list_accounts != null && list_accounts.size() > 0) update list_accounts; //DFL
            /* 2012-06-04 changed by Xia Tong <xia.tong@itbconsult.com> -- END*/
           
        //}

        return 'true' + ClsSurveyUtil.DEBUG_Message;
    }
	
	public static list<Survey_Question_Response__c> getResponseList(String answers, Survey_Question__c questions, String takerId, map<Id, Survey_Question_Response__c> map_questionId_oldButNewestResponse){
		list<Survey_Question_Response__c> list_return = new list<Survey_Question_Response__c>();
		list<String> list_multianswer = new list<String>();
		system.debug('NO RESPONSE');
		//list<String> list_multiChoice = new list<String>();
		if(answers != 'NO RESPONSE'){
			if(questions.Type__c == 'Multi-Select--Vertical'){
				list_multianswer.clear();
				list_multianswer = answers.split('&@');
				for(String answer : list_multianswer){
					Survey_Question_Response__c sqr = new Survey_Question_Response__c();
		            sqr.Response__c = answer;
		            sqr.Survey_Taken__c = takerId;
		            sqr.Survey_Question__c = questions.Id;
		            system.debug('@@@@@@@@##########sqr.Survey_Question__c' + sqr.Survey_Question__c);
		            list_return.add(sqr);
				}
			}
			else{
				Survey_Question_Response__c sqr = new Survey_Question_Response__c();
				sqr.Survey_Taken__c = takerId;
	            sqr.Survey_Question__c = questions.Id;
				if(map_questionId_oldButNewestResponse.containsKey(questions.Id)){
					sqr = map_questionId_oldButNewestResponse.get(questions.Id);
				}
				sqr.Response__c = answers;
	            
	            list_return.add(sqr);
			}
		}
		return list_return;
	}
	@TestVisible
    private static list<Survey_Question_Response__c> handleMultiSelectResponse(String response, String surveyTakerId, String questionId){
        List <String> responses = response.split('&@');
        List<Survey_Question_Response__c> sqrList = new List<Survey_Question_Response__c>();
        for( String r:responses){
        	
            Survey_Question_Response__c sqr = new Survey_Question_Response__c();
            sqr.Response__c = r;
            sqr.Survey_Taken__c = surveyTakerId;
            sqr.Survey_Question__c = questionId;
            sqrList.add(sqr);
        }
        return sqrList;
    }
    //------------------------------------------------------------------------------//    
    private static boolean checkRequired(String response, Survey_Question__c question){
        if(question.Required__c == true){
            if(response == null || response =='NO RESPONSE')
                return false;
        }
        return true;
    }   


    /*private static void updateCustomer(String userId,  List<Survey_Question_Response__c> list_responses) {
        Account account = [Select id, Customer_Classification_01__c, Customer_Classification_02__c, 
                            Target_Phone_Calls__c, Target_Visits__c      
                           from Account where id = :userId limit 1];
        Set<String>  set_questionIds = new Set<String>(); 
        Map<String, String> map_questionId_response = new Map<String, String>();
        for(Survey_Question_Response__c sqr: list_responses) {
            set_questionIds.add(sqr.Survey_Question__c);
            map_questionId_response.put(sqr.Survey_Question__c, sqr.Response__c);
        }
        Double score1 = 0; 
        Integer count1 = 0; 
        Double score2 = 0; 
        integer count2 = 0;
        for(Survey_Question__c sq: [SELECT  Type__c, Id, Survey__c, Required__c, 
                Question__c,  OrderNumber__c, 
                Name, Choices__c,Score__c, Weight__c, Class__c,Is_Calculable__c
                FROM Survey_Question__c
                where id in :set_questionIds]) {
            ClsQuestion q = new ClsQuestion(sq);
            String answer = map_questionId_response.get(sq.id);  
            //if the user does not answer this question, the answer will be stored as 'NO RESPONSE' in the Survey_Question_Response__c table 
            if(answer != null && answer.trim().length() > 0 && answer != 'NO RESPONSE') {
                if(sq.OrderNumber__c < 6) {
                    score1 += q.getResult(answer);
                    count1 ++;                  
                } else {
                    score2 += q.getResult(answer);
                    count2 ++;          
                }                   
            } 
                            
        }

        if(count1 > 0){
            double avg1 = score1 / count1; 
            if(avg1 < 2) 
                account.Customer_Classification_01__c = 'U5'; 
            else if(avg1 < 3.4) 
                account.Customer_Classification_01__c = 'U4'; 
            else if(avg1 < 6) 
                account.Customer_Classification_01__c = 'U3';           
            else if(avg1 < 8.5) 
                account.Customer_Classification_01__c = 'U2';
            else  
                account.Customer_Classification_01__c = 'U1';           
        } else 
            account.Customer_Classification_01__c = '';         
            
        if(count2 > 0) {
            double avg2 = score2 / count2; 
            if(avg2 < 4) 
                account.Customer_Classification_02__c = 'A3'; 
            else if(avg2 < 7) 
                account.Customer_Classification_02__c = 'A2'; 
            else  
                account.Customer_Classification_02__c = 'A1';           
        } else 
            account.Customer_Classification_02__c = '';         
        
        Map<String, integer> map_custClassfication_deservedVisitValue = new Map<String, Integer> {
            'A1,U1'=> 10, 'A1,U2'=> 7, 'A1,U3'=> 4, 'A1,U4'=> 0, 'A1,U5'=> 0, 
            'A2,U1'=> 7, 'A2,U2'=> 7, 'A2,U3'=> 4, 'A2,U4'=> 0, 'A2,U5'=> 0, 
            'A3,U1'=> 0, 'A3,U2'=> 0, 'A3,U3'=> 0, 'A3,U4'=> 0, 'A3,U5'=> 0
        };
        Map<String, integer> map_custClassfication_deservedTelephoneValue = new Map<String, Integer> {
            'A1,U1'=> 0, 'A1,U2'=> 0, 'A1,U3'=> 0, 'A1,U4'=> 2, 'A1,U5'=> 0, 
            'A2,U1'=> 0, 'A2,U2'=> 0, 'A2,U3'=> 0, 'A2,U4'=> 2, 'A2,U5'=> 0, 
            'A3,U1'=> 4, 'A3,U2'=> 4, 'A3,U3'=> 2, 'A3,U4'=> 2, 'A3,U5'=> 0
        };      
        String customerClassification01 = (account.Customer_Classification_01__c == '') ? 'U5' :  account.Customer_Classification_01__c; 
        String customerClassification02 = (account.Customer_Classification_02__c == '') ? 'A3' :  account.Customer_Classification_02__c; 
        
        account.Target_Visits__c = 
            map_custClassfication_deservedVisitValue.get(customerClassification02 + ',' + customerClassification01);        
        account.Target_Phone_Calls__c = 
            map_custClassfication_deservedTelephoneValue.get(customerClassification02 + ',' + customerClassification01);
        update account;
    }*/

    /** Redirects the page that displays the detailed results of the survey, 
      from all users who took the survey.
     */
    public PageReference resultPage() {
        return new PageReference('/apex/ResultsPage?id='+surveyId);
    }

    /** Redirects the page that displays the thank you note 
     */
    public PageReference thankYouPage() {
        return new PageReference('http://surveysite-developer-edition.na7.force.com/ThankYouPage');
    }


    /** Called from a VisualForce page to delete a question from the DB
     *  param: question ID  The Id of the question as specified in the DB
     *  returns 'true' on success
     */
    Webservice static String deleteQuestion(String questionID){
        Survey_Question__c sq = [Select Id, Weight__c, Name FROM Survey_Question__c WHERE Id =: questionID];
        delete sq;

        return 'true'; 
    }

    public Pagereference deleteRefresh(){
        allQuestions.clear();
        Double j = 0.0;
        List<Survey_Question__c> allQuestionsObject = 
            [Select Type__c, Id, Survey__c, Required__c, 
            Question__c,  OrderNumber__c, 
            Name, Choices__c,Score__c, Weight__c, Class__c, Is_Calculable__c    
                From Survey_Question__c  
                WHERE Survey__c =: surveyId
                order by OrderNumber__c];
        for (Integer i =0; i< allQuestionsObject.size(); i++){
            allQuestionsObject[i].OrderNumber__c= j;
            ClsQuestion theQ = new ClsQuestion(allQuestionsObject[i]);
            allQuestions.add(theQ);
            j = j+1.0;
        }
        responses = getResponses();
        try{
            update allQuestionsObject;
        }catch(Exception e){
            Apexpages.addMessages(e);
        }
        return null;
    }


    /** Called from a VisualForce page to update the order number of the questions
     *  in the DB.
     *  param qOrder:   List of String to specify the new order of the questions
     *  returns 'true' on success
     */ 
    Webservice static String updateQuestionOrder(List<String> qOrder){
        Integer i;
        String qId;
        Survey_Question__c q;
        for(i=0; i<qOrder.size(); i++){
            qId = qOrder[i];
            //system.debug('First ID is '+qId+ '  order '+ i );
            q = [select OrderNumber__c, id from Survey_Question__c where id = :qId];
            q.OrderNumber__c = i;
            update q;
            q = [select OrderNumber__c, id from Survey_Question__c where id = :qId];
            //System.debug('Second ID is '+q.Id+ '  order '+ q.OrderNumber__c );

        }
        return 'true';
    }

    /** 
     */
    public List<String> getResponses() {
        List<Survey_Question_Response__c> qr = [Select Survey_Question__c, Survey_Taken__c, Response__c, Name From Survey_Question_Response__c limit 100];
        List<String> resp = new List<String>();
        for (Survey_Question_Response__c r : qr) {
            resp.add(r.Response__c);
        }

        return resp;
    }  


    /** Fills up the List of questions to be displayed on the Visualforce page
     */ 
    public List<ClsQuestion> getAQuestion() {
        qQuestion = '';
        qChoices ='';

        List<Survey_Question__c> allQuestionsObject = 
            [Select s.Type__c, s.Id, s.Survey__c, s.Required__c, s.Question__c, 
            s.OrderNumber__c, s.Weight__c, s.Class__c, Is_Calculable__c,
            s.Name, s.Choices__c,Score__c 
                From Survey_Question__c s 
                WHERE s.Survey__c =: surveyId order by s.OrderNumber__c];
        allQuestions = new List<ClsQuestion>();

        Double old_OrderNumber = 0;
        Double new_OrderNumber;
        Double difference = 0;
        /* Make sure that the order number follow each other (after deleting a question, orders might not do so) */
        for (Survey_Question__c q : allQuestionsObject){ 
            new_OrderNumber = q.OrderNumber__c;
            difference = new_OrderNumber - old_OrderNumber - 1;
            if (difference > 0) {
                Double dd = double.valueOf(difference);
                Integer newOrderInt = dd.intValue();
                q.OrderNumber__c -= Integer.valueOf(newOrderInt); 
            }
            old_OrderNumber = q.OrderNumber__c;
            ClsQuestion theQ = new ClsQuestion(q);
            allQuestions.add(theQ);
        }
        allQuestionsSize = allQuestions.size();
        if(surveyReviewed) 
            getSurveyAnswer();
        return allQuestions;
    }   
    
    public void getSurveyAnswer() { 
        Map<String, ClsQuestion> map_id_question; 
        if(allQuestions != null && allQuestions.size() > 0) {
            map_id_question = new Map<String, ClsQuestion>();
            for(ClsQuestion q: allQuestions) 
                map_id_question.put(q.id, q);
            
            String latestSurveyTakenId; 
            ClsQuestion question;
            //Query the latest survey taken id
            List<Survey_Taken__c> list_sts = [SELECT View__c, Account_Name__c, 
                                    Id, CreatedDate, Survey_Name__c, Name, Survey__c 
                                    FROM Survey_Taken__c
                                    where Account_Name__c = :userId 
                                    and Survey__c = :surveyId
                                    order by CreatedDate desc]; 
            if(list_sts != null && list_sts.size() > 0) {
                latestSurveyTakenId = list_sts[0].Id; 
                for(Survey_Question_Response__c sqr: [SELECT Response__c, Id, Name, 
                                                     Survey_Question__c,  
                                                     Survey_Taken__c,  CreatedDate 
                                                  FROM Survey_Question_Response__c 
                                                  where Survey_Taken__c = : latestSurveyTakenId]) {
                    question = map_id_question.get(sqr.Survey_Question__c);
                    system.debug('question is ' + question); 
                    //add by Bin Yuan 2012-10-09 for null reference bug fix
                    if(question != null) {
                    	question.setAnswer(sqr.Response__c);
                    }                    
                    //add by Bin Yuan 2012-10-09 for null reference bug fix
                    system.debug('sqr.Response__c' + sqr.Response__c);
                }
            } else 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'User did not take such survey'));
        } else 
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Survey does not contain any question'));
    }
    
    
    private void GetInitSurveyTaken(){
		List<Survey_Taken__c> list_sts = [SELECT View__c, Account_Name__c, 
                                    Id, CreatedDate, Survey_Name__c, Name, Survey__c, Status__c 
                                    FROM Survey_Taken__c
                                    where Account_Name__c = :userId 
                                    and Survey__c = :surveyId
                                    order by CreatedDate desc]; 
     	if(list_sts != null && list_sts.size() > 0){
     		
     		if(buttonMode != null && buttonMode == '4'){
     			//if(list_sts[0].Status__c == 'New') Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_New));
     			//else if(list_sts[0].Status__c == 'Working') Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_Working));
     			//else if(list_sts[0].Status__c == 'Completed') Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_Completed));
     		}
     		/*
     		else if(list_sts[0].Status__c == 'New'){
				buttonMode = '1';
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_New));
     		}
     		*/
     		else if(list_sts[0].Status__c == 'Working'){
				buttonMode = '2';
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_Working));
     		}
     		else if(list_sts[0].Status__c == 'Completed'){
				buttonMode = '3';
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_Completed));
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.Survey_Taken_Completed));
     		}
     		else buttonMode = '1';
     	}
     	else{
     		if(buttonMode != '4') {
     			buttonMode = '1';
     			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Status : '+system.Label.Survey_Taken_Status_New));
     		}
     	}                           
                                    
    }
    
    
}