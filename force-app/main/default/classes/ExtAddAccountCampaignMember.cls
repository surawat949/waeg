/**
 *	This class is the controller of add account campaign member page which can be used to manage account campaign member.
 * 	This class contains a set of methods used in VF page ExtAddAccountCampaignMember for below functions:
 *	1. select some account campaign members
 *  2. create some account campaign members
 *	3. delete some account campaign members
 * 
 @author Yinfeng Guo
 @created 2013-08-27
 @version 1.0
 @since 28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-09-15 Minghao Li <minghao.li@oinio.com>
 * - Created	
 * 2013-08-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created	
 */
public with sharing class ExtAddAccountCampaignMember {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	public Campaign campaign{get;set;}
	public list<CustomField> list_cf {get;set;}
	public list<Account> tempList;

	public transient list<CustomField> list_filter{get;set;}
	public transient LocaleConfig lc {get;set;}
	public transient String jsonPaging {get;set;}
	public transient list<list<Account>> list_acts {get;set;}
	public transient Set<Id> accountMemberIdList {get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<String, String> map_urlParams;
    private final ApexPages.standardController stdCtrl;
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	{
        this.lc = new LocaleConfig();
        setUserLocale(lc, userInfo.getLocale());
    }
	
	
   /**
	* The contsructor
	*
	@author Yinfeng Guo
	@created 2013-08-27
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-08-27 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	* - Created
	*/
	public ExtAddAccountCampaignMember() {
		
		try{
			for(Campaign c : [select id, name from Campaign where id =: ApexPages.currentPage().getParameters().get('id')]){
                this.campaign = c;
            }
            initCampain();
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
		}
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////

    //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& -=BEGIN remote action methods=- &&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    	/**
    * This method is init campain.
    *
    @author Minghao Li
    @created 2015-09-15
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-09-15 Minghao Li <minghao.li@oinio.com>
    * - Created
    */
    public void initCampain(){
    	try{

            Paging p = new Paging('', false, 'select Id, ', '', ' Where Id != null ', 10000);
        	this.list_cf = new list<CustomField>();
    		this.list_acts = new list<list<Account>>();
    		this.tempList = new list<Account>();
    		this.list_filter = new list<CustomField>();
			    		
			/*
			 * CDU - replace filterable list by account fieldset
			 */
			list<Schema.FieldSetMember> list_filterset = SObjectType.Account.FieldSets.AccountFieldsCampaignFilter.getFields();
			
	    	for(Schema.FieldSetMember f : list_filterset) {
	    		String field = f.getFieldPath();
	    		this.list_filter.add( new CustomField(f.getLabel(), field));
	        }

			list_filter.sort();
    		
            list<Schema.FieldSetMember> list_accFs = SObjectType.Account.FieldSets.AccountFieldsOnCampaign.getFields();
			
	    	for(Schema.FieldSetMember f : list_accFs) {
	    		String field = f.getFieldPath();
	    		this.list_cf.add( new CustomField(f.getLabel(), field));
	    		p.baseSql += (field+',');
	        }
	        
	        p.baseSql = (p.baseSql.endswith(',') ? p.baseSql.subString(0, p.baseSql.length()-1) : p.baseSql);
	        p.baseSql += ' From Account ';
			p.sql = (p.baseSql + ' ' + p.filter + ' ' + p.orderBy + ' limit ' + p.limitSize);

			
			list_acts.clear();			
			list_acts = search(p.sql);
			p.isStop = (this.list_acts.size() < p.limitSize ? true : false);
			p.lastId = '';//(p.isStop ? '' : this.list_acts.get( (this.list_acts.size()-1)).Id );
			
			this.jsonPaging = JSON.serialize(p);
			
    	}catch(Exception e){
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
    	}
    }
    

	private list<list<Account>> search(String sql){
		String sharedSQL = sql;
		System.debug('base sql (' + sql.length() + '):' + sql);
		list<list<Account>> resultList = new list<list<Account>>();
		List<Id> accountMemberIdList = new List<Id>();

		//search member of campaign, they should be excluded from final result
		System.debug('XXX search account_campaign_member');
		for(Account_Campaing_Member__c cm : [select Account_Name__c, Campaign_Priority__c from Account_Campaing_Member__c where Central_Campaign__c =:this.campaign.Id]){
			accountMemberIdList.add(cm.Account_Name__c);
		}
		Set<Id> accountSet = new Set<Id>(accountMemberIdList);

		//build filter on security access (users should see only accounts they have access)

		String salesRole = [select Id, Sales_Role__c from User where id=:UserInfo.getUserId() ].Sales_Role__c;
		//if(!String.isEmpty(salesRole)){
			Set<Id> userIdSet = ToolBox.getRoleSubordinateUsers(UserInfo.getUserId());
			String crit = 'and ownerid in (';
			if(userIdSet.size()>0){
				for(Id i: userIdSet){
					crit = crit + '\'' + i + '\',';
				}
				crit = crit.substring(0, crit.length()-1) + ') order by ';
			} else {
				//only currrent user id should be considered
				crit = 'and ownerid=\''+UserInfo.getUserId()+'\' order by ';
			}
			sql = sql.replaceAll('order by', crit);
		//}
		System.debug('XXX sql string(' + sql.length() + '):' + sql);
		
		this.templist = new List<Account>();
		for(Account a : database.query(sql)){
			if(!accountSet.contains(a.id)){
				this.templist.add(a);
			}
			if(this.tempList.size()==1000){
				System.debug('Loop ' + resultList.size() + ', add ' + this.tempList.size() + ' items');
				resultList.add(this.tempList);
				this.tempList = new List<Account>();
			}
		}
		
		if(this.tempList.size()>0){
			resultList.add(tempList);
		}

		//CDU 03/06/2020: add shared accounts in list
		List<Id> accountShareList = new List<Id>();
		List<Group> relatedGroups = [SELECT Id FROM Group WHERE Id IN (
        									SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId() 
    									)
										];
	
		for(AccountShare sh : [select accountId from accountShare where UserOrGroupId in :relatedGroups or UserOrGroupId=:UserInfo.getUserId() limit 2000]){
			accountShareList.add(sh.accountId);
		}
		System.debug('xxx shared account list size=' + accountShareList.size());
		//loop on shared account  
		this.tempList = new List<Account>();

		for(Account b : [select Id, Name, Hoya_Account_ID__c,Shop_Postal_Code__c, Record_Type_Name__c,recordtype.name, Loyalty_Programms__c,Account_Status__c, shop_city__c, phone, Segmentation_Box__c, Financial_Status_Identifier__c, recordtypeid, potential__c, Share_of_Wallet__c, Target_List__c, Buying_Group_Name__c
				FROM Account Where Id in :accountShareList
				and ownerId!=:UserInfo.getUserId() 
				and account.Account_Status__c<>'Closed']){
			if(!accountSet.contains(b.id)){
				this.templist.add(b);
			}
			if(this.tempList.size()==1000){
				System.debug('Loop ' + resultList.size() + ', add ' + this.tempList.size() + ' items');
				resultList.add(this.tempList);
				this.tempList = new List<Account>();
			}
		}

		System.debug('Last tmpList size: ' + this.tempList.size());
		if(this.tempList.size()>0){
			resultList.add(tempList);
		}

		return resultList;
	}

	/**
    * This method is get account.
    *
    @author Minghao Li
    @created 2015-09-15
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-09-15 Minghao Li <minghao.li@oinio.com>
    * - Created
    */
    public void getAccountFunction(){
    	
    	Paging p = (Paging)Json.deserialize(jsonPaging, ExtAddAccountCampaignMember.Paging.class);
		if(this.list_acts!=null){
			System.debug('XXX Input size ' + this.list_acts.size());
		}
    	this.list_acts = new list<list<Account>>();
    	
    	try{

			list_acts.clear();	
			list_acts = search(p.sql);
			
			Integer pSize = this.list_acts.size();
			Integer fullSize = 0;
			if(pSize>0){
				fullSize = ((pSize-1)*1000) + this.list_acts[pSize-1].size();
			}
			System.debug('pSize='+pSize + ',fullsize=' + fullSize + ', limit=' + p.limitSize);
			p.isStop = (fullSize < p.limitSize ? true : false);
			p.lastId = (p.isStop ? '' : this.list_acts[pSize].get( (this.list_acts[pSize].size()-1)).Id );
			
    	}catch(Exception e){
    		p.isStop = true;
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
    	}
		this.jsonPaging = JSON.serialize(p);
    }
    
	/**
    * This method is insert campaing member.
    *
    @author Minghao Li
    @created 2015-09-15
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-09-15 Minghao Li <minghao.li@oinio.com>
    * - Created
    */
	@RemoteAction
	public static String insertCampaignMember(String jsons){

		list<CustomObject> list_co = (list<CustomObject>)JSON.deserialize(jsons, list<CustomObject>.class);
	    list<Account_Campaing_Member__c> list_members2Insert = new list<Account_Campaing_Member__c>();

	    for(CustomObject co : list_co){
	        list_members2Insert.add(new Account_Campaing_Member__c(Account_Name__c=co.aId, Central_Campaign__c=co.cId));
	    }
	    if(!list_members2Insert.isEmpty()){
	    	insert list_members2Insert;
	    }
	    return 'succeed';
	} 
    //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& -=End 	remote action methods=- &&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
    
    //********************************* -=BEGIN public methods=- **********************************
	//********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
	/**
    * This method is set user locale.
    *
    @author Minghao Li
    @created 2015-09-15
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-09-15 Minghao Li <minghao.li@oinio.com>
    * - Created
    */
    public static void setUserLocale(LocaleConfig localeConfig, String userLocale){
        try{
            localeConfig.locale= userLocale;
            list<String> list_s = localeConfig.locale.split('_');
            localeConfig.locale = list_s[0]+'-'+list_s[1];
        }catch(Exception e){
            localeConfig.locale = 'de-DE';
        }   
        localeConfig.jsPath = '/glob-cultures/cultures/globalize.culture.'+localeConfig.locale+'.js';
    }
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    
    public class LocaleConfig{
        public String locale {get;set;}
        public String jsPath {get;set;}
    }
    
    public class CustomObject{
    	public String aId {get;set;}
    	public String cId {get;set;}
    }
    
    public class CustomField implements Comparable{
    	public String label {get;set;}
    	public String field {get;set;}
    	
    	public CustomField(String label, String field){
    		this.label = label;
    		this.field = field;
    	}
    	
    	public Integer compareTo(Object compareTo) {
    		CustomField compareToEmp = (CustomField)compareTo;
			if (field == compareToEmp.field) return 0;
			if (field > compareToEmp.field) return 1;
			return -1; 
    	}
    }
    
    public class Paging{
    	
    	public String lastId {get;set;}
    	public Boolean isStop {get;set;}
    	public String sql {get;set;}
    	public String baseSql {get;set;}
    	public String filter {get;set;}
    	public String searchFilter {get;set;}
    	public Integer limitSize {get;set;}
    	public String orderBy {get;set;}
    	public Paging(String lastId, Boolean isStop, String baseSql, String sql, String filter, Integer limitSize){
    		this.lastId = lastId;
    		this.isStop = isStop;
    		this.baseSql = baseSql;
    		this.sql = sql;
    		this.filter = filter;
    		this.limitSize = limitSize;
    		this.searchFilter = '';
    		this.orderBy = ' order by Id asc ';
    	}
    }
	///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}