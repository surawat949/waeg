({
    doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        var visitId = pageReference.state.c__visitId;
        var accountId = pageReference.state.c__accountId;
        console.log('Account id is '+accountId);
        component.set('v.displaySection', 'section2');

        helper.getVisit(component,visitId, function(visitFetched)
        {
            component.set('v.visit',visitFetched);
            component.set('v.opportunityId', visitFetched.Opportunity__c);
            helper.getUserCompany(component, visitFetched, function(err, companyName){
                component.set('v.companyName', companyName);
                if(companyName=='HOLA' ||companyName=='HLCA' ||companyName=='VEUS' ||companyName=='SRX'){
                    component.set('v.isHVNA', true);
                }
                component.set('v.specificMkgSection', companyName=='HLHK' || companyName=='HOLK' || companyName=='SOC' || companyName=='HLSH' || companyName=='HLSI');
                if(companyName=='HAPL' || companyName=='HLHK' || companyName=='HOLK' || companyName=='ILENS' || companyName=='HOLM'|| companyName=='THAI'|| companyName=='HLSI'|| companyName=='HLSH'
                || companyName=='SOC'|| companyName=='HLID'
                || companyName=='HOLA' || companyName=='HLCA' || companyName=='VEUS' ){
                    component.set('v.displayStartStop',false);
                }
                if(companyName=='HLIB' || companyName=='HVC' || companyName=='HLIN' || companyName=='HOTA' || companyName=='HLPH'){
                    component.set('v.displayStartStop',true);
                    
                    if(navigator.geoLocation){
                        console.log("capability is there");
                    }else{
                        console.log("No Capability");
                    }
                    navigator.geolocation.getCurrentPosition(function(position) {
                        var latit = position.coords.latitude;
                        var longit = position.coords.longitude;
                        component.set("v.latitude",latit);
                        component.set("v.longitude",longit);
                        console.log("The Latitude is:"+ latit);
                        console.log("The Latitude is:" +longit);
                        //alert(typeof latit);
                    });  
                }

            });
 

            helper.getUserProfile(component, visitFetched, function(err, profileName){
                component.set('v.profileName', profileName);
            });
            /*
            helper.getUserName(component, visitFetched, function(err, usename){
                console.log('User name is '+JSON.stringify(usename));
                component.set('v.usename', usename);
    
                if((usename=='Yung Chan' && visit.Visit_Status__c=='Complete') || (usename=='Surawat Sakulmontreechai' && visit.Visit_Status__c=='Complete') || (usename == 'Rik Westerbeek' && visit.Visit_Status__c=='Complete')){
                    component.set('v.displaySection', 'section1');
                }
            });
            */
            helper.getAccount(component, visitFetched.Account__c, function(err, account){
                console.log('VisitFetch__Account = '+visitFetched.Account__c);
                component.set('v.account', account);
            });
            /*
            helper.getOpportunityByAccount(component, visitFetched.Account__c, function(err, options){
                component.set('v.opportunityList', options);
                if(options.length>1){
                    if(visitFetched.Id == null || visitFetched.Id == '' || visitFetched.Id == 'undefined'){
                        component.set('v.visitFetch.Opportunity__c', options[1].value);
                    }else{
                        //do nothing
                    }
                }
            });
            */
            helper.getOpportunityByAccount(component, visitFetched.Account__c, function(err, options){
                if(options.length>1){
                    component.set('v.hasOpportunity', true);
                    if(visitFetched.Id==null||visitFetched.Id==''||visitFetched.Id=='undefined'){
                        component.set('v.visitFetched.Opportunity__c', options[1].value);
                    }
                }else{
                    component.set('v.hasOpportunity', false);
                }
            });
            helper.getAccountCampaignMember(component, visitFetched.Account__c, function(err, result){
                component.set('v.ListCampaignMember', result);
            });
            helper.getUserRegion(component, visitFetched, function(err, result){
                component.set('v.regionname', result);
                console.log('XXX Get Region Name = '+JSON.stringify(result));
            });
           
        });
        if(accountId!=null){
            helper.getAccount(component, accountId, function(err, account){
                component.set('v.account', account);
            });
        }
        var visit = null;
        if(visitId==null || visitId==''){
            //initialize a new visit
            visit = {};
            visit.sobjectType = 'Visits__c';
            visit.Account__c = accountId;
            //visit.Account__r = {
            //    sobjectType : 'Account',
            //    Id: accountId,
            //    Name: account.name,
            //};
            //debugger;
            var date = new Date();
            visit.Start_Time__c = date.toJSON();
            visit.End_Time__c = new Date(date.getTime()+60*60000).toJSON();
            visit.Call_To_Action_Notes__c = null;
            visit.Visit_Reason__c = null;
            visit.Visit_Reason_APAC__c = null;
            visit.Call_To_Action__c = null;

            console.log(visit.Start_Time__c);
            console.log(visit.End_Time__c);
    
            var user = $A.get("$SObjectType.CurrentUser");
    
            visit.Assigned_to__c = user.Id;
            visit.Visit_Notes__c = null;
            visit.Visit_Type__c = null;
            visit.Visit_assigned_to__c = user.Name;
    
            component.set('v.visit', visit);
            helper.getUserCompany(component, visit, function(err, companyName){
                component.set('v.companyName', companyName);
                console.log('Company Name is '+JSON.stringify(companyName));
                component.set('v.specificMkgSection', companyName=='HLHK' || companyName=='HOLK' || companyName=='SOC' || companyName=='HLSH' || companyName=='HLSI');
                if(companyName=='HOLA' || companyName=='HLCA' || companyName=='VEUS'){
                    component.set('v.isHVNA',true);
                }
            });
            //component.set("v.isdisabled", visit.Visit_Status__c === 'Complete');
            
            helper.getUserProfile(component, visit, function(err, profileName){
                component.set('v.profileName', profileName);
            });
            
            helper.getUserRegion(component, visit, function(err, regionName){
                console.log('Region Name is === >'+JSON.stringify(regionName));
                component.set('v.regionname', regionName);
            });
            
            helper.getAccountCampaignMember(component, visit.Account__c, function(err, result){
                component.set('v.ListCampaignMember', result);
            });
            helper.getOpportunityByAccount(component, visit.Account__c, function(err, options){
                if(options.length>1){
                    component.set('v.hasOpportunity', true);
                    visit.Opportunity__c = options[1].value;
                    component.set('v.opportunityId', visit.Opportunity__c);
                    //if(visitFetched.Id==null||visitFetched.Id==''||visitFetched.Id=='undefined'){
                    //    component.set('v.visitFetched.Opportunity__c', options[1].value);
                    //}
                }else{
                    component.set('v.hasOpportunity', false);
                }
            });
        }
        if(accountId!=null && accountId!=''){
            helper.getAccount(component, accountId, function(err, account){
                component.set('v.account', account);
                var v = component.get('v.visit');
                v.Account__c = accountId;
                v.Account__r = {
                        sobjectType : 'Account',
                        Id: accountId,
                        Name: account.name,
                        Hoya_Account_ID__c: account.Hoya_Account_ID__c
                    };
                component.set('v.visit', v);
            });
        }
         
        
    },
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    handleStartDateTimeChange: function(cmp, event, helper){
        //need to add from start date/time = 1hrs when user select start date/time by themselves.
        var visit = null;
        visit.sobjectType = 'Visits__c';
        var date = visit.Start_Time__c.toJSON();
        visit.End_Time__c = new Date(date.getTime()+60*30000).toJSON();
        console.log(visit.End_Time__c);
        alert(visit.End_Time__c);

    },
    backToVPM: function(cmp, event, helper) {
        console.log('I am getting called 999');
        
        // redirect to visitPlanningVisitEditMobile cmp
        var navService = cmp.find("navService");
        var pageReference = {
            
            "type": "standard__component",
            "attributes": {
                "componentName": "c__VisitPlanningMobile"    
            },    
            "state": {
            }
        };
        cmp.set("v.pageReference", pageReference);
        var defaultUrl = "#";

        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            cmp.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));
        event.preventDefault();
        navService.navigate(pageReference);
    },
    handleLoad : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");    
        
    },
    handleSuccess: function(component, event, helper) {
     
        // Show toast
        $A.util.addClass(component.find("spinner"), "slds-hide"); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Visit updated with success",
        });
        toastEvent.fire();
        
        //var refresh = $A.get("e.force:refreshView");  //commented by mohan , this will avlid navigation so we have commented
       // refresh.fire();   //commented by mohan
        
         //new code-Mohan start
        // redirect to visitPlanningVisitEditMobile cmp
        //Added timeout just to give delay between toast message and navigation
       window.setTimeout(
       $A.getCallback(function() {
       var navService = component.find("navService");
        var pageReference = {
            
            "type": "standard__component",
            "attributes": {
                "componentName": "c__VisitPlanningMobile"    
            },    
            "state": {
            }
        };
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";

        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            component.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            component.set("v.url", defaultUrl);
        }));
        event.preventDefault();
        navService.navigate(pageReference);
           
    }), 2000
);
        
   //New Code- Mohan end
             
    },
    startVisit: function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-show");

        event.preventDefault();
        var d = new Date();
        var dm = new Date(d.getTime()-5*60000).toJSON();
        var company = component.get('v.companyName');
        console.log('User Company for Start/Stop '+company);

        //var dateTimeNow = $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDThh:mm:ssZ");
        var dateTimeNow = new Date().toISOString();
        console.log('start date time is '+dateTimeNow);
        var latitude = component.get("v.latitude");
        var longitude = component.get("v.longitude");

        var startPlan = component.find("StartTime").get("v.value");
        //var endPlan = component.find("StopTime").get("v.value");
        console.log('Start Plan is '+startPlan);

        try{
            component.find("vstartLat").set("v.value", latitude.toFixed(10));
            component.find("vstartLong").set("v.value", longitude.toFixed(10));
            component.find("vstarttime").set("v.value", dateTimeNow);
            component.find("original_start_plan").set("v.value", startPlan);
            //component.find("original_end_plan").set("v.value", endPlan);
            
            if(company=='HLPH' || company == 'HLIN' || company=='HAPL' || company=='HOLK' || company=='HOLM' || company=='ILENS' || company=='THAI' || company=='HLSI' || company=='HLSH' || company=='SOC' || company=='HLID' || company=='HOTA' || company=='HLHK'){
                component.find("StartTime").set("v.value", dateTimeNow);
                component.find("StopTime").set("v.value", dateTimeNow);
            }else{
                //return nothing;
            }
            
            component.find('visitEditForm').submit();
            //$A.get('e.force:refreshView').fire();
        }catch (error) {
  			alert(error);
            $A.util.addClass(component.find("spinner"), "slds-hide"); 
        }
    },
    stopVisit: function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-show"); 

        event.preventDefault();
        var d = new Date();
        var dm = new Date(d.getTime()-1*30000).toJSON();
        var company = component.get("v.companyName");
        
        //var dateTimeNow = $A.localizationService.formatDateTime(new Date(), "YYYY-MM-DDThh:mm:ssZ");
        var dateTimeNow = new Date().toISOString();
        console.log('stop date time is '+dateTimeNow);

        var latitude = component.get("v.latitude");
        var longitude = component.get("v.longitude");
        //var endPlan = component.find("StopTime").get("v.value");
        //console.log('Stop time is '+endPlan);
        try{
            component.find("vstopLat").set("v.value", latitude.toFixed(10));
            component.find("vstopLong").set("v.value", longitude.toFixed(10));
            component.find("vstoptime").set("v.value", dateTimeNow);

            //component.find("original_end_plan").set("v.value", endPlan);

            
            if(company=='HLPH' || company == 'HLIN' || company=='HAPL' || company=='HOLK' || company=='HOLM' || company=='ILENS' || company=='THAI' || company=='HLSI' || company=='HLSH' || company=='SOC' || company=='HLID' || company=='HOTA' || company=='HLHK'){
                component.find("StopTime").set("v.value", dateTimeNow);
            }else{
                //return nothing;
            }
            
            component.find("vstatus").set("v.value", "Complete");
            component.find('visitEditForm').submit();
            //$A.get('e.force:refreshView').fire();
        }catch (error) {
  			alert(error);
            $A.util.addClass(component.find("spinner"), "slds-hide"); 
        }
    },
    handleOpportunityChange: function(component, event, helper){
        // update opportunity form
        var value = event.getSource().get("v.value");
        console.log('Value is '+value);
        if(value!=null && value.toString()!='' && value.toString()!='undefined'){
            component.set('v.opportunityId',value.toString());
        }
    },
    handleCampaignChange: function(component, event, helper){
        // update campaign form
        var value = event.getSource().get("v.value");
        
        if(value!=null && value.toString()!='' && value.toString()!='undefined'){
            component.set('v.campaignId',value.toString());
        }
    },

    handleSendEmail : function(component, event, helper){
        var Visit_Status = component.find('vstatus').get('v.value');
        var Visit_Assign_To = component.find('Assigned_To').get('v.value');
        //alert('Status '+Visit_Status+' '+Visit_Assign_To);
        if((Visit_Status == 'Complete' && Visit_Assign_To == '0050X0000075o1cQAA') || (Visit_Status=='Complete' && Visit_Assign_To=='005b0000006kYAbAAM')||(Visit_Status=='Complete' && Visit_Assign_To=='0056700000BuRMLAA3') || (Visit_Status=='Complete' && Visit_Assign_To=='0056700000CZ6AuAAL')){
            //need get data from production for user Id to here. this is must be long Id
            component.set('v.displaySection', 'section1');
        }else{
            component.set('v.displaySection', 'section2');
            component.find('SendEmail').set('v.value', false);
        }
    },

    handleclickSave : function(component, event, helper){
       
        var startPlan = component.find("StartTime").get("v.value");
        var endPlan = component.find("StopTime").get("v.value");

        component.find("original_start_plan").set("v.value", startPlan);
        component.find("original_end_plan").set("v.value", endPlan);
    },
    handleStartTimeChange : function(component, event, helper){
        var startTime = component.find("StartTime").get("v.value");
        var date = new Date(startTime);
        var stopTime = new Date(date.getTime()+60*60000).toJSON();

        component.find("StopTime").set("v.value", stopTime);

    }
})