({
        getLastVisit : function(component, contactId, callback ) {

        var action= component.get('c.getContactLastVisitCompleted');
        action.setParams({"contactId": contactId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() !=null) {
         
                var lastVisit = response.getReturnValue();

                let obj = {
                    nameLink : '/'+ lastVisit.Id,
                    assignedLink:'/'+ lastVisit.Assigned_to__c,
                    contactLink:'/'+ lastVisit.Contact__c,
                    contactName:lastVisit.Contact__r.Name,
                    assignee:lastVisit.Assigned_to__r.Name,
                    visitType:lastVisit.Visit_Type__c,
                    startDate:lastVisit.Start_Date_Time__c,
                    objective:lastVisit.Visit_Reason__c,
                    contactName:lastVisit.Contact__r.Name,
                    name:lastVisit.Name,
                    notes:lastVisit.Visit_Notes__c,
                    action:lastVisit.Call_To_Action_Notes__c
             }        
                component.set('v.lastVisit', obj); 
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
                this.showError('Error',response.getError() ,'error');
            }
        });
        $A.enqueueAction(action);

    },
    
    getNextVisit : function(component, contactId, callback ) {
        var action= component.get('c.getNextVisitPlanned');
        action.setParams({"contactId": contactId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() !=null) {
         
                var nextVisit = response.getReturnValue();
				
                let obj = {
                    nameLink : '/'+ nextVisit.Id,
                    assignedLink:'/'+ nextVisit.Assigned_to__c,
                    contactLink:'/'+ nextVisit.Contact__c,
                    contactName:nextVisit.Contact__r.Name,
                    assignee:nextVisit.Assigned_to__r.Name,
                    visitType:nextVisit.Visit_Type__c,
                    startDate:nextVisit.Start_Date_Time__c,
                    objective:nextVisit.Visit_Reason__c,
                    contactName:nextVisit.Contact__r.Name,
                    name:nextVisit.Name,
                    notes:nextVisit.Visit_Notes__c,
                    action:nextVisit.Call_To_Action_Notes__c
             }  

                component.set('v.nextVisit', obj);            
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
                this.showError('Error',response.getError() ,'error');
            }
        });
        $A.enqueueAction(action);

    }
    ,
    
     getAllVisits : function(component, contactId, callback ) {

        var action= component.get('c.getVisits');
        action.setParams({"contactId": contactId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() !=null) {
                let data = [];
                let res=response.getReturnValue();
                
                let result = JSON.parse(JSON.stringify(res));   
				
                result.forEach((row)=>{
                        let obj = {
                            nameLink:'/'+row.Id,
                            name:row.Name,
                            contactLink:'/'+row.Contact__c,
                            contactName:row.Contact__r.Name,
                            startDate: row.Start_Day__c,
                            status:row.Visit_Status__c,
                            duration:row.Duration_Minutes__c,
                            visitType:row.Visit_Type__c,
                            objective:row.Visit_Reason__c
                        }
                        
                        data.push(obj);
					
                });

               var visitsData = (data.length <= 5) ? [...data] : [...data].splice(0,5);

                component.set('v.visitLists', visitsData);
              

                if(data.length > 5){
                    component.set('v.isDataExists',true);
                    component.set('v.visitCount','5+');
                }
                else{
                    component.set('v.isDataExists',true);
                    component.set('v.visitCount',data.length);
                }

                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
                this.showError('Error',response.getError() ,'error');
            }
        });
        $A.enqueueAction(action);

    },

    getLast3Visit : function(component, contactId, callback ) {
        var action= component.get('c.getVisitCompleted');
        action.setParams({"contactId": contactId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue() !=null) {
                
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                callback(null, response.getReturnValue());
                component.set('v.last3Visits', records);
                let dataExist = records.length>0 ? true: false;
                
                component.set('v.isLastVisitsExists',dataExist)
                
                /*let data = [];
                let res=response.getReturnValue();
                component.set('v.last3Visits', res);
                callback(null, response.getReturnValue());
                let dataExist = res.length>0 ? true: false;
                component.set('v.isLastVisitsExists',dataExist);*/
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
                this.showError('Error',response.getError() ,'error');
            }
        });
        $A.enqueueAction(action);
    },
 
      gotoRelatedList : function (component, contactId, callback) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "Visits__r",
            "parentRecordId": contactId
        });
        relatedListEvent.fire();
    },

    showError : function(title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }

})