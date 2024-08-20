({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');

        helper.getDoorVisitedLast3Month(component, recordId, function(err, result){
            console.log('XXX Get Data Last 3 Months == > '+JSON.stringify(result));
            component.set('v.Last3MthsVisited', result);
            var labels = [result.Last2MthLabel+' | '+result.Last2MthVisited, result.Last1MthLabel+' | '+result.Last1MthVisited, result.LastMthLabel+' | '+result.LastMthVisited];
            var dataSales = {
                labels : labels,
                datasets : [{
                    label : 'Doors visited last 3 months',
                    backgroundColor: ['rgb(255, 99, 132)', 'rgb(53,102,238)', 'rgb(31,145,69)'],
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
                    data : [result.Last2MthVisited, result.Last1MthVisited, result.LastMthVisited]
                }]
            };
            var options1 = {
                responsvie : true,
                showTooltips : true,
                showDatasetLabels : true,
                legend : {
                    display : true,
                    position : 'right'
                },
                title : {
                    display : true,
                    text : 'Doors visited last 3 months'
                },
                tooltips : {
                    enabled : true
                },
                animation : {
                    animateScale: true,
                    animateRotate: true
                }
            };
            const config1 = {
                type : 'doughnut',
                data : dataSales,
                options : options1
            }

            var el = component.find('pie-chart-1').getElement();
            var ctx = el.getContext('2d');
            try{
                var PieChart01 = new Chart(ctx, config1);
            }catch(error){  
                alert(error);
                console.log('Error is '+error);
            }
        });

        helper.getLastMonthByTargetList(component, recordId, function(err, result){
            component.set('v.SalesData', result);
            console.log('XXX Get Last Month FY/LFY by Target List=True == > '+JSON.stringify(result));
            var label = [result.LastMonthLabel, result.LastMonthLabelLY];
            var dataSales = {
                labels : label,
                datasets : [{
                    label : 'Value',
                    backgroundColor: ["#0489B1", "#FA5882", "#C70039", "#1a5276", "#633974", "#d98880"],
                    pointBorderColor: "white",
                    pointBackgroundColor: "black",
                    pointBorderWidth: 1,
                    pointHoverRadius: 8,
                    indexAxis : 'y',
                    pointHoverBackgroundColor: "brown",
                    pointHoverBorderColor: "yellow",
                    pointHoverBorderWidth: 2,
                    pointRadius: 4,
                    pointHitRadius: 10,
                    fill: false,
                    data:[result.LastMonthVal, result.LastMonthValLY]
                }]
            };

            var optionBar1 = {
                responsive : true,
                    legend : {
                        display : true,
                        position : 'right'
                    },
                    title : {
                        display : true,
                        text: 'Sales Value by Target List'
                    },
                    tooltip : {
                        enabled : true
                    },
                    scales : {
                        xAxes: [{
                            gridLines : {
                                color : '#FFFFFF',
                            }    
                        }],

                        yAxes: [{
                          gridLines : {
                                color : '#FFFFFF'
                          }  
                        }]
                    },
                    elements : {
                        bar : {
                            borderwidth:2,
                        }
                    }
            };
            const config3 = {
                type : 'horizontalBar',
                data : dataSales,
                options : optionBar1
            };

            var el3 = component.find('bar-chart-01').getElement();
            var ctx3 = el3.getContext('2d');

            try{
                var barchart01 = new Chart(ctx3, config3);
            }catch(error){
                alert(error);
                console.log('Bar Chart Last Sales VS Current Sales Error');
            }
        });

        helper.getLastMonthByTargetList(component, recordId, function(err, result){
            component.set('v.SalesVol', result);
            var label = [result.LastMonthLabel, result.LastMonthLabelLY];
            var dataSales = {
                labels : label,
                datasets : [{
                    label : 'Volumn',
                    backgroundColor: ["#1a5276", "#d98880"],
                    pointBorderColor: "white",
                    pointBackgroundColor: "black",
                    pointBorderWidth: 1,
                    pointHoverRadius: 8,
                    indexAxis : 'y',
                    pointHoverBackgroundColor: "brown",
                    pointHoverBorderColor: "yellow",
                    pointHoverBorderWidth: 2,
                    pointRadius: 4,
                    pointHitRadius: 10,
                    fill: false,
                    data:[result.LastMonthVol, result.LastMonthVolLY]
                }]
            };

            var optionBar1 = {
                responsive : true,
                    legend : {
                        display : true,
                        position : 'right'
                    },
                    title : {
                        display : true,
                        text: 'Sales Volumn by Target List'
                    },
                    tooltip : {
                        enabled : true
                    },
                    scales : {
                        xAxes : [{
                            gridLines : {
                                color : '#FFFFFF',
                            }
                        }],
                        yAxes : [{
                            gridLines : {
                                color : '#FFFFFF',
                            }
                        }]
                    },
                    elements : {
                        bar : {
                            borderwidth:2,
                        }
                    }
            };
            const config3 = {
                type : 'horizontalBar',
                data : dataSales,
                options : optionBar1
            };

            var el3 = component.find('bar-chart-02').getElement();
            var ctx3 = el3.getContext('2d');

            try{
                var barchart01 = new Chart(ctx3, config3);
            }catch(error){
                alert(error);
                console.log('Bar Chart Last Sales VS Current Sales Error');
            }
        });

        helper.getActiveSales01(component, recordId, function(err, result){
            component.set('v.ActiveDoors', result);
            console.log('XXX Get Active Sales More than $1 USD == > '+JSON.stringify(result));
            var labels = [result.Last2MthLabel, result.Last1MthLabel, result.LastMthLabel];
            var activeSales = {
                labels : labels,
                datasets : [{
                    label : 'Active Door',
                    backgroundColor: ['rgb(255, 99, 132)', 'rgb(53,102,238)', 'rgb(31,145,69)'],
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
                    data : [result.Last2MthActiveSales, result.Last1MthActiveSales, result.LastMthActiveSales]
                }]
            };

            var options3 = {
                responsvie : true,
                showTooltips : true,
                showDatasetLabels : true,
                legend : {
                    display : true,
                    position : 'right'
                },
                title : {
                    display : true,
                    text : 'Active Door (Over $1 Last 3 Month)'
                },
                tooltips : {
                    enabled : true
                },
                animation : {
                    animateScale: true,
                    animateRotate: true
                }
            };
            const config3 = {
                type : 'doughnut',
                data : activeSales,
                options : options3
            }

            var el3 = component.find('pie-chart-3').getElement();
            var ctx3 = el3.getContext('2d');
            try{
                var PieChart03 = new Chart(ctx3, config3);
            }catch(error){  
                alert(error);
                console.log('Error is '+error);
            }
        });

        helper.getOpportunityByStage(component, recordId, function(err, result){
            console.log('XXX Get Opportunity Stage by Last 3 Months Created : '+JSON.stringify(result));
            component.set('v.OppByStage', result);
            let val = result;
            var labelset = [];
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label);
                dataset.push(key.Qty);
            });
            
            var piechart2 = {
                labels : labelset,
                datasets : [{
                    label : 'All opportunity created last 3 month by stage',
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
                }],
            };

            var options2 = {
                responsvie : true,
                showTooltips : true,
                showDatasetLabels : true,
                legend : {
                    display : true,
                    position : 'right'
                },
                plugins: {
                    datalabels: {
                        color: "orange",
                        labels: {
                            title: {
                                font: {
                                    weight: "bold"
                                }
                            }
                        }
                    }
                },
                title : {
                    display : true,
                    text : 'All opportunity created last 3 month by stage'
                },
                tooltips : {
                    enabled : true
                },
                animation : {
                    animateScale: true,
                    animateRotate: true
                }
            };

            const config2 = {
                type : 'doughnut',
                data : piechart2,
                options : options2
            }

            var el2 = component.find('pie-chart-2').getElement();
            var ctx2 = el2.getContext('2d');

            try{
                var PieChart02 = new Chart(ctx2, config2);
            }catch(error){  
                alert(error);
                console.log('Error is '+error);
            }
        });

        helper.callActionAsPromise(component,helper,'c.getOpportunityDataColumn',{
            'sObjectName': component.get('v.sObjectName'),
            'sObjectFieldsNames': component.get('v.sObjectFieldsNames'),
            'recordId' : component.get('v.recordId'),
            'AndWhere' : component.get('v.AndWhere'),
            'OwnerWhere' : component.get('v.OwnerWhere')
        })
        .then(function(r) {
            component.set('v.columns', r.result.columns);            
            component.set('v.allData', r.result.data);
            component.set('v.filteredData', r.result.data);
            helper.preparePagination(component, r.result.data);   
        })
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
        if ($A.util.isEmpty(component.get("v.searchPhrase"))) {
            let allData = component.get("v.allData");
            component.set("v.filteredData", allData);
            helper.preparePagination(component, allData);
        }
    },
    
    handleSearch : function (component, event, helper) {
        helper.searchRecordsBySearchPhrase(component);
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
    }
})