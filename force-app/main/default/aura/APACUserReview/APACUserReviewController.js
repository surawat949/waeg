({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        
        var companyName = component.get('v.companyName');
        
        console.log('Controller get company name == > '+companyName);
        
        helper.getUserCompany(component, recordId, function(err, result){
            component.set('v.companyName', result);
            //console.log('Get user company name == > '+JSON.stringify(result));
        });
        /*
        helper.getRxStockSales(component, recordId, function(err, result){
            component.set('v.rxstockSales', result);
            console.log('Fetch data for Rx/Stock Sales == > '+JSON.stringify(result));
        });
        */
        /*
        helper.getLensGenDesignSales(component, recordId, 'SV', function(err, result){
            component.set('v.SVSales', result);
            console.log('Fetch data for SV == > '+JSON.stringify(result));
        });

        helper.getLensGenDesignSales(component, recordId, 'BF', function(err, result){
            component.set('v.BFSales', result);
            console.log('Fetch data for BF == > '+JSON.stringify(result));
        });

        helper.getLensGenDesignSales(component, recordId, 'PAL', function(err, result){
            component.set('v.PALSales', result);
            console.log('Fetch data for PAL == > '+JSON.stringify(result));
        });

        helper.getLensDesignOthsSales(component, recordId, function(err, result){
            component.set('v.OthSales', result);
            console.log('Fetch data for Othes Sales (NOT IN SV,BF,PAL) == > '+JSON.stringify(result));
        });
        */
        helper.getInitsalesdata(component, recordId, function(err, result){
            component.set('v.sales', result);
            console.log('Get initialize sales == > '+JSON.stringify(result));
           
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'APR', 0.1, function(err, result){
            component.set('v.AprActiveAccount01CFY', result);
            //console.log('XXX Get Data April Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'MAY', 0.1, function(err, result){
            component.set('v.MayActiveAccount01CFY', result);
            //console.log('XXX Get Data May Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'JUN', 0.1, function(err, result){
            component.set('v.JunActiveAccount01CFY', result);
            //console.log('XXX Get Data Jun Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'JUL', 0.1, function(err, result){
            component.set('v.JulActiveAccount01CFY', result);
            //console.log('XXX Get Data Jul Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'AUG', 0.1, function(err, result){
            component.set('v.AugActiveAccount01CFY', result);
            //console.log('XXX Get Data Aug Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'SEP', 0.1, function(err, result){
            component.set('v.SepActiveAccount01CFY', result);
            //console.log('XXX Get Data SEP Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'OCT', 0.1, function(err, result){
            component.set('v.OctActiveAccount01CFY', result);
            //console.log('XXX Get Data Oct Acctive Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'NOV', 0.1, function(err, result){
            component.set('v.NovActiveAccount01CFY', result);
            //console.log('XXX Get Data Nov Active Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'DEC', 0.1, function(err, result){
            component.set('v.DecActiveAccount01CFY', result);
            //console.log('XXX Get Data Dec Active Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'JAN', 0.1, function(err, result){
            component.set('v.JanActiveAccount01CFY', result);
            //console.log('XXX Get Data Jan Active Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'FEB', 0.1, function(err, result){
            component.set('v.FebActiveAccount01CFY', result);
            //console.log('XXX Get Data Feb Active Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'MAR', 0.1, function(err, result){
            component.set('v.MarActiveAccount01CFY', result);
            //console.log('XXX Get Data Mar Active Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'ANNUAL', 0.1, function(err, result){
            component.set('v.AnnualActiveAccount01CFY', result);
            //console.log('XXX Get Data Annual Active Account CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'APR', 0.1, function(err, result){
            component.set('v.AprActiveAccount01CLY', result);
            //console.log('XXX Get Data Apr Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'MAY', 0.1, function(err, result){
            component.set('v.MayActiveAccount01CLY', result);
            //console.log('XXX Get Data May Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'JUN', 0.1, function(err, result){
            component.set('v.JunActiveAccount01CLY', result);
            //console.log('XXX Get Data Jun Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'JUL', 0.1, function(err, result){
            component.set('v.JulActiveAccount01CLY', result);
            //console.log('XXX Get Data Jul Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'AUG', 0.1, function(err, result){
            component.set('v.AugActiveAccount01CLY', result);
            //console.log('XXX Get Data Aug Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'SEP', 0.1, function(err, result){
            component.set('v.SepActiveAccount01CLY', result);
            //console.log('XXX Get Data Sep Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'OCT', 0.1, function(err, result){
            component.set('v.OctActiveAccount01CLY', result);
            //console.log('XXX Get Data Oct Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'NOV', 0.1, function(err, result){
            component.set('v.NovActiveAccount01CLY', result);
            //console.log('XXX Get Data Nov Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'DEC', 0.1, function(err, result){
            component.set('v.DecActiveAccount01CLY', result);
            //console.log('XXX Get Data Dec Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'JAN', 0.1, function(err, result){
            component.set('v.JanActiveAccount01CLY', result);
            //console.log('XXX Get Data Jan Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'FEB', 0.1, function(err, result){
            component.set('v.FebActiveAccount01CLY', result);
            //console.log('XXX Get Data Feb Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'MAR', 0.1, function(err, result){
            component.set('v.MarActiveAccount01CLY', result);
            //console.log('XXX Get Data Mar Active Account CLY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'ANNUAL', 0.1, function(err, result){
            component.set('v.AnnualActiveAccount01CLY', result);
            //console.log('XXX Get Data Annual Active Account CLY : '+JSON.stringify(result));
        });

        /* ================ Start component more than $US 500 ========================= */
        helper.getCountingActiveAccount(component, recordId, 'CY', 'APR', 500, function(err, result){
            component.set('v.AprActiveAccount02CFY', result);
            //console.log('XXX Get Data Apr Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'MAY', 500, function(err, result){
            component.set('v.MayActiveAccount02CFY', result);
            //console.log('XXX Get Data May Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'JUN', 500, function(err, result){
            component.set('v.JunActiveAccount02CFY', result);
            //console.log('XXX Get Data Jun Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'JUL', 500, function(err, result){
            component.set('v.JulActiveAccount02CFY', result);
            //console.log('XXX Get Data Jul Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'AUG', 500, function(err, result){
            component.set('v.AugActiveAccount02CFY', result);
            //console.log('XXX Get Data Aug Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'SEP', 500, function(err, result){
            component.set('v.SepActiveAccount02CFY', result);
            //console.log('XXX Get Data Sep Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'OCT', 500, function(err, result){
            component.set('v.OctActiveAccount02CFY', result);
            //console.log('XXX Get Data Oct Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'NOV', 500, function(err, result){
            component.set('v.NovActiveAccount02CFY', result);
            //console.log('XXX Get Data Nov Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'DEC', 500, function(err, result){
            component.set('v.DecActiveAccount02CFY', result);
            //console.log('XXX Get Data Dec Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'JAN', 500, function(err, result){
            component.set('v.JanActiveAccount02CFY', result);
            //console.log('XXX Get Data Jan Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'FEB', 500, function(err, result){
            component.set('v.FebActiveAccount02CFY', result);
            //console.log('XXX Get Data Feb Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'MAR', 500, function(err, result){
            component.set('v.MarActiveAccount02CFY', result);
            //console.log('XXX Get Data Mar Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'CY', 'ANNUAL', 500, function(err, result){
            component.set('v.AnnualActiveAccount02CFY', result);
            //console.log('XXX Get Data Annual Active Account More than $USD 500 CFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'APR', 500, function(err, result){
            component.set('v.AprActiveAccount02CLY', result);
            //console.log('XXX Get Data Apr Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'MAY', 500, function(err, result){
            component.set('v.MayActiveAccount02CLY', result);
            //console.log('XXX Get Data May Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'JUN', 500, function(err, result){
            component.set('v.JunActiveAccount02CLY', result);
            //console.log('XXX Get Data Jun Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'JUL', 500, function(err, result){
            component.set('v.JulActiveAccount02CLY', result);
            //console.log('XXX Get Data Jul Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'AUG', 500, function(err, result){
            component.set('v.AugActiveAccount02CLY', result);
            //console.log('XXX Get Data Aug Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'SEP', 500, function(err, result){
            component.set('v.SepActiveAccount02CLY', result);
            //console.log('XXX Get Data Sep Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'OCT', 500, function(err, result){
            component.set('v.OctActiveAccount02CLY', result);
            //console.log('XXX Get Data Oct Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'NOV', 500, function(err, result){
            component.set('v.NovActiveAccount02CLY', result);
            //console.log('XXX Get Data Nov Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'DEC', 500, function(err, result){
            component.set('v.DecActiveAccount02CLY', result);
            //console.log('XXX Get Data Dec Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'JAN', 500, function(err, result){
            component.set('v.JanActiveAccount02CLY', result);
            //console.log('XXX Get Data Jan Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'FEB', 500, function(err, result){
            component.set('v.FebActiveAccount02CLY', result);
            //console.log('XXX Get Data Feb Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'MAR', 500, function(err, result){
            component.set('v.MarActiveAccount02CLY', result);
            //console.log('XXX Get Data Mar Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getCountingActiveAccount(component, recordId, 'LY', 'ANNUAL', 500, function(err, result){
            component.set('v.AnnualActiveAccount02CLY', result);
            //console.log('XXX Get Data Annual Active Account More than $USD 500 LFY : '+JSON.stringify(result));
        });

        helper.getSalesFigured(component, recordId, function(err, result){
            component.set('v.SalesData', result);
            //console.log('XXX Get Data Sales Figured == > '+JSON.stringify(result));
        });
        /*
        helper.getTopCustomer(component, recordId, function(err, result){
            component.set('v.TopCust', result);
            console.log('XXX Get Top Ten Customer == > '+JSON.stringify(result));
        });*/

        helper.getFiscalyear(component, recordId, function(err, result){
            component.set('v.fiscal', result);
            //console.log('XXX Get fiscal year == > '+JSON.stringify(result));
        });

        /*
        helper.getSegmentationSalesFigure(component, recordId, function(err, result){
            component.set('v.segment', result);
            console.log('XXX Get Sales Segmentation == > '+JSON.stringify(result));
        });
        */
        helper.getSegmentationSales(component, recordId, function(err, result){
            component.set('v.SalesSegment', result);
            //console.log('XXX Get Segmentation Sales == >'+JSON.stringify(result));
        });
        helper.getSalesBySubArea(component, recordId, function(err, result){
            component.set('v.SalesSub', result);
            //console.log('XXX Get Sales by sub-area == >'+JSON.stringify(result));
        });

        helper.getUserIdConversionReate(component, recordId, function(err, result){
            component.set('v.conversionRate', result);
            console.log('XXX UserId Conversion Rate == > '+JSON.stringify(result));
        });
        /*
        helper.getSubAreaByUserId(component, recordId, function(err, result){
            component.set('v.subarea', result);
            console.log('XXX Get Sales by Sub-area and by UserId == > '+JSON.stringify(result));
        });*/

        helper.getTopTenCustomer(component, recordId, function(err, result){
            component.set('v.toptensales', result);
            //console.log('XXX Get Top ten sales == > '+JSON.stringify(result));
        });

        helper.getStockRxbyOwnerId(component, recordId, function(err, result){
            component.set('v.LensSales', result);
            //console.log('XXX Get Stock/Rx Lens Sales == > '+JSON.stringify(result));
        });

        helper.getGenericDesign(component, recordId, function(err, result){
            component.set('v.LensGenSales', result);
            console.log('XXX Get Lens Generic Design == > '+JSON.stringify(result));
        });
        
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