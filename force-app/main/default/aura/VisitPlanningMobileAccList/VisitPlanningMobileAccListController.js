({
    init: function (component, event, helper) {
        component.set('v.accountArray', []);
        component.set("v.selectedAccountFieldListInPicklist",null );
        
        helper.handleCompanyName(component, helper);
        helper.handleUserInfo(component, helper);
        helper.getListViews(component, helper);
        helper.getCampaignList(component, helper);
        helper.getAccountZonalList(component, helper);
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
            });
        });
        //component.set("v.loaded",true);
    },
    listviewChange : function (component, event, helper)
    {
        /*
        * CDU add detection on listview: only 1 active, account or campaign
        */
        component.set("v.loaded", true);
        var lvId = component.get('v.listview');
        if(component.find("campaignSelect")!=null){
            if( lvId==null || lvId==''){
                component.find("campaignSelect").set("v.disabled", false); 
            } else {
                component.find("campaignSelect").set("v.disabled", true); 
            }
        }
        component.set('v.accountArray', null);
        if( lvId!=null && lvId!=''){
            helper.getAccounts(component, helper);
        }
        window.setTimeout($A.getCallback(function() {component.set("v.loaded", false);}), 5000);
    },
    handleToolbarMenuSelect: function(component, event, helper) {
        component.set("v.selectedAccountFieldListInPicklist",component.get("v.selectedAccountFieldList") );
    },
    search: function(component, event, helper){
        //CDU 10/06/2020: inactivated, requested by APAC
        //window.localStorage.setItem('campaignId', component.get('v.campaignId'));
        component.set("v.loaded", true);
        helper.getAccounts(component, helper);
        helper.saveSelectedAccountFieldList(component, helper);
        window.setTimeout($A.getCallback(function() {component.set("v.loaded", false);}), 5000);
    },
    loadMore: function(component, event, helper){
        component.set('v.loaded', true);
        var mobileListSize=component.get("v.mobileListSize");
        mobileListSize = mobileListSize +50;
        component.set("v.mobileListSize", mobileListSize);
        helper.getAccounts(component, helper);
        window.setTimeout($A.getCallback(function() {component.set("v.loaded", false);}), 5000);
        
    },
//    toggleSpin: function (component, event) {
//        //component.set('v.loaded', !component.get('v.loaded'));
//        component.set('v.loaded', true);
//        alert('spin on');
//        window.setTimeout(
//            $A.getCallback(function() {
//                component.set("v.loaded", false);
//            }), 5000);
//    }
})