({
    init : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log('XXXX Account Id is '+recordId);

        helper.getUserCompany(component, function(err, result){
            component.set('v.CompanyName', result);
            console.log('XXX User Company is '+JSON.stringify(result));
            
        });

        helper.getInstrumentInShop(component, recordId, function(err, result){
            component.set('v.Instrument', result);
            console.log('XXX Get Data for Instrument In Shop == > '+JSON.stringify(result));
        });

        helper.getSoftwareInShop(component, recordId, function(err, result){
            component.set('v.Software', result);
            console.log('XXX Get Data fro Software In Shop == >'+JSON.stringify(result));
        });

        //helper.getLensHoyaIdentifier(component,helper);
        //helper.getHoyaiLogforChart(component,helper);
    }
})