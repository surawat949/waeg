({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');

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

        helper.getActiveCampaign(component, recordId, function(err, result){
            component.set('v.ActiveCampaign', result);
            console.log('XXX Get Active Campaign Data == >'+JSON.stringify(result));

            let val = result;
            var labelset = [];
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label);
                dataset.push(key.Qty);
            });

            var DoughNutChart1 = {
                labels : labelset,
                datasets : [{
                    label : 'Campaign Name',
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

            var option1 = {
                responsvie : true,
                showTooltips : true,
                showDatasetLabels : true,
                legend : {
                    display : true,
                    position : 'right'
                },
                title : {
                    display : true,
                    text : 'Active Campaign'
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
                data : DoughNutChart1,
                options : option1
            }

            var el1 = component.find('doughnut-1').getElement();
            var ctx1 = el1.getContext('2d');

            try{
                var doughnut1 = new Chart(ctx1, config1);
            }catch(error){  
                alert(error);
                console.log('Error is '+error);
            }

        });

        helper.getCampaignNotPresented(component, recordId, function(err, result){
            component.set('v.CampNotPresent', result);
            console.log('XXX Get campaign does not present yet == >'+JSON.stringify(result));

            let val = result;
            var labelset = [];
            var dataset = [];

            val.forEach(function(key){
                labelset.push(key.label);
                dataset.push(key.Qty);
            });

            var BarChart1 = {
                labels : labelset,
                datasets : [{
                    label : 'Nums of Account',
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

            var OptionBar1 = {
                responsvie : true,
                showTooltips : true,
                showDatasetLabels : true,
                legend : {
                    display : true,
                    position : 'right'
                },
                title : {
                    display : true,
                    text : 'Campaign Not Present'
                },
                tooltips : {
                    enabled : true
                },
                animation : {
                    animateScale: true,
                    animateRotate: true
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
                }
            };

            const config = {
                type : 'horizontalBar',
                data : BarChart1,
                options : OptionBar1
            }

            var el = component.find('barchart-1').getElement();
            var ctx = el.getContext('2d');

            try{
                var barchart1 = new Chart(ctx, config);
            }catch(error){  
                alert(error);
                console.log('Error is '+JSON.stringify(error));
            }

        });

        helper.getLevelInterested(component, recordId, function(err, result){
            component.set('v.LevelInterested', result);
            console.log('XXX Get Data Level of Interested == > '+JSON.stringify(result));

            let val = result;
            var labelset = [];
            var dataset1 = [];
            var dataset2 = [];
            var dataset3 = [];
            var dataset4 = [];

            val.forEach(function(key){
                labelset.push(key.CampaignName);
                dataset1.push(key.InterestedLevel1);
                dataset2.push(key.InterestedLevel2);
                dataset3.push(key.InterestedLevel3);
                dataset4.push(key.InterestedLevel4);
            });

            var ctx = component.find('bar-stack-1').getElement().getContext('2d');
            var myChart = new Chart(ctx, {
                type : 'horizontalBar',
                data : {
                    labels : labelset,
                    datasets : [{
                        label : 'Not Interested',
                        backgroundColor: 'rgb(255, 99, 132)',
                        data : dataset1
                    }, {
                        label : 'Partial Interested',
                        backgroundColor: 'rgb(249,152,87)',
                        data : dataset2
                    }, {
                        label : 'Interested',
                        backgroundColor : 'rgb(31,145,69)',
                        data : dataset3
                    }, {
                        label : 'Very Interested',
                        backgroundColor : 'rgb(53,102,238)',
                        data : dataset4
                    }],
                },
                options : {
                    indexAxis : 'y',
                    tooltips: {
                        displayColors: true,
                        callbacks:{
                            mode: 'y',
                        },
                    },
                    scales: {
                        xAxes: [{
                            stacked: true,
                            gridLines: {
                                color: '#FFFFFF'
                            }
                        }],
                        yAxes: [{
                            stacked: true,
                            gridLines : {
                                color: '#FFFFFF'
                            }
                        }]
                    },
                        responsive: true,
                        maintainAspectRatio: false,
                        legend: { position: 'right' },
                }
            });

        });
        helper.getTargetCampaign(component, recordId, function(err, result){
            console.log('XXX Get Data for Target/None-Target == >'+JSON.stringify(result));
        });
        helper.getCentralCampaignName(component, recordId, function(err, result){
            console.log('XXX Get Data for Central Campaign Name == > '+JSON.stringify(result));
            component.set('v.searchPicklist', result);
        });
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
        if ($A.util.isEmpty(component.get("v.searchByPicklist"))) {
            let allData = component.get("v.allData");
            component.set("v.filteredData", allData);
            helper.preparePagination(component, allData);
        }
    },
    
    handleSearch : function (component, event, helper) {
        helper.searchRecordsBySearchPhrase(component);
        if($A.util.isEmpty(component.get('v.searchByPicklist'))){
            let allData = component.get('v.allData');
            component.set('v.filteredData', allData);
            helper.preparePagination(component, allData);
        }
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
    }
})