public with sharing class GARequestWrapper {
    public GARequestWrapper(User userRec, String event, String solution) {
        this.client_id = '1234';
        this.user_id = userRec.contactId;
        Long micros =  Datetime.now().getTime() * 1000;
        this.timestamp_micros = String.valueOf(micros);
        this.non_personalized_ads = false;
        cls_params paramObj = new cls_params();
		paramObj.Solution = solution;
		paramObj.contactId = userRec.contactId;
		paramObj.primary_account_salesforce_id = userRec.contact.accountId;
		paramObj.account_salesforce_id = userRec.contact.accountId;
		paramObj.account_hoya_number = userRec.contact.Hoya_Account_Id__c;
		paramObj.portal_id = userRec.contact.Account_Portal__c;
		paramObj.brand = userRec.contact.Account.Brand__c;
		paramObj.market = userRec.contact.Account.Language__c;
        cls_events eventObj = new cls_events();
        eventObj.name = event;
        eventObj.params = paramObj;
        this.events.add(eventObj);
    }

	public GARequestWrapper(Contact conRec, String event, String solution) {
        this.client_id = '1234';
        this.user_id = conRec.Id;
        Long micros =  Datetime.now().getTime() * 1000;
        this.timestamp_micros = String.valueOf(micros);
        this.non_personalized_ads = false;
        cls_params paramObj = new cls_params();
		paramObj.Solution = solution;
		paramObj.contactId = conRec.Id;
		paramObj.primary_account_salesforce_id = conRec.accountId;
		paramObj.account_salesforce_id = conRec.accountId;
		paramObj.account_hoya_number = conRec.Hoya_Account_Id__c;
		paramObj.portal_id = conRec.Account_Portal__c;
		paramObj.brand = conRec.Account.Brand__c;
		paramObj.market = conRec.Account.Language__c;
        cls_events eventObj = new cls_events();
        eventObj.name = event;
        eventObj.params = paramObj;
        this.events.add(eventObj);
    }
    
    public String client_id;	
	public String user_id;
    public String timestamp_micros;	//1672127615272000
	public boolean non_personalized_ads;
	public List<cls_events> events = new List<cls_events>();
	class cls_events {
		public String name;
		public cls_params params;
	}
	class cls_params {
		public string solution;
		public String contactId;
		public String primary_account_salesforce_id;
		public String account_salesforce_id;
		public String account_hoya_number;
		public String portal_id;
		public String brand;
		public String market;
	}
}