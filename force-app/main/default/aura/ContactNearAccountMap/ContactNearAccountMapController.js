({
    init: function (component, event, helper) {

        var myJson = [];
        var recordId = component.get('v.recordId');
        helper.getNearAccount(component, recordId, function(err, result){
            //alert('result size =' + result.length)
            for(var i=0; i<result.length;i++){
                var icon = 'standard:contact';
                var color='red';

                if(i==0){
                    icon = 'standard:contact';
                    color='Blue';
                    
                    var place ={location:{"Latitude": result[i].MailingLatitude,
                                    "Longitude": result[i].MailingLongitude,
                                    "Street": result[i].MailingStreet
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
                                "description":  'Miyosmart Attitude:' +result[i].MiyoSmart_Attitude__c + '<br/>'+ 'Last Contact Visit Day:' + result[i].Last_contact_visit_date__c+'<br/>' +'Preferred Contact Method:' + result[i].Preferred_contact_method__c + '<br/>' + 'Related Account Name:' + result[i].Account.Name
                                            + '<br/>'+ 'Contact Address: ' + result[i].MailingStreet + ' ' +result[i].MailingCity + ' ' + result[i].MailingPostalCode};
                
                    myJson.push(place);
                } else {
                
                    var place ={location:{"Latitude": result[i].MailingLatitude,
                                    "Longitude": result[i].MailingLongitude,
                                    "Street": result[i].MailingStreet
                                },
                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Name,
                                "description": 'Miyosmart Attitude: ' +result[i].MiyoSmart_Attitude__c + '<br/>'+ 'Last Contact Visit Day: ' + result[i].Last_contact_visit_date__c+'<br/>' +'Preferred Contact Method: ' + result[i].Preferred_contact_method__c + '<br/>' + 'Related Account Name: ' + result[i].Account.Name
                                         + '<br/>'+ 'Contact Address: ' + result[i].MailingStreet + ' ' +result[i].MailingCity + ' ' + result[i].MailingPostalCode};
                
                    myJson.push(place);
                }

                
            }
            //first result is contact position, use for center map
            component.set('v.center', {
                location: {
                    Latitude: result[0].MailingLatitude,
                    Longitude: result[0].MailingLongitude
                },
            });
            component.set('v.mapMarkers', myJson);
        });

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