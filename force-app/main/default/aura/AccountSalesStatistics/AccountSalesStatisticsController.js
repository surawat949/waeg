({
    doInit : function(component, event, helper) {
       var recordId = component.get('v.recordId');
        console.log(recordId);
       if(recordId != null){
            helper.initSales(component, recordId, function(err, result){
                console.log(result);               
                component.set('v.sales', result[0]); 
                var obj = JSON.parse(result[1]);
                var OhabitsArray = new Array(parseInt(obj.ManualOrders),parseInt(obj.HVCsys),parseInt(obj.OtherOrders),parseInt(obj.UnCutlens),parseInt(obj.RemoteEdging),parseInt(obj.Mounting),parseInt(obj.FramesByHvc),parseInt(obj.RealShape),parseInt(obj.StandShape),parseInt(obj.Boxing) );
                var prodRetArray = new Array(parseInt(obj.ProdRet12),parseInt(obj.ProdRet3),parseInt(obj.CutRet12),parseInt(obj.CutRet3),parseInt(obj.MountRet12),parseInt(obj.MountRet3),parseInt(obj.TotalProdRet12),parseInt(obj.TotalProdRet3));
                var nonProdRetArray = new Array(parseInt(obj.SalesRet12),parseInt(obj.SalesRet3),parseInt(obj.OrderMisRet12),parseInt(obj.OrderMisRet3),parseInt(obj.NonAdapRet12),parseInt(obj.NonAdapRet3),parseInt(obj.DeliveryRet12),parseInt(obj.DeliveryRet3),parseInt(obj.OtherRet12),parseInt(obj.OtherRet3),parseInt(obj.TotalNonProdRet12),parseInt(obj.TotalNonProdRet3));
                var totalRetArray = new Array(parseInt(obj.TotalRet12),parseInt(obj.TotalRet3));
                component.set('v.prodRetLst', prodRetArray);
                component.set('v.nonProdRetLst', nonProdRetArray);
                component.set('v.totalRet',totalRetArray);
                component.set('v.orderingHabitsLst', OhabitsArray);
				var CYSales = result[2];
                var totalconLensNetSales = CYSales[4].contactLensNetSales+CYSales[5].contactLensNetSales+CYSales[6].contactLensNetSales+CYSales[7].contactLensNetSales+CYSales[8].contactLensNetSales+CYSales[9].contactLensNetSales+CYSales[10].contactLensNetSales+CYSales[11].contactLensNetSales+CYSales[12].contactLensNetSales+CYSales[1].contactLensNetSales+CYSales[2].contactLensNetSales+CYSales[3].contactLensNetSales;
                var conLensNetLst = new Array(CYSales[4].contactLensNetSales,CYSales[5].contactLensNetSales,CYSales[6].contactLensNetSales,CYSales[7].contactLensNetSales,CYSales[8].contactLensNetSales,CYSales[9].contactLensNetSales,CYSales[10].contactLensNetSales,CYSales[11].contactLensNetSales,CYSales[12].contactLensNetSales,CYSales[1].contactLensNetSales,CYSales[2].contactLensNetSales,CYSales[3].contactLensNetSales,totalconLensNetSales);
                var totalconLensGrossSales = CYSales[4].contactLensGrossSales+CYSales[5].contactLensGrossSales+CYSales[6].contactLensGrossSales+CYSales[7].contactLensGrossSales+CYSales[8].contactLensGrossSales+CYSales[9].contactLensGrossSales+CYSales[10].contactLensGrossSales+CYSales[11].contactLensGrossSales+CYSales[12].contactLensGrossSales+CYSales[1].contactLensGrossSales+CYSales[2].contactLensGrossSales+CYSales[3].contactLensGrossSales;
                var conLensGrossLst = new Array(CYSales[4].contactLensGrossSales,CYSales[5].contactLensGrossSales,CYSales[6].contactLensGrossSales,CYSales[7].contactLensGrossSales,CYSales[8].contactLensGrossSales,CYSales[9].contactLensGrossSales,CYSales[10].contactLensGrossSales,CYSales[11].contactLensGrossSales,CYSales[12].contactLensGrossSales,CYSales[1].contactLensGrossSales,CYSales[2].contactLensGrossSales,CYSales[3].contactLensGrossSales,totalconLensGrossSales);
				var conLensQtyLst = new Array(CYSales[4].contactLensQty,CYSales[5].contactLensQty,CYSales[6].contactLensQty,CYSales[7].contactLensQty,CYSales[8].contactLensQty,CYSales[9].contactLensQty,CYSales[10].contactLensQty,CYSales[11].contactLensQty,CYSales[12].contactLensQty,CYSales[1].contactLensQty,CYSales[2].contactLensQty,CYSales[3].contactLensQty,totalconLensNetSales);
				component.set('v.conLensNetLst', conLensNetLst);
                component.set('v.conLensGrossLst', conLensGrossLst);
                component.set('v.conLensQtyLst',conLensQtyLst);
                window.setTimeout(
           		 $A.getCallback(function() {             
                //Init chart
                var labels = ['Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec','Jan','Feb','Mar'];
                var labelsCal = ['Jan','Feb','Mar','Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec'];
                var dataSales = {
                    labels: labels,
                    datasets: [{
                      label: 'Current Fiscal Year',
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
                      data: [result[0].aprSales,result[0].maySales,result[0].junSales,result[0].julSales,result[0].augSales,result[0].sepSales,result[0].octSales,result[0].novSales,result[0].decSales,result[0].janSales,result[0].febSales,result[0].marSales]
                    },{
                        label: 'Last Fiscal Year',
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
                        data: [result[0].aprSalesLY,result[0].maySalesLY,result[0].junSalesLY,result[0].julSalesLY,result[0].augSalesLY,result[0].sepSalesLY,result[0].octSalesLY,result[0].novSalesLY,result[0].decSalesLY,result[0].janSalesLY,result[0].febSalesLY,result[0].marSalesLY]
                      }]
                };
                var dataNetSales = {
                    labels: labels,
                    datasets: [{
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
                      data: [result[0].aprNetSales,result[0].mayNetSales,result[0].junNetSales,result[0].julNetSales,result[0].augNetSales,result[0].sepNetSales,result[0].octNetSales,result[0].novNetSales,result[0].decNetSales,result[0].janNetSales,result[0].febNetSales,result[0].marNetSales]
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
                        data: [result[0].aprNetSalesLY,result[0].mayNetSalesLY,result[0].junNetSalesLY,result[0].julNetSalesLY,result[0].augNetSalesLY,result[0].sepNetSalesLY,result[0].octNetSalesLY,result[0].novNetSalesLY,result[0].decNetSalesLY,result[0].janNetSalesLY,result[0].febNetSalesLY,result[0].marNetSalesLY]
                      }]
                };
                var dataVolume = {
                    labels: labels,
                    datasets: [{
                      label: 'Current Fiscal Year',
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
                      data: [result[0].aprQty,result[0].mayQty,result[0].junQty,result[0].julQty,result[0].augQty,result[0].sepQty,result[0].octQty,result[0].novQty,result[0].decQty,result[0].janQty,result[0].febQty,result[0].marQty]
                    },{
                        label: 'Last Fiscal Year',
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
                        data: [result[0].aprQtyLY,result[0].mayQtyLY,result[0].junQtyLY,result[0].julQtyLY,result[0].augQtyLY,result[0].sepQtyLY,result[0].octQtyLY,result[0].novQtyLY,result[0].decQtyLY,result[0].janQtyLY,result[0].febQtyLY,result[0].marQtyLY]
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
                const configNet = {
                    type: 'line',
                    data: dataNetSales,
                    options: optionSales
                };
               
                     if(result[0].isGermanyAccount){
                         var el = component.find("chartSales").getElement();                    
                         var ctx = el.getContext('2d');
                         var elvol2 = component.find("volumeChart2").getElement();
                         var ctxVol2 = elvol2.getContext('2d');
                         try{
                             var salesChart = new Chart(ctx,config);
                             var volumeChart2 = new Chart(ctxVol2,configVol); 
                         } catch(error){
                             alert(error);
                         }
                     }
                     else if(result[0].isSOSAorSONLAccount){
                         var el2 = component.find("chartSales1").getElement();
                         var ctx2 = el2.getContext('2d');
                         var elNet2 = component.find("chartNetSales2").getElement();
                         var ctxNet2 = elNet2.getContext('2d');
                         var elvol3 = component.find("volumeChart3").getElement();
                         var ctxVol3 = elvol3.getContext('2d');
                         try{
                             var salesChart2 = new Chart(ctx2,config);
                             var netSalesChart = new Chart(ctxNet2,configNet);                   
                             var volumeChart3 = new Chart(ctxVol3,configVol);
                         }catch(error){
                   			 alert(error);
                          }
                     }
                     else if(result[0].isOtherCountryAccount){
                         var elvol = component.find("volumeChart").getElement();
                         var ctxVol = elvol.getContext('2d');
                         var elNet = component.find("chartNetSales").getElement();
                         var ctxNet = elNet.getContext('2d');  
                         try{                           
                             var netSalesChart = new Chart(ctxNet,configNet);
                             var volumeChart = new Chart(ctxVol,configVol); 
                         } catch(error){
                   			 alert(error);
                		 }
                     }
            
                 }),100);
            });
            helper.initRelatedSales(component, recordId, function(err, result){
                 console.log(result);
                 component.set('v.relatedDataList', result);
            });
            helper.initAccount(component, recordId, function(err, result){
                component.set('v.account', result);
                console.log(result);
                component.set('v.statPdf', 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+recordId+'&name='+result.Hoya_Account_ID__c+'.pdf');
                
                component.set('v.statConsoPdf', 'http://ec2-34-252-248-24.eu-west-1.compute.amazonaws.com/SfdcSynchroWeb/DocumentWebService?entity=seikostat&id='+recordId+'&name='+result.Hoya_Account_ID__c+'conso.pdf');
            });
        }
           
    },
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
    },
    
    handleSuccess : function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title" : "Save Success",
            "message" : "The record saved successfully",
            "type" : "Success"
        });
        toastEvent.fire();

    }
})