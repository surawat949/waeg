({
    init: function (component, event, helper) {

        var myJson = [];
        var recordId = component.get('v.recordId');
        var competittorName = component.get('v.globalCompetitor');
        console.log('XXX Get competitor name '+competittorName);
        helper.getNearbyAccount(component, recordId, function(err, result){
            //alert('result size =' + result.length)
            for(var i=0; i<result.length;i++){
                var icon = 'standard:account';
                var color='red';
                var visitflag = 'R';

                if(i==0){
                    icon = 'standard:account';
                    color='Blue';
                    console.log(new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].AnnualRevenue));

                    if(result[i].Visits_performed__c == 0 || result[i].Visits_performed__c < result[i].Agreed_Visits__c){
                        visitflag = 'R';
                    }else if(result[i].Visits_performed__c < result[i].Agreed_Visits__c){
                        visitflag = 'Y';
                    }else if(result[i].Visits_performed__c > result[i].Agreed_Visits__c){
                        visitflag = 'G';
                    }else{
                        visitflag = 'U';
                    }

                    var place ={location:{"Latitude": result[i].ShippingLatitude,
                                    "Longitude": result[i].ShippingLongitude,
                                    "Street": result[i].ShippingStreet,
                                    "City" : result[i].ShippingCity,
                                    "State" : result[i].ShippingState,
                                    "PostalCode" : result[i].ShippingPostalCode,
                                    "Country" : result[i].ShippingCountry
                        },
                        mapIcon : {
                            path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                            fillColor: '#3338FF',
                            fillOpacity: .7,
                            strokeWeight: 1,
                            scale: .15,
                        },
                            "value": result[i].Id,
                            "icon": icon,
                            "title": result[i].Name,
                            "description": result[i].Hoya_Account_ID__c +'<br/>Brand: '+result[i].Brand__c+'<br/>Segmentation Pre-covid : '+result[i].Segmentation_Box__c+'<br/>SValue: '+result[i].CurrencyIsoCode+' '+new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].Potential__c)+'<br/>Last 12 Months Sales : '+result[i].CurrencyIsoCode+' '+new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].AnnualRevenue)+'<br/><br/>1st Global Name : '+result[i].First_Competitor_global_name__c+'<br/>1st Local Name : '+result[i].First_Competitor_local_name__c+'<br/>1st SOW: '+result[i].First_Competitor_SOW__c+'<br/><br/>'+result[i].ShippingStreet+ '&nbsp;' +result[i].ShippingCity+ '<br/>' +result[i].ShippingPostalCode+'<br/>Phone: '+result[i].Phone+'<br/>Last Visit Date: '+new Date(result[i].Last_Visit_date__c).toLocaleDateString('en-GB')+'<br/>Shop Visit Frequency '+result[i].Visit_Frequency_Status__c};
                        
                        myJson.push(place);        

                }else{
                    if(result[i].Account_Status__c == 'Prospect'){
                        if(result[i].Visits_performed__c == 0 || result[i].Visits_performed__c < result[i].Agreed_Visits__c){
                            visitflag = 'R';
                        }else if(result[i].Visits_performed__c < result[i].Agreed_Visits__c){
                            visitflag = 'Y';
                        }else if(result[i].Visits_performed__c > result[i].Agreed_Visits__c){
                            visitflag = 'G';
                        }else{
                            visitflag = 'U';
                        }
                        console.log('Account Status : '+result[i].Account_Status__c);
                        var place ={location:{"Latitude": result[i].ShippingLatitude,
                                    "Longitude": result[i].ShippingLongitude,
                                    "Street": result[i].ShippingStreet,
                                    "City": result[i].ShippingCity,
                                    "State": result[i].ShippingState,
                                    "Postalcode" : result[i].ShippingPostalCode,
                                    "Country":result[i].ShippingCountry
                        },
                        mapIcon : {
                            path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                            fillColor: '#FFFF50',
                            fillOpacity: 1,
                            strokeWeight: 1,
                            scale: .15,
                        },
                            "value": result[i].Id,
                            "icon": icon,
                            "title": result[i].Name,
                            "description": result[i].Hoya_Account_ID__c +'<br/>Brand: '+result[i].Brand__c+'<br/> Segmentation Pre-Covid : '+result[i].Segmentation_Box__c+'<br/>SValue: '+result[i].CurrencyIsoCode+' '+new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].Potential__c)+'<br/>Last 12 Months Sales : '+result[i].CurrencyIsoCode+' '+new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].AnnualRevenue)+'<br/><br/>1st Global Name : '+result[i].First_Competitor_global_name__c+'<br/>1st Local Name : '+result[i].First_Competitor_local_name__c+'<br/>1st SOW: '+result[i].First_Competitor_SOW__c+'<br/><br/>'+result[i].ShippingStreet+ '&nbsp;' +result[i].ShippingCity+ '<br/>' +result[i].ShippingPostalCode+'<br/>Phone: '+result[i].Phone+'<br/>Last Visit Date: '+new Date(result[i].Last_Visit_date__c).toLocaleDateString('en-GB')+'<br/>Shop Visit Frequency '+result[i].Visit_Frequency_Status__c};
                        
                        myJson.push(place);        
                    }else{
                        if(result[i].Visits_performed__c == 0 || result[i].Visits_performed__c < result[i].Agreed_Visits__c){
                            visitflag = 'R';
                        }else if(result[i].Visits_performed__c < result[i].Agreed_Visits__c){
                            visitflag = 'Y';
                        }else if(result[i].Visits_performed__c > result[i].Agreed_Visits__c){
                            visitflag = 'G';
                        }else{
                            visitflag = 'U';
                        }
                        var place ={location:{"Latitude": result[i].ShippingLatitude,
                                    "Longitude": result[i].ShippingLongitude,
                                    "Street": result[i].ShippingStreet,
                                    "City" : result[i].ShippingCity,
                                    "State" : result[i].ShippingState,
                                    "Postalcode" : result[i].ShippingPostalCode,
                                    "Country" : result[i].ShippingCountry
                                },
                                "value": result[i].Id,
                                "icon":  icon,
                                "title": result[i].Name,
                                "description": result[i].Hoya_Account_ID__c +'<br/>Brand: '+result[i].Brand__c+'<br/>Segmentation Pre-Covid : '+result[i].Segmentation_Box__c+'<br/>SValue: '+result[i].CurrencyIsoCode+' '+new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].Potential__c)+'<br/>Last 12 Months Sales : '+result[i].CurrencyIsoCode+' '+new Intl.NumberFormat('en-US', {maximumFractionDigits:2}).format(result[i].AnnualRevenue)+'<br/><br/>1st Global Name : '+result[i].First_Competitor_global_name__c+'<br/>1st Local Name : '+result[i].First_Competitor_local_name__c+'<br/>1st SOW: '+result[i].First_Competitor_SOW__c+'<br/><br/>'+result[i].ShippingStreet+ '&nbsp;' +result[i].ShippingCity+ '<br/>' +result[i].ShippingPostalCode+'<br/>Phone: '+result[i].Phone+'<br/>Last Visit Date: '+new Date(result[i].Last_Visit_date__c).toLocaleDateString('en-GB')+'<br/>Shop Visit Frequency '+result[i].Visit_Frequency_Status__c};
                
                        myJson.push(place);
                    }
                }

                
            }
            //first result is contact position, use for center map
            component.set('v.center', {
                location: {
                    Latitude: result[0].ShippingLatitude,
                    Longitude: result[0].ShippingLongitude
                },
            });
            console.log('XXX Map Maker phase to JSON = '+JSON.stringify(myJson));
            component.set('v.mapMarkers', myJson);
        });
        
        /*
        var value = component.get('v.globalCompetitor');
        if(value!=null && value!='' && value!='undefined'){
            cmp.find("options").set("v.value",value);
        }
        */
        /*
        var value =  component.get('v.svsnetwork');
        if(value!=null && value!='' && value!='undefined'){
            cmp.find("select").set("v.value",value);
        }
        */
        
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