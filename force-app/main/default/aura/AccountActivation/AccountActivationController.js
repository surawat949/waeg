({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId!=null){
            helper.initSeikoData(component, recordId, function(err, result){
                component.set('v.seikoData', result);
                component.set('v.TotalLoyaltyPoints', result.Account__r.Total_Loyalty_Points__c);
            });
            
        }
        helper.initNmuTool(component, recordId, 'SXN orders', function(err, result){
            component.set('v.snxOrder', result);
        });
        helper.initNmuTool(component, recordId, 'Measurements', function(err, result){
            component.set('v.measurements', result);
        });
        helper.initNmuTool(component, recordId, 'Lens Selection', function(err, result){
            component.set('v.lensSelection', result);
        });
        helper.initNmuTool(component, recordId, 'Frame', function(err, result){
            component.set('v.frame', result);
        });
        helper.initNmuTool(component, recordId, 'Vision Test', function(err, result){
            component.set('v.visionTest', result);
        });
        helper.initNmuTool(component, recordId, 'eColumn Measurements', function(err, result){
            component.set('v.ecolonneMeasurements', result);
            console.log('XXX Get data for eColumn Lens Measurements '+JSON.stringify(result));
        });
        helper.initNmuTool(component, recordId, 'eColumn Lens Selection', function(err, result){
            component.set('v.ecolonneConsultation', result);
            console.log('XXX Get Data for eColumn Lens Selection '+JSON.stringify(result));
        });
        helper.initSocialMedia(component, recordId, function(err, result){
            component.set('v.socialMedia', result);
        })
        helper.initSeikoPro(component, recordId, function(err, result){
            component.set('v.seikoPro', result);
        })
        helper.initLastTrainingDate(component, recordId, 'SEIKO Store locator', function(err, result){
            component.set('v.dealerLocatorLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Product range', function(err, result){
            component.set('v.productRangeLastTraining', result);
            if(result!=null && result!=''){
                component.set('v.SeikoProduct1stTraining', true);
            }
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Track & Trace', function(err, result){
            component.set('v.TrackAndTraceLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SVS Purchase registration', function(err, result){
            component.set('v.purchaseRegistrationLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SVS Loyalty Program Emails', function(err, result){
            component.set('v.loyaltyProgramLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Vision Academy', function(err, result){
            component.set('v.visionAcademyLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SVS Social Media Plateform', function(err, result){
            component.set('v.socialManagerLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Pro', function(err, result){
            component.set('v.seikoProLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Catalogue', function(err, result){
            component.set('v.seikoCatalogueLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Xtranet', function(err, result){
            component.set('v.seikoXTranetLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Vision Xperience iPad', function(err, result){
            component.set('v.seikoIPadLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Vision Xperience eColonne', function(err, result){
            component.set('v.seikoEColonneLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Tracer', function(err, result){
            component.set('v.seikoTracerLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SVS Shop in shop', function(err, result){
            component.set('v.seikoShopInShopLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'SEIKO Xperience Center', function(err, result){
            component.set('v.seikoXperienceCenterLastTraining', result);
        });
        helper.initLastTrainingDate(component, recordId, 'MIYOSMART', function(err, result){
            component.set('v.seikoMiyosmartLastTraining', result);
        });

        helper.initSeikoXtraNet(component, recordId, function(err, result){
            component.set('v.isSeikoXtranet', result);
            console.log('Is Seiko Xtranet is '+JSON.stringify(result));
        });
        
        
        helper.iniSeikoXperienceIpad(component, recordId, function(err, result){
            component.set('v.SeikoXpIpad', result);
            console.log('Is Seiko Xperience Ipad '+JSON.stringify(result));
        });
        

    }, handleReset: function(cmp, event, helper) {
        cmp.find('field').forEach(function(f) {
            f.reset();
        });
    },
    handlSuccess: function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Record saved with success"
        });
        toastEvent.fire();
    },
    generateStatement: function(component, event, helper) {
        component.find('loyaltyPointsStatement').displayModal();
    }
})