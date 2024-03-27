/**
*   util class for page FlexCalendar
*
@author Yuda Zheng
@created 2013-03-28
@version 1.0
@since 28.0
*
@changelog
* 2017-03-01 Weili Hong<weili.hong@capgemini.com>
* - Modified
* - remove unactive user
* 2013-04-11 Yuda Zheng <yuda.zheng@itbconsult.com>
* - add function to get visit type
* 2013-03-28 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
*/
global class ClsWSCalendarUtil {
    
    global class ClsEmployeeAccessLevel{
        webservice Id userId {get;set;}
        webservice String userName {get;set;}
        webservice String accessLevel {get;set;}
    }
    
    global class ClsMetaDataInfo{
		webservice String label{get;set;}
		webservice String filterStr{get;set;}
	}
    
    /**
     * webservice to get employee access levels
     *
     @author Yuda Zheng
     @created 2013-03-28
     @version 1.0
     @since 23.0
     *
     *
     @return                List    list_employeeAccessLevels       
     *
     @changelog
     * 2013-03-28 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     */
    webservice static List<ClsEmployeeAccessLevel> getEmployeeAccessLevels(){
        List<ClsEmployeeAccessLevel> list_employeeAccessLevels = new List<ClsEmployeeAccessLevel>();        

        getEmployeeHierarchy(list_employeeAccessLevels);
        
        return list_employeeAccessLevels;
    }
    
    /**
     * This method is used to get employee hierarchy
     *
     @author Yuda Zheng
     @created 2013-03-28
     @version 1.0
     @since 23.0
     *
     @params                List    employee access levels
     *
     *
     @changelog
     * 2013-03-28 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     * 2017-03-01 Weili Hong<weili.hong@capgemini.com>
     * - Modified
     * - remove unactive user
     */
    public static void getEmployeeHierarchy(List<ClsEmployeeAccessLevel> list_employeeAccessLevels){
        Set<Id> set_managerIds = new Set<Id>();
        set_managerIds.add(UserInfo.getUserId());
        
        ClsEmployeeAccessLevel ealUser = new ClsEmployeeAccessLevel();
        ealUser.userId = UserInfo.getUserId();
        ealUser.userName = UserInfo.getName();
        ealUser.accessLevel = 'EDIT'; //need to specify access level in user record on separate fields or need to be determined dependent on profile
        list_employeeAccessLevels.add(ealUser);
        
        while (!set_managerIds.isEmpty()){
            Set<Id> set_tmpManagerIds = new Set<Id>();
            for (User u : [Select Id, Name, ManagerId from User where ManagerId IN : set_managerIds and IsActive = true]){
                ClsEmployeeAccessLevel eal = new ClsEmployeeAccessLevel();
                eal.userId = u.Id;
                eal.userName = u.Name;
                eal.accessLevel = 'READONLY'; //need to specify access level in user record on separate fields or need to be determined dependent on profile
                list_employeeAccessLevels.add(eal);
                set_tmpManagerIds.add(u.Id);
            }
            set_managerIds.clear();
            set_managerIds.addAll(set_tmpManagerIds);
        }
    }
    
    
    /**
     * methode to get user Time
     *
     @author Yuda Zheng
     @created 2013-03-28
     @version 1.0
     @since 23.0
     *
     @return                    string TimeZoneSidKey
     *
     @changelog
     * 2013-03-28 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     *
     */ 
    public static String getUserTimeZoneSidKey(){
        String returnString='';
        Id userId = UserInfo.getUserId();
        returnString = [SELECT TimeZoneSidKey FROM User WHERE Id =: userId][0].TimeZoneSidKey;
        return returnString;
    }
    
    /**
     * methode to get user Time
     *
     @author Yuda Zheng
     @created 2013-04-11
     @version 1.0
     @since 23.0
     *
     @return                    string visit type
     *
     @changelog
     * 2013-04-11 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     *
     */ 
    public static String getVisitType(){
        String returnString = '';
        for( Schema.PicklistEntry f : Visits__c.Visit_Type__c.getDescribe().getPicklistValues()){
            if(f.getValue()!=''){
                returnString += f.getValue().trim() + ',' + f.getLabel().trim() + ';';
            } 
        }   
        return returnString.substring(0, returnString.length() - 1);
    }
    
    /**
     * methode to check if has permission to access metadata
     *
     @author Yuda Zheng
     @created 2013-09-06
     @version 1.0
     @since 23.0
     *
     @return                    string visit type
     *
     @changelog
     * 2013-09-06 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     *
     */ 
    public static Boolean getMetadataPermission() {
    	for(Profile profile : [select Id,PermissionsApiEnabled ,PermissionsModifyAllData from Profile where id =: UserInfo.getProfileId()]) {
    		if (profile != null && profile.PermissionsApiEnabled == true && profile.PermissionsModifyAllData == true) {
    			return true;
    		} 
    	}
    	return false;
    }
    
    /**
     * webservice to save metaData information to custom setting.
     *
     @author Yuda Zheng
     @created 2013-09-010
     @version 1.0
     @since 23.0
     *
     @params                	list    metadata informaiton
     @return                    string	successed/failed
     *
     @changelog
     * 2013-09-10 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     *
     */ 
    webservice static String setMetaDataInfo(list<ClsMetaDataInfo> list_metaDataInfo){
    	system.debug('ooooooooooooooo'+list_metaDataInfo);
    	String result = 'failed';
    	if(list_metaDataInfo != null && list_metaDataInfo.size() > 0){
    		
    		
    		//method to save metaData information to custom setting.

    		list<MetaDataInfo__c> list_meta = new list<MetaDataInfo__c>();
			list_meta = MetaDataInfo__c.getAll().values();
			delete list_meta;

    		set<String> set_fields = new set<String>();
    		Map<String, Schema.SObjectField> Fields = Schema.getGlobalDescribe().get('MetaDataInfo__c').getDescribe().fields.getMap();
    		for(String s : Fields.keyset()){
				if(s.indexOf('query')==0){
					set_fields.add(s);
				}
			}
			list<MetaDataInfo__c> list_mdi = new list<MetaDataInfo__c>();
			
			system.debug('list_metaDataInfo=='+list_metaDataInfo);
			if(list_metaDataInfo!=null && list_metaDataInfo.size()>0){
				
				for(ClsMetaDataInfo mdi : list_metaDataInfo){
					system.debug('ClsMetaDataInfo=='+mdi);
					MetaDataInfo__c m = new MetaDataInfo__c();
					if(mdi.label!=null && mdi.filterStr != null && mdi.label!='' && mdi.filterStr != ''){
						m.Name = mdi.label;
						Integer size = (Math.mod(mdi.filterStr.length() , 255)==0)?(mdi.filterStr.length() / 255):((mdi.filterStr.length() / 255 )+1);
		
						for(Integer i = 1; i <= size; i++){
							if(i == size){
								m.put('query'+i+'__c',mdi.filterStr.subString((i-1)*255, mdi.filterStr.length()));
							}else{
								m.put('query'+i+'__c',mdi.filterStr.subString((i-1)*255, i*255-1));
							}
						}
						list_mdi.add(m);
					}
				}
				if(list_mdi!=null && list_mdi.size()>0) insert list_mdi;
			}
			
			
			
			system.debug('list_mdi==='+list_mdi);

    		result = 'successed';
    	}
    	return result;
    }
    
    /**
     * webservice to get metaData information to custom setting.
     *
     @author Yuda Zheng
     @created 2013-09-010
     @version 1.0
     @since 23.0
     *
     @return                    list    metadata informaiton
     *
     @changelog
     * 2013-09-10 Yuda Zheng <yuda.zheng@itbconsult.com>
     * - Created
     *
     */ 
    webservice static list<ClsMetaDataInfo> getMetaDataInfo(){
    	list<ClsMetaDataInfo> list_ClsMetaDataInfo = new list<ClsMetaDataInfo>();
    	
    	//method to save metaData information to custom setting.
		list<MetaDataInfo__c> list_metaDataInfo = new list<MetaDataInfo__c>();
		list_metaDataInfo = MetaDataInfo__c.getAll().values();
		Map<String, Schema.SObjectField> Fields = Schema.getGlobalDescribe().get('MetaDataInfo__c').getDescribe().fields.getMap();
		set<String> set_fields = new set<String>();
		list<String> list_fields = new list<String>();
		for(String s : Fields.keyset()){
			if(s.indexOf('query')==0){
				set_fields.add(s);
			}
		}
		
    	if(list_metaDataInfo != null && list_metaDataInfo.size() > 0){
    		
    		for(MetaDataInfo__c m : list_metaDataInfo){
    			ClsMetaDataInfo mdi = new ClsMetaDataInfo();
    			mdi.label = m.Name;
    			mdi.filterStr = '';
    			for(Integer i=1; i<=set_fields.size(); i++){
    				if(m.get('query'+i+'__c') != null && m.get('query'+i+'__c') != '') {
    					mdi.filterStr += m.get('query'+i+'__c');
    				}
    			}
    			list_ClsMetaDataInfo.add(mdi);
    		}
    		
    	}
    	system.debug(list_ClsMetaDataInfo);
    	return list_ClsMetaDataInfo;
    }
}