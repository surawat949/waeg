/**
*	This class is to show Account on Google Maps
*
@author Jian Yin
@created 2013-10-22
@version 1.0
@since 28.0 (Force.com ApiVersion)
*
@changelog
* 2013-10-22 Jian Yin <jian.yin@itbconsult.com>
* - Created
*/
public with sharing class CtrlShowAccountOnGoogleMaps {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public MapObject defaultAccount{get;private set;}
	public String locationJSON{get;private set;}
	public list<ClsAccount> clsAccounts{get;private set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CtrlShowAccountOnGoogleMaps(){
		
		defaultAccount = new MapObject();
		clsAccounts = new list<ClsAccount>();
		
		String paramName = 'ids';
		String paramStr = '';
		String defaultAccountId = '';
		map<String, String> map_id_distance = new map<String, String>();
		list<String> list_param = new list<String>(); 
		map<String, String> map_urlParams = ApexPages.currentPage().getParameters();
		if(map_urlParams != null && map_urlParams.size() > 0){
			paramStr = map_urlParams.get(paramName);
			list_param.addAll(paramStr.split(','));

			if(list_param != null && list_param.size() > 0){
				for(Integer i = 0; i < list_param.size(); i++){
					String[] id_distance = list_param[i].split('_');
					if(i == 0){
						defaultAccountId = id_distance[0];
					}else{
						map_id_distance.put(id_distance[0], id_distance[1]);
					}
				}
			}
		}
		
		
		Account acc = [SELECT Id, Name, Shipping_Geo_Code_Long__c, Shipping_Geo_Code_Lat__c, 
							ShippingCountry, ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode 
							FROM Account WHERE Id =:defaultAccountId ];
		defaultAccount.Latitude = Double.valueOf(acc.Shipping_Geo_Code_Lat__c);
		defaultAccount.Longitude = Double.valueOf(acc.Shipping_Geo_Code_Long__c);
		defaultAccount.Name = acc.Name;
		defaultAccount.Id = acc.Id;
		defaultAccount.acct = acc;
		
		locationJSON = '';
		if(map_id_distance != null && map_id_distance.size() > 0){
			getAccountInfo(map_id_distance);
		}
		
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
	* This method is used to
	*
	@author	 Jian Yin 
	@created 2013-10-22
	@version 1.0
	@since   28.0 (Force.com ApiVersion)
	*
	@param 
	*
	*
	@changelog
	* 2013-10-22 Jian Yin <jian.yin@itbconsult.com>
	* - Created
	*/ 
	public void getAccountInfo(map<String, String> map_id_distance){

		list<Account> accounts = [SELECT Id, Name, Shipping_Geo_Code_Long__c, Shipping_Geo_Code_Lat__c,
									ShippingCountry, ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode 
									FROM Account WHERE Id IN :map_id_distance.keySet()];
		
		list<MapObject> mapObjects = new list<MapObject>();
		
		for(Account a : accounts){
			ClsAccount ca = new ClsAccount();
			ca.acct = a;
			ca.dist = Double.valueOf( map_id_distance.get(String.valueOf(a.Id)) );
			clsAccounts.add(ca);
			
			MapObject mo = new MapObject();
			mo.Id = a.Id;
			mo.Latitude = Double.valueOf(a.Shipping_Geo_Code_Lat__c);
			mo.Longitude =  Double.valueOf(a.Shipping_Geo_Code_Long__c);
			mo.Name = a.Name;
			mapObjects.add(mo);
		}
		
		locationJSON = JSON.Serialize(mapObjects);
		
	}

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class ClsAccount{
    	public Account acct{get;set;}
    	public Double dist{get;set;}
    	
    	public ClsAccount(){
    		this.dist = 0;
    	}
    }
    
    public class MapObject{
    	public String Id{get;set;}
    	public double Latitude{get;set;}
    	public double Longitude{get;set;}
    	public String Name{get;set;}
    	public Account acct{get;set;}
    	
    	public MapObject(){}
    }
	///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}