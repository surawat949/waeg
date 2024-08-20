({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.receivedId');
        component.set('v.mycolumns', [
            
            {label: $A.get("$Label.c.Start_Date"), fieldName: 'startDate',type: 'date',
             typeAttributes:{day:'numeric',month:'short',year:'numeric'}},
            {label: $A.get("$Label.c.Report_Visit_Type"), fieldName: 'visitType', type: 'text'},
            {label: $A.get("$Label.c.Status"), fieldName: 'status', type: 'text'},
            {label: $A.get("$Label.c.Duration")+' (mins)', fieldName: 'duration', type: 'text'},
            {label: $A.get("$Label.c.Report_Visit_Objective"), fieldName: 'objective', type: 'text'},
            {label: $A.get("$Label.c.Report_Visit_Id"), fieldName: 'nameLink', typeAttributes: {
                label: { fieldName: 'name' }
            }, type: 'url',target: 'blank'}
        ]);

        component.set('v.last3VisitsColumns', [
            {label: $A.get("$Label.c.Reports_Date"), fieldName: 'Start_Day__c',type: 'date'},
            {label: $A.get("$Label.c.Assigned_To"), fieldName: 'Visit_assigned_to__c', type: 'text'},
            {label: $A.get("$Label.c.Report_Visit_Type"), fieldName: 'Visit_Type__c', type: 'text'},
            {label: $A.get("$Label.c.Report_Visit_Objective"), fieldName: 'Visit_Reason__c', type: 'text'},
            {label: $A.get("$Label.c.Visit_Notes"), fieldName: 'Visit_Notes__c', type: 'text', wrapText: true},
            {label: $A.get("$Label.c.Call_To_Action"), fieldName: 'Call_To_Action_Notes__c', type: 'text', wrapText: true},
            {label: $A.get("$Label.c.Report_Visit_Id"), fieldName: 'linkName', typeAttributes: {
                label: { fieldName: 'Name' }
            }, type: 'url',target: 'blank'}
        ]);

        if(recordId!=null){

            helper.getAllVisits(component, recordId, function(err,result){

            });

            helper.getLastVisit(component, recordId, function(err,result){
                
            });

            helper.getLast3Visit(component, recordId, function(err,result){
                
            });

            helper.getNextVisit(component, recordId, function(err,result){
                
            });
  
        }
        
    },
    navigateToRelatedTab : function(component, event, helper) {
        var recordId = component.get('v.receivedId');
        helper.gotoRelatedList(component, recordId, function(err,result){
            
        });
    }
})