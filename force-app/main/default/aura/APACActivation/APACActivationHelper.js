({
    getEquipment : function(component, recordId, callback) {
        component.set('v.mycolumns', [
            {label: $A.get("$Label.c.APACActivationSerialNo"), fieldName:'Name', type:'text'},
            {label: $A.get("$Label.c.APACActivationHoyalog"), fieldName:'HAPL_Hoya_Log__c', type:'boolean'},
            {label: $A.get("$Label.c.APACActivationLAM"), fieldName:'HAPL_LAM__c', type:'number'},
            {label: $A.get("$Label.c.APACActivationMiyoSmartUnit"), fieldName:'HAPL_MiyoSmart_Units__c', type:'number'},
            {label: $A.get("$Label.c.APACActivationOthers"), fieldName:'HAPL_Others__c', type:'number'},
            {label: $A.get("$Label.c.APACActivationSensitySample"), fieldName:'HAPL_Sensity_Samples__c', type:'number'},
            {label: $A.get("$Label.c.APACActivationTintSample"), fieldName:'HAPL_Tint_Samples__c', type:'number'}
        ]);

        var action = component.get('c.getEquipmentId');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection.');
            }

        });
        $A.enqueueAction(action);
    },

    getHoyalogEquipment : function(component, recordId, callback){
        component.set('v.myColumnsHoyalog',
            [{label: $A.get("$Label.c.APACActivationSerialNo"), fieldName:'HAPL_Hoyalog_Serial_Number__c', type:'text'},
            {label: $A.get("$Label.c.APACActivationType"), fieldName:'Equipment_Type__c', type:'text'},
            {label: $A.get("$Label.c.APACActivationShipmentDate"), fieldName:'Shipment_Date__c', type:'date'},
            {label: $A.get("$Label.c.APACActivationInstallationDate"), fieldName:'Installation_Date__c',type:'date'},
            {label: $A.get("$Label.c.APACActivationTracer"), fieldName:'HAPL_Hoyalog_Tracer__c', type:'text'},
            {label: $A.get("$Label.c.APACActivationBrand"), fieldName:'HW_Brand__c', type:'text'},
            {label: $A.get("$Label.c.APACAcitvationTermId"), fieldName:'HAPL_Hoyalog_Term_ID__c', type:'text'}
        ]);
        
        var action = component.get('c.getHoyaLogEduipment');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getAppleVisualReel : function(component, recordId, callback){
        component.set('v.myColumnsVisualReel',
            [
                {label: $A.get("$Label.c.APACActivationSerialNo"), fieldName:'Name', type:'text'},
                {label: $A.get("$Label.c.APACActivationHW"), fieldName:'HW_Brand__c', type:'text'},
                {label: $A.get("$Label.c.APACActivationModel"), fieldName:'HW_Model__c', type:'text'},
                {label: $A.get("$Label.c.APACActivationType"), fieldName:'HW_Subtype__c', type:'text'},
                {label: $A.get("$Label.c.APACActivationVRType"), fieldName:'Model2__c', type:'text'},
                {label: $A.get("$Label.c.APACActivationSubType"), fieldName:'Subtype__c', type:'text'}
            ]
        );

        var action = component.get('c.getIpadVisualReal');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getUserCompany : function(componet, callback){
        var action = componet.get('c.getCompanyName');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(componet.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(componet.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('getUserCompany : Error during the connection');
            }
        });
        $A.enqueueAction(action);
    },

    getEquipmentAll : function(component, recordId, callback){

        var action = component.get('c.getEuipementsAll');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },

    getFSVProject : function(component, recordId, callback){

        var action = component.get('c.getFSVProject');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getEquipmentTool : function(component, recordId, callback){
        var action = component.get('c.getEquipmentTool');
        action.setParams({"recordId":recordId});

        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());

            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection');
            }
        });
        $A.enqueueAction(action);
    },

    getContactId : function(component, recordId, callback){
        var action = component.get('c.getContactIdFromAccount');
        action.setParams({"recordId":recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection');
            }
        });
        $A.enqueueAction(action);
    },

    getContactNumber : function(component, recordId, callback){
        var action = component.get('c.getContactNumber');
        action.setParams({"recordId":recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection');
            }
        });
        $A.enqueueAction(action);
    }
})