/**
*  This test class is for ExtContentWorkspace.
*
@author Yuda Zheng
@created 2013-09-03
@version 1.0
@since 27.0 
*
@changelog
* 2013-09-03 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
* - Test coverage 96%
*/
@isTest(SeeAllData=true)
private class ExtContentWorkspace_Test {
    static testMethod void myUnitTest() {
        List<User> list_user = [Select Id From User Where Name = 'Pim Uijttewaal' and isActive=true];
        if(list_user.size() > 0){
            System.runAs(list_user[0]){
                Set<Id> set_ids = new Set<Id>();
                for (Campaign c : [select Content_Workspace_Id__c from Campaign]) {
                    set_ids.add(c.Content_Workspace_Id__c);
                }
                
                List<ContentWorkspace> list_cw = [select Id,Name From ContentWorkspace where Id not in: set_ids limit 1];
                String workspaceId;
                
                if(list_cw != null && list_cw.size() > 0){
                    workspaceId = list_cw.get(0).Id;
                }
                else{
                    return;
                }
                
                ContentVersion coverContentInsert = new ContentVersion(); 
                coverContentInsert.Title = 'cover';
                coverContentInsert.ContentURL='http://www.google.com/'; 
                insert coverContentInsert;
                
                ContentVersion coverContent = [SELECT ContentDocumentId FROM ContentVersion where Id = :coverContentInsert.Id]; 
                ContentWorkspaceDoc coverWorkspaceDoc = new ContentWorkspaceDoc(); 
                coverWorkspaceDoc.ContentWorkspaceId = workspaceId; 
                coverWorkspaceDoc.ContentDocumentId = coverContent.ContentDocumentId; 
                insert coverWorkspaceDoc; 
                
                ContentVersion backgroundContentInsert = new ContentVersion(); 
                backgroundContentInsert.Title = 'background';
                backgroundContentInsert.ContentURL='http://www.google.com/'; 
                insert backgroundContentInsert;
                
                ContentVersion backgroundContent = [SELECT ContentDocumentId FROM ContentVersion where Id = :backgroundContentInsert.Id]; 
                ContentWorkspaceDoc backgroundWorkspaceDoc = new ContentWorkspaceDoc(); 
                backgroundWorkspaceDoc.ContentWorkspaceId = workspaceId; 
                backgroundWorkspaceDoc.ContentDocumentId = backgroundContent.ContentDocumentId; 
                insert backgroundWorkspaceDoc; 
                
                Campaign campaign = new Campaign();
                campaign.Name = 'testCampaign';
                campaign.CurrencyIsoCode = 'EUR';
                campaign.Content_Workspace_Id__c = workspaceId;
                campaign.Campaign_Description__c = 'Test Description';
                campaign.Cover_Flow_Picture_ID__c = coverContent.ContentDocumentId;
                campaign.Background_Picture_ID__c  = backgroundContent.ContentDocumentId;
                insert campaign;
                
                ApexPages.currentPage().getParameters().put('mode','view');
                
                ApexPages.StandardController sc = new ApexPages.StandardController(campaign);
                ExtContentWorkspace ect = new ExtContentWorkspace(sc);
                Test.startTest();
                ect.contentdocumentOption();
                ect.list_ContentWorkspaceDoc();
                ect.refreshContentDocOptions();
                //ect.workspaceAndDocumentNames();
                ect.workspaceOption();      
                ect.edit();
                ect.cancel();
                ect.save();
                Test.stopTest();
            }
            
        }
    }
}