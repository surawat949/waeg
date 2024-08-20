/*
 * Extension Controller to List all existed surveys, or add/delete survey
 @author Haobo Song
 @created 2011-10-25
 @version 1.0
 @since 20.0
 *
 @changelog
 * 2011-10-25 Haobo Song <haobo.song@itbconsult.com>
 * - Migrated from old system
 */
global with sharing class ExtGSurveys {

	public String surveyDelete                       {get; set;}
	//public String newSurveyName                      {get; set;}
	//public String status							 {get;set;} 
	//public Date	validFrom							 {get;set;}
	//public Date	validTo							 	 {get;set;}
	public Survey__c survey							 {get;set;}
	public List<miniSurvey> allSurveys               {get; set;}
	public String username                           {get; set;}
	public String userId                             {get; set;}
	public String POD                                {get; set;}

	//public String siteInfo  {get; set;}

	public ExtGSurveys(ApexPages.StandardController stdController){
		username = System.Userinfo.getUserId();    
		setAllSurveys();
		survey = new Survey__c();
	}

	private void setAllSurveys(){
		List<Survey__c> surveys = [Select Id, Name, Status__c, Valid_From__c, Valid_To__c from Survey__c where IsDeleted = false order by Name];

		if(allSurveys == null){
			allSurveys = new List<miniSurvey>();
		}
		else{
			allSurveys.clear(); 
		}
		for(Survey__c s : surveys){
			allSurveys.add(new miniSurvey(s.Name, s.Id, s.Status__c, s.Valid_From__c, s.Valid_To__c));
		}
	}


	public Pagereference makeNewSurvey(){
		if(survey == null){
			POD='';
			return null;
		}
		//Survey__c s = new Survey__c();
		//s.Name = newSurveyName;
		//s.Status__c = status;
		//s.Valid_From__c = validFrom;
		//s.Valid_To__c = validTo;
		//s.URL__c = urlToSave;
		//s.Submit_Response__c = 'empty';
		//s.thankYouText__c = 'Your survey has been submitted. Thank you for taking our survey.';
		//s.thankYouLink__c='http://www.salesforce.com';
		try{
			insert survey;
			createAnonSurveyTaker(survey.Id);
			return new Pagereference('/apex/ExtSurvey?id='+survey.Id);
		}catch(Exception e){
			return null;
		}
	}

	private static void createAnonSurveyTaker(String surveyId){
		//list <Survey_Taken__c> sTakers = [select id from Survey_Taken__c where Survey__c = :surveyId and Contact__c = null and Case__c = null];
		list <Survey_Taken__c> sTakers = [select id from Survey_Taken__c where Survey__c = :surveyId and Account_Name__c = null];  	 
		if(sTakers != null && sTakers.size()>0)
			return;
		Survey_Taken__c st = new Survey_Taken__c();  	
		//st.Case__c = null;
		st.Survey__c = surveyId;
		st.Account_Name__c = null;
		insert st;
	}

	public Pagereference doSurveyReset(){
		setAllSurveys();
		return null;
	}

	/*
	public static webservice String deleteSurvey(String deleteId){
		Survey__c s= [Select Id, Name from Survey__c where Id =:deleteId];
		delete s;

		return 'true';
	}*/

	Webservice static String deleteSurvey(String deleteId){
		//public static webservice doesn't allow via api 55.0 - need to use webservice static string
		Survey__c s= [Select Id, Name from Survey__c where Id =:deleteId];
		delete s;

		return 'true';
	}


	public Class miniSurvey{
		public String sName   {get; set;}
		public String sId     {get; set;}
		public String status  {get;set;} 
		public String validFrom {get;set;}
	    public String validTo	  {get;set;}
	    
		public miniSurvey(String miniName, String miniId, String miniStatus, Date miniValidFrom, Date miniValidTo){
			sName = miniName;
			sId = miniId;
			status = miniStatus;
			validFrom = formatDate(miniValidFrom);
			validTo = formatDate(miniValidTo);
		} 

    	private String formatDate(Date dateVal) {
    		String result = ''; 
    		if(dateVal != null) 
    			result = dateVal.format();
    		return result;
    	}
	}
}