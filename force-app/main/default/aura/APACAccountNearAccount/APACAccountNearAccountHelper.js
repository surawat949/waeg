({
    getNearbyAccount : function(component, accountId, callback) {
        var action = component.get('c.getAccounts');
        var pdistance = component.get('v.distance');
        var pPotentialMax = component.get('v.potentialMax');
        var pPotentialMin = component.get('v.potentialMin');
        var globalCompetitor = component.get('v.globalCompetitor');
        var secondCompetitor = component.get('v.secondCompetitor');
        var segmentation = component.get('v.segmentation');

        var param1 = 'param1';
        action.setParams({
            "accountId" : accountId,
            "distance" : pdistance,
            "oneParam" : param1,
            "potentialMin" : pPotentialMin,
            "potentialMax" : pPotentialMax,
            "competitorGlobal1" : globalCompetitor,
            "competitorGlobal2" : secondCompetitor,
            "Segmentation" : segmentation
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){

                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
            }

        });
        $A.enqueueAction(action);
    }
})