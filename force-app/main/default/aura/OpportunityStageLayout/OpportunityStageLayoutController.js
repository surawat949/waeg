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
                    //alert('Account Name =' +acc.Name);
                    component.set('v.accfields', ['NumberOfEmployees','Number_of_sales_desk__c', 'First_Competitor_global_name__c', 'Second_Competitor_global_name__c', 'First_Competitor_local_name__c', 'Second_Competitor_Local_Name__c','First_Competitor_SOW__c', 'Second_Competitor_SOW__c']);
                    
                });
                helper.getSeikoData(component, opp.AccountId, function(err, resultS){
                    component.set('v.seikoData', resultS);
                    seikoData=resultS;
                });
                
                //alert('hoya account id =' +acc.Hoya_Account_ID__c);
                //default value match to 1st appointment stage
                //component.set('v.fields',  ['Name','Expected_Sales__c','Total_Amount__c', 'Amount']);
                component.set('v.fields',  ['Date_1st_appointment__c']);
                component.set('v.fieldoppList',  ['Name','Expected_Sales__c','Total_Amount__c', 'Amount']);
                if(opp.Optician_level_of_interest__c=='Not interested'){
                    //component.set('v.displayCalendar', false);
                }
                component.set('v.displayOrder', false);
                if(opp.StageName=='2. SVS Concept validation'){
                    //component.set('v.fields',  ['Contact_s_name_s_registered_in_SFDC__c','Healthcare_networks_identified_for_SOF__c']); 
                    component.set('v.fieldoppList',  ['Annual_Expected_Sales__c','SVS_Contract_Project_Given__c','Key_reasons_for_switching_supplier__c','Contact_s_name_s_registered_in_SFDC__c','Key_reasons_for_keeping_current_supplier__c','Healthcare_networks_identified_for_SOF__c', 'Optician_level_of_interest_2__c']); 
                    //if(opp.Optician_level_of_interest_2__c=='Not interested'){
                        component.set('v.displayOrder', false);
                    //}
                } else if(opp.StageName=='3. Products/prices validation'){
                    component.set('v.fields',  ['SV_Premium_design__c','PAL_Premium_design__c','SV_Best_design__c','PAL_Best_design__c','SV_Better_design__c','PAL_Better_design__c','SV_Good_design__c','PAL_Good_design__c']);
                    component.set('v.priceFields',  [ 'Commintment_on_annual_turnover__c','Retail_prices_calculated__c', 'Commintment_on__c','Margin_simulation_done__c','Pricelist_selected__c', 'Optician_level_of_interest_3__c']);
                    
                    if(opp.Optician_level_of_interest_3__c==null){
                        component.set('v.displayOrder', false);
                    } else {
                        component.set('v.displayOrder', true);
                    }
                } else if(opp.StageName=='4. SVS Proposal'){
                    component.set('v.fields',  ['Seiko_Vision_Xperience_iPAD__c','Seiko_Vision_Simulator__c','Seiko_Vision_Xperience_column__c','Seiko_Xchanger_display__c','Seiko_Tracer__c','Seiko_Shop_in_shop__c','Other_Investments__c', 'SVS_investment_value__c']);
                    component.set('v.displayOrder', false);
                } else if(opp.StageName=='5. SVS Contract signature'){
                    component.set('v.fields',  ['Pricelist_selected__c', 'Seiko_monthly_support_to_investment__c', 'Commintment_on_annual_turnover__c', 'Seiko_support_in__c', 'Commintment_on__c','Seiko_support_duration_in_Mo__c','Date_of_1st_proposal__c', '']);
                    component.set('v.displayOrder', false);
                } else if(opp.StageName=='6. Seiko Brand activation'){
                    component.set('v.fields',  ['SEIKO_Catalogues__c','SEIKO_catalogues_training__c','SEIKO_Products_1rst_training__c',
                    'SEIKO_Products_1rst_training_date__c','Seiko_track_trace_daily_email__c','Seiko_track_trace_email_activation__c',
                    'SEIKO_Track_Trace__c','SEIKO_Track_Trace_activation__c','SVS_Sample_boxes__c','SVS_Sample_boxes_setting_up__c',
                    'SVS_Newsletters__c','SVS_Newsletters_activation__c','SVS_Store_locator__c','SVS_Store_locator_activation__c']);
                    component.set('v.displayOrder', false);
                } else if(opp.StageName=='7. Trial period validation'){
                    component.set('v.fields',  []);
                    component.set('v.displayOrder', false);
                } 
            });
            helper.getNumberOfVisits(component, function(err, result){
                component.set('v.numberOfVisits', result);
            });
        }
       
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('myRecordForm').submit(fields);
    },
    handleSubmitPriceList: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if(fields["Optician_level_of_interest_3__c"]=='Not interested'){
            fields.StageName='[SVS] Closed Lost';
            component.find('priceListForm').submit(fields);
        } else if(fields["Optician_level_of_interest_3__c"]==null || fields["Retail_prices_calculated__c"]==null || fields["Margin_simulation_done__c"]==null|| fields["Commintment_on_annual_turnover__c"]==null
                || fields["Commintment_on__c"]==null|| fields["Commintment_on__c"]==null|| fields["Commintment_on__c"]==null|| fields["Commintment_on__c"]==null|| fields["Pricelist_selected__c"]==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "All Activity 2 fields must be completed"
            });
            toastEvent.fire();
        } else {
            component.find('priceListForm').submit(fields);
        }

        component.find('priceListForm').submit(fields);
    },
    handleSubmitNegociation: function(component, event, helper){
        var fields = event.getParam('fields');
        if(fields["Optician_level_of_interest_4__c"]=='Not interested'){
            fields.StageName='[SVS] Closed Lost';
            component.find('negociationForm').submit(fields);
        }
        
        if(fields["Optician_level_of_interest_4__c"]=='Contract Signed'){
            fields.StageName='6. Seiko Brand activation';
            fields.Optician_level_of_interest_5__c='Contract Signed';
            component.find('negociationForm').submit(fields);
            var accountId = component.get('v.accountId');
            helper.updateOnBoardingAccount(component, accountId, function(err, result){
            // xxxxxxxx
            });
        }
        
        
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('negociationForm').submit(fields);
    },
    SvsProgramSubmit: function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('svsProgramForm').submit(fields);
    },
    handleSubmitOpp2: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if(fields["Optician_level_of_interest_2__c"]=='Not interested'){
            fields.StageName='[SVS] Closed Lost';
            component.find('oppRecordForm').submit(fields);
        } else if(fields["Optician_level_of_interest_2__c"]==null || fields["Key_reasons_for_switching_supplier__c"]==null || fields["Key_reasons_for_keeping_current_supplier__c"]==null|| fields["Contact_s_name_s_registered_in_SFDC__c"]==false|| fields["SVS_Contract_Project_Given__c"]==false){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "All Activity 2 fields must be completed"
            });
            toastEvent.fire();
        } else {
            component.find('oppRecordForm').submit(fields);
        }
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
    handleSubmitOppInterest: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('svsProposalForm').submit(fields);
    },
    handleAccountSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        var myForm = component.find('accRecordForm');
        component.find('accRecordForm').submit(fields);
    },
    handleProposalSubmit:function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        if(fields["Optician_level_of_interest_5__c"]=='Not interested'){
            fields.StageName='[SVS] Closed Lost';
        }
        if(fields["Optician_level_of_interest_5__c"]=='Contract Signed'){
            var accountId = component.get('v.accountId');
            helper.updateOnBoardingAccount(component, accountId,function(err, result){
            // xxxxxxxx
            });
        }
        component.find('svsProposalForm').submit(fields);
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