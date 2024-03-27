/**
 * Created by thomas.schnocklake on 14.02.18.
 */
({
    doInit : function(component, event, helper)
    {
        //console.log('doInit VisitPlanningVisitEdit');
        var visit = component.get('v.visit');
        //console.log('visit', visit);
        component.set("v.isdisabled", visit.Visit_Status__c === 'Complete');

        helper.getContactsForAccount(component, visit.Account__c, function(err, options){
            //console.log('XXXXXX', err, options);
            component.set('v.contactSelectOptions', options);
        });
        
        helper.getUserCompany(component, visit, function(err, companyName){
            component.set('v.companyName', companyName);
            component.set('v.specificMkgSection', companyName=='HLHK' || companyName=='HOLK' || companyName=='SOC' || companyName=='HLSH' || companyName=='HLSI');
        });
        helper.getUserProfile(component, visit, function(err, profileName){
            component.set('v.profileName', profileName);
        });
    },
    handleCancel : function(component, event, helper)
    {
        var compEvent = component.getEvent("decisionresult");
        compEvent.setParams({"result" : 'Cancelled' });
        compEvent.fire();
    },
    handleSave : function(component, event, helper)
    {
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
    },
    handleDelete : function(component, event, helper)
    {
        var v = component.get('v.visit');
        v.Start_Time__c = new Date(v.Start_Time__c);
        v.End_Time__c = new Date(v.End_Time__c);
        component.set('v.message', null);

        helper.deleteVisit(component, v, function(err, result)
        {
            console.log('delete result', err, result);

            if (err)
            {
                component.set('v.message', 'neinnnnnn');
                return;
            }
            var compEvent = component.getEvent("decisionresult");
            compEvent.setParams({"result" : 'Deleted' });
            compEvent.fire();
        });
    },

})