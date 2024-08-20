/**
 *  This trigger is used to fill fields of Account_Campaign_Member__c
 *
 @author    Chu Zhang
 @created   2013-08-07
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-08-07 Chu Zhang <chu.zhang@itbconsult.com>
 * - Created
 */

trigger AccountCampaignMember_BIU_FillFields on Account_Campaing_Member__c (before insert, before update) {
	
	map<String,String> map_fields = new map<String,String>();
	list<Account_Campaing_Member_Fields__c>  list_acmf = Account_Campaing_Member_Fields__c.getall().values(); 
	String query_cam ='select Id, isActive'; 
	map<String, Schema.SObjectField> map_acmFields = Schema.getGlobalDescribe().get('Account_Campaing_Member__c').getDescribe().fields.getMap(); 
	map<String, Schema.SObjectField> map_campFields = Schema.getGlobalDescribe().get('Campaign').getDescribe().fields.getMap(); 
	map<String, String> map_acm = new map<String,String>();
	map<String, String> map_camp = new map<String,String>();

	if(list_acmf.size()>0){
		for(Account_Campaing_Member_Fields__c acmf : list_acmf){
			if(acmf.Active__c &&(map_acmFields.containsKey(acmf.source_field__c))){
				map_acm.put(acmf.target_field__c,acmf.source_field__c);
			}
			
		 	if(acmf.Active__c && (map_campFields.containsKey(acmf.source_field__c))){
		    	map_camp.put(acmf.target_field__c,acmf.source_field__c);
		    	query_cam += ','+acmf.source_field__c+' ';
		 	}
		} 	
	}
	
	//begin: added by yinfeng.guo 2013-10-24
	set<id> set_campaignIds = new set<id>();
	for(Account_Campaing_Member__c acm :trigger.new){
	 	if(acm.Central_Campaign__c != null) set_campaignIds.add(acm.Central_Campaign__c);
	}
	String output = '(';
	for(String s : set_campaignIds) {
		if(s != null) output += '\'' + s + '\'' + ', ';
	}
	if(output.endsWith(', ')) output = output.substring(0, output.length() - 2);
	output += ')';
	if(output == '()') output = '(\'\')'; 

	query_cam += '  from Campaign where Id  in '+ output ;

	list<Campaign> list_campaigns = database.query(query_cam);
	map<id, Campaign> map_id_campaigns = new map<id, Campaign>();
	for(Campaign c : list_campaigns){
		map_id_campaigns.put(c.id, c);
	}
	//end: added by yinfeng.guo 2013-10-24


	for(Account_Campaing_Member__c acm :trigger.new){
		if(map_acm!=null){
			for(String key:map_acm.keySet()){  
					acm.put(key,acm.get(map_acm.get(key)));
			}
		}
		
		if(map_camp!= null){
			/*comment out by yinfeng.guo
			query_cam = query_cam + '  from Campaign where Id =\''+acm.Central_Campaign__c +'\''; 
			Campaign c = database.query(query_cam); 
			*/
			Campaign c = map_id_campaigns.get(acm.Central_Campaign__c);
			for(String key:map_camp.keySet()){  
				acm.put(key,c.get(map_camp.get(key)));
			}
			acm.Is_Campaign_Active__c = c.isActive;
		}
	}
	
}