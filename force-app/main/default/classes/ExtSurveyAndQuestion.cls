/* Controller associated with pages to edit a survey 
 * add/delete question, change question order ...  
 *
 @author Haobo Song
 @created 2011-10-25
 @version 1.0
 @since 20.0
 *
 @changelog
 * 2012-09-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Modified : after has survey taken is in status "Complete", make the survey unable edit -> line 16, and line 92 to line 100
 * 2011-10-25 Haobo Song <haobo.song@itbconsult.com>
 * - Migrated from old system
 */ 
global virtual with sharing class ExtSurveyAndQuestion{// extends SurveyAndQuestionController{
	//Start ITB 2012-10-19 by Bin Yuan : Comment out to make Survey Modifiable form The fact of being already taken or not by any user.
	/*
	public Boolean hasSurveyTakenCompleted {get; set;}//added by yinfeng.guo 
	public String hasSurveyTakenCompletedMsg {get; set;}//added by yinfeng.guo 
	*/
	//End ITB 2012-10-19 by Bin Yuan : Comment out to make Survey Modifiable form The fact of being already taken or not by any user.
	public List<SelectOption> questionTypeOptions {get; set;}
	public List<SelectOption> classTypeOptions {get; set;}	
	public String  showBasicValues                {get; set;}
	public String  showSingleSelect               {get; set;}
	public String  showSingleSelectPreview        {get; set;}
	public String  showMultiSelect                {get; set;}
	public String  showMultiSelectPreview         {get; set;}
	public String  showFreeText                   {get; set;}
	public String  showFreeTextPreview            {get; set;}
	public String  showRowQuestion                {get; set;}
	public String  showRowQuestionPreview         {get; set;}
	public String  showSelectQuestionType         {get; set;}
	public List<SelectOption> singleOptions       {get; set;}
	public List<SelectOption> multiOptions        {get; set;}
	public List<SelectOption> rowOptions          {get; set;}
	public String  questionReference              {get; set;}
	public String  reportId                       {get; set;}
	private Boolean saveAndNew;
	private String  surveyRef;
	private String surveyOrderNumber;
	private Survey_Question__c questionToUpdate;
	/***/
	public String  qQuestion                      {get; set;}
	public Boolean qRequired                      {get; set;}
	public Boolean qCalculable 					   {get;set;}
	public String  qChoices                       {get; set;}
	public String qClass						{get;set;} //2011-11-27 added by Shanliang Wu
	public String qScores						{get;set;} //2011-11-27 added by Shanliang Wu
	public String qWeight						{get;set;} //2011-11-27 added by Shanliang Wu
	public List<ChoiceScore> qChoiceScores		{get;set;}
	public String surveyName                  {get; set;}
	public String surveyHeader                {get; set;}
	public String surveyId                    {get; set;} 
	public String renderSurveyPreview         {get; set;}  
	public String questionName                {get; set;}  
	public String questionType                {get; set;}
	public Boolean questionRequired           {get; set;}
	public List<question> allQuestions        {get; set;}
	public List<String> responses             {get; set;}
	public Integer allQuestionsSize           {get; set;}
	public String  templateURL                {get; set;}
	public String  surveyThankYouText         {get; set;}
	public String  surveyThankYouURL          {get; set;}
	public String  caseId                     {get; set;}
	private ApexPages.StandardController stdr;

	public  ExtSurveyAndQuestion (ApexPages.StandardController stdController){
		stdr = stdController;
		// Get url parameters
		surveyId = Apexpages.currentPage().getParameters().get('id');
		caseId   = Apexpages.currentPage().getParameters().get('caId');
		if(caseId ==null || caseId.length()<5){
			caseId = 'none';
		}
		// By default the preview is not showing up
		renderSurveyPreview = 'false';

		if (surveyId != null){ 
			// Retrieve all necessary information to be displayed on the page 
			allQuestions = new List<question>();
			setSurveyNameAndThankYou(surveyId);
			//allQuestionsSize = setupQuestionList();
		}
		/**/
		//super(stdController);
		surveyRef = surveyId;
		//TODO updateUrl();
		setupQuestionTypeOptions();
		//setClassTypeOptions();
		resetViewsToFalse(true);
		showSelectQuestionType = 'False';
		ClsReportFinderUtil rfu = new ClsReportFinderUtil();
		reportId = rfu.findReportId('Survey with Questions and Responses');
		
		//Start ITB 2012-10-19 by Bin Yuan : Comment out to make Survey Modifiable form The fact of being already taken or not by any user.
		/*
		//Begin : Modified by yinfeng.guo 2012-09-11 : after has survey taken is in status "Complete", make the survey unable edit
		hasSurveyTakenCompleted = false;
		for(Survey_Taken__c st : [SELECT  Status__c  FROM Survey_Taken__c where Survey__c =: surveyId]){
			if(st.Status__c == 'Completed'){
				hasSurveyTakenCompleted = true;
				hasSurveyTakenCompletedMsg =  system.Label.Can_Not_Edit_Survey;
				break;
			}
		}
		//Begin : Modified by yinfeng.guo 2012-09-11 : after has survey taken is in status "Complete", make the survey unable edit
		*/
		//End ITB 2012-10-19 by Bin Yuan : Comment out to make Survey Modifiable form The fact of being already taken or not by any user.
	}

	public PageReference save() {
		System.debug('deug1 -=-=-=- save line 113');
		Pagereference pr = null;
		if(stdr != null) {
			Survey__c survey = (Survey__c)stdr.getRecord();
			update survey;
			pr = new Pagereference('/apex/ExtSurvey?id='+surveyRef);			
			pr.setRedirect(true);
		}
		return pr;
	}
	public Pagereference back() {
		System.debug('deug2 -=-=-=- back line 124');
		return new Pagereference('/apex/ExtGsurveys');
	}

		
	//if you are using a developement org you will need to manually add your Pod.
	//TODO
	public Pagereference updateUrl(){
		System.debug('deug3 -=-=-=- updateUrl line 132');
		/*Survey__c survey = [select Name, Id, URL__c from Survey__c where id = :surveyId];  
		  Site subSite = [select Subdomain, id from Site limit 1];
		  if(survey.URL__c.contains(subSite.Subdomain))
		  return null;
		  else
		  return updateDomain(survey, subSite);*/
		return null;
	}

	private Pagereference updateDomain(Survey__c survey, Site subSite){
		System.debug('deug4 -=-=-=- updateDomain line 143');
		String surveyUrl = ''; // TODO survey.URL__c;
		String subdomainReplace = ''; // TODO 'http://'+subSite.subdomain;
		surveyUrl = surveyUrl.substring(surveyUrl.indexOf('.'), surveyUrl.length());
		surveyUrl = subdomainReplace + surveyUrl;
		try{
			// TODO survey.URL__c = surveyUrl;
			update survey;
		}catch(Exception e){
			system.debug(e);
		}
		setSurveyNameAndThankYou(surveyId);
		return null;
	}

	public Pagereference makeNewQuestionLink(){
		System.debug('deug5 -=-=-=- makeNewQuestionLink line 159');
		questionReference = null;
		resetViewsToFalse(true);
		return null;
	}


	public Pagereference editQuestion(){
		System.debug('deug6 -=-=-=- editQuestion line 167');
		if (questionReference == null)
			return null;
		setupEditQuestion();
		showSelectQuestionType = 'True';
		return null;
	}

	public Pagereference addQuestion(){
		System.debug('deug7 -=-=-=- addQuestion line 176');
		showSelectQuestionType = 'True';
		resetViewsToFalse(true);
		return null;
	}

	private void setupEditQuestion(){
		System.debug('deug8 -=-=-=- setupEditQuestion line 183');
		questionToUpdate =     [Select Type__c, Question__c, Id, Choices__c, 
								Required__c, OrderNumber__c, Class__c, Score__c, Weight__c, Is_Calculable__c,
						 		Survey__c, Name
							 From Survey_Question__c 
							 where Id = :questionReference];
		questionType = questionToUpdate.Type__c;
		setupQuestionFields();
		setupEditFields(questionToUpdate);
	}

	private void setupEditFields(Survey_Question__c q){
		System.debug('deug9 -=-=-=- setupEditFields line 195');
		qQuestion = q.Question__c;
		qRequired = q.Required__c;
		qCalculable = q.Is_Calculable__c;
		qClass = q.Class__c;
		qChoices = q.Choices__c;
		qScores = q.Score__c;
		qWeight = String.valueOf(q.Weight__c); 
		qChoiceScores = getChoiceScores(qChoices, qScores);
		surveyRef = q.Survey__c;    
	}

	private List<ChoiceScore> getChoiceScores(String choices, String scores) {
		System.debug('deug10 -=-=-=- getChoiceScores line 208');
		List<ChoiceScore> list_choiceScore = new List<ChoiceScore>();
		List<String> list_choices;
		List<String> list_scores;
		
		if(choices != null && choices.trim().length() > 0)
			list_choices = choices.split('\n');
		if(scores != null && scores.trim().length() > 0)
			list_scores = scores.split('\n'); 
	
					
		if(list_choices!= null && list_scores != null  
				&& list_choices.size() > 0 && list_scores.size() > 0 
				&& list_choices.size() == list_scores.size() ) {
			Integer i; 
			for(i = 0; i < list_choices.size(); i++) {
				system.debug('list_choices' + list_choices[i]);
				system.debug('list_score' + list_scores[i]);
				list_choiceScore.add(new ChoiceScore(i + 1, list_choices[i].trim(), list_scores[i].trim()));
			
			}
		}
			
		return list_choiceScore;						
	}
		
	private void setupQuestionTypeOptions(){
		//get picklist values
		Schema.DescribeFieldResult fieldResult = Survey_Question__c.Type__c.getDescribe();
		List<Schema.PicklistEntry>  ple = fieldResult.getPicklistValues();

		//set/add them to selectOption list
		questionTypeOptions = new List<SelectOption>();
		questionTypeOptions.add(new SelectOption('--SELECT--', '--SELECT--'));
		for(Schema.PicklistEntry pe: ple){
			questionTypeOptions.add(new SelectOption(pe.getLabel(), pe.getValue()));
		}
	}
	/*
	private void setClassTypeOptions() {
		classTypeOptions = new List<SelectOption>();
		classTypeOptions.add(new SelectOption('--SELECT--', '--SELECT--'));
		List<Survey_Classification__c> list_class = [Select Class__c, Id, Survey__c 
													from Survey_Classification__c 
													where Survey__c = :surveyId];
		if(!list_class.isempty()) {
			Set<String> set_class = new Set<String>(); 
			for(Survey_Classification__c sc: list_class) 
				set_class.add(sc.Class__c);
			for(String c: set_class) 
				classTypeOptions.add(new SelectOption(c, c));
		}
	}*/

	private void resetViewsToFalse(Boolean clearFields){
		showSingleSelect =        'False';
		showSingleSelectPreview = 'False';
		showMultiSelect =         'False';
		showMultiSelectPreview=   'False';
		showFreeText =            'False';
		showFreeTextPreview=      'False';
		showRowQuestion=          'False';
		showRowQuestionPreview=   'False';
		qRequired =                true;
		qCalculable = false;
		if(clearFields){
			qChoices =                 '';
			qScores = '';
			qQuestion =                '';
			qClass = ''; 
			qWeight = '1';
			qChoiceScores = new List<ChoiceScore>();
		}
	}

	public Pagereference setupQuestionFields(){
		resetViewsToFalse(false);
		if(questionType=='Multi-Select-Vertical'){
			showMultiSelect='True';
		}
		else if(questionType == 'Single Select-Vertical'){
			showSingleSelect = 'True';
		}
		else if(questionType == 'Free Text'){
			showFreeText = 'True';
		}
		else if(questionType == 'Single Select-Horizontal'){
			showRowQuestion = 'True';
		}
		return null;
	}  

	public Pagereference changeCalculable() {
		return null;	
	} 
	
	public Pagereference saveAndNewQuestion(){
		saveAndNew = True;
		if(questionReference == null || questionReference.length() <5)
			return saveNewQuestion();
		else 
			return updateQuestion();  
	}


	public Pagereference controllerSavQuestion(){
		if(questionReference == null || questionReference.length() <5){
			return saveNewQuestion();
		}
		else{ 
			return updateQuestion();
		}
	}


	private Pagereference updateQuestion(){
		//questionToUpdate is setup in an earlier call to editQuestion()
		questionToUpdate.Name = questionToName(qQuestion);
		questionToUpdate.Class__c = qClass;
		questionToUpdate.Choices__c = qChoices;
		questionToUpdate.Required__c = qRequired;
		questionToUpdate.Is_Calculable__c = qCalculable;
		questionToUpdate.Type__c = questionType;
		questionToUpdate.Question__c = qQuestion;
		questionToUpdate.Score__c = qScores;
		questionToUpdate.Weight__c = Decimal.valueOf(qWeight);
		try{
			update questionToUpdate;
			resetViewsToFalse(true);
			//deleteOldResponses(questionToUpdate.id);
			//questionReference = null;
		}catch(Exception e){
			System.debug(e);
			Apexpages.addMessages(e);
		}

		return saveOrUpdateReturn();
	}

	private void deleteOldResponses(String qId){
		for(List <Survey_Question_Response__c> sResponses : [select id, Survey_Question__c from Survey_Question_Response__c where Survey_Question__c = :qId]) {
			delete sResponses;
		}
		/*
		if(sResponses != null)
			delete sResponses;
		*/
	}

	private Pagereference saveOrUpdateReturn(){
		
		system.debug('returning...');
		setupQuestionList();
		Pagereference pr = new Pagereference('/apex/ExtSurvey?id='+surveyRef);
		pr.setRedirect(true);
		system.debug('pr is ' + pr);
		questionType = '--SELECT--';
		if(saveAndNew != null  && saveAndNew == true){
			saveAndNew = False;
			showSelectQuestionType = 'True';      
			return pr;
		}
		else{  
			showSelectQuestionType = 'False';      
			return pr; 
		}
	}

	private Integer getNewQuestionNum(){
		if(allQuestions == null)
			return 0;
		else{
			return allQuestions.size();
		}    
	}

	private Pagereference saveNewQuestion(){ 
		Survey_Question__c newQuestion = new Survey_Question__c();
		newQuestion.Survey__c = surveyRef;
		newQuestion.Name = questionToName(qQuestion);
		newQuestion.Choices__c = qChoices;
		//system.debug('qChoices is + ' + qChoices);
		newQuestion.Class__c = qClass;
		newQuestion.Required__c = qRequired;
		newQuestion.Is_Calculable__c = qCalculable;
		newQuestion.Type__c = questionType;
		newQuestion.OrderNumber__c = getNewQuestionNum();
		newQuestion.Question__c = qQuestion;
		newQuestion.Score__c = qScores;
		newQuestion.Weight__c = Decimal.valueOf(qWeight);
		
		resetViewsToFalse(true);
		try{
			insert newQuestion;
		}catch(Exception e){
			System.debug(e);
		}
		return saveOrUpdateReturn();
	}

	private String questionToName(String q){
		if(q.length()<75)
			return q;
		else
			return q.substring(0, 75)+'...';
	}

	public Pagereference previewQuestion(){
		if(questionType  == 'Multi-Select-Vertical'){
			showMultiSelectPreview = 'True';
			multiOptions = stringToSelectOptions(qChoices);
		}
		else if(questionType == 'Single Select-Vertical'){
			showSingleSelectPreview = 'True';
			singleOptions = stringToSelectOptions(qChoices);
		}
		else if(questionType =='Free Text'){
			showFreeTextPreview = 'True';
		}
		else if(questionType == 'Single Select-Horizontal'){
			showRowQuestionPreview = 'True';
			rowOptions = stringToSelectOptions(qChoices);
		}
		return null;
	}


	private List<SelectOption> stringToSelectOptions(String str){
		List<String> strList = str.split('\\r|\n');
		List<SelectOption> returnVal = new List<SelectOption>();
		for(String s: strList){
			returnVal.add(new SelectOption(s,s));
		}
		return returnVal;

	}
	/****/

	/* Called during the setup of the page. 
	   Retrieve questions and responses from DB and inserts them in 2 lists. */
	public Integer setupQuestionList(){
		getAQuestion();
		return allQuestions.size();
	}


	/** Sets the survey's name variable
	 *  param: sID The survey ID as specified in the DB
	 */
	public void setSurveyNameAndThankYou(String sId){
		Survey__c s = [SELECT Name, Id, 
				  //TODO URL__c, thankYouText__c, thankYouLink__c, 
				  Survey_Header__c FROM Survey__c WHERE Id =:sId];
		surveyName = s.Name;
		surveyHeader = s.Survey_Header__c;
		// TODO templateURL = s.URL__c+'id='+sId;
		templateURL = 'id='+sId;   
		//TODO surveyThankYouText = s.thankYouText__c;
		//TODO surveyThankYouURL = s.thankYouLink__c;
	}

	public Pagereference updateSurveyName(){ 
		Survey__c s = [SELECT Name, Id
			//TODO URL__c, thankYouText__c, thankYouLink__c 
			FROM Survey__c WHERE Id =:surveyId];
		s.Name = surveyName;
		try{
			update s;
		}catch (Exception e){
			Apexpages.addMessages(e);
		}
		return null;
	} 

	public Pagereference updateSurveyThankYouAndLink(){
		Survey__c s = [SELECT Name, Id
			//TODO , URL__c, thankYouText__c, thankYouLink__c 
			FROM Survey__c WHERE Id =:surveyId];
		//TODO
		//s.thankYouText__c = surveyThankYouText;
		//s.thankYouLink__c = surveyThankYouURL;
		try{
			update s;
		}catch(Exception e){
			Apexpages.addMessages(e);
		}
		return null;
	}

	//------------------------------------------------------------------------------//  
	/** When requested from the page - when the user clicks on 'Update Order' -
	  this function will reorganize the list so that it is displayed in the new order
	 */
	public Pagereference refreshQuestionList(){
		setupQuestionList();
		return null;
	}

	Webservice static String getResponses(List<String> resp) {

		//old one - public static Webservice String getResponses(List<String> resp)
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
			stList = [Select id, Account_Name__c
				// TODO contact__c ,Taken__c 
				from Survey_Taken__c where Account_Name__c=:userId AND Survey__c= :surveyId]; //TODO AND Case__c= :caseId];
		}catch(Exception e){
			return 'problem';
		}

		Survey_Taken__c st;
		if(stList == null || stList.size()==0)
			return 'problem';
		else
			st = stList[0];

		resp.remove(resp.size()-1);
		resp.remove(resp.size()-1);
		resp.remove(resp.size()-1);

		List<Survey_Question__c> allQuestions = [Select Id, Type__c, Required__c, Is_Calculable__c from Survey_Question__c Where Survey__c=:surveyId ORDER BY OrderNumber__c];

		List<String> questionsId = new List<String>();

		for (Survey_Question__c q : allQuestions)
			questionsId.add(q.Id);

		//new response list  
		List <Survey_Question_Response__c> sqrList = new List<Survey_Question_Response__c>();

		Integer i = 0;
		for(String r:resp) {
			if(!checkRequired(r, allQuestions[i])){
				return 'false';       
			}
			if(allQuestions[i].Type__c=='Multi-Select--Vertical'){
				sqrList.addAll(handleMultiSelectResponse(r, String.valueOf(st.Id), questionsId[i]));
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

		try{
			insert sqrList;
		}catch(exception e){
			return 'false';
		}

		return 'true';
	}

	private static List<Survey_Question_Response__c> handleMultiSelectResponse(String response, String surveyTakerId, String questionId){
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

	private static boolean checkRequired(String response, Survey_Question__c question){
		if(question.Required__c == true){
			if(response == null || response =='NO RESPONSE')
				return false;
		}
		return true;
	} 

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
	 *  param: question ID The Id of the question as specified in the DB
	 *  returns 'true' on success
	 */
	Webservice static String deleteQuestion(String questionID){
		//old code -- public static webservice String deleteQuestion(String questionID)
		Survey_Question__c sq = [Select Id, Name FROM Survey_Question__c WHERE Id =: questionID];
		delete sq;

		return 'true'; 
	}

	public Pagereference deleteRefresh(){
		allQuestions.clear();
		Double j = 0.0;
		List<Survey_Question__c> allQuestionsObject = 
			[Select Type__c, Id, Survey__c, Required__c, 
			Question__c, OrderNumber__c, 
			Name, Choices__c, Score__c, Weight__c, Class__c, Is_Calculable__c   
				From Survey_Question__c  
				WHERE Survey__c =: surveyId
				order by OrderNumber__c];
		for (Integer i =0; i< allQuestionsObject.size(); i++){
			allQuestionsObject[i].OrderNumber__c= j;
			question theQ = new question(allQuestionsObject[i]);
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
	 *  param qOrder: List of String to specify the new order of the questions
	 *  returns 'true' on success
	 */ 
	webservice static String updateQuestionOrder(List <String> qOrder){
		//old code -- public static webservice String updateQuestionOrder
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
			//system.debug('Second ID is '+q.Id+ '  order '+ q.OrderNumber__c );

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
	public List<question> getAQuestion() {
		List<Survey_Question__c> allQuestionsObject = 
			[Select s.Type__c, s.Id, s.Survey__c, s.Required__c, s.Question__c, Class__c, Score__c, Weight__c,
			s.OrderNumber__c, Is_Calculable__c,
			s.Name, s.Choices__c 
				From Survey_Question__c s 
				WHERE s.Survey__c =: surveyId ORDER BY s.OrderNumber__c];
		allQuestions = new List<question>();

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
			question theQ = new question(q);
			allQuestions.add(theQ);
		}
		allQuestionsSize = allQuestions.size();
		return allQuestions;
	} 
	
	/** Class: question
	 *  Retrieves the question information and puts it in the question object
	 */    
	public class question{
		public String   name                   {get; set;}
		public String   id                     {get; set;}
		public String   question               {get; set;}
		public String   orderNumber            {get; set;}
		public String   choices                {get; set;}
		public String 	scores				   {get;set;} 
		public String 	weight				   {get;set;} 
		public String   classficationClass     {get;set;}
		public List<SelectOption> singleOptions{get; set;}
		public List<SelectOption> multiOptions {get; set;}
		public Boolean  required               {get; set;}
		public Boolean  calculable			    {get;set;}
		public String   questionType           {get; set;}  
		public String   surveyName             {get; set;}
		public String   renderFreeText         {get; set;}
		public String   renderSelectRadio      {get; set;}
		public String   renderSelectCheckboxes {get; set;} 
		public String   renderSelectRow        {get; set;}
		public List<String> responses          {get; set;}
		public String   singleOptionsForChart  {get; set;}
		public String   qResultsForChart       {get; set;} 
		public List<String> strList            {get; set;} // The question's option as a list of string
		public List<Integer> resultsCounts     {get; set;} // The count of each response to a question's choices
		public List<SelectOption> rowOptions   {get; set;}
		public boolean  noData                 {get; set;}

		/** Fills up the question object
		 *  param:  Survey_Question__c 
		 */     
		public question(Survey_Question__c sq) {
			name = sq.Name;
			id = sq.Id;
			//system.debug('in Question found one with id '+id);
			question = sq.Question__c;
			orderNumber = String.valueOf(sq.OrderNumber__c+1);
			choices = sq.Choices__c;
			scores = sq.Score__c;
			weight = String.valueOf(sq.Weight__c); 
			classficationClass = sq.Class__c;		
			required = sq.Required__c;
			calculable = sq.Is_Calculable__c;
			questionType = sq.Type__c;
			singleOptionsForChart = ' ';
			if (sq.Type__c=='Single Select-Vertical'){
				renderSelectRadio='true';
				singleOptions = stringToSelectOptions(choices);
				renderSelectCheckboxes='false';
				renderFreeText='false';
				renderSelectRow = 'false';
			}
			else if (sq.Type__c=='Multi-Select-Vertical'){    
				renderSelectCheckboxes='true';
				multiOptions = stringToSelectOptions(choices);
				renderSelectRadio='false';
				renderFreeText='false';
				renderSelectRow = 'false';
			}
			else if (sq.Type__c=='Single Select-Horizontal'){   
				renderSelectCheckboxes='false';
				rowOptions = stringToSelectOptions(choices);
				renderSelectRadio='false';
				renderFreeText='false';
				renderSelectRow = 'true';
			}
			else if (sq.Type__c=='Free Text'){
				renderFreeText='true';
				renderSelectRadio='false';
				renderSelectCheckboxes='false';
				renderSelectRow = 'false';
			}
			//responses= getResponses();
		}

		/** Splits up the string as given by the user and adds each option
		 *  to a list to be displayed as option on the Visualforce page
		 *  param: str String as submitted by the user
		 *  returns the List of SelectOption for the visualforce page
		 */  
		private List<SelectOption> stringToSelectOptions(String str){
			List<SelectOption> returnVal = new List<SelectOption>();

			if(str != null) {
				strList = str.split('\n');
				for(String s: strList){
					if (s!='') {
						returnVal.add(new SelectOption(s,s));
						if (s != 'null' && s!= null) {
							String sBis = s.replace(' ', '%20');
							singleOptionsForChart += s.trim()+'|';
						}
					}
				}
				singleOptionsForChart = singleOptionsForChart.substring(0, singleOptionsForChart.length()-1);				
			}

			return returnVal;
		} 
		
		
	}

	public class ChoiceScore {
		public Integer index {get;set;} 
		public String choice {get;set;}
		public String min	 {get;set;}
		public String max	 {get;set;}
		public String score {get;set;}
		
		public ChoiceScore(Integer index, String choice, String score) {
			this.index = index; 
			this.choice = choice; 
			List<String> list_boundraries = choice.split(';');
			if(list_boundraries.size() == 0) {
				this.min = '';
				this.max = '';
			} else if(list_boundraries.size() == 1) {
				this.min = list_boundraries[0].trim();
			} else {
				this.min = list_boundraries[0].trim();
				this.max = list_boundraries[1].trim();
			}
			this.score = score;
		}
	}

}