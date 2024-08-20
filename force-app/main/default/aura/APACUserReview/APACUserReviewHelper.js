({
    getVisitDataMap : function(component, recordId, datetime1, datetime2, callback){
        var action = component.get('c.getVisitDataList');
        action.setParams({"recordId":recordId,
                            "datetime1":datetime1,
                            "datetime2":datetime2});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },
    getInitsalesdata : function(component, recordId, callback){
        var action = component.get('c.initUserSales');
        action.setParams({"recordId":recordId});

        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state ==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Get initSales : Error during the connection');
            }
        });

        $A.enqueueAction(action);
    },
   
    getUserCompany : function(component, recordId, callback){
        var action = component.get('c.getCompanayName');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },
    
    getCountingActiveAccount : function(component, recordId, yeartext, monthtext, SegmentValue, callback){
        var action = component.get('c.getAccountActiveCounting');
        action.setParams({"recordId":recordId, 
                            "yeartext":yeartext, 
                            "monthtext":monthtext, 
                            "SegmentValue":SegmentValue});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error occured during apex connection.');
            }
        });
        $A.enqueueAction(action);
    },
    
    getinitVisitsCounting : function(component, recordId, callback){
        var action = component.get('c.initTotalVisits');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());

            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error had occurred during the apex connection.');
            }
        });
        $A.enqueueAction(action);
    },
    /*
    getVisitsCountingBySegmentA : function(component, recordId, callback){
        var action = component.get('c.initSegmA');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error had occured during the apex connection.');
            }
        });
        $A.enqueueAction(action);
    },

    getVisitCoutingBySegmentB : function(component, recordId, callback){
        var action = component.get('c.initSegmB');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error had occured during the apex connection.');
            }
        });
        $A.enqueueAction(action);
    },

    getVisitCoutingBySegmentC : function(component, recordId, callback){
        var action = component.get('c.initSegmC');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error had occured during the apex connection.');
            }
        });
        $A.enqueueAction(action);
    },*/

    getCampaignListByUser : function(component, recordId, callback){
        var action = component.get('c.getCampaignListByUser');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Campaign Member List Error XXX ');
            }
        });
        $A.enqueueAction(action);
    },

    getSalesFigured : function(component, recordId, callback){
        var action = component.get('c.getUserSalesfigured');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Sales Figured error :'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    /*
    getRxStockSales : function(component, recordId, callback){
        var action = component.get('c.getRxStockSales');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error during the connection');
            }
        });
        $A.enqueueAction(action);
    },*/
    /*
    getLensGenDesignSales : function(component, recordId, GenericDesign, callback){
        var action = component.get('c.getGenericDesignSales');
        action.setParams({"recordId":recordId, 
            "GenericDesign":GenericDesign
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },
    getLensDesignOthsSales : function(component, recordId, callback){
        var action = component.get('c.getGensDesignOthsSales');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error during the connection.');
            }
        });
        $A.enqueueAction(action);
    },
    */

    /*
    getTopCustomer : function(component, recordId, callback){
        var action = component.get('c.getTopCustomerByOwner');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error was occured, GET TOP TEN CUSTOMERS : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },*/

    getFiscalyear : function(component, recordId, callback){
        var action = component.get('c.getFiscalYear');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error was occurred, get fiscal year : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    getSegmentationSales : function(component, recordId, callback){
        var action = component.get('c.getNewSegmentation');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred : '+JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },

    getSalesBySubArea : function(component, recordId, callback){
        var action = component.get('c.getNewSubArea');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX An error was occurred : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    /*
    getSegmentationSalesFigure : function(component, recordId, callback){
        var action = component.get('c.getDataSegmentationOwnerId');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());

            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('An error was occurred, get Sales Segmentation : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },*/

    getUserIdConversionReate : function(component, recordId, callback){
        var action = component.get('c.getUserIdConversionRate');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state ==='SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get User Id Conversion Rate error == > '+response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    /*
    getSubAreaByUserId : function(component, recordId, callback){
        var action = component.get('c.getSubAreaSalesByOwnerId');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Sales by Sub-area and by UserId ERROR == > '+response.getError());
            }
        });
        $A.enqueueAction(action);
    },*/

    getTopTenCustomer : function(component, recordId, callback){
        var action = component.get('c.getTopTenCustomer');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state==='ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Top ten customer error == > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    getStockRxbyOwnerId : function(component, recordId, callback){
        var action = component.get('c.getRxStockbyOwnerId');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('XXX Get Stock/Rx by OwnerId == > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    getGenericDesign : function(component, recordId, callback){
        var action = component.get('c.getLensDesignByOwner');
        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === 'SUCCESS'){
                callback(null, response.getReturnValue());
            }else if(component.isValid() && state === 'ERROR'){
                callback(response.getError(), response.getReturnValue());
                console.log('Get Lens design by ownerId error == > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})