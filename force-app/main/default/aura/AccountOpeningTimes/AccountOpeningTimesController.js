({
    doInit : function (cmp, event, helper){
        var recordId = cmp.get('v.recordId');
        helper.getTime(cmp, recordId, function(err, result){
            //alert((result));
            //decode json string
            const times = JSON.parse(result);
            cmp.set('v.OAM1', times.days[1].openAM);
            cmp.set('v.CAM1', times.days[1].closeAM);
            cmp.set('v.OPM1', times.days[1].openPM);
            cmp.set('v.CPM1', times.days[1].closePM);
            
            cmp.set('v.OAM2', times.days[2].openAM);
            cmp.set('v.CAM2', times.days[2].closeAM);
            cmp.set('v.OPM2', times.days[2].openPM);
            cmp.set('v.CPM2', times.days[2].closePM);
            
            cmp.set('v.OAM3', times.days[3].openAM);
            cmp.set('v.CAM3', times.days[3].closeAM);
            cmp.set('v.OPM3', times.days[3].openPM);
            cmp.set('v.CPM3', times.days[3].closePM);

            cmp.set('v.OAM4', times.days[4].openAM);
            cmp.set('v.CAM4', times.days[4].closeAM);
            cmp.set('v.OPM4', times.days[4].openPM);
            cmp.set('v.CPM4', times.days[4].closePM);
            
            cmp.set('v.OAM5', times.days[5].openAM);
            cmp.set('v.CAM5', times.days[5].closeAM);
            cmp.set('v.OPM5', times.days[5].openPM);
            cmp.set('v.CPM5', times.days[5].closePM);
            
            cmp.set('v.OAM6', times.days[6].openAM);
            cmp.set('v.CAM6', times.days[6].closeAM);
            cmp.set('v.OPM6', times.days[6].openPM);
            cmp.set('v.CPM6', times.days[6].closePM);
            
            cmp.set('v.OAM7', times.days[7].openAM);
            cmp.set('v.CAM7', times.days[7].closeAM);
            cmp.set('v.OPM7', times.days[7].openPM);
            cmp.set('v.CPM7', times.days[7].closePM);
        });
    },
    /*handleSave : function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        let jsonStr ='{"startOfWeekDay":1,'
        +'"days":{'
            +'"1":["'+cmp.get('v.OAM1').substring(0,5)+'", "'+cmp.get('v.CAM1').substring(0,5)+'","'+cmp.get('v.OPM1').substring(0,5)+'","'+cmp.get('v.CPM1').substring(0,5)+'"],'
            +'"2":["'+cmp.get('v.OAM2').substring(0,5)+'", "'+cmp.get('v.CAM2').substring(0,5)+'","'+cmp.get('v.OPM2').substring(0,5)+'","'+cmp.get('v.CPM2').substring(0,5)+'"],'
            +'"3":["'+cmp.get('v.OAM3').substring(0,5)+'", "'+cmp.get('v.CAM3').substring(0,5)+'","'+cmp.get('v.OPM3').substring(0,5)+'","'+cmp.get('v.CPM3').substring(0,5)+'"],'
            +'"4":["'+cmp.get('v.OAM4').substring(0,5)+'", "'+cmp.get('v.CAM4').substring(0,5)+'","'+cmp.get('v.OPM4').substring(0,5)+'","'+cmp.get('v.CPM4').substring(0,5)+'"],'
            +'"5":["'+cmp.get('v.OAM5').substring(0,5)+'", "'+cmp.get('v.CAM5').substring(0,5)+'","'+cmp.get('v.OPM5').substring(0,5)+'","'+cmp.get('v.CPM5').substring(0,5)+'"],'
            +'"6":["'+cmp.get('v.OAM6').substring(0,5)+'", "'+cmp.get('v.CAM6').substring(0,5)+'","'+cmp.get('v.OPM6').substring(0,5)+'","'+cmp.get('v.CPM6').substring(0,5)+'"],'
            +'"7":["'+cmp.get('v.OAM7').substring(0,5)+'", "'+cmp.get('v.CAM7').substring(0,5)+'","'+cmp.get('v.OPM7').substring(0,5)+'","'+cmp.get('v.CPM7').substring(0,5)+'"]'
            +'}'
        +'}';
        
        alert(jsonStr);
        helper.updateTime(cmp, recordId, jsonStr, function(err, result){
            alert('err=' + err);
        })
    },*/
    handleSave : function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        let jsonStr ='{"startOfWeekDay":1,'
        +'"days":{'
            +'"1":{"openAM":"'+cmp.get('v.OAM1').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM1').substring(0,5)+'","openPM":"'+cmp.get('v.OPM1').substring(0,5)+'","closePM":"'+cmp.get('v.CPM1').substring(0,5)+'"},'
            +'"2":{"openAM":"'+cmp.get('v.OAM2').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM2').substring(0,5)+'","openPM":"'+cmp.get('v.OPM2').substring(0,5)+'","closePM":"'+cmp.get('v.CPM2').substring(0,5)+'"},'
            +'"3":{"openAM":"'+cmp.get('v.OAM3').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM3').substring(0,5)+'","openPM":"'+cmp.get('v.OPM3').substring(0,5)+'","closePM":"'+cmp.get('v.CPM3').substring(0,5)+'"},'
            +'"4":{"openAM":"'+cmp.get('v.OAM4').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM4').substring(0,5)+'","openPM":"'+cmp.get('v.OPM4').substring(0,5)+'","closePM":"'+cmp.get('v.CPM4').substring(0,5)+'"},'
            +'"5":{"openAM":"'+cmp.get('v.OAM5').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM5').substring(0,5)+'","openPM":"'+cmp.get('v.OPM5').substring(0,5)+'","closePM":"'+cmp.get('v.CPM5').substring(0,5)+'"},'
            +'"6":{"openAM":"'+cmp.get('v.OAM6').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM6').substring(0,5)+'","openPM":"'+cmp.get('v.OPM6').substring(0,5)+'","closePM":"'+cmp.get('v.CPM6').substring(0,5)+'"},'
            +'"7":{"openAM":"'+cmp.get('v.OAM7').substring(0,5)+'", "closeAM":"'+cmp.get('v.CAM7').substring(0,5)+'","openPM":"'+cmp.get('v.OPM7').substring(0,5)+'","closePM":"'+cmp.get('v.CPM7').substring(0,5)+'"}'
            +'}'
        +'}';
        
        //alert(jsonStr);
        helper.updateTime(cmp, recordId, jsonStr, function(err, result){
            //alert('err=' + err);
        })
    }
})