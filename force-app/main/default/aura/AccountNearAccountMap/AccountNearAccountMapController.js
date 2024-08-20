({
    init: function (component, event, helper) {

        var myJson = [];
        var recordId = component.get('v.recordId');
        helper.getNearAccount(component, recordId, function(err, result){
            //alert('result size =' + result.length)
            for(var i=0; i<result.length;i++){
                var icon = 'standard:account';
                var color='red';

                if(i==0){
                    icon = 'standard:contact';
                    color='Blue';
                    
                    var place ={location:{"Latitude": result[i].ShippingLatitude,
                                    "Longitude": result[i].ShippingLongitude,
                                    "Street": result[i].ShippingStreet
                                },
                                mapIcon : {
                                    path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                    fillColor: '#CF3476',
                                    fillOpacity: .5,
                                    strokeWeight: 1,
                                    scale: .10,
                                },
                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Name,
                                "description": result[i].Hoya_Account_ID__c +'<br/>' +result[i].Name + '<br/>'+ result[i].ShippingStreet+'<br/>' +result[i].ShippingPostalCode + ' ' + result[i].ShippingCity};
                
                    myJson.push(place);
                } else {
                
                    var place ={location:{"Latitude": result[i].ShippingLatitude,
                                    "Longitude": result[i].ShippingLongitude,
                                    "Street": result[i].ShippingStreet
                                },
                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Name,
                                "description": result[i].Hoya_Account_ID__c +'<br/>' +result[i].Name + '<br/>'+result[i].Potential__c+ '<br/>'+result[i].First_Competitor_local_name__c + '<br/>'+ result[i].ShippingStreet+'<br/>' +result[i].ShippingPostalCode + ' ' + result[i].ShippingCity};
                
                    myJson.push(place);
                }

                
            }
            //first result is contact position, use for center map
            component.set('v.center', {
                location: {
                    Latitude: result[0].ShippingLatitude,
                    Longitude: result[0].ShippingLongitude
                },
            });
            component.set('v.mapMarkers', myJson);
        });
        var value =  component.get('v.svsnetwork');
        if(value!=null && value!='' && value!='undefined'){
            cmp.find("select").set("v.value",value);
        }
    },

    handleMarkerSelect: function (component, event, helper) {
        var marker = event.getParam("selectedMarkerValue");
        var link = 'https://' + window.location.hostname + '/lightning/r/Account/' + marker +'/view';
        window.open(link, "_blank");
    },
    displayList:function(component, event, helper){
        component.set('v.displayListView', 'visible');
    },
    hideList:function(component, event, helper){
        component.set('v.displayListView', 'hidden');
    }

})