({
    doInit : function(component, event, helper) {
        let channel = '/event/Refresh_Task_Event__e';
        const replayId = -1;
        const empApi = component.find("empApi");
        const callback = function (message) {
            let obj = message.data.payload;
            alert(JSON.stringify(obj));            
            var workspaceAPI = component.find("workspace");
            workspaceAPI.isConsoleNavigation().then(function(response) {
                console.log(response);                    
                if(response){
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getAllTabInfo().then(function(response) {
                        for(let tabRec of response){
                            workspaceAPI.closeTab({tabId: tabRec.tabId});
                        }
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/lightning/page/home"
                        });
                        urlEvent.fire();
                    })
                    .catch(function(error) {
                        console.log(error);
                    });
                }else{
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/page/home"
                    });
                    urlEvent.fire();
                }
            })
            .catch(function(error) {
                console.log(error);
            }); 
        };
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            console.log("Subscribed to channel 1" + channel);
        });        
        const errorHandler = function (message) {
            console.error("Received error ", JSON.stringify(message));
        };
        empApi.onError(errorHandler);
    }
})