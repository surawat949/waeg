({
    doInit : function(component, event, helper) {
        
        var recordId = component.get('v.recordId');
        const theTime = new Date();
        const theDate = new Date();
        //const theTime2 = new Date();
        
        theTime.setDate(theTime.getDate());
        theDate.setDate(theDate.getDate()-7);
        console.log('XXX Get Date Last 7 Days == > '+JSON.stringify(theDate.toISOString().split('T')[0]));
        //theTime2.setHours(theTime2.getHours());

        //component.find('select1').set('v.value', 'Complete');

        var startDay = component.get('v.datetime1');

        if(startDay==null){
            startDay = theDate.toISOString().split('T')[0];
            component.set('v.datetime1', theTime.toISOString().split('T')[0]);    
        }else{
            startDay = component.get('v.datetime1');
        }

        var Visit_Status = component.get('v.VisitStatus');
        if(Visit_Status==null || Visit_Status==''){
            component.set('v.VisitStatus', 'Complete');
        }else{
            Visit_Status = component.get('v.VisitStatus');
        }
        /*
        var endDay = component.get('v.datetime2');
        if(endDay==null){
            component.set('v.datetime2', theTime2.toISOString());
        }else{
            endDay = component.get('v.datetime2');
        }*/

        var datetime1 = component.get('v.datetime1');
        if(datetime1==null){datetime1=startDay;}

        var VisitStatus = component.get('v.VisitStatus');
        var LastVisitDay = component.get('v.LastVisit');
        if(VisitStatus==null || VisitStatus==''){VisitStatus='Complete';}
        if(LastVisitDay == null || LastVisitDay == ''){LastVisitDay='LAST_N_DAYS:7';}
        console.log('XXX Get Visit Status == > '+JSON.stringify(Visit_Status));

        /*
        var datetime2 = component.get('v.datetime2');
        if(datetime2==null){datetime2=endDay;}*/
        
        helper.getinitVisitsCounting(component, recordId, function(err, result){
            component.set('v.VisitCnt', result);
            console.log('XXX Fetch data for Inititialize Visit Counting Monthly Trend == > '+JSON.stringify(result));
        });

        helper.getInitsalesdata(component, recordId, function(err, result){
            component.set('v.sales', result);
            console.log('XXX Fetch data for get init Sales Figure == > '+JSON.stringify(result));
        });

        helper.getVisitStartDate(component, recordId, LastVisitDay, Visit_Status, function(err, result){
            component.set('v.searchVisitStart', result);
            console.log('XXX Fetch string data visit start date ==> '+JSON.stringify(result));
        });

        helper.callActionAsPromise(component,helper,'c.getColumnsAndData',{
            'sObjectName': component.get('v.sObjectName'),
            'sObjectFieldsNames': component.get('v.sObjectFieldsNames'),
            'recordId' : component.get('v.recordId'),
            'LastVisitDay' : component.get('v.LastVisit'),
            'VisitStatus' : component.get('v.VisitStatus')
        })
        .then(function(r) {
            component.set('v.columns', r.result.columns);            
            component.set('v.allData', r.result.data);
            component.set('v.filteredData', r.result.data);
            helper.preparePagination(component, r.result.data);   
        })
        /*
        helper.getCompletedVisitBySegment(component, recordId, function(err, result){
            component.set('v.CompletedVisits',result);
            console.log('XXX Get data completed visit last 30 days by segment : == >'+JSON.stringify(result));

            let val = result;
            var labelset = [];
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label);
                dataset.push(key.Qty);
            });
                var barchart01 = {
                    labels : labelset,
                    datasets : [{
                        label : 'Segmentation',
                        backgroundColor: ['rgb(255, 99, 132)', 'rgb(53,102,238)', 'rgb(31,145,69)', 'rgb(87,152,249)', 'rgb(249,152,87)', 'rgb(8,82,146)', 'rgb(27,141,114)', 'rgb(144,92,116)', 'rgb(71,56,135)'],
                        borderColor: ['#FFFFFF', '#FFFFFF', '#FFFFFF'],
                        pointBorderColor: "white",
                        pointBackgroundColor: "black",
                        pointBorderWidth: 1,
                        pointHoverRadius: 8,
                        pointHoverBackgroundColor: "brown",
                        pointHoverBorderColor: "yellow",
                        pointHoverBorderWidth: 2,
                        pointRadius: 4,
                        hoverOffset: 4,
                        pointHitRadius: 10,
                        fill: false,
                        data : dataset
                    }]
                };

                var option1 = {
                    responsvie : true,
                    showTooltips : true,
                    legend : {
                        display : true,
                        position : 'right'
                    },
                    title : {
                        display : true,
                        text : 'Completed Visits by Segmentation : Last 30 days'
                    },
                    tooltips : {
                        enabled : true
                    }
                };

                const config1 = {
                    type : 'horizontalBar',
                    data : barchart01,
                    options : option1
                };

                var el = component.find('barchart01').getElement();
                var ctx = el.getContext('2d');

                try{
                    var barchart1 = new Chart(ctx, config1);
                }catch(error){
                    alert(error);
                    console.log('XXX An error during rendering chart == > '+JSON.stringify(error));
                }
        });*/
        /*
        helper.getCompletedVisitBySubArea(component, recordId, function(err, result){
            component.set('v.CompletedVisitsSubArea', result);
            console.log('XXX Get Data Completed Visits by Sub-area == > '+JSON.stringify(result));

            let val = result;
            var labelset = [];
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label);
                dataset.push(key.Qty);
            });

            var barchart2 = {
                labels : labelset,
                datasets : [{
                    label : 'Sub-Area',
                    backgroundColor: ['rgb(255, 99, 132)', 'rgb(53,102,238)', 'rgb(31,145,69)', 'rgb(87,152,249)', 'rgb(249,152,87)', 'rgb(8,82,146)', 'rgb(27,141,114)', 'rgb(144,92,116)', 'rgb(71,56,135)'],
                    borderColor: ['#FFFFFF', '#FFFFFF', '#FFFFFF'],
                    pointBorderColor: "white",
                    pointBackgroundColor: "black",
                    pointBorderWidth: 1,
                    pointHoverRadius: 8,
                    pointHoverBackgroundColor: "brown",
                    pointHoverBorderColor: "yellow",
                    pointHoverBorderWidth: 2,
                    pointRadius: 4,
                    hoverOffset: 4,
                    pointHitRadius: 10,
                    fill: false,
                    data : dataset
                }]
            };

            var option2 = {
                responsvie : true,
                showTooltips : true,
                legend : {
                    display : true,
                    position : 'right'
                },
                title : {
                    display : true,
                    text : 'Completed Visits by Sub-Area : Last 30 days'
                },
                tooltips : {
                    enabled : true
                }
            };

            const config2 = {
                type : 'horizontalBar',
                data : barchart2,
                options : option2
            };

            var el = component.find('barchart02').getElement();
            var ctx = el.getContext('2d');

            try{
                var Barchart2 = new Chart(ctx, config2);
            }catch(error){
                alert(error);
                console.log('XXX An error was occurred during rendering chart == > '+JSON.stringify(error));
            }

        });*/

        var myjson = [];
        helper.getVisitDataMap(component, recordId, startDay, Visit_Status, function(err, result){
            console.log('XXX Get parameters : recordId='+JSON.stringify(recordId)+' Start Day='+JSON.stringify(startDay)+' Visit_Status = '+JSON.stringify(Visit_Status));
            
            if(result.length==0){
                result = 'No Vists Map Rendering Return';
                component.set('v.NoVisitReturn', result);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "No Visits Map",
                    "message": "No visit map rendering following your date range."
                });
                toastEvent.fire();
                var refresh = $A.get("e.force:refreshView");
                refresh.fire();

            }else{
                component.set('v.NoVisitReturn', 'Found Visit(s) List : '+result.length+'\n');
                for(var i=0;i<result.length;i++){
                    var icon = 'standard:address';
                    var color='red';
                    if(i==0){
                        if(result[i].Visited_Date_Behind__c>=0){
                            console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                            var place = {location:
                                {
                                    "Latitude":result[i].Shop_Latitude__c, 
                                    "Longitude":result[i].Shop_Longitude__c,
                                    "Street": result[i].Shop_Street__c,
                                    "City": result[i].Shop_City__c,
                                    "State": result[i].Shop_State__c,
                                    "Postalcode": result[i].Shop_Postal_Code__c,
                                    "Country":result[i].Shop_Country__c
                                },
                    
                            mapIcon : {
                                path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                fillColor: '#3338FF',
                                fillOpacity: .7,
                                strokeWeight: 1,
                                scale: 1.5,
                            },

                            "value": result[i].Id,
                            "icon": icon,
                            "title": result[i].Account__r.Name,
                            "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c

                            };
                            myjson.push(place);
                        }else if((result[i].Visited_Date_Behind__c>-7) && (result[i].Visited_Date_Behind__c<-3)){
                            console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                            var place = {location:
                                {
                                    
                                    "Latitude":result[i].Shop_Latitude__c, 
                                    "Longitude":result[i].Shop_Longitude__c,
                                    "Street": result[i].Shop_Street__c,
                                    "City": result[i].Shop_City__c,
                                    "State": result[i].Shop_State__c,
                                    "Postalcode": result[i].Shop_Postal_Code__c,
                                    "Country":result[i].Shop_Country__c
                                },
                    
                            mapIcon : {
                                path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                fillColor: '#f5b041',
                                fillOpacity: .7,
                                strokeWeight: 1,
                                scale: 1.5,
                            },
                            "value": result[i].Id,
                            "icon": icon,
                            "title": result[i].Account__r.Name,
                            "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c
                            
                            };
                            myjson.push(place);
                        }else if(result[i].Visited_Date_Behind__c<=-7){
                            console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                            var place = {location:
                                {
                                    "Latitude":result[i].Shop_Latitude__c, 
                                    "Longitude":result[i].Shop_Longitude__c,
                                    "Street": result[i].Shop_Street__c,
                                    "City": result[i].Shop_City__c,
                                    "State": result[i].Shop_State__c,
                                    "Postalcode": result[i].Shop_Postal_Code__c,
                                    "Country":result[i].Shop_Country__c
                                },
                    
                            mapIcon : {
                                path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                fillColor: '#922b21',
                                fillOpacity: .7,
                                strokeWeight: 1,
                                scale: 1.5,
                            },

                            "value": result[i].Id,
                            "icon": icon,
                            "title": result[i].Account__r.Name,
                            "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c

                            };
                            myjson.push(place);

                        }else{
                            console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                            var place = {
                            location : {

                                "Latitude":result[i].Shop_Latitude__c, 
                                "Longitude":result[i].Shop_Longitude__c,
                                "Street": result[i].Shop_Street__c,
                                "City": result[i].Shop_City__c,
                                "State": result[i].Shop_State__c,
                                "Postalcode": result[i].Shop_Postal_Code__c,
                                "Country":result[i].Shop_Country__c
                            },
                        
                            mapIcon : {
                                path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                fillColor: '#3338FF',
                                fillOpacity: 2,
                                strokeWeight: 1,
                                scale: 1.5,
                            },
                            "value": result[i].Id,
                            "icon": icon,
                            "title": result[i].Account__r.Name,
                            "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Account__r.Shop_Postal_Code__c+'<br/>'+result[i].Account__r.Shop_Country__c
                            };
                            myjson.push(place);
                        }
                        /*
                        icon = 'stardard:address';
                        color = 'red';
                        var place = {location:{"Latitude":result[i].Start_Location_Lattitude__c, 
                                "Longitude":result[i].Start_Location_Longitude__c,
                                "Street": result[i].Shop_Street__c,
                                "City": result[i].Shop_City__c,
                                "State": result[i].Shop_State__c,
                                "Postalcode": result[i].Shop_Postal_Code__c,
                                "Country":result[i].Shop_Country__c
                            },
                            /*
                            mapIcon : {
                                path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                fillColor: '#33d7ff',
                                fillOpacity: .7,
                                strokeWeight: 1,
                                scale: .15,
                            },*/
                            /*
                            "value": result[i].Id,
                            "icon": icon,
                            "title": 'SHOP ADDRESS '+' | '+result[i].Name+' | '+result[i].Account__r.Hoya_Account_ID__c+' '+result[i].Account__r.Name,
                            "description": 'Visit info : '+'<br/>Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Visit__r.Segmentation_Box__c+'<br/>Start : '+result[i].Visit__r.Start_Date_Time__c+'<br/>End : '+result[i].Visit__r.End_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective : '+result[i].Visit_Reason_Global__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c

                        };
                        myjson.push(place);
                        */
                    }else{
                            if(result[i].Visited_Date_Behind__c>=0){
                                console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                                var place = {location:
                                    {
                                        "Latitude":result[i].Shop_Latitude__c, 
                                        "Longitude":result[i].Shop_Longitude__c,
                                        "Street": result[i].Shop_Street__c,
                                        "City": result[i].Shop_City__c,
                                        "State": result[i].Shop_State__c,
                                        "Postalcode": result[i].Shop_Postal_Code__c,
                                        "Country":result[i].Shop_Country__c
                                    },
                        
                                mapIcon : {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: '#3338FF',
                                    fillOpacity: .7,
                                    strokeWeight: 1,
                                    scale: 1.5,
                                },

                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Account__r.Name,
                                "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c
    
                                };
                                myjson.push(place);

                            }else if((result[i].Visited_Date_Behind__c>-7) && (result[i].Visited_Date_Behind__c<-3)){
                                console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                                var place = {location:
                                    {
                                        "Latitude":result[i].Shop_Latitude__c, 
                                        "Longitude":result[i].Shop_Longitude__c,
                                        "Street": result[i].Shop_Street__c,
                                        "City": result[i].Shop_City__c,
                                        "State": result[i].Shop_State__c,
                                        "Postalcode": result[i].Shop_Postal_Code__c,
                                        "Country":result[i].Shop_Country__c
                                    },
                        
                                mapIcon : {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: '#f5b041',
                                    fillOpacity: .7,
                                    strokeWeight: 1,
                                    scale: 1.5,
                                },

                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Account__r.Name,
                                "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c
                                
                                };
                                myjson.push(place);

                            }else if(result[i].Visited_Date_Behind__c<=-7){
                                console.log('Visit Date Behind : '+result[i].Visited_Date_Behind__c);
                                var place = {location:
                                {
                                    "Latitude":result[i].Shop_Latitude__c, 
                                    "Longitude":result[i].Shop_Longitude__c,
                                    "Street": result[i].Shop_Street__c,
                                    "City": result[i].Shop_City__c,
                                    "State": result[i].Shop_State__c,
                                    "Postalcode": result[i].Shop_Postal_Code__c,
                                    "Country":result[i].Shop_Country__c
                                },
                        
                                mapIcon : {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: '#922b21',
                                    fillOpacity: .7,
                                    strokeWeight: 1,
                                    scale: 1.5,
                                },

                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Account__r.Name,
                                "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c
                                
                                };
                                myjson.push(place);

                            }else{
                                console.log('Visit Date Behind = : '+result[i].Visited_Date_Behind__c);
                                var place = {
                                    location : {
                                        "Latitude":result[i].Shop_Latitude__c, 
                                        "Longitude":result[i].Shop_Longitude__c,
                                        "Street": result[i].Shop_Street__c,
                                        "City": result[i].Shop_City__c,
                                        "State": result[i].Shop_State__c,
                                        "Postalcode": result[i].Shop_Postal_Code__c,
                                        "Country":result[i].Shop_Country__c
                                    },
                            
                                mapIcon : {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: '#3338FF',
                                    fillOpacity: 2,
                                    strokeWeight: 1,
                                    scale: 1.5,
                                },
                                "value": result[i].Id,
                                "icon": icon,
                                "title": result[i].Account__r.Name,
                                "description": 'Hoya Account Id : '+result[i].Account__r.Hoya_Account_ID__c+'<br/>Account Name : '+result[i].Account__r.Name+'<br/>Segmentation : '+result[i].Account__r.Segmentation_Box__c+'<br/>Start : '+result[i].Start_Date_Time__c+'<br/>End : '+result[i].End_Date_Time__c+'<br/>Visit Type : '+result[i].Visit_Type__c+'<br/>Visit Status : '+result[i].Visit_Status__c+'<br/>Visit Objective (APAC) : '+result[i].Visit_Reason_APAC__c+'<br/> Call to action note : '+result[i].Call_to_action_notes__c+'<br/>Shop Street : '+result[i].Shop_Street__c+'<br/>'+result[i].Shop_City__c+' '+result[i].Shop_State__c+' '+result[i].Shop_Postal_Code__c+'<br/>'+result[i].Shop_Country__c

                                };
                                myjson.push(place);
                            }
                        }
                    }
            }
            component.set('v.center', {
                location: {
                    Latitude: result[0].Shop_Latitude__c,
                    Longitude: result[0].Shop_Longitude__c,
                    Street : result[0].Shop_Street__c,
                    City : result[0].Shop_City__c,
                    State : result[0].Shop_State__c,
                    Country : result[0].Shop_Country__c,
                    Postalcode : result[0].Shop_Postal_Code__c
                },
            });
            console.log('XXX Map Maker phase to JSON = '+JSON.stringify(myjson));
            component.set('v.mapMarkers', myjson);

        });
        /*
        helper.getVisitRollupSummary(component, recordId, function(err, result){
            component.set('v.VisitSum', result);
            console.log('XXX Get Visits Data Roll-up summary : '+JSON.stringify(result));
        });initTotalVisits
        */
    },

    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    displayList:function(component, event, helper){
        component.set('v.displayListView', 'visible');
    },

    hideList:function(component, event, helper){
        component.set('v.displayListView', 'hidden');
    },

    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onFirst: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },
    
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
    
    onPageSizeChange: function(component, event, helper) {        
        helper.preparePagination(component, component.get('v.filteredData'), component.get('v.recordId'));
    },
    
    onChangeSearchPhrase : function (component, event, helper) {
        if ($A.util.isEmpty(component.get("v.searchByVisitStart"))) {
            let allData = component.get("v.allData");
            component.set("v.filteredData", allData);
            helper.preparePagination(component, allData);
        }
    },
    
    handleSearch : function (component, event, helper) {
        helper.searchRecordsBySearchPhrase(component);
        if($A.util.isEmpty(component.get('v.searchByVisitStart'))){
            let allData = component.get('v.allData');
            component.set('v.filteredData', allData);
            helper.preparePagination(component, allData);
        }
    },

    sortColumn : function(component, event, helper){
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var data = component.get('v.data');
        component.set('v.sortedBy', fieldName);
        component.set('v.sortedDirection', sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    }
    /*
    handleDateTimeChange : function(component, event, helper){
        var datetime1 = component.get('v.datetime1');
        var datetime2 = component.get('v.datetime2');

        if(datetime2<datetime1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "An Error",
                "message": "End-time value greater than Start-time."
            });
            toastEvent.fire();
            const theTime = new Date();
            const theTime2 = new Date();
            theTime.setHours(theTime.getHours()-192);       //back date to Last 8 days ago
            theTime2.setHours(theTime2.getHours());
            component.set('v.datetime1', theTime.toGMTString());
            component.set('v.datetime2', theTime2.toGMTString());
            var refresh = $A.get("e.force:refreshView");
            refresh.fire();
        }
    }*/
})