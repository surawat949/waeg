({
    doInit : function(component, event, helper) {
   
        helper.initPickList(component, helper, function(err, result){
            component.set('v.countryList', result);
        });
        helper.initPickListNetwork(component, helper, function(err, result){
            component.set('v.networkList', result);
        });
        helper.getWinnerList(component, helper, function(err, result){
            //alert(err);
        });
        var opts = [
            { value: "", label: "" },
            { value: "01", label: "January" },
            { value: "02", label: "February" },
            { value: "03", label: "March" },
            { value: "04", label: "April" },
            { value: "05", label: "May" },
            { value: "06", label: "June" },
            { value: "07", label: "July" },
            { value: "08", label: "August" },
            { value: "09", label: "September" },
            { value: "10", label: "October" },
            { value: "11", label: "November" },
            { value: "12", label: "December" }
        ];
        component.set("v.monthList", opts);

        var year = [];
        year.push({ label: '', value: '' })
        for(let i=2021; i<=2050; i++){
            year.push({ label: i, value: i })
        }
        component.set("v.yearList", year);

        component.set('v.mycolumns', [
            {label: 'Month', fieldName: 'Month', type: 'text'},
            {label: 'Year', fieldName: 'Year', type: 'text'},
            {label: 'Name', fieldName: 'Id', 
                 typeAttributes: {
                     label: { fieldName: 'Name' },
                     target: '_blank'
                 },
             	 type: 'url'},
             
            /* typeAttributes: {
                	label: { fieldName: 'Name' }
              		}, type: 'url',target: '_blank'},*/
              {label: 'Email', fieldName: 'Email', type: 'text'},
              {label: 'AccountName', fieldName: 'AccountName', type: 'text'},
              {label: 'HoyaAccountId', fieldName: 'HoyaAccountId', type: 'text'},
              {label: 'WinnerDate', fieldName: 'WinnerDate', type: 'text'},
              {label: 'RegistrationDate', fieldName: 'RegistrationDate', type: 'text'},
              {label: 'Choice', fieldName: 'Choice', type: 'text'},
              {label: 'Country', fieldName: 'Country', type: 'text'},
              {label: 'Network', fieldName: 'Network', type: 'text'},
              {label: 'Delete', type: 'button', initialWidth: 135, typeAttributes: { label: 'Delete', name: 'Delete', title: 'Delete'}}
            ]);

    },
    pickaWinner:function(component, event, helper) {
        var country = component.get('v.country');
        var month = component.get('v.month');
        var year = component.get('v.year');
        var network = component.get('v.network');

        if(country=='' || month=='' || year==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Please select country, month and year "
            });
            toastEvent.fire();
        } else {

            helper.getPickaWinner(component, helper, function(err, result){
                helper.getWinnerList(component,helper, function(err2, result2){
                });
                if(result==null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Warning!",
                        "message": "No more patient registered in the database"
                    });
                    toastEvent.fire();

                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Winner is " + result.Name
                    });
                    toastEvent.fire();
                }
            });
        }
        
    },
    //Special Context code Start INC-11219
    specialContest:function(component, event, helper) {
        var country = component.get('v.countryInSpecialContest');
        var month = component.get('v.monthInSpecialContest');
        var year = component.get('v.yearInSpecialContest');
        var email = component.get('v.emailInSpecialContest');

        if(country=='' || month=='' || year=='' || email==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Please select country, month, year and email"
            });
            toastEvent.fire();
        } else {

             helper.pickWinner(component, helper, function(err, result){
                
                if(result==null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Warning!",
                        "message": "No more patient registered in the database"
                    });
                    toastEvent.fire();

                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Winner is " + result.Name
                    });
                    toastEvent.fire();
                }
            });
        }
        
    },
     //Special Context End INC-11219
    handleRowAction: function (component, event, helper) {
        //var action = event.getParam('action');
      /*  var row = event.getParam('row');
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'view_details':
                window.open(row.recordId, "_blank");
                break;
            default:
        }*/
        helper.removeWinner(component, row.recordId, function(err,message){
            if(err!='SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Winner cannot be removed (" +err+ ")"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Winner removed"
                    });
                    toastEvent.fire();
            }
        });
        helper.getWinnerList(component, helper, function(err,result){
        });
    },
    countryFilter: function(component, event, helper){
        var filter = component.get('v.countryFilter');
        helper.getWinnerList(component, helper, function(err,result){
        });
    },
    checkRegistration: function(component, event, helper){
        var code = component.get('v.checkCode');
        var country = component.get('v.countryCheck');
        helper.checkRegistration(component, code, country, function(err, result){
            if(result==null){
                component.set('v.checkResult', 'No result found');
                //component.set('v.checkResult', message);
                var checkDiv = component.find('checkStyle');
                $A.util.removeClass(checkDiv, 'slds-text-color_success');
                $A.util.addClass(checkDiv, 'slds-text-color_error');
            } else {
                var message='OK - that product was registered on ' + result.RegistrationDate__c + ' for patient ' + result.Contact__r.Name + ' and ECP ' + result.Contact__r.Account_Name__c;
                component.set('v.checkResult', message);
                var checkDiv = component.find('checkStyle');
                $A.util.removeClass(checkDiv, 'slds-text-color_error');
                $A.util.addClass(checkDiv, 'slds-text-color_success');
            }
        });

    }
})