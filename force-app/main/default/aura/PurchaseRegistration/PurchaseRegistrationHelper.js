({
    initPickList :function(component, helper, callback){
        var action = component.get("c.getCountryList");
        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);

    },
    initPickListNetwork :function(component, helper, callback){
        var action = component.get("c.getSeikoNetworkList");
        action.setCallback(this, function(response){
            callback(null, response.getReturnValue());
        });
        $A.enqueueAction(action);

    },
    getWinnerList:function(component, helper, callback){
        var action = component.get("c.GetWinnerList");
        var country = component.get('v.countryFilter');
        action.setParams({all:false, country:country});
        action.setCallback(this, function(response){
            let data = [];
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let data = [];
                response.getReturnValue().forEach((row)=>{
                    let obj = {
                        Name: row.Contact__r.Name,
                        Id:'/'+row.Contact__c,
                        Email: row.Contact__r.Email,
                        HoyaAccountId: row.Contact__r.Hoya_Account_Id__c,
                        AccountName: row.Contact__r.Account_Name__c,
                        WinnerDate: row.winner_date__c.substring(0,10),
                        RegistrationDate: row.RegistrationDate__c,
                        Month:row.winner_date__c.substring(5,7),
                        Year:row.winner_date__c.substring(0,4),
                        Country:row.Contact__r.Account.Owner.Country,
                        recordId: row.Id,
                        Choice:row.MembersOnlyChoiceLabel__c,
                        Country: row.Contact__r.Account.Owner.Country__c,
                        Network: row.Contact__r.Account.Seiko_Network__c
                    }
                    data.push(obj);
                });
                component.set('v.winnerList', data);
                callback(null, response.getReturnValue());
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getPickaWinner:function(component, helper, callback){
        var action = component.get("c.getPickaWinner");
        var country = component.get('v.country');
        var month = component.get('v.month');
        var year = component.get('v.year');
        var network = component.get('v.network');
        var buyingGroup = component.get('v.buyingGroup');

        action.setParams({country:country, month:month, year: year, network:network, buyingGroup:buyingGroup});
        action.setCallback(this, function(response){
          
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let row = response.getReturnValue();
                if(row!=null){
                    let obj = {
                        Name: row.Contact__r.Name,
                        Id:'/'+row.Contact__c,
                        Email: row.Contact__r.Email,
                        HoyaAccountId: row.Contact__r.Hoya_Account_Id__c,
                        AccountName: row.Contact__r.Account_Name__c,
                        WinnerDate: row.winner_date__c.substring(0,10),
                        RegistrationDate: row.RegistrationDate__c,
                        Month:row.winner_date__c.substring(5,7),
                        Year:row.winner_date__c.substring(0,4),
                        Country:row.Contact__r.Account.Owner.Country
                    }
                    callback(null, obj);
                } else {
                    callback('ERROR', null);
                }
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    removeWinner: function(component, recordId, callback){
        var action = component.get("c.removeWinner");
        action.setParams({recordId: recordId});
        action.setCallback(this, function(response){
            callback(response.getState(), response.getError());
        });
        $A.enqueueAction(action);
    },
    checkRegistration: function(component, code, country, callback){
        var action = component.get("c.checkRegistrationCode");
        action.setParams({code: code, country:country});
        action.setCallback(this, function(response){
            callback(response.getError(), response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
        
    //Special Context code Start INC-11219    
     pickWinner:function(component, helper, callback){
        var action = component.get("c.pickWinnerRandomly");
        var country = component.get('v.countryInSpecialContest');
        var month = component.get('v.monthInSpecialContest');
        var year = component.get('v.yearInSpecialContest');
        var email = component.get('v.emailInSpecialContest');

        action.setParams({country:country, month:month, year: year, email:email});
        action.setCallback(this, function(response){
          
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                let row = response.getReturnValue();
                if(row!=null){
                    let obj = {
                        Name: row.Contact__r.Name,
                        Id:'/'+row.Contact__c,
                        Email: row.Contact__r.Email,
                        HoyaAccountId: row.Contact__r.Hoya_Account_Id__c,
                        AccountName: row.Contact__r.Account_Name__c,
                        WinnerDate: row.winner_date__c.substring(0,10),
                        RegistrationDate: row.RegistrationDate__c,
                        Month:row.winner_date__c.substring(5,7),
                        Year:row.winner_date__c.substring(0,4),
                        Country:row.Contact__r.Account.Owner.Country
                    }
                    callback(null, obj);
                } else {
                    callback('ERROR', null);
                }
            }
            else if (component.isValid() && state === "ERROR") {
                callback(response.getError(), response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }    

 //Special Context code END INC-11219
        
})