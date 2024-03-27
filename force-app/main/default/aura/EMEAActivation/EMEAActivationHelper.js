({
    /*
    getEquipment : function(component, recordId, callback) {
        component.set('v.mycolumns', [
            {label:'Serial Number', fieldName:'Name', type:'text'},
            {label:'Hoyalog', fieldName:'HAPL_Hoya_Log__c', type:'boolean'},
            {label:'LAM', fieldName:'HAPL_LAM__c', type:'number'},
            {label:'MiyoSmart Unit', fieldName:'HAPL_MiyoSmart_Units__c', type:'number'},
            {label:'Others', fieldName:'HAPL_Others__c', type:'number'},
            {label:'Sensity Sample', fieldName:'HAPL_Sensity_Samples__c', type:'number'},
            {label:'Tint Sample', fieldName:'HAPL_Tint_Samples__c', type:'number'}
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
            [{label:'Serial No.', fieldName:'Name', type:'text'},
            {label:'Type', fieldName:'Equipment_Type__c', type:'text'},
            {label:'Shipment Date', fieldName:'Shipment_Date__c', type:'date'},
            {label:'Installation Date', fieldName:'Installation_Date__c',type:'date'},
            {label:'Model', fieldName:'Model2__c', type:'text'},
            {label:'Brand', fieldName:'Brand2__c', type:'text'},
            {label:'Term Id', fieldName:'HAPL_Hoyalog_Term_ID__c', type:'text'}
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
                {label:'Serial', fieldName:'Name', type:'text'},
                {label:'H/W', fieldName:'HW_Brand__c', type:'text'},
                {label:'Model', fieldName:'HW_Model__c', type:'text'},
                {label:'Type', fieldName:'HW_Subtype__c', type:'text'},
                {label:'VR Type', fieldName:'Model2__c', type:'text'},
                {label:'SubType', fieldName:'Subtype__c', type:'text'}
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
    */
    getInstrumentInShop : function(component, recordId, callback){
        component.set('v.myColumn1',
            [
                {label:'Equipment Serial Number', fieldName:'Name', type:'text'},
                {label:'Brand', fieldName:'Brand2__c', type:'text'},
                {label:'Model', fieldName:'Model2__c', type:'text'},
                {label:'Subtype', fieldName:'Subtype__c', type:'text'},
                {label:'Shipment Date', fieldName:'Shipment_date__c', type:'date'},
                {label:'Installation Date', fieldName:'Installation_Date__c', type:'date'}
            ]
        );

        var action = component.get('c.getInstruInShop');
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
    getSoftwareInShop : function(component, recordId, callback){
        component.set('v.myColumn2', 
            [
                {label:'Equipment Serial Number', fieldName:'Name', type:'text'},
                {label:'Brand', fieldName:'Brand2__c', type:'text'},
                {label:'Model', fieldName:'Model2__c', type:'text'},
                {label:'Subtype', fieldName:'Subtype__c', type:'text'},
                {label:'Shipment Date', fieldName:'Shipment_date__c', type:'date'},
                {label:'Installation Date', fieldName:'Installation_Date__c', type:'date'}
            ]
        );
        var action = component.get('c.getSoftwareInShop');
        action.setParams({"recordId":recordId});

        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection');
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

    getLensHoyaIdentifier : function(component, helper){
        //this class for generic design chart SV, BF, PAL - Rx Lens
        var action = component.get('c.getHoyaIdentifierEMEA');
        var recordId= component.get('v.recordId');
        action.setParams({"recordId":recordId});
        console.log('Get data for pie-chart 1 with account id:Current FY '+recordId);

        action.setCallback(this, function(response){
            var state = response.getState();

            if(state === 'SUCCESS'){
                let val = response.getReturnValue();
                var labelset = [];
                var dataset = [];

                val.forEach(function(key){
                    labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                    //console.log('Label is '+labelset.push(key.label));
                    dataset.push(key.qty);
                    //console.log('Data is '+dataset.push(key.amount));
                });

                var linechart1 = {
                    labels : labelset,
                    datasets : [{
                        label : 'Qty',
                        backgroundColor: 'rgb(255, 99, 132)',
                        borderColor: 'rgb(255, 99, 132)',
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data : dataset
                    }]
                };

                var optionLinechart1 = {
                    responsive : true,
                    legend :{
                        display : false,
                        position : 'right'
                    },
                    title : {
                        display : true,
                        text : 'Hoyaidentifier'
                    }
                };

                const config1 = {
                    type : 'line',
                    data : linechart1,
                    options : optionLinechart1
                };

                var el1 = component.find('line-chart1').getElement();
                var ctx1 = el1.getContext('2d');
                try{
                    var linechart1 = new Chart(ctx1, config1);
                }catch(error){
                    alert(error);
                    console.log('Error : '+error);
                }

            }else{
                console.log('Error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },

    //Get Hoyailog for Chart below

    getHoyaiLogforChart : function(component, helper){

        var action = component.get('c.getHoyaIlogForChart');
        var recordId = component.get('v.recordId');
        action.setParams({"recordId":recordId});

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                let val = response.getReturnValue();
                var labelset = [];
                var dataset = [];

                val.forEach(function(key){
                    labelset.push(key.label.substr(-2)+'/'+key.label.substring(0,4));
                    //console.log('Label is '+labelset.push(key.label));
                    dataset.push(key.qty);
                    //console.log('Data is '+dataset.push(key.amount));
                });

                var linechart2 = {
                    labels : labelset,
                    datasets : [{
                        label : 'Qty',
                        backgroundColor: 'rgb(255, 99, 132)',
                        borderColor: 'rgb(255, 99, 132)',
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data : dataset
                    }]
                };

                var optionLinechart2 = {
                    responsive : true,
                    legend :{
                        display : false,
                        position : 'right'
                    },
                    title : {
                        display : true,
                        text : 'Hoyailog Order'
                    }
                };

                const config2 = {
                    type : 'line',
                    data : linechart2,
                    options : optionLinechart2
                };

                var el2 = component.find('line-chart2').getElement();
                var ctx2 = el2.getContext('2d');
                try{
                    var linechart2 = new Chart(ctx2, config2);
                }catch(error){
                    alert(error);
                    console.log('Error : '+error);
                }

            }else{
                console.log('Error during the connection.');
            }
        });
        $A.enqueueAction(action);
    }
})