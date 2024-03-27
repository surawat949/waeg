/**
 * Created by thomas.schnocklake on 23.01.18.
 */
({

    getAccounts: function(component, helper){
        var action = component.get("c.getAccounts");
        action.setParam('listViewId',component.get("v.listview"));
        var fields = component.get("v.accountColumns");

        action.setParam('fields',fields.map(function(field) {return field.fieldName}));
        var filter = component.get("v.quickFilter");
        action.setParam('filter',filter);
        
        var targetList = component.get('v.targetList');
        action.setParam('campaignId', component.get("v.campaignId"));
        action.setParam('campaignPriority', component.get('v.campaignPriority'));
        action.setParam('campaignPresented', component.get('v.campaignPresented'));
        action.setParam('device', 'webbrowser');
        action.setParam('mobileListSize', 0);//not used in web browser mode
        action.setParam('zonal', component.get('v.zonal'));
        action.setParam('tacticom', component.get('v.tacticom'));
        action.setParam('tacticomSeiko', component.get('v.tacticomseiko'));
        action.setParam('targetList', targetList);
        //alert('targetList=' + targetList);

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var accounts = response.getReturnValue();
                if (accounts.length == 10000)
                {
                    var tooManyRecordsExceptionLabel =  $A.get("$Label.c.TooManyRecordsException");
                    alert(tooManyRecordsExceptionLabel);
                }
                component.set('v.accountArray', accounts);
                //console.log(accounts);

            }
            else
            {
                //if (typeof response.getError()[0] && response.getError()[0].message === "auth")
                //{
					var url;
					if (response.getError()[0].message.indexOf('auth') == 0)
                    {
                    	url = "/0XU/e"
                    }
                    else if (response.getError()[0].message.indexOf('0XU') == 0)
                    {
                        url = "/" + response.getError()[0].message + "/e";
                    }
                	if (url)
                    {
                        var missingAuthException =  $A.get("$Label.c.MissingAuthException");
                        alert(missingAuthException);

                        var urlEvent = $A.get("e.force:navigateToURL");
                        if (urlEvent)
                        {
                            urlEvent.setParams({
                              "url": url
                            });
                            urlEvent.fire();
                        }
                        else
                        {
                            location.href = url;
                        }
                    }
                	else
                    {
                        alert('ERROR: ' + response.getError()[0].message);
                    }
                //}
            }
        });
        $A.enqueueAction(action);
    },
    getSelectedAccountFieldList: function(component, helper, callback){
        var action = component.get("c.getSelectedAccountFieldList");

        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    saveSelectedAccountFieldList: function(component, helper){
        var action = component.get("c.saveSelectedAccountFieldList");
        action.setParam('selectedAccountFieldList',component.get("v.selectedAccountFieldList"));

        action.setCallback(this, function(response){
            //console.log(response);
        });
        $A.enqueueAction(action);
    },
    getAccountFieldList: function(component, helper, callback){
        var action = component.get("c.getAccountFieldList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                callback(null, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getListViews: function(component, helper){
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = [{}].concat(response.getReturnValue());

                component.set('v.listviews', listviews);
            }
        });
        $A.enqueueAction(action);
    },
    getCampaignList: function(component, helper){
        var action = component.get("c.getCampaignList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var campaignList = [{}].concat(response.getReturnValue());

                component.set('v.campaignList', campaignList);
            }
        });
        $A.enqueueAction(action);
    },
    getAccountZonalList: function(component, helper){
        var action = component.get("c.getAccountZonalList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountZonalList = [{}].concat(response.getReturnValue());

                component.set('v.accountZonalList', accountZonalList);
            }
        });
        $A.enqueueAction(action);

    },

    handleFieldSelectionUpdate: function(component, helper){
        var selectedAccountFieldList = component.get("v.selectedAccountFieldList")
        var accountFieldList = component.get("v.accountFieldList");
        var accountColumns = [];

        var accountFieldMap = {};
        accountFieldList.forEach(
            function(accountField)
            {
                accountFieldMap[accountField.fieldName] =
                    {
                        label: accountField.label,
                        fieldName: accountField.fieldName,
                        type: accountField.type
                    }
                ;
                //console.log(accountFieldMap);
            }
        );
        accountColumns = selectedAccountFieldList.map(function(n)
        {
            return  accountFieldMap[n];
        });

        component.set("v.accountColumns", accountColumns);
    },
    handleCompanyName: function(component, helper){
        
        var action = component.get("c.getCompanyName");
        var storeResponse ='';
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                storeResponse = response.getReturnValue();
                component.set("v.companyName", storeResponse);
                if(storeResponse=='HOLA' ||storeResponse=='HLCA' ||storeResponse=='VEUS' ||storeResponse=='SRX'){
                    component.set('v.isHVNA', true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleUserInfo: function(component, helper){
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },

    getAccountTacticomHoyaList: function(component, helper){
        //add for account tacticom list in vpm module

        var action = component.get("c.getAccountTacticomHoyaList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){

                var accountTacticomList = [{}].concat(response.getReturnValue());
                
                component.set("v.accountTacticomHoyaList", accountTacticomList);
            }
        
        });
        $A.enqueueAction(action);
    },
    getAccountTacticomSeikoList: function(component, helper){
        //add for account tacticom list in vpm module

        var action = component.get("c.getAccountTacticomSeikoList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){

                var accountTacticomList = [{}].concat(response.getReturnValue());
                
                component.set("v.accountTacticomSeikoList", accountTacticomList);
            }
        
        });
        $A.enqueueAction(action);
    }
})