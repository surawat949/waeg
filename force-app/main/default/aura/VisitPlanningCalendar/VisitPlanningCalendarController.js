/**
 * Created by thomas.schnocklake on 22.12.17.
 */
({
    doInit : function(component, event, helper)
    {
        helper.getUserCompany(component, function(err, companyName){
            component.set('v.companyName', companyName); 
        });
        var UserName =  $A.get("$SObjectType.CurrentUser.Email");
        component.set("v.UserName",UserName);
    },
    jsLoaded : function(component, event, helper)
    {
        var date = new Date();
        //console.log(date);

    },
    onViewChange : function(component, event, helper) {
        var start = event.getParam("start");
        var end = event.getParam("end");
        //console.log('onViewChange', start, end);
        helper.updateCalenderEvents(component, event, helper);
    },
    onOpenEvent : function(component, event, helper) {
        //console.log('onOpenEvent');
        var fcEvent = event.getParam("event");

        helper.getVisit(component,fcEvent.sfid, function(visitFetched)
        {
            component.set('v.visit',visitFetched);
        });
    },
    onMoveEvent : function(component, event, helper) {
        //console.log('onMoveEvent');
        var fcEvent = event.getParam("event");
        var companyName =  $A.get("$SObjectType.CurrentUser.companyName");
        var v = {};
        v.sobjectType = 'Visits__c';
        /*if(companyName=='HOLA' || companyName=='HLCA' ||companyName=='SRX' ||companyName=='VEUS'){
            v.RecordTypeId='0126700000110DLAAY';
        }*/
        v.Id = fcEvent.sfid;
//        v.Start_Time__c = new Date(fcEvent.start);
//        v.End_Time__c = new Date(fcEvent.end)new Date(v.Start_Time__c)
        v.Start_Time__c = new Date(moment.tz(fcEvent.start.toJSON(), $A.get('{!$Locale.timezone}')).format());
        v.End_Time__c = new Date(moment.tz(fcEvent.end.toJSON(), $A.get('{!$Locale.timezone}')).format());

        helper.upsertVisit(component, v, function(err, result)
        {
            //console.log('upsert result', err, result);

            if (err)
            {
                alert('error moving visit');
            }
            helper.updateCalenderEvents(component, event, helper);
        });

    },
    onDropEvent : function(component, event, helper) {
        var droppedData = event.getParam("droppedData");
        console.log('droppedd'+JSON.stringify(droppedData));
        var date = event.getParam("date");
        //console.log(date);

        var v = {};
        v.sobjectType = 'Visits__c';
        v.Account__c = droppedData.id;
        v.Account__r = {
            sobjectType : 'Account',
            Id: droppedData.id,
            Name: droppedData.name,
        };
        //debugger;
        v.Start_Time__c = date.format();
        v.End_Time__c = date.add(60, 'minutes').format();
        v.Call_To_Action_Notes__c = null;
        v.Visit_Reason__c = null;
        v.Call_To_Action__c = null;
        v.Campaign_name__c = component.get('v.campaignId');
        v.Visit_Planning_Tracker__c = 'Visit Planning';
        var user = $A.get("$SObjectType.CurrentUser");

        v.Assigned_to__c = user.Id;
        v.Visit_Notes__c = null;
        v.Visit_Type__c = null;


        component.set('v.visit', v);
    },

    handleModalDecision: function(component, event, helper) {
        //console.log('handleModalDecision');
        //console.log(event.getParam("result"));
        if (event.getParam("result")=== 'Cancelled')
        {
            component.set('v.visit', null);
        }
        else if (event.getParam("result")=== 'Saved')
        {
            component.set('v.visit', null);

            helper.updateCalenderEvents(component, event, helper);
        }
        else if (event.getParam("result")=== 'Deleted')
        {
            component.set('v.visit', null);

            helper.updateCalenderEvents(component, event, helper);
        }
    },
})