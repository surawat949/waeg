/**
*   Page controller for page FlexCalendar
*
@author Yuda Zheng
@created 2013-03-28
@version 1.0
@since 23.0
*
@changelog
* 2013-03-28 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
* 2016-10-24 Weili Hong <weili.hong@oino.com>
* - Add all locales
*/

public with sharing class ExtFlexCalendar {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String accountIds{get;private set;}
    public String timeZoneSidKey{get;private set;}
	public String userLanguage{get;private set;}
	public String visitType{get;private set;}
	public Boolean metadataPermission{get;private set;}
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<String, String> map_urlParams;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
    * The contsructor
    *
    @author Yuda Zheng
    @created 2013-03-28
    @version 1.0
    @since 23.0
    *
    @changelog
    * 2013-03-28 Yuda Zheng <yuda.zheng@itbconsult.com>
	* - Created
    */
    public ExtFlexCalendar(ApexPages.standardController stdCtrl) {
        accountIds = '';
        timeZoneSidKey = ClsWSCalendarUtil.getUserTimeZoneSidKey();
        visitType = ClsWSCalendarUtil.getVisitType();
        metadataPermission = ClsWSCalendarUtil.getMetadataPermission();
        String lang = UserInfo.getLanguage();
        map<String,String> map_lang_userLanguage = new map<String,String>();
        map_lang_userLanguage.put('de', 'de_DE');
        map_lang_userLanguage.put('hu', 'hu_HU');
        /*map_lang_userLanguage.put('cs', 'cs_CZ');
        map_lang_userLanguage.put('da', 'da_DK');
        map_lang_userLanguage.put('es', 'es_ES');
        map_lang_userLanguage.put('fi', 'fi_FI');
        map_lang_userLanguage.put('fr', 'fr_FR');
        map_lang_userLanguage.put('it', 'it_IT');
        map_lang_userLanguage.put('nl_NL', 'nl_NL');
        map_lang_userLanguage.put('pl', 'pl_PL');
        map_lang_userLanguage.put('pt_PT', 'pt_PT');
        map_lang_userLanguage.put('ro', 'ro_RO');
        map_lang_userLanguage.put('sv', 'sv_SE');
        map_lang_userLanguage.put('tr', 'tr_TR');
        map_lang_userLanguage.put('ko', 'ko_KR');*/
        userLanguage = 'en_US';
        for(String langStr :map_lang_userLanguage.keySet()){
            if(lang.equals(langStr)) {
                userLanguage = map_lang_userLanguage.get(langStr);
                break;
            }
        }
        /*if(lang.equals('de'))
        {
        	userLanguage = 'de_DE';
        }
        else if (lang.equals('hu'))
        {
        	userLanguage = 'hu_HU';
        }
    	else
    	{
    		userLanguage = 'en_US';
    	}*/
        map_urlParams = ApexPages.currentPage().getParameters();
        
        if(map_urlParams.containsKey('accountIds')) {
            accountIds = map_urlParams.get('accountIds');
        }
        
   
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}