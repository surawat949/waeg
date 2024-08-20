({
    myAction : function(component, event, helper) {

    },
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        window.setTimeout(
        $A.getCallback(function() {     
        var labels = ['Apr','May'];
                var labelsCal = ['Jan','Feb','Mar','Apr','May','June','Jul','Aug','Sept','oct','Nov', 'Dec'];
                
                var dataNetSales = {
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
                      data: ['10','20']
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
                        data: ['0','0']
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
                      data: ['30','40']
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
                        data: ['60','50']
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

            }),100);
    }
})