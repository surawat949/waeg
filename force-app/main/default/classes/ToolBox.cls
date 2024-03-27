public class ToolBox {

static Map<CountryEnum, List<CompanyNameEnum>> countryCompanyMap = new Map<CountryEnum, List<CompanyNameEnum>>();
    static{
            countryCompanyMap.put(CountryEnum.Australia, new List<CompanyNameEnum>{CompanyNameEnum.HAPL});
            //countryCompanyMap.put(CountryEnum.Austria, new List<CompanyNameEnum>{CompanyNameEnum., CompanyNameEnum.});
            countryCompanyMap.put(CountryEnum.Belgium, new List<CompanyNameEnum>{CompanyNameEnum.HLBE, CompanyNameEnum.SOB});
            countryCompanyMap.put(CountryEnum.Brazil, new List<CompanyNameEnum>{CompanyNameEnum.HLBR});
            countryCompanyMap.put(CountryEnum.China, new List<CompanyNameEnum>{CompanyNameEnum.HLSH, CompanyNameEnum.SOC});
            countryCompanyMap.put(CountryEnum.CzechRepublic, new List<CompanyNameEnum>{CompanyNameEnum.HLCZ});
            countryCompanyMap.put(CountryEnum.Denmark, new List<CompanyNameEnum>{CompanyNameEnum.HOLD});
            countryCompanyMap.put(CountryEnum.Finland, new List<CompanyNameEnum>{CompanyNameEnum.HOLF});
            countryCompanyMap.put(CountryEnum.France, new List<CompanyNameEnum>{CompanyNameEnum.HLFR, CompanyNameEnum.SOF});
            countryCompanyMap.put(CountryEnum.Germany, new List<CompanyNameEnum>{CompanyNameEnum.HODG, CompanyNameEnum.SOG});
            countryCompanyMap.put(CountryEnum.HongKong, new List<CompanyNameEnum>{CompanyNameEnum.HLHK, CompanyNameEnum.SOG});
            countryCompanyMap.put(CountryEnum.Hungary, new List<CompanyNameEnum>{CompanyNameEnum.HMHU, CompanyNameEnum.SOHU});
            //countryCompanyMap.put(CountryEnum.Ireland, new List<CompanyNameEnum>{CompanyNameEnum., CompanyNameEnum.});
            countryCompanyMap.put(CountryEnum.Italy, new List<CompanyNameEnum>{CompanyNameEnum.HOLI, CompanyNameEnum.SOI});
            countryCompanyMap.put(CountryEnum.Malaysia, new List<CompanyNameEnum>{CompanyNameEnum.HOLM, CompanyNameEnum.ILENS});
            countryCompanyMap.put(CountryEnum.Netherlands, new List<CompanyNameEnum>{CompanyNameEnum.HLNL});
            //countryCompanyMap.put(CountryEnum.Norway, new List<CompanyNameEnum>{CompanyNameEnum., CompanyNameEnum.});
            countryCompanyMap.put(CountryEnum.Poland, new List<CompanyNameEnum>{CompanyNameEnum.HLPO, CompanyNameEnum.SOPL});
            countryCompanyMap.put(CountryEnum.Romania, new List<CompanyNameEnum>{CompanyNameEnum.HLRO});
            countryCompanyMap.put(CountryEnum.Russia, new List<CompanyNameEnum>{CompanyNameEnum.HLRU, CompanyNameEnum.SORU});
            countryCompanyMap.put(CountryEnum.Spain, new List<CompanyNameEnum>{CompanyNameEnum.HLIB, CompanyNameEnum.SOES});
            countryCompanyMap.put(CountryEnum.SouthAfrica, new List<CompanyNameEnum>{CompanyNameEnum.HLSA, CompanyNameEnum.SOSA});
            countryCompanyMap.put(CountryEnum.SouthKorea, new List<CompanyNameEnum>{CompanyNameEnum.HOLK});
            countryCompanyMap.put(CountryEnum.Sweden, new List<CompanyNameEnum>{CompanyNameEnum.HLSE});
            countryCompanyMap.put(CountryEnum.Thailand, new List<CompanyNameEnum>{CompanyNameEnum.THAI});
            countryCompanyMap.put(CountryEnum.Turkey, new List<CompanyNameEnum>{CompanyNameEnum.HLTR, CompanyNameEnum.SOT});
            countryCompanyMap.put(CountryEnum.UnitedKingdom, new List<CompanyNameEnum>{CompanyNameEnum.HLUK, CompanyNameEnum.SOUK});
            countryCompanyMap.put(CountryEnum.EMEA, new List<CompanyNameEnum>{CompanyNameEnum.HLNL, CompanyNameEnum.HVC, CompanyNameEnum.HVEU});
            countryCompanyMap.put(CountryEnum.HongKong, new List<CompanyNameEnum>{CompanyNameEnum.HLHK});
            countryCompanyMap.put(CountryEnum.Singapore, new List<CompanyNameEnum>{CompanyNameEnum.HLSI});
            countryCompanyMap.put(CountryEnum.Phillipine, new List<CompanyNameEnum>{CompanyNameEnum.HLPH});
            countryCompanyMap.put(CountryEnum.Taiwan, new List<CompanyNameEnum>{CompanyNameEnum.HOTA});
            countryCompanyMap.put(CountryEnum.APAC, new List<CompanyNameEnum>{CompanyNameEnum.HAPL,CompanyNameEnum.HLSI, CompanyNameEnum.HLHK, CompanyNameEnum.THAI,CompanyNameEnum.HOLM, CompanyNameEnum.ILENS,CompanyNameEnum.HLSH, CompanyNameEnum.SOC, CompanyNameEnum.HLPH, CompanyNameEnum.HOTA});
    }

static Map<CompanyNameEnum, CountryEnum> companyCountryMap = new Map<CompanyNameEnum,CountryEnum>();
    static{
        companyCountryMap.put(CompanyNameEnum.HAPL, CountryEnum.Australia);
        companyCountryMap.put(CompanyNameEnum.HLBE, CountryEnum.Belgium);
        companyCountryMap.put(CompanyNameEnum.HLBR, CountryEnum.Brazil);
        companyCountryMap.put(CompanyNameEnum.HLCZ, CountryEnum.CzechRepublic);
        companyCountryMap.put(CompanyNameEnum.HLFR, CountryEnum.France);
        companyCountryMap.put(CompanyNameEnum.HLHK, CountryEnum.HongKong);
        companyCountryMap.put(CompanyNameEnum.HLHU, CountryEnum.Hungary);
        companyCountryMap.put(CompanyNameEnum.HLIB, CountryEnum.Spain);
        companyCountryMap.put(CompanyNameEnum.HLNL, CountryEnum.Netherlands);
        companyCountryMap.put(CompanyNameEnum.HLPH, CountryEnum.Phillipine);
        companyCountryMap.put(CompanyNameEnum.HLPO, CountryEnum.Poland);
        companyCountryMap.put(CompanyNameEnum.HLRO, CountryEnum.Romania);
        companyCountryMap.put(CompanyNameEnum.HLRU, CountryEnum.Russia);
        companyCountryMap.put(CompanyNameEnum.HLSA, CountryEnum.SouthAfrica);
        companyCountryMap.put(CompanyNameEnum.HLSE, CountryEnum.Norway);
        companyCountryMap.put(CompanyNameEnum.HLSE, CountryEnum.Sweden);
        companyCountryMap.put(CompanyNameEnum.HLSH, CountryEnum.China);
        companyCountryMap.put(CompanyNameEnum.HLSI, CountryEnum.HongKong);
        companyCountryMap.put(CompanyNameEnum.HLSI, CountryEnum.Singapore);
        companyCountryMap.put(CompanyNameEnum.HLTR, CountryEnum.Turkey);
        companyCountryMap.put(CompanyNameEnum.HLUK, CountryEnum.UnitedKingdom);
        companyCountryMap.put(CompanyNameEnum.HODG, CountryEnum.Germany);
        companyCountryMap.put(CompanyNameEnum.HOLD, CountryEnum.Denmark);
        companyCountryMap.put(CompanyNameEnum.HOLD, CountryEnum.Norway);
        companyCountryMap.put(CompanyNameEnum.HOLF, CountryEnum.Finland);
        companyCountryMap.put(CompanyNameEnum.HOLI, CountryEnum.Italy);
        companyCountryMap.put(CompanyNameEnum.HOLK, CountryEnum.SouthKorea);
        companyCountryMap.put(CompanyNameEnum.HOLM, CountryEnum.Malaysia);
        companyCountryMap.put(CompanyNameEnum.HOTA, CountryEnum.Taiwan);
        companyCountryMap.put(CompanyNameEnum.SOB, CountryEnum.Belgium);
        companyCountryMap.put(CompanyNameEnum.SOB, CountryEnum.Netherlands);
        companyCountryMap.put(CompanyNameEnum.SOC, CountryEnum.China);
        companyCountryMap.put(CompanyNameEnum.SOE, CountryEnum.Germany);
        companyCountryMap.put(CompanyNameEnum.SOES, CountryEnum.Spain);
        companyCountryMap.put(CompanyNameEnum.SOF, CountryEnum.France);
        companyCountryMap.put(CompanyNameEnum.SOG, CountryEnum.Germany);
        companyCountryMap.put(CompanyNameEnum.SOHU, CountryEnum.Hungary);
        companyCountryMap.put(CompanyNameEnum.SOI, CountryEnum.Italy);
        companyCountryMap.put(CompanyNameEnum.SOPL, CountryEnum.Poland);
        companyCountryMap.put(CompanyNameEnum.SORU, CountryEnum.Russia);
        companyCountryMap.put(CompanyNameEnum.SOSA, CountryEnum.SouthAfrica);
        companyCountryMap.put(CompanyNameEnum.SOT, CountryEnum.Turkey);
        companyCountryMap.put(CompanyNameEnum.SOUK, CountryEnum.UnitedKingdom);
        companyCountryMap.put(CompanyNameEnum.THAI, CountryEnum.Thailand);
        companyCountryMap.put(CompanyNameEnum.HVC, CountryEnum.EMEA);
        companyCountryMap.put(CompanyNameEnum.HVEU, CountryEnum.EMEA);
        companyCountryMap.put(CompanyNameEnum.AHQ, CountryEnum.APAC);
    }

public static List<String> getCompanyList(String company){

        CompanyNameEnum cmp = null;
        //get enum value for from company name
        for(CompanyNameEnum c : CompanyNameEnum.values()){
            if(c.name()==company){
                cmp = c;
            }
        }
        //get country
        CountryEnum country = companyCountryMap.get(cmp);

        // get list of company link to country
        List<String> result = new List<String>();
        for(CompanyNameEnum name: countryCompanyMap.get(country)){
            result.add(name.name());
        }
        return result;
    }


	public static Set<ID> getRoleSubordinateUsers(Id userId) {

        // get requested user's role
        Id roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :allSubRoleIds]);
        // return the ids as a set so you can do what you want with them
        return users.keySet();

  }

  private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

    Set<ID> currentRoleIds = new Set<ID>();

    // get all of the roles underneath the passed roles
    for(UserRole userRole :[select Id from UserRole where ParentRoleId 
      IN :roleIds AND ParentRoleID != null])
    currentRoleIds.add(userRole.Id);

    // go fetch some more rolls!
    if(currentRoleIds.size() > 0)
      currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));

    return currentRoleIds;

  }
    
    public static set<Id> getSubordinateRoles(Id roleId) {
    
        map<Id, set<Id>> parentAndChildren = new map<Id, set<Id>>();
        set<Id> children;
        for(UserRole ur : [select Id, ParentRoleId from UserRole]) {
            children = parentAndChildren.containsKey(ur.ParentRoleId) ? parentAndChildren.get(ur.ParentRoleId) : new set<Id>();
            children.add(ur.Id);
            parentAndChildren.put(ur.ParentRoleId, children);
        }
        return getSubordinateRoles(roleID, parentAndChildren);
    }

    public static set<Id> getSubordinateRoles(Id roleId, map<Id, set<Id>> parentAndChildren) {
        set<Id> subordinateRoles = new set<Id>();
        set<Id> remainingSubordinateRoles = new set<Id>();
        if(parentAndChildren.containsKey(roleId)) {
            subordinateRoles.addAll(parentAndChildren.get(roleId));
            for(Id subRoleId : subordinateRoles) {
                remainingSubordinateRoles.addAll(getSubordinateRoles(subRoleId, parentAndChildren));
            }
        }
        subordinateRoles.addAll(remainingSubordinateRoles);
        return subordinateRoles;
    }

    public static boolean isApac(String company){
        CompanyNameEnum country = null;
        for(CompanyNameEnum enumValue: CompanyNameEnum.values()){
            if(enumValue.name().equals(company)){
                country = enumValue;
            }
        }
        List<CompanyNameEnum> apacList = countryCompanyMap.get(CountryEnum.APAC);
        return apacList.contains(country);
    }
    public static String getDescribedObjects( List<String> lstSObjectType ) {
    	
        // Globally desribe all the objects 
        Map<String, SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
        // Create a JSON string with object field labels and picklist values
        String allObjJSON = '{';
        
        // Iterate over the list of objects and describe each object  
        for( String sObjectType : lstSObjectType ) {
            
            if( allObjJSON != '{' ) 
            	allObjJSON += ', ';
            allObjJSON += '"' + sObjectType + '": ';
            DescribeSObjectResult describeResult = globalDescribe.get(sObjectType).getDescribe();
            Map<String, Schema.SObjectField> desribedFields = describeResult.fields.getMap();
            String objJSON = '{';
            
            for( String fieldName :  desribedFields.keySet() ) {
                
                // Descirbe the field 
                Schema.SObjectField field = desribedFields.get( fieldName );
                Schema.DescribeFieldResult f = field.getDescribe();	   
                if( objJSON != '{' )
                    objJSON += ', ';    
                // Get the field label and append in the JSON string
                objJSON += '"' + f.getName() + '": ' + '{ "label" : "' + f.getLabel() + '"';
                
                // if it's a picklist field then also add the picklist options
                if( field.getDescribe().getType() == Schema.DisplayType.PICKLIST ){
                    
                    List <Schema.PicklistEntry> picklistValues = field.getDescribe().getPickListValues();
                	List<String> pickListOptions = new List<String>();
                    pickListOptions.add('{ "label": "--None--", "value": null }');
                    
                    for (Schema.PicklistEntry pe : picklistValues) { 
                        
                        pickListOptions.add('{ "label": "' + pe.getLabel() + '", "value": "' + pe.getValue() + '" }');
                    
                    }
                    
                    System.debug( '>>>> ' + fieldName + '>>>> ' + String.join(pickListOptions, ', ') );
                    objJSON += ', "picklistOptions": [' + String.join(pickListOptions, ', ') + ']';   
                }
                objJSON += '}';
            }
            objJSON += '}';
            
            allObjJSON += objJSON;
        }
        
        // Close the object in the JSON String
        allObjJSON += '}';
        
        System.debug( ' JSON STRING : ' + allObjJSON );
        
        return allObjJSON;
    }
    
    public static String stripToEmpty(String value){
        if(value!=null && value!=''){
            return value;
        }
        return '';
    }
}