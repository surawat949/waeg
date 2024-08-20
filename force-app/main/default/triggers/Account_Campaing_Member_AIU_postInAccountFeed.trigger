/**
 *  Trigger to post chatter feed in Account
 * 
 * @author Haobo Song
 * @created 2013-08-12
 * @version 1.0
 * @since 27.0
 * 
 * 
 *
 * @changelog
 * 2013-08-12 Chu Zhang <chu.zhang@itbconsult.com>
 * - Created   
 *
 */
trigger Account_Campaing_Member_AIU_postInAccountFeed on Account_Campaing_Member__c (after insert, after update) {
	//************************* BEGIN Pre-Processing **********************************************
	if(TriggerRecursionDefense.set_Account_Campaing_Member_AIU_postInAccountFeed == null) TriggerRecursionDefense.set_Account_Campaing_Member_AIU_postInAccountFeed = new set<id>();
	//List<FeedItem> feedItems = new List<FeedItem>(); 
	set<id> set_id = new set<id>(); 
	set<id> set_createdById = new set<id>(); 
	string baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
	//************************* END Pre-Processing ************************************************ 
	
	//************************* BEGIN Before Trigger **********************************************
	
	//************************* END Before Trigger ************************************************
	
	//************************* BEGIN After Trigger ***********************************************
	
	for (Account_Campaing_Member__c acm : Trigger.new) {
		if(!TriggerRecursionDefense.set_Account_Campaing_Member_AIU_postInAccountFeed.contains(acm.id) && 
		   (trigger.isInsert || trigger.isUpdate)) { 
	        set_id.add(acm.Id);
	        set_createdById.add(acm.createdById);
	        TriggerRecursionDefense.set_Account_Campaing_Member_AIU_postInAccountFeed.add(acm.id);
		}
	}
	//Save the FeedItems all at once.
	if(set_id.size() > 0){
		map<id, user> map_id_user = new map<id, user>([select id, name from user where id in: set_createdById]);
		system.debug(map_id_user+'+++++'+set_createdById+'----'+set_id);

		//begin: added by yinfeng.guo 2013-10-24
		set<id> set_accIds = new set<id>();
		set<id> set_campaignIds = new set<id>();
		for (Account_Campaing_Member__c acm : Trigger.new) { 
			if(acm.Account_Name__c != null) set_accIds.add(acm.Account_Name__c);
			if(acm.Central_Campaign__c != null) set_campaignIds.add(acm.Central_Campaign__c);
		}

		map<id, account> map_id_accounts = new map<id, account>([Select Id, Name From Account Where Id in: set_accIds]);
		map<id, Campaign> map_id_campaigns = new map<id, Campaign>([Select Id, Name From Campaign Where Id in: set_campaignIds]);
		//end: added by yinfeng.guo 2013-10-24

		//begin: added by yinfeng.guo 2013-10-24
		List<FeedItem> list_Feeds = new List<FeedItem>();
		//end: added by yinfeng.guo 2013-10-24

		for (Account_Campaing_Member__c acm : Trigger.new) { 
			if(set_id.contains(acm.Id)) {
				/* comment out by yinfeng.guo 2013-10-24
				List<Account> list_acc = [Select Id, Name From Account Where Id =: acm.Account_Name__c limit 1];
				
				List<Campaign> list_campaign = [Select Id, Name From Campaign Where Id =: acm.Central_Campaign__c limit 1];
				

		        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
				ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
				ConnectApi.TextSegmentInput textSegment;
				ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
				
				messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
				
				textSegment = new ConnectApi.TextSegmentInput();
				textSegment.text = 'Your Account (' + list_acc.get(0).Name +') has been selected for the Campaign (' + list_campaign[0].Name + ') - ' + map_id_user.get(acm.createdById).name + ' ';
				

				messageInput.messageSegments.add(textSegment);
				
				mentionSegment.id = map_id_user.get(acm.createdById).Id;
				messageInput.messageSegments.add(mentionSegment);
				*/
				/*
				textSegment = new ConnectApi.TextSegmentInput();
				textSegment.text = '. How are you?';
				messageInput.messageSegments.add(textSegment);
				*/
				/* comment out by yinfeng.guo 2013-10-24
				input.body = messageInput;
				
				ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, 'me', input, null);
				*/


				//begin: added by yinfeng.guo 2013-10-24
				Account a = map_id_accounts.get(acm.Account_Name__c);
				Campaign c = map_id_campaigns.get(acm.Central_Campaign__c);
				FeedItem nf = new FeedItem();
                nf.ParentId = acm.createdById;             
                nf.Type = 'LinkPost';
                nf.Title = 'Account: ' + a.Name;
                String body = 'Your Account (' + a.Name +') has been selected for the Campaign (' + c.Name + ') - ' + map_id_user.get(acm.createdById).name + ' ';
                nf.Body = body;
                nf.LinkUrl = '/' + a.Id;
				list_Feeds.add(nf);
				//end: added by yinfeng.guo 2013-10-24
			}
		}
		//begin: added by yinfeng.guo 2013-10-24
		if (!list_Feeds.isEmpty()) insert list_Feeds;
		//end: added by yinfeng.guo 2013-10-24

		//notice the false value. This will allow some to fail if Chatter isn't available on that object
		//Database.insert(feedItems,false); 
	}
	
	//************************* END After Trigger *************************************************
}