/**
*   This class is to set Content WorkSpace, Cover Flow Picture and Background Picture
*
@author Jian Yin
@created 2013-08-07
@version 1.0
@since 24.0 (Force.com ApiVersion)
*
@changelog
* 2013-08-07 Jian Yin <jian.yin@itbconsult.com>
* - Created
*/
public with sharing class ExtContentWorkspace {
    
    public Campaign campaign{get;set;}
    public Campaign cam{get;set;}
    
    public String workspaceId{get;set;}
    public String coverflowpictureId{get;set;}
    public String backgroundpictureId{get;set;}
    public String urlSchemeLinkId{get;set;}
    public String workspaceName{get;private set;}
    public String coverflowpictureTitle{get;private set;}
    public String backgroundpictureTitle{get;private set;}
    public String urlSchemeLinkTitle{get;private set;}
    
    public String mode{get;set;}
    
    public List<ContentWorkspace> list_contentworkspace{get;private set;}
    public List<ContentDocument> list_contentdocument{get;private set;}
    public Set<String> set_contentdocumentId{get;private set;}
    public List<Selectoption> list_workspaceOptions{get;private set;}
    public List<Selectoption> list_contentdocumentOptions{get;private set;}
    
    
    public ExtContentWorkspace(ApexPages.StandardController stdController){
        
        campaign = (Campaign)stdController.getRecord();
        mode = 'view';
        workspaceId = '';
        coverflowpictureTitle = '';
        backgroundpictureTitle = '';
        
        String value = ApexPages.currentPage().getParameters().get('mode');
        if(value != null )
            mode = value;
        
        /* already has contentworkspace */
        cam = [SELECT Id, Name, Description, Content_Workspace_Id__c, Cover_Flow_Picture_ID__c, Background_Picture_ID__c, URL_Scheme_Link__c From Campaign WHERE Id =: campaign.Id];
        workspaceId = cam.Content_Workspace_Id__c;
        ContentWorkspace cw = new ContentWorkspace();
        List<ContentWorkspace> cw_list = [SELECT Id, Name FROM ContentWorkspace WHERE Id =: workspaceId limit 1];
        // workspace exists
        if(cw_list.size()>0 ){
            cw = cw_list.get(0);
            workspaceName = cw.Name;
            if(cam.Cover_Flow_Picture_ID__c != null){
                ContentDocument cd1 = new ContentDocument();
                List<ContentDocument> list_cd1 = [SELECT Id, Title FROM ContentDocument WHERE Id =: cam.Cover_Flow_Picture_ID__c limit 1]; 
                if(list_cd1.size() > 0){
                    cd1 = list_cd1.get(0);
                    coverflowpictureTitle = cd1.Title;
                    coverflowpictureId = cd1.Id;
                }
            }
            if(cam.Background_Picture_ID__c != null){
                ContentDocument cd2 = new ContentDocument();
                List<ContentDocument> list_cd2 = [SELECT Id, Title FROM ContentDocument WHERE Id =: cam.Background_Picture_ID__c limit 1];
                if(list_cd2.size() > 0){
                    cd2 = list_cd2.get(0);
                    backgroundpictureTitle = cd2.Title;
                    backgroundpictureId = cd2.Id;
                }
            }
            if(cam.URL_Scheme_Link__c != null){
                ContentDocument cd3 = new ContentDocument();
                List<ContentDocument> list_cd3 = [SELECT Id, Title FROM ContentDocument WHERE Id =: cam.URL_Scheme_Link__c limit 1];
                if(list_cd3.size() > 0){
                    cd3 = list_cd3.get(0);
                    urlSchemeLinkTitle = cd3.Title;
                    urlSchemeLinkId = cd3.Id;
                }
                else{
                    urlSchemeLinkTitle = '';
                    urlSchemeLinkId = '';
                }
            }
        }
        // workspace doesn't exists
        else{
            workspaceId = [SELECT Id, Name From ContentWorkspace limit 1].Id;
        }
        System.debug(workspaceId);

        //workspaceId = '058J00000004JCNIA2';
        workspaceOption();
        refreshContentDocOptions();
    }
    
    
    // create workspace select options to show on page
    public void workspaceOption(){
        
        list_contentworkspace = new List<ContentWorkspace>();
        list_contentworkspace = [SELECT Id, Name FROM ContentWorkspace];
        
        list_workspaceOptions = new List<Selectoption>();
        for(ContentWorkspace cw : list_contentworkspace){
            Selectoption so = new Selectoption(cw.Id, cw.Name);
            list_workspaceOptions.add(so);
        }
    }
    
    // get ContentDocumentIds 
    public void list_ContentWorkspaceDoc(){
        set_contentdocumentId = new Set<String>();
        for(ContentWorkspaceDoc cwd : [SELECT ContentDocumentId, ContentWorkspaceId FROM ContentWorkspaceDoc WHERE ContentWorkspaceId = :workspaceId]){
            if(!set_contentdocumentId.contains(cwd.ContentDocumentId)){
                set_contentdocumentId.add(cwd.ContentDocumentId);
            }
        }
    }
    
    
    // create content document select options to show on page
    public void contentdocumentOption(){
        
        list_contentdocument = new List<ContentDocument>();
        list_contentdocument = [SELECT Id, Title FROM ContentDocument WHERE Id IN :set_contentdocumentId ];
        
        list_contentdocumentOptions = new List<Selectoption>();
        Selectoption nso = new Selectoption('', '--None--');
        list_contentdocumentOptions.add(nso);
        for(ContentDocument cd : list_contentdocument){
            Selectoption so = new Selectoption(cd.Id, cd.Title);
            list_contentdocumentOptions.add(so);
        }
    }
    
    public void refreshContentDocOptions(){
        list_ContentWorkspaceDoc();
        contentdocumentOption();
    }
    
    // get workspace name and document titles
    public void workspaceAndDocumentNames(){
        workspaceName = [SELECT Id, Name FROM ContentWorkspace WHERE Id =: workspaceId].Name;
        coverflowpictureTitle = (coverflowpictureId != '' && coverflowpictureId != null)? [SELECT Id, Title FROM ContentDocument WHERE Id =: coverflowpictureId].Title : '';
        backgroundpictureTitle = (backgroundpictureId != '' && backgroundpictureId != null)? [SELECT Id, Title FROM ContentDocument WHERE Id =: backgroundpictureId].Title : '';
        system.debug('urlSchemeLinkId:'+urlSchemeLinkId);
        urlSchemeLinkTitle = (urlSchemeLinkId != '' && urlSchemeLinkId != null && urlSchemeLinkId != 'None')? [SELECT Id, Title FROM ContentDocument WHERE Id =: urlSchemeLinkId].Title : '';
    }
    
    public void edit(){
        mode = 'edit';
    }
    public Pagereference cancel(){
        mode = 'view';
        PageReference page = new PageReference('/apex/ExtContentWorkspace?id=' + campaign.Id + '&mode=' + mode);
        page.setRedirect(true);
        return page;
    }
    
    public void save(){
        List<Campaign> list_campaign = [SELECT Id, Content_Workspace_Id__c FROM Campaign WHERE Content_Workspace_Id__c =: workspaceId];
        Map<Id,Campaign> map_campaignId = new Map<Id,Campaign>();
        for(Campaign c : list_campaign){
            map_campaignId.put(c.Id,c);
        }
        if(list_campaign.size() > 0 && !map_campaignId.containsKey(cam.Id)){
            mode = 'edit';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'THE CONTENT WORKSPACE IS ALREADY SELECTED BY OTHER CAMPAIGN !!!'));
        }else{
            cam.Content_Workspace_Id__c = workspaceId;
            cam.Cover_Flow_Picture_ID__c = coverflowpictureId;
            cam.Background_Picture_ID__c = backgroundpictureId;
            cam.URL_Scheme_Link__c = urlSchemeLinkId;
            workspaceAndDocumentNames();
            update cam;
            mode = 'view';
        }
        /*
        PageReference page = new PageReference('/apex/ExtContentWorkspace?id=' + campaign.Id + '&mode=' + mode);
        page.setRedirect(true);
        return page;
        */
    }
    public void saveCampaign(){
        system.debug(' in saveCampaign ---');
        List<Campaign> list_campaign = [SELECT Id, Content_Workspace_Id__c FROM Campaign WHERE Content_Workspace_Id__c =: workspaceId];
        Map<Id,Campaign> map_campaignId = new Map<Id,Campaign>();
        for(Campaign c : list_campaign){
            map_campaignId.put(c.Id,c);
        }
        if(list_campaign.size() > 0 && !map_campaignId.containsKey(cam.Id)){
            mode = 'edit';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'THE CONTENT WORKSPACE IS ALREADY SELECTED BY OTHER CAMPAIGN !!!'));
        }else{
            cam.Content_Workspace_Id__c = workspaceId;
            cam.Cover_Flow_Picture_ID__c = coverflowpictureId;
            cam.Background_Picture_ID__c = backgroundpictureId;
            cam.URL_Scheme_Link__c = urlSchemeLinkId;
            workspaceAndDocumentNames();
            update cam;
            mode = 'view';
        }
    }
}