({
    init : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log('XXXX Account Id is '+recordId);
        helper.getEquipment(component, recordId, function(err, result){
            component.set('v.equipement', result);
            console.log('XXXX Equipment Details '+JSON.stringify(result));
        });
        helper.getHoyalogEquipment(component,recordId, function(err, result){
            component.set('v.equipHoyalog', result);
            console.log('XXX Equipment Hoyalog Details '+JSON.stringify(result));
        });
        helper.getAppleVisualReel(component, recordId, function(err, result){
            component.set('v.visualreel', result);
            console.log('XXX Visual Reel Details '+JSON.stringify(result));
        });
        helper.getUserCompany(component, function(err, result){
            component.set('v.CompanyName', result);
            console.log('XXX User Company is '+JSON.stringify(result));
            
        });
        helper.getEquipmentAll(component, recordId, function(err, result){
            component.set('v.equipements', result);
            console.log('XXX Get Data Equipement All '+JSON.stringify(result));
        });
        helper.getFSVProject(component, recordId, function(err, result){
            component.set('v.fsvproject', result);
            console.log('XXX Get data for FSV Project '+JSON.stringify(result));
        });
        helper.getEquipmentTool(component, recordId, function(err, result){
            component.set('v.instorevisual', result);
            console.log('XXX Get data for Instore Visual '+JSON.stringify(result));
        });

        helper.getContactId(component, recordId, function(err, result){
            component.set('v.ContactId', result);

        });
        
        helper.getContactNumber(component, recordId, function(err, result){
            component.set('v.ContactNum', result);
        });
    }
})