({
    init: function (component, event, helper) {
        component.set('v.accountArray', []);
        component.set("v.selectedAccountFieldListInPicklist",null );
        
        helper.handleCompanyName(component, helper);
        helper.handleUserInfo(component, helper);
        helper.getListViews(component, helper);
        helper.getCampaignList(component, helper);
        helper.getAccountZonalList(component, helper);
        helper.getAccountTacticomHoyaList(component, helper);
        helper.getAccountTacticomSeikoList(component, helper);
        helper.getAccountFieldList(component, helper, function(err, result)
        {
            var accountFieldList = result;
            accountFieldList.sort(function(a,b) {
                return a.label < b.label ? -1 : 1;
            } );

            component.set("v.accountFieldList", accountFieldList);

            helper.getSelectedAccountFieldList(component, helper, function(err, result)
            {
                //console.log(result);
                component.set("v.selectedAccountFieldList", result);
                helper.handleFieldSelectionUpdate(component, helper);
                
        		var storeResponse = component.get("v.companyName");
                console.log('XXX Get user company name from controller = '+storeResponse);  //SSU Added 2021-08-17 need to know for user companyName
                if(storeResponse!='HLFR'){
                    //no account in initialization (only after search)
                	helper.getAccounts(component, helper);
                }
                if(storeResponse=='HOLM' || storeResponse=='THAI' ||storeResponse=='HLSH'
                || storeResponse=='SOC' || storeResponse=='HLID'|| storeResponse=='HLIN'
                || storeResponse=='HLHK' || storeResponse=='HOLK' || storeResponse=='HVC'
                || storeResponse=='HAPL' || storeResponse=='HLPH' || storeResponse=='ILENS')
                {
                    component.set('v.zonalDisplay', true);
                    component.set('v.tacticomDisplay', true);
                }
            });
        });
    },
    jsLoaded : function(component, event, helper)
    {
//
    },
    listviewChange : function (component, event, helper)
    {
        /*
        * CDU add detection on listview: only 1 active, account or campaign
        */
       var lvId = component.get('v.listview');
       if(component.find("campaignSelect")!=null){
        if( lvId==null|| lvId==''){
                component.find("campaignSelect").set("v.disabled", false); 
            } else {
                component.find("campaignSelect").set("v.disabled", true); 
        }
        }
        component.set('v.accountArray', null);
        helper.getAccounts(component, helper);
    },

    handleSelectedAccountFieldListChange: function(component, event, helper) {
        //var selectedAccountFieldList = event.getParam("value");
        helper.handleFieldSelectionUpdate(component, helper);
        helper.getAccounts(component, helper);
        helper.saveSelectedAccountFieldList(component, helper);
    },
    handleToolbarMenuSelect: function(component, event, helper) {
        component.set("v.selectedAccountFieldListInPicklist",component.get("v.selectedAccountFieldList") );
    },
    handleFieldSelectionDecision: function(component, event, helper) {
        if (event.getParam("result")=== 'Cancelled')
        {
            component.set("v.selectedAccountFieldListInPicklist",null );
        }
        else if (event.getParam("result")=== 'Saved')
        {
            component.set("v.selectedAccountFieldList",component.get("v.selectedAccountFieldListInPicklist") );
            component.set("v.selectedAccountFieldListInPicklist",null );
            helper.handleFieldSelectionUpdate(component, helper);
            helper.getAccounts(component, helper);
            helper.saveSelectedAccountFieldList(component, helper);
        }
    },
    search: function(component, event, helper){
        window.localStorage.setItem('campaignId', component.get('v.campaignId'));
        helper.getAccounts(component, helper);
        helper.saveSelectedAccountFieldList(component, helper);
    },
    monitorinput: function(component, event, helper){
        if(event.which==13){
            helper.getAccounts(component, helper);
        	helper.saveSelectedAccountFieldList(component, helper);
        }
    }
})