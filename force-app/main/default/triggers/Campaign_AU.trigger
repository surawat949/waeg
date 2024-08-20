/**
 *  This trigger is used to fill fields of Account_Campaign_Member__c
 *
 @author    Lei Tang
 @created   2014-07-23
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-07-23 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
trigger Campaign_AU on Campaign (after update) {
	
	list<Account_Campaing_Member_Fields__c>  list_acmf = Account_Campaing_Member_Fields__c.getall().values(); 
	String query_cam ='select Id, Central_Campaign__c'; 
	map<String, Schema.SObjectField> map_acmFields = Schema.getGlobalDescribe().get('Account_Campaing_Member__c').getDescribe().fields.getMap(); 
	map<String, Schema.SObjectField> map_campFields = Schema.getGlobalDescribe().get('Campaign').getDescribe().fields.getMap(); 
	map<String, String> map_acm = new map<String,String>();
	map<String, String> map_camp = new map<String,String>();
	

	if(list_acmf.size()>0){
		for(Account_Campaing_Member_Fields__c acmf : list_acmf){
			if(acmf.Active__c && (map_acmFields.containsKey(acmf.target_field__c))){
				map_acm.put(acmf.source_field__c, acmf.target_field__c);
				query_cam += ',' + acmf.target_field__c + ' ';
			}
			
		 	if(acmf.Active__c && (map_campFields.containsKey(acmf.source_field__c))){
		    	map_camp.put(acmf.target_field__c, acmf.source_field__c);
		    	//query_cam += ','+acmf.source_field__c+' ';
		 	}
		} 	
	}
	
	map<Id,Campaign> map_campaigs = new map<Id,Campaign>();
	for(Campaign camp :trigger.new){
		//for(String key : map_camp.keySet()) {
		//	if(camp.get(map_camp.get(key)) != trigger.oldMap.get(camp.Id).get(map_camp.get(key))){
				map_campaigs.put(camp.Id, camp);
		//		break;
		//	}
		//}
	}
	//system.debug('@#map_campaigs : '+map_campaigs.keySet());
	if(map_campaigs.size() > 0) {
		
		String output = '(';
		for(Id s : map_campaigs.keySet()) {
			if(s != null) {
				output += '\'' + s + '\'' + ', ';
			}
		}
		if(output.endsWith(', ')) output = output.substring(0, output.length() - 2);
		output += ')';
		if(output == '()') output = '(\'\')'; 
	
		query_cam += '  from Account_Campaing_Member__c where Central_Campaign__c in '+ output ;
		System.debug(query_cam);
		list<Account_Campaing_Member__c> list_ACMs = new list<Account_Campaing_Member__c>();
		
		ClsCampaignUtil.isExecuteTrigger = false;
		
		system.debug('@#query_cam : ' + query_cam);
		for(Account_Campaing_Member__c acmtemp :  database.query(query_cam)) {
			
			if(map_camp != null) {
				if(map_campaigs.get(acmtemp.Central_Campaign__c) != null) {
					Campaign c = map_campaigs.get(acmtemp.Central_Campaign__c);
					for(String key : map_camp.keySet()) {  
						acmtemp.put(key, c.get(map_camp.get(key)));
					}
					//acmtemp.Is_campaign_active__c = c.IsActive;
					list_ACMs.add(acmtemp);
				}
			}
		}
		system.debug('@#list_ACMs.size :' + list_ACMs.size());
		if(list_ACMs.size() > 0) {
			update list_ACMs;
		}

	
	}
	
}