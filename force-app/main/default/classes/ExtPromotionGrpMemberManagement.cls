/**
 *	This class is used to manage account promotion members.
 *
 @author Bin Yuan
 @created 2013-05-22
 @version 1.0
 @since 27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public class ExtPromotionGrpMemberManagement {
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public Promotion_Group__c promotionGrp {get; set;}
	public CustomOption customOption {get; set;}
	public list<CustomPromotionMember> list_proMember {get; set;}
	public Integer currentIndex{get; set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	private map<String, String> map_urlParams;
	private ApexPages.standardController stdCtrl;
	private Id proGrpId;
	private map<Id, String> map_acctId_acctName = new map<Id, String>();
	private Integer rowCounter;
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
	* The contsructor
	*
	@author Bin Yuan
	@created 2013-01-05
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-01-05 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/
    public ExtPromotionGrpMemberManagement(ApexPages.standardController stdCtrl) {
    	map_urlParams = ApexPages.currentPage().getParameters();
    	this.stdCtrl = stdCtrl;
    	customOption = new CustomOption();
    	promotionGrp = (Promotion_Group__c) this.stdCtrl.getRecord();
    	
		init();
    }
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

    
   /**
	* This method is used to get custom select option
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	*
	@return 			CustomOption
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/    
	public CustomOption getCustomOption() {
		return this.customOption;
	}
	
   /**
	* This method is used to set custom select option
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@param String selectOption
	*
	@return 			void
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/  	
	public void setCustomOption(String selectOption) {
		this.customOption.selected = selectOption;
	}    
	
   /**
	* This method is used to add promotion group members
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@param String selectOption
	*
	@return 			void
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/  	
	public void addProGrpMembs() {
		for(Integer i = 1; i <= Integer.valueOf(this.customOption.selected); i++) {
			Promotion_Group_Member__c proGrpMemb = new Promotion_Group_Member__c();
			proGrpMemb.Promotion_Group__c = this.promotionGrp.Id;
			CustomPromotionMember customMember = new CustomPromotionMember(proGrpMemb, rowCounter);
			list_proMember.add(customMember);
			rowCounter ++;
		}
	} 
	   
   /**
	* This method is used to DELETE promotion group members
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@param String selectOption
	*
	@return 			void
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/  	
	public void deleteProGrpMembs() {
		Promotion_Group_Member__c proGrpMemb = list_proMember[currentIndex - 1].promotionMember;
		if(proGrpMemb.Id != null) {
			list_proMember.remove(currentIndex - 1);
			delete proGrpMemb;
		}
		else {
			list_proMember.remove(currentIndex - 1);
		} 
		rowCounter = 1;
		for(CustomPromotionMember memb : list_proMember) {
			memb.rowIndex = rowCounter;
			rowCounter ++;
		}
	} 
	   
   /**
	* This method is used to add promotion group members
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	@param String selectOption
	*
	@return 			void
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/  	
	public void saveProGrpMembs() {
		list<Promotion_Group_Member__c> list_proGrpMembs2Upsert = new list<Promotion_Group_Member__c>();
		set<Id> set_acctIds = new set<Id>();
		boolean isSaveSuccess = true; 
		for(CustomPromotionMember memb : list_proMember) {
			//Required field check
			if(memb.promotionMember.Account__c == null) {
				memb.promotionMember.Account__c.addError(system.label.PromotionGrpMem_Need_Acct_Msg);
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.PromotionGrpMem_Need_Acct_Msg));
				return;
			}
			//Process mutiple assignment
			if(set_acctIds.contains(memb.promotionMember.Account__c)) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.PromotionGrpMem_Acct_Repeat_Msg));
				return;
			}
			set_acctIds.add(memb.promotionMember.Account__c);
			
			if(memb.promotionMember.Start_of_Membership__c == null) {
				memb.promotionMember.Start_of_Membership__c.addError(system.label.PromotionGrpMem_Need_StartDate_Msg);
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, system.label.PromotionGrpMem_Need_StartDate_Msg));
				return;
			}
			list_proGrpMembs2Upsert.add(memb.promotionMember);
			
		}

		try {
			if(!list_proGrpMembs2Upsert.isEmpty()) {
				upsert list_proGrpMembs2Upsert;
				init();
			}
		}
		catch(Exception ex) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
	}    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
   /**
	* This method is used to init the page data
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	*
	@return 			void
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/    
    private void init(){
    	try {
    		rowCounter = 1;
	    	promotionGrp = (Promotion_Group__c) [Select Id, Name From Promotion_Group__c Where Id =: promotionGrp.Id];
	    	list_proMember = new list<CustomPromotionMember>();
	    	getExistingPromotionGroupMembs();
    	}
    	catch(Exception ex) {
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex + ''));
    	}
    } 
   /**
	* This method is used to get all promotion
	*
	@author Bin Yuan
	@created 2013-05-22
	@version 1.0
	@since 25.0 (Force.com ApiVersion)
	*
	*
	@return 			void
	*
	@changelog
	* 2013-05-22 Bin Yuan <bin.yuan@itbconsult.com>
	* - Created
	*/    
    private void getExistingPromotionGroupMembs(){
    	for(Promotion_Group_Member__c member : [Select Id, Name, Promotion_Group__c, Promotion_Group__r.Name, End_of_Membership__c,
    												   Marketing_Material__c, Member_of_the_Group__c, Number_of_collected_Points__c,
    												   Number_of_credited_Points__c, Number_of_Total_Points__c, Registration__c, 
    												   Start_of_Membership__c, Telesales__c, Account__c
    											From   Promotion_Group_Member__c 
    											Where  Promotion_Group__c =: promotionGrp.Id
    											order by Name]) {
    		CustomPromotionMember customMember = new CustomPromotionMember(member, rowCounter);
    		list_proMember.add(customMember);
    		rowCounter ++;
    		
    	}
    }  
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
	public class CustomOption{
		public String selected {get;set;}
	  	public List<SelectOption> getNumberAddOptions(){ 
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('1', '1'));
			options.add(new SelectOption('2', '2'));
			options.add(new SelectOption('3', '3'));
			options.add(new SelectOption('5', '5'));
			options.add(new SelectOption('10', '10'));
			return options;        
		}
		public CustomOption(){
			this.selected = '1';
		}
	}	
	public class CustomPromotionMember {
		public Integer rowIndex {get; set;}
		public Promotion_Group_Member__c promotionMember {get; set;}
		
		public CustomPromotionMember(Promotion_Group_Member__c member, Integer counter) {
			this.rowIndex = counter;
			this.promotionMember = member;
		}
		
	}    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************	
}