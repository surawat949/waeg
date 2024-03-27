/**
*   Contains a set of static methods used for surveys
*
* @author      Xia Tong  
* @created     2012-05-30
* @since       23.0    
* @version     1.0                                                                
* 
* @changelog
* 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
* - Created
*    
*/
public class ClsSurveyUtil {
	
	private  Map<id,Map<id,String>> map_surveyTakenId_questionId_response = new Map<id,Map<id,String>>();
	private  Map<id,Map<String, List<ClsQuestion>>> map_surveyId_class_questions = new Map<id,Map<String, List<ClsQuestion>>>();
	private  Map<id,Map<String,String>> map_surveyId_classOrType_fields = new Map<id,Map<String,String>>();
	private  Map<id,set<String>> map_surveyId_types = new Map<id,set<String>>();
	private  Map<id,Account> map_accountId_account = new Map<id,Account>();
	private  List<Survey_Classification__c> list_classifications = new List<Survey_Classification__c>();
	private  List<Survey_Calculatation_Table__c> list_calcTables = new List<Survey_Calculatation_Table__c>();
	private  Set<Id> set_questionIds = new Set<id>();
	private  Map<String, String> map_className_classLevel;
	private  map<id, id> map_surveyTakenId_accId = new map<id, id>();
	private  map<id, id> map_surveyTakenId_surId = new map<id, id>();
	private  List<id> list_surveyTakenIds = new List<id>();
	// added by xia 2012-09-12 new progress for survey calculation for classification
	private  map<id,map<string,string>> map_accId_class_classValue = new map<id,map<string,string>>();
	
	public static string DEBUG_Message = '';
	/** Constructor
	*
	* @author      Xia Tong  
	* @created     2012-05-30
	* @since       23.0    
	* @version     1.0                                                                
	* 
	* @changelog
	* 2012-06-04 Xia Tong <xia.tong@itbconsult.com>
	* - Created
	*    
	*/
	public ClsSurveyUtil(map<id, id> map_stId_accId, map<id, id> map_stId_surId,List<id> list_stId){
		map_surveyTakenId_accId = map_stId_accId;
		map_surveyTakenId_surId = map_stId_surId;
		list_surveyTakenIds = list_stId;
	}
	
	
		/** Constructor
	*
	* @author      Xia Tong  
	* @created     2012-05-30
	* @since       23.0    
	* @version     1.0                                                                
	* 
	* @changelog
	* 2012-06-04 Xia Tong <xia.tong@itbconsult.com>
	* - Created
	*    
	*/
	public ClsSurveyUtil(String accountId, String surveyId,String surveyTakenId){
		map_surveyTakenId_accId.put(surveyTakenId,accountId);
		map_surveyTakenId_surId.put(surveyTakenId,surveyId);
		list_surveyTakenIds.add(surveyTakenId);
	}
	
	
	/** calculation survey takens  
	 *    
	 @param: map,key:surveyTaken Id, value: account id;
	 @param: map,key:surveyTaken Id, value: survey Id;
	 @param: list of surveyTaken Id order by LastModifiedDate in Survey_Taken__c;
	 @return: list of accounts to update

	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */
	public List<Account> calcSurveyTakens(){
		loadSurveyQuestionResponse();
		loadClassFields();
		loadTypes();
		loadAccounts();
		loadClassfications();
		updateObject();
		return map_accountId_account.values();
	}

	 /** method to load Survey Question Responses and Survey Questions  
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public  void loadSurveyQuestionResponse(){
		if(!map_surveyTakenId_accId.isEmpty()){
			for(Survey_Question_Response__c sqr: [SELECT Id, Response__c, Name, Survey_Question__c, Survey_Taken__c FROM Survey_Question_Response__c 
												  where Survey_Taken__c IN :list_surveyTakenIds]) {
				set_questionIds.add(sqr.Survey_Question__c);
				if(!map_surveyTakenId_questionId_response.containsKey(sqr.Survey_Taken__c)){
					map_surveyTakenId_questionId_response.put(sqr.Survey_Taken__c,new Map<id,String>());
				}
				map_surveyTakenId_questionId_response.get(sqr.Survey_Taken__c).put(sqr.Survey_Question__c,sqr.Response__c);
			} 
		}
		//system.debug('map_surveyTakenId_accId:' + map_surveyTakenId_accId.size());
		//system.debug('map_surveyTakenId_questionId_response:' + map_surveyTakenId_questionId_response.size());
		if(set_questionIds.size() > 0){
			for(Survey_Question__c sq: [SELECT  Type__c, Id, Survey__c, Required__c, Class__c, Weight__c,  
                							Question__c,  OrderNumber__c,Is_Calculable__c, 
                							Name, Choices__c,Score__c 
                							FROM Survey_Question__c
                							where id in :set_questionIds]) {
            	ClsQuestion q = new ClsQuestion(sq);
            	if(!map_surveyId_class_questions.containsKey(sq.Survey__c)){
					map_surveyId_class_questions.put(sq.Survey__c, new Map<String, List<ClsQuestion>>());
				}
				if(!map_surveyId_class_questions.get(sq.Survey__c).containsKey(sq.Class__c)){
					map_surveyId_class_questions.get(sq.Survey__c).put(sq.Class__c, new List<ClsQuestion>());
				}
				map_surveyId_class_questions.get(sq.Survey__c).get(sq.Class__c).add(q);
        	}
		}
		//system.debug('map_surveyId_class_questions:' + map_surveyId_class_questions.size());
	}
	 /** method to load Survey Field Mapping  
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */		
	public  void loadClassFields() {
		for(Survey_Field_Mapping__c fm: [SELECT Survey__c, Name, Field__c, 
													Object__c, Class__c 
											 FROM Survey_Field_Mapping__c 
											 where Survey__c IN: map_surveyTakenId_surId.values() and Object__c = 'Account']){
			if(!map_surveyId_classOrType_fields.containsKey(fm.Survey__c)){
				map_surveyId_classOrType_fields.put(fm.Survey__c,new Map<String,String>());
			}
			map_surveyId_classOrType_fields.get(fm.Survey__c).put(fm.Class__c,fm.Field__c);								 
		} 
		//system.debug('map_surveyId_classOrType_fields:' + map_surveyId_classOrType_fields.size());
	}
	 /** method to load Types in Survey Calculation Tables 
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */
	public  void loadTypes() {
		for(Survey_Calculatation_Table__c sct: [select Id, Type__c, Survey__c,Unique_Name__c, Score__c from Survey_Calculatation_Table__c 
													where Survey__c IN: map_surveyTakenId_surId.values()]) {
			if(!map_surveyId_types.containsKey(sct.Survey__c)){
				map_surveyId_types.put(sct.Survey__c,new Set<String>());
			}
			map_surveyId_types.get(sct.Survey__c).add(sct.Type__c);	
			list_calcTables.add(sct);
		}
		//system.debug('map_surveyId_types:' + map_surveyId_types.size());
		//system.debug('list_calcTables:' + list_calcTables.size());
	}
	 /** method to load Accounts  
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public  void loadAccounts(){
		for(Account a: [select Id, Name from Account where id IN: map_surveyTakenId_accId.values()]){
			map_accountId_account.put(a.Id,a);
		}
		//system.debug('map_accountId_account:' + map_accountId_account.size());
	}
	 /** method to load Survey Classifications  
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public  void loadClassfications(){
		list_classifications = [select id, name, Active__c, Class__c, Survey__c, Min__c, Max__c, Unique_Name__c
                                                      from Survey_Classification__c where Survey__c IN: map_surveyTakenId_surId.values() ];
        //system.debug('list_classifications:' + list_classifications.size());
	}
	
	 /** method to calculate Survey Takens and save to accounts  
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public  void updateObject() { 
		if(!map_accountId_account.isEmpty()) {
			for(String stId: list_surveyTakenIds){
				String accId = map_surveyTakenId_accId.get(stId);
				String surveyId = map_surveyTakenId_surId.get(stId);
				map_className_classLevel = new Map<String, String>();
				for(String classfication: map_surveyId_class_questions.get(surveyId).keySet()) {
					Double point = getPoint(map_surveyId_class_questions.get(surveyId).get(classfication),stId);
					//system.debug('point:' + point);
					//DEBUG_Message += '|' + classfication + ':' + string.valueOf(point);
					if(point != null) 
						updateClassfication(classfication, point,surveyId,map_accountId_account.get(accId));
				}	
				//system.debug('map_className_classLevel:' + map_className_classLevel);		
				if(!map_className_classLevel.isEmpty()) {
					for(String sType: map_surveyId_types.get(surveyId)) 
						updateType(sType,surveyId,map_accountId_account.get(accId));				
				}	
			
			}	

			
			//system.debug('account after calc:' + map_accountId_account.values());
		}
	}
	 /** method to update classification and save to accounts  
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public  void updateClassfication(String classfication, Double point, String surveyId, Account account) {
		if(map_surveyId_classOrType_fields.get(surveyId) != null) {
			String field = map_surveyId_classOrType_fields.get(surveyId).get(classfication); 
			
			if(field != null && point != null && list_classifications.size() > 0) {
				List<Survey_Classification__c> list_sc = new List<Survey_Classification__c>();
				for(Survey_Classification__c c: list_classifications){
					if(c.Survey__c == surveyId && c.Active__c && c.Min__c <= point && c.Max__c >= point && c.Class__c == classfication){
						list_sc.add(c);
					}
				
				}
				
                //system.debug('updateClassfication,field:' + field);
                //system.debug('updateClassfication,list_sc:' + list_sc);
                if(list_sc.size() >= 1) {
                	String value = list_sc[0].Name;
                	//system.debug('updateClassfication,value:' + value);
					account.put(field, value);
					map_className_classLevel.put(classfication, value);
					if(!map_accId_class_classValue.containsKey(account.Id)){
						map_accId_class_classValue.put(account.Id,new map<string,string>());
					}
					map_accId_class_classValue.get(account.Id).put(classfication,value);
                } else 
                	map_className_classLevel.put(classfication, '');
			}                                                                                   
		}
	}
	 /** method to calculate the point of Survey Question Responses
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public  Double getPoint(List<ClsQuestion> list_questions,String stId) {
		Double qCount = 0;
		Double qScore = 0;
		Double qTmpScore; 
		Double qPoint = null;
		Double qWeight;
		String answer; 
		for(ClsQuestion q: list_questions) { 
			if(q.calculable) {
				//system.debug('getPoint map_surveyTakenId_questionId_response:' + map_surveyTakenId_questionId_response.keySet());
				//system.debug('getPoint map_surveyTakenId_questionId_response.get(stId):' + map_surveyTakenId_questionId_response.get(stId));
				//system.debug('getPoint stId:' + stId);
				//system.debug('getPoint q.id:' + q.id);
				if(map_surveyTakenId_questionId_response.containsKey(stId)){
					answer = map_surveyTakenId_questionId_response.get(stId).get(q.id);
				}else{
					//system.debug('do not contains this survey taken:' + stId);
				}
        		if(answer != null && answer.trim().length() > 0 && answer != 'NO RESPONSE') {
        				qTmpScore = q.getResult(answer);
        				if(qTmpScore != null) {
        					qWeight = q.weight;
                    		qScore += (qWeight * qTmpScore);
                    		qCount += qWeight;              					
        				}
     	
        		}				
			}
		}

        if(qCount > 0) 
			qPoint = qScore / qCount;        
        
        return qPoint; 
	}
	 /** method to calculate the score based on calculation setting
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */	
	public void updateType(String sType,String surveyId,Account account) {
		if(map_surveyId_classOrType_fields.get(surveyId) != null) {
	
			String field = map_surveyId_classOrType_fields.get(surveyId).get(sType);
			
			if(field != null && list_calcTables.size() > 0) {
				//system.debug('updateType,field:' + field);
				String uniqueName = surveyId;
				uniqueName += getAllClassLevels();
				uniqueName += (';' + sType);
				List<Survey_Calculatation_Table__c> list_sct = new List<Survey_Calculatation_Table__c>();
				for(Survey_Calculatation_Table__c c :list_calcTables){
					if(c.Unique_Name__c == uniqueName && c.Survey__c == surveyId){
						list_sct.add(c);
					}
				}
				//system.debug('updateType,list_sct:' + list_sct);
        		if(list_sct.size() == 1) {
                	Double value = list_sct[0].Score__c;
                	//system.debug('updateType,value:' + value);
					account.put(field, value);
        		}				
			}
       	}
       
	}
	 /** return string to generate unique name in calculation setting
	 *    
	 @author Xia Tong
	 @created 2012-05-31
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2012-05-31 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */		
	public  String getAllClassLevels() {
		String result = '';
		List<String> list_classes = new List<String>(); 
		list_classes.addAll(map_className_classLevel.keySet()); 
		list_classes.sort();
		for(String c: list_classes) 
			result += (';' + map_className_classLevel.get(c));
		return result;
	}

}