({
    doInit : function(component, event, helper) {
     
        var recordId = component.get('v.recordId');
        if(recordId!=null){
           /* helper.initSales(component, recordId, function(err, result){
                component.set('v.sales', result);
                //Init chart
                var labels = ['Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec','Jan','Fev','Mar'];
                var labelsCal = ['Jan','Fev','Mar','Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec'];

                var dataSales = {
                    labels: labels,
                    datasets: [{
                      label: 'Fiscal Year',
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
                      data: [result.AprSales,result.MaySales,result.JunSales,result.JulSales,result.AugSales,result.SepSales,result.OctSales,result.NovSales,result.DecSales,result.JanSales,result.FebSales,result.MarSales]
                    },{
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
                        data: [result.AprSalesLY,result.MaySalesLY,result.JunSalesLY,result.JulSalesLY,result.AugSalesLY,result.SepSalesLY,result.OctSalesLY,result.NovSalesLY,result.DecSalesLY,result.JanSalesLY,result.FebSalesLY,result.MarSalesLY]
                      }]
                };
                var dataSalesCal = {
                    labels: labelsCal,
                    datasets: [{
                      label: 'Calendar Year',
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
                      data: [result.JanSalesLY,result.FebSalesLY,result.MarSalesLY,result.AprSales,result.MaySales,result.JunSales,result.JulSales,result.AugSales,result.SepSales,result.OctSales,result.NovSales,result.DecSales]
                    },{
                        label: 'Last Calendar Year',
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
                        data: [result.janSalesN2, result.febSalesN2,result.marSalesN2,result.AprSalesLY,result.MaySalesLY,result.JunSalesLY,result.JulSalesLY,result.AugSalesLY,result.SepSalesLY,result.OctSalesLY,result.NovSalesLY,result.DecSalesLY]
                      }]
                };
                var dataVolume = {
                    labels: labels,
                    datasets: [{
                      label: 'Fiscal Year',
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
                      data: [result.AprQty,result.MayQty,result.JunQty,result.JulQty,result.AugQty,result.SepQty,result.OctQty,result.NovQty,result.DecQty,result.JanQty,result.FebQty,result.MarQty]
                    },{
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
                        data: [result.AprQtyLY,result.MayQtyLY,result.JunQtyLY,result.JulQtyLY,result.AugQtyLY,result.SepQtyLY,result.OctQtyLY,result.NovQtyLY,result.DecQtyLY,result.JanQtyLY,result.FebQtyLY,result.MarQtyLY]
                      }]
                };
                var dataVolumeCal = {
                    labels: labelsCal,
                    datasets: [{
                      label: 'Calendar Year',
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
                      data: [result.JanQtyLY,result.FebQtyLY,result.MarQtyLY,result.AprQty,result.MayQty,result.JunQty,result.JulQty,result.AugQty,result.SepQty,result.OctQty,result.NovQty,result.DecQty]
                    },{
                        label: 'Last Calendar Year',
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
                        data: [result.janQtyN2, result.febQtyN2,result.marQtyN2,result.AprQtyLY,result.MayQtyLY,result.JunQtyLY,result.JulQtyLY,result.AugQtyLY,result.SepQtyLY,result.OctQtyLY,result.NovQtyLY,result.DecQtyLY]
                      }]
                };
                //fiscal year chart
                var optionSales={
                    responsive: true,
                    legend:{
                        display:false
                    },
                    title:{
                        display:true,
                        text: 'LFY / CFY sales'
                    }
                };
                var optionVolume={
                    responsive: true,
                    legend:{
                        display:false
                    },
                    title:{
                        display:true,
                        text: 'LFY / CFY Volumes'
                    }
                };
                
                const config = {
                    type: 'line',
                    data: dataSales,
                    options: optionSales
                };
                const configVol = {
                    type: 'line',
                    data: dataVolume,
                    options: optionVolume
                };
                var el = component.find("chartSales").getElement();
                var ctx = el.getContext('2d');
                var elvol = component.find("volumeChart").getElement();
                var ctxVol = elvol.getContext('2d');

                //calendar charts
                
                var optionSalesCal={
                    responsive: true,
                    legend:{display:false},
                    title:{display:true,text: 'LY / CY sales'}
                };
                var optionVolumeCal={
                    responsive: true,
                    legend:{display:false},
                    title:{display:true,text: 'LY / CY Volumes'
                    }
                };
                const configSalesCal = {
                    type: 'line',
                    data: dataSalesCal,
                    options: optionSalesCal
                };
                const configVolCal = {
                    type: 'line',
                    data: dataVolumeCal,
                    options: optionVolumeCal
                };
                var calEl = component.find("chartCalendarSales").getElement();
                var calCtx = calEl.getContext('2d');
                var calElvol = component.find("chartCalendarVolumes").getElement();
                var calCtxVol = calElvol.getContext('2d');

                try{
                   var salesChart = new Chart(ctx,config);
                   var volumeChart = new Chart(ctxVol,configVol);
                   var salesCalendarChart = new Chart(calCtx,configSalesCal);
                   var volumeCalendarChart = new Chart(calCtxVol,configVolCal);

                } catch(error){
                    alert(error);
                }
                
            });
            helper.initRelatedSales(component, recordId, true, function(err, result){
                component.set('v.relatedDataList', result);
                
                helper.initRelatedSales(component, recordId, false, function(err, resultLY){
                    component.set('v.relatedDataListLY', resultLY);
                    var relatedDataListCYvsLY = new Array();
                    var cy = component.get('v.relatedDataList');
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
                                    april:resultLY[j].april<=0?null:((cy[i].april- resultLY[j].april)/resultLY[j].april)*100,
                                    may:(resultLY[j].may<=0)?null:((cy[i].may- resultLY[j].may)/resultLY[j].may)*100,
                                    june:(resultLY[j].june<=0)?null:((cy[i].june- resultLY[j].june)/resultLY[j].june)*100,
                                    july:(resultLY[j].july<=0)?null:((cy[i].july- resultLY[j].july)/resultLY[j].july)*100,
                                    august:(resultLY[j].august<=0)?null:((cy[i].august- resultLY[j].august)/resultLY[j].august)*100,
                                    september:(resultLY[j].september<=0)?null:((cy[i].september- resultLY[j].september)/resultLY[j].september)*100,
                                    october:(resultLY[j].october<=0)?null:((cy[i].october- resultLY[j].october)/resultLY[j].october)*100,
                                    november:(resultLY[j].november<=0)?null:((cy[i].november- resultLY[j].november)/resultLY[j].november)*100,
                                    december:(resultLY[j].december<=0)?null:((cy[i].december- resultLY[j].december)/resultLY[j].december)*100,
                                    january:(resultLY[j].january<=0)?null:((cy[i].january- resultLY[j].january)/resultLY[j].january)*100,
                                    february:(resultLY[j].february<=0)?null:((cy[i].february- resultLY[j].february)/resultLY[j].february)*100,
                                    march:(resultLY[j].march<=0)?null:((cy[i].march- resultLY[j].march)/resultLY[j].march)*100,
                                    total:resultLY[j].salesYTD<=0?null:((cy[i].salesYTD-resultLY[j].salesYTD)/resultLY[j].salesYTD)*100

                                    /*
                                        SSU - 2022/03/09 Added | This code below is existing before about criteria in month -- don't know why need for month criteria

                                        april:resultLY[j].april<=0||month<=3?null:((cy[i].april- resultLY[j].april)/resultLY[j].april)*100,
                                        may:(resultLY[j].may<=0||month<=4)?null:((cy[i].may- resultLY[j].may)/resultLY[j].may)*100,
                                        june:(resultLY[j].june<=0||month<=5)?null:((cy[i].june- resultLY[j].june)/resultLY[j].june)*100,
                                        july:(resultLY[j].july<=0||month<=6)?null:((cy[i].july- resultLY[j].july)/resultLY[j].july)*100,
                                        august:(resultLY[j].august<=0||month<=7)?null:((cy[i].august- resultLY[j].august)/resultLY[j].august)*100,
                                        september:(resultLY[j].september<=0||month<=8)?null:((cy[i].september- resultLY[j].september)/resultLY[j].september)*100,
                                        october:(resultLY[j].october<=0||month<=9)?null:((cy[i].october- resultLY[j].october)/resultLY[j].october)*100,
                                        november:(resultLY[j].november<=0||month<=10)?null:((cy[i].november- resultLY[j].november)/resultLY[j].november)*100,
                                        december:(resultLY[j].december<=0||month<=11)?null:((cy[i].december- resultLY[j].december)/resultLY[j].december)*100,
                                        january:(resultLY[j].january<=0||month>0)?null:((cy[i].january- resultLY[j].january)/resultLY[j].january)*100,
                                        february:(resultLY[j].february<=0||month>1)?null:((cy[i].february- resultLY[j].february)/resultLY[j].february)*100,
                                        march:(resultLY[j].march<=0||month>2)?null:((cy[i].march- resultLY[j].march)/resultLY[j].march)*100,
                                        total:resultLY[j].salesYTD<=0?null:((cy[i].salesYTD-resultLY[j].salesYTD)/resultLY[j].salesYTD)*100
                                    */
                               /* }
                                relatedDataListCYvsLY.push(obj);
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

            });*/
            
            helper.initAccount(component, recordId, function(err, result){
                component.set('v.account', result);
                
                component.set('v.statPdf', 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+recordId+'&name='+result.Hoya_Account_ID__c+'.pdf');
                component.set('v.statConsoPdf', 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+recordId+'&name='+result.Hoya_Account_ID__c+'conso.pdf');
            });
        }

    },
    /*initCanvas : function(component, sales) {
        const labels = ['Apr','May','June','Jul','Aug','Sept','Nov', 'Dec','Jan','Fev','Mar'];
        const data = {
            labels: labels,
            datasets: [{
              label: 'My First dataset',
              backgroundColor: 'rgb(255, 99, 132)',
              borderColor: 'rgb(255, 99, 132)',
              data: [0, 10, 5, 2, 20, 30, 45],
            }]
        };
        const options ={
            responsive: true,
            legend:{
                display:false
            },
            title:{
                display:true,
                text: 'last 24h Entities balance'
            },
            scales:{
                xAxes:[{stacked:true}],
                yAxes:[{stacked:true}]
            }
        };
        
        const config = {
            type: 'line',
            data,
            options: options
        };
        var el = component.find("mychart").getElement();
        var ctx = el.getContext('2d');
        try{
           var myChart = new Chart(
            ctx,
            config
          );
        } catch(error){
            alert(error);
        }

    },*/
    doExportPdf: function(component, event, helper){
        var content = document.getElementById("salesTab");
        var specialElementHandlers = 
                            function (element,renderer) {
                            return true;
                            }
        var doc = new jsPDF();
        try{
            //doc.fromHTML(content,15,15,{
            //    'width': 170,
            //    'elementHandlers': specialElementHandlers
             //   });
            //var res = doc.autoTableHtmlToJson(content.innerHTML);
            //doc.autoTable(res.columns, res.data);
            //doc.fromHTML(content.innerHTML, 15, 15, {
            //'width': 170
            //});
            //doc.output('Test.pdf');
            doc.fromHTML(content.innerHTML, 15, 15, {
                width: 170
             }, function() {
                doc.save('sample-file.pdf');
             });
        } catch(error){
            alert(error);
        }
    }
})