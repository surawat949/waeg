({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId!=null){
            var opp = null;
            var acc = null;
            var seikoData = null;
            helper.getOpportunity(component, recordId,function(err, result){
                component.set('v.opp', result);
                opp = result;
                component.set('v.accountId', opp.AccountId);
                helper.getAccount(component, opp.AccountId, function(err, resultA){
                    component.set('v.acc', resultA);
                    acc = resultA;
                    component.set('v.accfields', ['NumberOfEmployees','Number_of_sales_desk__c', 'First_Competitor_global_name__c', 'Second_Competitor_global_name__c', 'First_Competitor_local_name__c', 'Second_Competitor_Local_Name__c','First_Competitor_SOW__c', 'Second_Competitor_SOW__c']);
                    
                });
                helper.getSeikoData(component, opp.AccountId, function(err, resultS){
                    component.set('v.seikoData', resultS);
                    seikoData=resultS;
                });
                
                component.set('v.fields',  ['Date_1st_appointment__c']);
                component.set('v.fieldoppList',  ['Name','Expected_Sales__c','Total_Amount__c', 'Amount']);
               
                component.set('v.displayOrder', false);
                if(opp.StageName=='2. Discovery'){
                    component.set('v.fieldoppList',  ['Key_reasons_for_switching_supplier__c','Key_reasons_for_keeping_current_supplier__c','Healthcare_Networks_identified__c']); 
                } else if(opp.StageName=='3. ATOL Agreement'){
                    component.set('v.priceFields',  [ 'Strategic_Value__c', 'Annual_Expected_Sales__c', 'Annual_Revenue__c','Annual_Incremental_Sales__c']);
                
                } else if(opp.StageName=='4. Contract Optimisation'){
                    component.set('v.priceFields',  [ 'Strategic_Value__c', 'Annual_Expected_Sales__c', 'Annual_Revenue__c','Annual_Incremental_Sales__c']);
                    
                } else if(opp.StageName=='5. SVS Contract signature'){
                    //component.set('v.fields',  ['Pricelist_selected__c', 'Seiko_monthly_support_to_investment__c', 'Commintment_on_annual_turnover__c', 'Seiko_support_in__c', 'Commintment_on__c','Seiko_support_duration_in_Mo__c','Date_of_1st_proposal__c', '']);
                    
                } else if(opp.StageName=='5. Brand Activation'){
                    component.set('v.fields',  ['SEIKO_Catalogues__c','SEIKO_catalogues_training__c','SEIKO_Products_1rst_training__c',
                    'SEIKO_Products_1rst_training_date__c','Seiko_track_trace_daily_email__c','Seiko_track_trace_email_activation__c',
                    'SEIKO_Track_Trace__c','SEIKO_Track_Trace_activation__c','SVS_Sample_boxes__c','SVS_Sample_boxes_setting_up__c',
                    'SVS_Newsletters__c','SVS_Newsletters_activation__c','SVS_Store_locator__c','SVS_Store_locator_activation__c']);
                    
                } 
            });
            helper.getNumberOfVisits(component, function(err, result){
                component.set('v.numberOfVisits', result);
            });
            helper.getCompanyName(component, function(err, result){
                component.set('v.companyName', result);
            });
        }
       
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('myRecordForm').submit(fields);
    },
    handleSubmit32: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('myRecordForm32').submit(fields);
        if(fields["Margin_simulation_done__c"]==true && fields["Estimated_margin_gain__c"]==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Margin gain must be completed"
            });
            toastEvent.fire();
        } else if(fields["Atol_Optician_level_of_interest__c"]=='Not interested'){
            fields.StageName='6-Closed Lost';
            component.find('myRecordForm32').submit(fields);
        } else if (fields["Atol_Optician_level_of_interest__c"]=='ATOL Contract signed') {
            fields.StageName='4. Contract Optimisation';
            var accountId = component.get('v.accountId');
            helper.updateOnBoardingAccount(component, accountId,function(err, result){
                // xxxxxxxx
            });
            
            component.find('myRecordForm32').submit(fields);
        }  else {
            component.find('myRecordForm32').submit(fields);
        }

    },
    handleSubmit42: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if(fields["Additional_ASM_Discount__c"]!=null && fields["Type_of_Discount__c"]==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Type of Discount must be completed"
            });
            toastEvent.fire();
        } else {
            component.find('form42').submit(fields);
        }
    },
    handleSubmit43: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if(fields["Optician_interest_for_SVS__c"]=='SVS Add-on signed' && fields["Seiko_Vision_Specialist_Offer__c"]==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "SVS offer must be completed"
            });
            toastEvent.fire();
        } else {
            component.find('form43').submit(fields);
            if(fields["Optician_interest_for_SVS__c"]=='SVS Add-on signed'){
                var accountId = component.get('v.accountId');
                helper.enrollSVS(component, accountId,function(err, result){
                    // xxxxxxxx
                });
            }
        }
    },
    SvsProgramSubmit: function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('svsProgramForm').submit(fields);
    },
    handleSubmitOppInterest: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if(fields["Optician_level_of_interest__c"]=='Not interested'){
            fields.StageName='[SVS] Closed Lost';
            //component.set('v.displayCalendar', false);
        } else {
            //component.set('v.displayCalendar', true);
        }
        component.find('oppInterestRecordForm').submit(fields);
    },
    handleAccountSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        var myForm = component.find('accRecordForm');
        component.find('accRecordForm').submit(fields);
    },
    handleSurveySuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Survey saved with success"
        });
        toastEvent.fire();

        var decision = component.get('v.opportunityWon');
        var recordId = component.get('v.recordId');
        
        helper.saveOpportunity(component, recordId, decision, function(err, result){
            $A.get('e.force:refreshView').fire();
        });


    },
    handleUserChange : function(component, event, helper) {        
        var lookupId = event.getParam("value")[0];
        //component.set('v.userVisitId', lookupId);
        //var childCmp = component.find("uCalendar");
        //childCmp.reload();

        var cmpEvent = component.getEvent("userIdEvent");
        var accountId = component.get('v.accountId');
        var opportunityId = component.get('v.opp.id');
        cmpEvent.setParams({
            "accountId" : accountId,
            "opportunityId" : opportunityId
        });
        cmpEvent.fire();
    },
    handleTacticomSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Tacticom saved with success"
        });
        toastEvent.fire();

    },
    handleDecision:function(component, event, helper) {
       var value = event.getSource().get("v.value");
       if(value=='WE CONTINUE'){
            component.set('v.opportunityWon', true);
       } else {
            component.set('v.opportunityWon', false);
       }
    },
    recordUpdated: function(component, event, helper){
        //alert('record updated (toast detection)');
        this.doInit(component, event, helper);
    },
    toggle : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    }
})