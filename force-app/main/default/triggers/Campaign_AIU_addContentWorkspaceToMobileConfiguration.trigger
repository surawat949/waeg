/**
 *  This trigger is used to add ContentWorkspace to MoblieConfiguration when the campaign is insert or update
 *
 @author 	Jian Yin
 @created 	2013-07-16
 @version 	1.0
 @since 	27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-07-16 Jian Yin <jian.yin@itbconsult.com>
 * - Created
 */
 
trigger Campaign_AIU_addContentWorkspaceToMobileConfiguration on Campaign (after insert, after update) {
	/**
	for(Campaign c : trigger.new){
		
		String userId = c.OwnerId;
		User user = [SELECT Id, ProfileId FROM User WHERE Id =:userId];
		String mvamconfgId = '';
		String contentWorkspaceId = c.Content_Workspace_Id__c;

		if(contentWorkspaceId != null && contentWorkspaceId != '') {
			List<MobileVizArt__Mobile_Configuration__c> list_mm = [SELECT Id, MobileVizArt__Profiles__c, OwnerId FROM MobileVizArt__Mobile_Configuration__c where MobileVizArt__Active__c = true];

			if(list_mm != null && list_mm.size() > 0){
				Boolean flag = false;
				for(MobileVizArt__Mobile_Configuration__c mmc : list_mm){
					String pfs = mmc.MobileVizArt__Profiles__c;
					if(pfs != null && pfs != ''){
						String[] profiles = pfs.split(',');
						for(String str : profiles){
							if(str == user.ProfileId) {
								mvamconfgId = mmc.Id;
								flag = true;
								break;
							}
						}
					}
					if(flag){
						break;
					}
				}
			}else{
				return;
			}
			
			List<MobileVizArt__Mobile_Content__c> list_mvamc = new List<MobileVizArt__Mobile_Content__c>();
			if(mvamconfgId != '' && mvamconfgId != null){
				list_mvamc = [SELECT Id, MobileVizArt__Workspace__c,MobileVizArt__Mobile_Configuration__c FROM MobileVizArt__Mobile_Content__c  WHERE MobileVizArt__Mobile_Configuration__c =: mvamconfgId AND MobileVizArt__Workspace__c =: contentWorkspaceId];
	
				if(list_mvamc == null || list_mvamc.size() == 0){
					MobileVizArt__Mobile_Content__c mmcc = new MobileVizArt__Mobile_Content__c();
					mmcc.MobileVizArt__Synchronize_To_Filesystem__c = true;
					mmcc.MobileVizArt__List_Content_Fields__c = 'Title,Description,TagCsv';
					mmcc.MobileVizArt__Search_Fields__c = 'Title,Description,TagCsv';
					mmcc.MobileVizArt__Workspace__c = contentWorkspaceId;
					mmcc.Name = [SELECT Id, Name From ContentWorkspace WHERE Id =: c.Content_Workspace_Id__c limit 1].Name;
					mmcc.MobileVizArt__Mobile_Configuration__c = mvamconfgId;
					
					insert mmcc;
				}			
	
			}
		}
        
		String contentWorkspaceId = c.Content_Workspace_Id__c;
		String contentName = '';
		Set<Id> set_mConfigIds2Add = new Set<Id>();
		Set<Id> set_mConfigIdsExist = new Set<Id>();
		list<MobileVizArt__Mobile_Content__c> list_mConent = new list<MobileVizArt__Mobile_Content__c>();
		
		if(contentWorkspaceId != null && contentWorkspaceId != '') {
			for(ContentWorkspace cw : [SELECT Id, Name From ContentWorkspace WHERE Id =: c.Content_Workspace_Id__c limit 1]) {
				contentName = cw.Name;
			}
			
			for(MobileVizArt__Mobile_Configuration__c mConfig : [SELECT Id, MobileVizArt__Profiles__c, OwnerId FROM MobileVizArt__Mobile_Configuration__c where MobileVizArt__Active__c = true]) {
				set_mConfigIds2Add.add(mConfig.Id);
			}
			if(set_mConfigIds2Add != null && set_mConfigIds2Add.size() > 0){
				for(MobileVizArt__Mobile_Content__c mContent : [SELECT Id, MobileVizArt__Mobile_Configuration__c FROM MobileVizArt__Mobile_Content__c  WHERE MobileVizArt__Mobile_Configuration__c in: set_mConfigIds2Add AND MobileVizArt__Workspace__c =: contentWorkspaceId]){
					set_mConfigIdsExist.add((Id)mContent.MobileVizArt__Mobile_Configuration__c);
				}
				set_mConfigIds2Add.removeAll(set_mConfigIdsExist);
				
				if(set_mConfigIds2Add.size() > 0){
					for(Id mcId : set_mConfigIds2Add){
						MobileVizArt__Mobile_Content__c mConent = new MobileVizArt__Mobile_Content__c();
						mConent.MobileVizArt__Synchronize_To_Filesystem__c = true;
						mConent.MobileVizArt__List_Content_Fields__c = 'Title,Description,TagCsv';
						mConent.MobileVizArt__Search_Fields__c = 'Title,Description,TagCsv';
						mConent.MobileVizArt__Workspace__c = contentWorkspaceId;
						mConent.Name = contentName;
						mConent.MobileVizArt__Mobile_Configuration__c = mcId;
						
						list_mConent.add(mConent);
					}
					
					insert list_mConent;
				}
			}
			
			
		}
	}
**/
}