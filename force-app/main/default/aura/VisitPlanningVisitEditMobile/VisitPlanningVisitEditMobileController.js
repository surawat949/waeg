({
    doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        var accountId = pageReference.state.c__accountId;
        component.set("v.AccountId", accountId);
       
        helper.getTranslations(component, event, helper, function(translations)
        {
            console.log(translations)
            component.set('v.translations', translations);
        });
        helper.getContactsForAccount(component, accountId, function(err, options){
            component.set('v.contactSelectOptions', options);
        });

        var visit = component.get('v.visit');
        if(visit==null){
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
            visit.Call_To_Action__c = null;
    
            var user = $A.get("$SObjectType.CurrentUser");
    
            visit.Assigned_to__c = user.Id;
            visit.Visit_Notes__c = null;
            visit.Visit_Type__c = null;
    
            component.set('v.visit', visit);

        }
        helper.getAccount(component, accountId, function(err, account){
            component.set('v.account', account);
            var v = component.get('v.visit');
            visit.Account__r = {
                    sobjectType : 'Account',
                    Id: accountId,
                    Name: account.name,
                    Hoya_Account_ID__c: account.Hoya_Account_ID__c
                };
            component.set('v.visit', v);
        });
         
        helper.getUserCompany(component, visit, function(err, companyName){
            component.set('v.companyName', companyName);
            component.set('v.specificMkgSection', companyName=='HLHK' || companyName=='HOLK' || companyName=='SOC' || companyName=='HLSH' || companyName=='HLSI');
        });
        //component.set("v.isdisabled", visit.Visit_Status__c === 'Complete');
        
        helper.getUserProfile(component, visit, function(err, profileName){
            component.set('v.profileName', profileName);
        });
    },
    backToVPM: function(cmp, event, helper) {
        
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
    handleSave : function(component, event, helper)
    {
        component.set('v.loaded', true);
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
         }, true);
         if (allValid) {
             //alert('All form entries look valid. Ready to submit!');
         } else {
                return;
         }

        var v = component.get('v.visit');
        var lang = $A.get("$Locale.language");
        var dateFormat = $A.get("$Locale.dateFormat") + ' ' + $A.get("$Locale.timeFormat").replace(":ss", "").replace("dd", "DD");
       // alert(v.Start_Time__c + ' => ' + dateFormat + ' --- ' + v.Start_Time__c.length);
        if(lang=='es' && v.Start_Time__c.length<18){
            //CDU test on size of string-date: on init date have standard format, if user change date, it is spain format
       		moment.locale(lang);
            //specific format for spain
        	dateFormat='DD-MMM-YYYY hh:mm';
            var mstart = moment(v.Start_Time__c, dateFormat).toDate();
            v.Start_Time__c = mstart;
            if(v.Start_Time__c=='Invalid Date' || v.Start_Time__c=='undefined'){
                v.Start_Time__c = new Date(v.Start_Time__c);
            }
        } else {
            v.Start_Time__c = new Date(v.Start_Time__c);
        }
        
        if(lang=='es' && v.End_Time__c.length<18){
            //CDU test on size of string-date: on init date have standard format, if user change date, it is spain format
       		moment.locale(lang);
            //specific format for spain
        	dateFormat='DD-MMM-YYYY hh:mm';
            var mend = moment(v.End_Time__c, dateFormat).toDate();
            v.End_Time__c = mend;
            if(v.End_Time__c=='Invalid Date' || v.End_Time__c=='undefined'){
                v.End_Time__c = new Date(v.End_Time__c);
            }
        } else {
            v.End_Time__c = new Date(v.End_Time__c);
        }

       // alert('v.start_time__c=' + v.StartTime__c + ', v.end_time__c=' + v.End_Time__c)
        component.set('v.message', null);
        component.set('v.saving', true);


        helper.upsertVisit(component, v, function(err, result)
        {
            console.log('upsert result', err, result);

            if (err)
            {

                var errors = err;
                var message = '';
                errors.forEach( function (error){

                    //top-level error.  there can be only one
                    if (error.message){
                        message += error.message;
                    }

                    //page-level errors (validation rules, etc)
                    if (error.pageErrors){
                        error.pageErrors.forEach( function(pageError) {
                            if (pageError.message.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION') > 0)
                            {
                                message += pageError.message.substr(pageError.message.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION')+35)
                            }
                            else
                            {
                                message += pageError.message;
                            }


                        });
                    }

                    if (error.fieldErrors){
                        //field specific errors--we'll say what the field is
                        for (var fieldName in error.fieldErrors) {
                            //each field could have multiple errors
                            error.fieldErrors[fieldName].forEach( function (errorList){
                                message += errorList.message;
                            });
                        };  //end of field errors forLoop
                    } //end of fieldErrors if
                }); //end Errors forEach

                component.set('v.message', message);
                component.set('v.saving', false);
			    return;
            }
            var compEvent = component.getEvent("decisionresult");
            compEvent.setParams({"result" : 'Saved' });
            compEvent.fire();
        });
        window.setTimeout($A.getCallback(function() {component.set("v.loaded", false);}), 2000);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been saved successfully."
        });
        toastEvent.fire();
        // redirect to visitPlanningVisitEditMobile cmp
 //       var navService = component.find("navService");
 //       var pageReference = {
            
//            "type": "standard__component",
//            "attributes": {
//                "componentName": "c__VisitPlanningMobile"    
//            },    
//            "state": {
//            }
//        };
//        component.set("v.pageReference", pageReference);
//        var defaultUrl = "#";

//        navService.generateUrl(pageReference)
//        .then($A.getCallback(function(url) {
//            component.set("v.url", url ? url : defaultUrl);
//        }), $A.getCallback(function(error) {
//            component.set("v.url", defaultUrl);
//       }));
//        event.preventDefault();
//        navService.navigate(pageReference);
    }
})