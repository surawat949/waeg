/* Controller associated with pages rendering the survey.
 * Used by SurveyPage, ResultsPage, TakeSurvey
 *
 @author Haobo Song
 @created 2011-11-08
 @version 1.0
 @since 20.0
 *
 @changelog
 * 2011-11-08 Haobo Song <haobo.song@itbconsult.com>
 * - Split from ExtTakeSurvey
 * 2013-01-31 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Modified method :  setAnswer -> fix null pointer	
 */ 
public with sharing class ClsQuestion {
	public String   name                   {get; set;}
	public String   id			               {get; set;}
	public String   question	             {get; set;}
	public String   orderNumber            {get; set;}
	public String   choices                {get; set;}
	public List<SelectOption> singleOptions{get; set;}
	public List<SelectOption> multiOptions {get; set;}
	public Boolean  required               {get; set;}
	public Boolean 	calculable				{get;set;}
	public String   questionType           {get; set;}	
	public String   surveyName	           {get; set;}
	public String   renderFreeText		     {get; set;}
	public String   renderSelectRadio 	   {get; set;}
	public String   renderSelectCheckboxes {get; set;} 
	public String   renderSelectRow        {get; set;}
	public List<String> responses			     {get; set;}
	public String   singleOptionsForChart	 {get; set;}
	public String   qResultsForChart		   {get; set;} 
	public List<String> strList	           {get; set;} // The question's option as a list of string
	public List<Integer> resultsCounts 	   {get; set;} // The count of each response to a question's choices
	public List<SelectOption> rowOptions   {get; set;}
	public boolean  noData                 {get; set;}
	public String singleAnswer			   {get; set;} 
	public List<String> multipleAnswers 	{get;set;}
	public String scores {get;set;} 
	public String classficationClass {get;set;} 
	public Double weight {get;set;}
	private Map <String, Double> map_choice_score;
	private List<Boundrary> list_boundray;

	/** Fills up the question object
	 *  param:	Survey_Question__c 
	 */  	  
	public ClsQuestion(Survey_Question__c sq) {
		multipleAnswers = new list<String>();
		name = sq.Name;
		id = sq.Id;
		//System.debug('in Question found one with id '+id);
		question = sq.Question__c;
		orderNumber = String.valueOf(sq.OrderNumber__c+1);
		choices = sq.Choices__c;
		required = sq.Required__c;
		questionType = sq.Type__c;
		weight = sq.Weight__c; 
		classficationClass = sq.Class__c;
		singleOptionsForChart = ' ';
		if (sq.Type__c=='Single Select--Vertical'){
			renderSelectRadio='true';
			singleOptions = stringToSelectOptions(choices);
			renderSelectCheckboxes='false';
			renderFreeText='false';
			renderSelectRow = 'false';
		} else if (sq.Type__c=='Multi-Select--Vertical'){		
			renderSelectCheckboxes='true';
			multiOptions = stringToSelectOptions(choices);
			renderSelectRadio='false';
			renderFreeText='false';
			renderSelectRow = 'false';
		} else if (sq.Type__c=='Single Select--Horizontal'){   
			renderSelectCheckboxes='false';
			rowOptions = stringToSelectOptions(choices);
			renderSelectRadio='false';
			renderFreeText='false';
			renderSelectRow = 'true';
		} else if (sq.Type__c=='Free Text'){
			renderFreeText='true';
			renderSelectRadio='false';
			renderSelectCheckboxes='false';
			renderSelectRow = 'false';
		}
		//responses= getResponses();
		if(sq.Type__c == 'Free Text' && !sq.Is_Calculable__c)
			calculable = false;
		else 
			calculable = true;

 		if(calculable && sq.Score__c != null) { 
			initializeScore(sq);		
		}
	}

	public Double getResult(String choice) {
		if(choice != null && choice.length() > 0) {
			if(renderFreeText == 'true') 
				return getBoundraryResult(choice.trim());
			else {
				if(map_choice_score != null && !map_choice_score.isEmpty()) 
					return map_choice_score.get(choice.trim());
				else 
					return null;
			}
		} else 
			return null;
	}
	
	public void setAnswer(String answer) {
		/*
		if(renderSelectCheckboxes == 'true') {
			//multipleAnswers = new List<String>();
			multipleAnswers.add(answer.trim());
		} else 
			singleAnswer = answer.trim();
		*/
		//Begin : added by yinfeng.guo 2013-01-31 -> fix null pointer	
		if(renderSelectCheckboxes == 'true') {
			if(answer != null) multipleAnswers.add(answer.trim());
			else multipleAnswers.add('');
		} 
		else{
			if(answer != null) singleAnswer = answer.trim();	
			else singleAnswer = '';	
		} 
		//End : added by yinfeng.guo 2013-01-31 -> fix null pointer
	}
	/** Splits up the string as given by the user and adds each option
	 *  to a list to be displayed as option on the Visualforce page
	 *  param: str	String as submitted by the user
	 *  returns the List of SelectOption for the visualforce page
	 */  
	private List<SelectOption> stringToSelectOptions(String str){
		List<SelectOption> returnVal = new List<SelectOption>();
		if(str != null && str.trim().length() > 0) {
			strList = str.split('\n');
			
			for(String s: strList){
				if (s!='') {
					returnVal.add(new SelectOption(s.trim(),s.trim()));
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
	
	private void initializeScore(Survey_Question__c sq) {
		if(sq.Type__c == 'Free Text' )
			initializeScoreList(sq);
		else
			initializeScoreMap(sq);
	}
	
	private void initializeScoreMap(Survey_Question__c sq) {
		scores = sq.Score__c; 
		map_choice_score = new Map<String, Double>();
		List<String> list_scores = scores.split('\n'); 
		List<String> list_choices = choices.split('\n');
		Integer i;
		for(i = 0; i < list_choices.size(); i++) 
			map_choice_score.put(list_choices[i].trim(), Double.valueOf(list_scores[i].trim()));		
	}

	private void initializeScoreList(Survey_Question__c sq) {
		scores = sq.Score__c; 
		list_boundray = new List<Boundrary>();
		List<String> list_scores = scores.split('\n'); 
		List<String> list_choices = choices.split('\n');
		Integer i;
		for(i = 0; i < list_choices.size(); i++) {
			system.debug('list_choices is ' + list_choices[i].trim());
			list_boundray.add(new Boundrary(list_choices[i].trim(), list_scores[i].trim()));
		}
		
		system.debug('list_boundray is ' + list_boundray);
	}
	
	private Double getBoundraryResult(String choice) {
		Double result = null;
		Double value = null;
		try{// try-catch added by xia Tong 2012-06-01
			value = Double.valueOf(choice);
		}catch(Exception e){
			return null;
		}
		if(value != null && list_boundray != null && list_boundray.size() > 0) {
			for(Boundrary boundrary: list_boundray) 
				if(boundrary.contains(value)) {
					result = boundrary.score;
					break;
				}
		}	
		return result;
	}	
	
	public class Boundrary {
		public Double min  {get;set;} 
		public Double max  {get;set;} 
		public Double score	 {get;set;}
		
		public Boundrary(String choiceStr, String scoreStr) { 
			if(choiceStr != null) {
				List<String> list_tmp = choiceStr.split(';');
				final Double INFINITE_SMALL = -system.Math.pow(2, 63);
				final Double INFINITE_LARGE = system.Math.pow(2, 63) - 1;
				if(list_tmp.size() == 0) {
					min = INFINITE_SMALL;
					max = INFINITE_LARGE;
				} else if(list_tmp.size() == 1) {
					max = INFINITE_LARGE;
					if(list_tmp[0].trim().length() > 0) 
						min = Double.valueOf(list_tmp[0].trim());
					else 
						min =  INFINITE_SMALL;
					
				} else {
					if(list_tmp[0].trim().length() > 0) 
						min = Double.valueOf(list_tmp[0].trim());
					else 
						min =  INFINITE_SMALL;
				
					if(list_tmp[1].trim().length() > 0) 
						max = Double.valueOf(list_tmp[1].trim());								
					else 
						max =  INFINITE_LARGE;
				}
			} else {
				min = null;
				max = null; 
			}
			if(scoreStr != null) 
				score = Double.valueOf(scoreStr.trim());
			else 
				score = null;			
		} 

		public Boolean contains(Double value) {
			Boolean isContained = false; 
			if(min != null && max != null && score != null && value >= min && value <= max) 
				isContained = true; 
			return isContained;  
		}
	}
}