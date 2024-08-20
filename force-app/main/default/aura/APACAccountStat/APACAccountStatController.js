({
    init : function(component, event, helper) {

        var accountId = component.get('v.recordId');
        var recordId = component.get('v.recordId');
        console.log('XXX Get Data for Account Id : '+accountId+' XXX');
        console.log('===================================================');
        
        helper.initAccount(component, accountId, function(err, result){
            console.log('XXX Get data for initAccount : '+JSON.stringify(result));
            console.log('==========================================================');
            component.set('v.account', result);
        });
        helper.initSales(component, accountId, function(err, result){
            console.log('XXX Get Data for initiSales : '+JSON.stringify(result)+' XXX');
            console.log('===========================================================');
            component.set('v.sales', result);

            //initialize for Sales in charts
            var labels = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];

            var dataSales = {
                labels : labels,
                datasets : [{
                    label: 'Current Fiscal Year',
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
                    data: [result.AprSales, result.MaySales, result.JunSales, result.JulSales, result.AugSales, result.SepSales, result.OctSales, result.NovSales, result.DecSales, result.JanSales, result.FebSales, result.MarSales]
                }, {
                    label: 'Last Fiscal Year',
                    backgroundColor: 'rgb(99,255,  132)',
                    borderColor: 'rgb(99, 255, 132)',
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
                    data:[result.AprSalesLY, result.MaySalesLY, result.JunSalesLY, result.JulSalesLY, result.AugSalesLY, result.SepSalesLY, result.OctSalesLY, result.NovSalesLY, result.DecSalesLY, result.JanSalesLY, result.FebSalesLY, result.MarSalesLY]
                }]
            };
            var optionSales={
                responsive: true,
                legend:{
                    display:false
                },
                title:{
                    display:true,
                    text:'Current Sales'
                }
            };

            const config = {
                type: 'line',
                data: dataSales,
                options: optionSales
            };

            var el = component.find('chartSales').getElement();
            var ctx = el.getContext('2d');
            try{
                var salesChart = new Chart(ctx,config);

            }catch(error){
                alert(error);
            }

            var labels0 = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
            var dataSales0 = {
                labels : labels0,
                datasets : [{
                    label: 'Current Fiscal Year',
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
                    data : [result.AprQty, result.MayQty, result.JunQty, result.JulQty, result.AugQty, result.SepQty, result.OctQty, result.NovQty, result.DecQty, result.JanQty, result.FebQty, result.MarQty]
                }, {
                    label: 'Last Fiscal Year',
                    backgroundColor: 'rgb(99,255,  132)',
                    borderColor: 'rgb(99, 255, 132)',
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
                    data : [result.AprQtyLY, result.MayQtyLY, result.JunQtyLY, result.JulQtyLY, result.AugQtyLY, result.SepQtyLY, result.OctQtyLY, result.NovQtyLY, result.DecQtyLY, result.JanQtyLY, result.FebQtyLY, result.MayQtyLY]
                }]
            };

            var optionsales0 = {
                responsive: true,
                legend:{
                    display:false
                },
                title:{
                    display:true,
                    text:'Current Qty'
                }
            };

            const config0 = {
                type: 'line',
                data: dataSales0,
                options: optionsales0
            };
            var el0 = component.find('chartSales0').getElement();
            var ctx0 = el0.getContext('2d');

            try{
                var salesChart0 = new Chart(ctx0,config0);

            }catch(error){
                alert(error);
            }

            var labelC = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            var dataSalesC ={
                labels : labelC,
                datasets : [{
                    label : 'Current Calendar Year',
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
                    data : [result.JanSalesLY, result.FebSalesLY, result.MarSalesLY, result.AprSales, result.MaySales, result.JunSales, result.JulSales, result.AugSales, result.SepSales, result.OctSales, result.NovSales, result.DecSales]
                }, {
                    label: 'Last Calenar Year',
                    backgroundColor: 'rgb(99,255,  132)',
                    borderColor: 'rgb(99, 255, 132)',
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
                    data:[result.janSalesN2, result.febSalesN2, result.marSalesN2, result.AprSalesLY, result.MaySalesLY, result.JunSalesLY, result.JulSalesLY, result.AugSalesLY, result.SepSalesLY, result.OctSalesLY, result.NovSalesLY, result.DecSalesLY]
                }]
            };
            var optionsalesC = {
                responsive: true,
                legend:{
                    display:false
                },
                title:{
                    display:true,
                    text:'Current Calendar Sales'
                }
            };

            const configC = {
                type: 'line',
                data: dataSalesC,
                options: optionsalesC
            };
            var el1 = component.find('chartSalesC').getElement();
            var ctx1 = el1.getContext('2d');

            try{
                var salesChartC = new Chart(ctx1,configC);

            }catch(error){
                alert(error);
            }
            
            //for Qty quantity on chart
            var labelQty = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            var datasetQty = {
                labels : labelQty,
                datasets : [{
                    label : 'Current CY (Qty)',
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
                    data:[result.JanQtyLY, result.FebQtyLY, result.MarQtyLY, result.AprQty, result.MayQty, result.JunQty, result.JulQty, result.AugQty, result.SepQty, result.OctQty, result.NovQty, result.DecQty]
                }, {
                    label: 'Last CY (Qty)',
                    backgroundColor: 'rgb(99,255,  132)',
                    borderColor: 'rgb(99, 255, 132)',
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
                    data:[result.janQtyN2, result.febQtyN2, result.marQtyN2, result.AprQtyLY, result.MayQtyLY, result.JunQtyLY, result.JulQtyLY, result.AugQtyLY, result.SepQtyLY, result.OctQtyLY, result.NovQtyLY, result.DecQtyLY]
                }]
            };

            var optionsalesC1 = {
                responsive: true,
                legend:{
                    display:false
                },
                title:{
                    display:true,
                    text:'Current Calendar Qty'
                }
            };

            const configC1 = {
                type: 'line',
                data: datasetQty,
                options: optionsalesC1
            };
            var el2 = component.find('chartSalesC1').getElement();
            var ctx2 = el2.getContext('2d');

            try{
                var salesChartC1 = new Chart(ctx2,configC1);

            }catch(error){
                alert(error);
            }

        });
        helper.initRelatedSales(component, recordId, true, function(err, result){
            component.set('v.relatedDataList', result);
            console.log('Related data list '+JSON.stringify(result));

            helper.initRelatedSales(component, recordId, false, function(err, resultLY){
                component.set('v.relatedDataListLY', resultLY);
                console.log('XXX parse result LY == >'+JSON.stringify(resultLY));
                var relatedDataListCYvsLY = new Array();
                var cy = component.get('v.relatedDataList');
                console.log('XXX CY'+JSON.stringify(cy));
                var label = 'CFY vs LFY (Total=YTD)';
                var shift = 0;

                for(let i=0; i<cy.length;i++){
                    //var xapril = ((cy[i].april- resultLY[i].april)/resultLY[i].april);
                    //var xmay = ((cy[i].may- resultLY[i].may)/resultLY[i].may);
                    var month = new Date().getMonth();
                    let j = helper.getAccountIndex(resultLY, cy[i].hoya_account_id, cy[i].type);
                    if(j>=0){
                        try{
                            let obj = {
                                accountId: cy[i].accountId,
                                hoya_account_id:  cy[i].hoya_account_id=='Total CFY'?label:cy[i].hoya_account_id,
                                type: cy[i].type,
                                april:resultLY[j].april<=0?null:((cy[i].april)/resultLY[j].april)*100,
                                may:(resultLY[j].may<=0)?null:((cy[i].may)/resultLY[j].may)*100,
                                june:(resultLY[j].june<=0)?null:((cy[i].june)/resultLY[j].june)*100,
                                july:(resultLY[j].july<=0)?null:((cy[i].july)/resultLY[j].july)*100,
                                august:(resultLY[j].august<=0)?null:((cy[i].august)/resultLY[j].august)*100,
                                september:(resultLY[j].september<=0)?null:((cy[i].september)/resultLY[j].september)*100,
                                october:(resultLY[j].october<=0)?null:((cy[i].october)/resultLY[j].october)*100,
                                november:(resultLY[j].november<=0)?null:((cy[i].november)/resultLY[j].november)*100,
                                december:(resultLY[j].december<=0)?null:((cy[i].december)/resultLY[j].december)*100,
                                january:(resultLY[j].january<=0)?null:((cy[i].january)/resultLY[j].january)*100,
                                february:(resultLY[j].february<=0)?null:((cy[i].february)/resultLY[j].february)*100,
                                march:(resultLY[j].march<=0)?null:((cy[i].march)/resultLY[j].march)*100,
                                total:resultLY[j].salesYTD<=0?null:((cy[i].salesYTD)/resultLY[j].salesYTD)*100
                            }
                            relatedDataListCYvsLY.push(obj);
                            //console.log('XXXX Relate Data List CY VS LY '+JSON.stringify(relatedDataListCYvsLY.push(obj)));
                        } catch (error) {
                            console.debug(error);
                        }
                    } else {
                        //case new customer with sales CY, no sales LY
                        let obj = {
                            accountId: cy[i].accountId,
                            hoya_account_id:  cy[i].hoya_account_id=='Total CFY'?label:cy[i].hoya_account_id,
                            type: cy[i].type,
                            april:cy[i].april>0?100:null,
                            may:cy[i].april>0?100:null,
                            june:cy[i].june>0?100:null,
                            july:cy[i].july>0?100:null,
                            august:cy[i].august>0?100:null,
                            september:cy[i].september>0?100:null,
                            october:cy[i].october>0?100:null,
                            november:cy[i].november>0?100:null,
                            december:cy[i].december>0?100:null,
                            january:cy[i].january>0?100:null,
                            february:cy[i].february>0?100:null,
                            march:cy[i].march>0?100:null,
                            total:cy[i].total>0?100:null
                        }
                        relatedDataListCYvsLY.push(obj);
                    }
                    if(j-i>shift){
                        //case old customer with sales in LY, no sale in CY
                        let obj = {
                            accountId: resultLY[i].accountId,
                            hoya_account_id:  resultLY[i].hoya_account_id=='Total CFY'?label:resultLY[i].hoya_account_id,
                            type: resultLY[i].type,
                            april:resultLY[i].april>0?-100:null,
                            may:resultLY[i].may>0?-100:null,
                            june:resultLY[i].june>0?-100:null,
                            july:resultLY[i].july>0?-100:null,
                            august:resultLY[i].august>0?-100:null,
                            september:resultLY[i].september>0?-100:null,
                            october:resultLY[i].october>0?-100:null,
                            november:resultLY[i].november>0?-100:null,
                            december:resultLY[i].december>0?-100:null,
                            january:resultLY[i].january>0?-100:null,
                            february:resultLY[i].february>0?-100:null,
                            march:resultLY[i].march>0?-100:null,
                            total:resultLY[i].total>0?-100:null
                        }
                        relatedDataListCYvsLY.push(obj);
                        shift = shift+1;
                    }
                }
                console.log('XXX Relate Data List CY vs LY == > '+JSON.stringify(relatedDataListCYvsLY));
                component.set('v.relatedDataListCYvsLY', relatedDataListCYvsLY);

            //int graphics
            var datasetArrSal = new Array(0);
            var datasetArrVol = new Array(0);

            var labels = ['Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec','Jan','Fev','Mar'];
            var red = 'rgb(255, 99, 132)';
            var green = 'rgb(99, 255, 132)';
            var color = red;
            for (var i = 0; i<result.length; i++){
                //console.log(result[i].hoya_account_id);
                if(result[i].hoya_account_id.startsWith('Total')){
                    //alert(result[i].hoya_account_id + ' - ' + result[i].type); 
                    var dataset= {
                        label: result[i].hoya_account_id,
                        backgroundColor: red,
                        borderColor: red,
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
                        title:result[i].hoya_account_id,
                        data: [result[i].april,result[i].may,result[i].june,result[i].july,result[i].august,result[i].september,result[i].october,result[i].november,result[i].december,result[i].january,result[i].february,result[i].march]
                    };
                    var datasetLY= {
                        label: resultLY[i].hoya_account_id,
                        backgroundColor: red,
                        borderColor: red,
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
                        title:resultLY[i].hoya_account_id,
                        data: [resultLY[i].april,resultLY[i].may,resultLY[i].june,resultLY[i].july,resultLY[i].august,resultLY[i].september,resultLY[i].october,resultLY[i].november,resultLY[i].december,resultLY[i].january,resultLY[i].february,resultLY[i].march]
                    };
                    if(result[i].type=='sales'){
                            dataset.backgroundColor=red;dataset.borderColor=red;
                            datasetArrSal.push(dataset);
                            datasetLY.backgroundColor=green;datasetLY.borderColor=green;
                            datasetArrSal.push(datasetLY);
                    } else {
                            dataset.backgroundColor=red;dataset.borderColor=red;
                            datasetArrVol.push(dataset);
                            datasetLY.backgroundColor=green;datasetLY.borderColor=green;
                            datasetArrVol.push(datasetLY);
                    }
                }
            }
            var dataSales = {labels: labels,datasets:datasetArrSal};
            var dataVolumes = {labels: labels,datasets:datasetArrVol};
            var optionSales={
                responsive: true,
                legend:{display:false},
                title:{display:true,text: 'LY / CY sales'}
            };
            var optionVolumes={
                responsive: true,
                legend:{display:false},
                title:{display:true,text: 'LY / CY volumes'}
            };
            const configSales = {
                type: 'line',
                data: dataSales,
                options: optionSales
            };
            const configVolumes = {
                type: 'line',
                data: dataVolumes,
                options: optionVolumes
            };
            var salesChart = component.find("relatedChartSales").getElement();
            var salCtx = salesChart.getContext('2d');
            var volumeChart = component.find("relatedChartVolumes").getElement();
            var volCtx = volumeChart.getContext('2d');
            try{
                var salesRelatedChart = new Chart(salCtx,configSales);
                var volumeCalendarChart = new Chart(volCtx,configVolumes);

                } catch(error){
                    alert(error);
                }
            
            });

        });
    },
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    handleSuccess : function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title" : "Save Success",
            "message" : "The record saved successfully",
            "type" : "success"
        });
        toastEvent.fire();
    }
})