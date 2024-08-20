import { LightningElement, api, track, wire} from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//apex import class start here
import getAccountMapFetch from '@salesforce/apex/TabVisitsEcpNearby.getAccountsMap';
import getSeikoNetworkPicklist from '@salesforce/apex/TabVisitsEcpNearby.getSVSNetworkPicklistVal';
import USER_LOCALE from '@salesforce/i18n/locale';
//End

//custom label start here -
import lblSegmentation from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import lblMainCompetitor from '@salesforce/label/c.SFDC_V2_Account_ECP_Nearby_MainCompetitor';
import lblMinPotential from '@salesforce/label/c.SFDC_V2_Account_ECP_Nearby_MinPotential';
import lblHVCRoyaltyProgram from '@salesforce/label/c.HVC_Loyalty_Program';
import lblMaxPotential from '@salesforce/label/c.SFDC_V2_Account_ECP_Nearby_MaxPotential';
import lblDistance from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Distance';
import lblDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Display';
import lblHideDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Hide';
//end

export default class TabVisitsEcpNearby extends LightningElement {
    @api receivedId;

    optSVSNetwork = [{label : 'No Filter', value : ''}];
    errors1;

    errors2;

    @track isLoading = false;
    @track optValues;                       //for first option value - Segmentation
    @track CompetitorVal;                   //for first competitor local - First_local_competitor__c
    @track distance = '5';
    @track SVSNetworkVal;
    @track potentialMinVal;
    @track potentialMaxVal;
    @track mapMaker = [];
    @track markerTitle = 'ECP Nearby';
    @track vCenter;
    @track zoomLevel = 13;
    @track isDisplayList = true;
    @track optOption;
    @track displayListView = 'hidden';
    @track firstCompetitorSearch;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.mapMaker = [];
        this.handleKeyMapChange();
        //console.log('child connected call-' + this.receivedId);
    }

    get optSegment(){
        return[
            {label : 'No Filter', value : ''},
            {label : 'A1', value : 'A1'},
            {label : 'A2', value : 'A2'},
            {label : 'A3', value : 'A3'},
            {label : 'B1', value : 'B1'},
            {label : 'B2', value : 'B2'},
            {label : 'B3', value : 'B3'},
            {label : 'C1', value : 'C1'},
            {label : 'C2', value : 'c2'},
            {label : 'C3', value : 'C3'}

        ];
    }

    get optDistance(){
        return[
            {label : '2', value : '2'},
            {label : '5', value : '5'},
            {label : '10', value : '10'},
            {label : '25', value : '25'},
            {label : '50', value : '50'}
        ];
    }

    @wire(getSeikoNetworkPicklist) wirePickListSVSNetwork({data, error}){
        if(data){
            for(var i=0; i<data.length; i++){
                this.optSVSNetwork = [...this.optSVSNetwork, {label : data[i].label, value : data[i].values}];
            }
            this.errors1=undefined;
        }else if(error){
            this.data = undefined;
            this.errors1 = error;
            this.showToast('Error', JSON.stringify(this.errors1), 'error');
        }
    }

    get optCompetitor(){
        return[
            {label : 'No Filter', value : ''}
        ];
    }

    get optSeikoNetwork(){
        return this.optSVSNetwork;
    }

    handleKeyMapChange(){
        getAccountMapFetch({recordId : this.receivedId, distance : Math.floor(this.distance), SegmentationBox : this.optValues, PotentialMin : Math.floor(this.potentialMinVal), PotentialMax : Math.floor(this.potentialMaxVal), FirstLocalCampetitor : this.firstCompetitorSearch, svsnetwork : this.SVSNetworkVal})
        .then(result=>{
            this.mapMaker = [];
			if(result.length > 0){
				for(var i=0;i<result.length;i++){
                    //console.log('Data ==> '+JSON.stringify(result));
                    
                    let formattednetSalesValue = null;
                    let StrategicValueNet = null;

                    if(result[i].Lenses_Net_Sales_Last_12Mo){
                        const netsales = result[i].Lenses_Net_Sales_Last_12Mo;
                        formattednetSalesValue = new Intl.NumberFormat(USER_LOCALE, {style : 'currency', currency : result[i].AccCurrencyIsoCode}).format(netsales);
                    }else{
                        formattednetSalesValue = new Intl.NumberFormat(USER_LOCALE, {style : 'currency', currency : result[i].AccCurrencyIsoCode}).format(0);
                    }

                    if(result[i].Strategic_Value_Net_Sales){
                        const SValues = result[i].Strategic_Value_Net_Sales;
                        StrategicValueNet = new Intl.NumberFormat(USER_LOCALE, {style : 'currency', currency : result[i].AccCurrencyIsoCode}).format(SValues);
                    }else{
                        StrategicValueNet = new Intl.NumberFormat(USER_LOCALE, {style : 'currency', currency : result[i].AccCurrencyIsoCode}).format(0);
                    }

                    let mapDescription =    '<b>Hoya Account ID : </b>' + this.replaceUndefinedValue(result[i].Hoya_Account_ID) + '<br>' + 
                                            '<b>Brand : </b>' + this.replaceUndefinedValue(result[i].Brand) + '<br>' +
                                            '<b>Segmentation : </b>'+this.replaceUndefinedValue(result[i].Segmentation_Net) + '<br>' + 
                                            '<b>Strategic Value : </b>'+StrategicValueNet + '<br>' +
                                            '<b>Last 12 months sales : </b>'+formattednetSalesValue + '<br>' +
                                            '<b>HVC Loyalty Program : </b>'+this.replaceUndefinedValue(result[i].Seiko_Network) + '<br>' +
                                            '<b>Main Competitor : </b>'+this.replaceUndefinedValue(result[i].First_competitor_local) + '<br>' +
                                            '<b>Main competitor SOW : </b>'+this.replaceUndefinedValue(result[i].First_Competitor_SOW_Last_3_Month) + '<br>' +
                                            '<b>Last Store Visit Date : </b>'+this.replaceFormatDate(result[i].Last_visit_date) + '<br>' +
                                            '<b>Direct Visit Frequency : </b>'+this.replaceUndefinedValue(result[i].Visit_Frequency_Status) + '<br>' +
                                            '<b>Phone : </b>'+this.replaceUndefinedValue(result[i].AccPhone) + '<br>' +
                                            '<b>Address : </b>'+this.replaceUndefinedValue(result[i].AccShoptreet) + ' ' + this.replaceUndefinedValue(result[i].AccShopCity) + ' ' + this.replaceUndefinedValue(result[i].AccShopState) + ' ' + this.replaceUndefinedValue(result[i].AccShopPostalCode) + ' ' + this.replaceUndefinedValue(result[i].AccShopCountry);
                    
                    if(i==0){
                        this.mapMaker = [...this.mapMaker,
							{
								location : {
									Latitude : this.replaceUndefinedLatLong(result[i].AccLatitude),
									Longitude : this.replaceUndefinedLatLong(result[i].AccLongitude),
									Street : this.replaceUndefinedValue(result[i].AccShoptreet),
									City : this.replaceUndefinedValue(result[i].AccShopCity),
									State : this.replaceUndefinedValue(result[i].AccShopState),
									PostalCode : this.replaceUndefinedValue(result[i].AccShopPostalCode),
									Country : this.replaceUndefinedValue(result[i].AccShopCountry)
								},
								mapIcon : {
									path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
									fillColor: '#3338FF',
									fillOpacity: .7,
									strokeWeight: 1,
									scale: .15,             
								},
								icon : 'standard:account',
								title : result[i].AccName,
								value : result[i].accounId,
								description : mapDescription
							}
						];
                    }else{
                        this.mapMaker = [...this.mapMaker,
                            {
                                location : {
									Latitude : this.replaceUndefinedLatLong(result[i].AccLatitude),
									Longitude : this.replaceUndefinedLatLong(result[i].AccLongitude),
									Street : this.replaceUndefinedValue(result[i].AccShoptreet),
									City : this.replaceUndefinedValue(result[i].AccShopCity),
									State : this.replaceUndefinedValue(result[i].AccShopState),
									PostalCode : this.replaceUndefinedValue(result[i].AccShopPostalCode),
									Country : this.replaceUndefinedValue(result[i].AccShopCountry)
								},
                                icon : 'standard:account',
								title : result[i].AccName,
								value : result[i].accounId,
								description : mapDescription
                            }
                        ];
                    }
				}
				this.vCenter = {
					location : {
						Latitude : result[0].AccLatitude,
						Longitude : result[0].AccLongitude,
						Street : result[0].AccShoptreet,
						City : result[0].AccShopCity,
						State : result[0].AccShopState,
						PostalCode : result[0].AccShopPostalCode,
						Country : result[0].AccShopCountry
					},
				};
			}else{
				this.showToast('Warning', 'warining', 'Address details is missing');
			}

        })
        .catch(error=>{
            this.errors2 = error;
            this.showToast('Error', 'error', JSON.stringify(this.errors2));
        });
    }

    handleKeyChange(event){
        if(event.target.name === 'Segmentation'){
            this.optValues = event.target.value;
            this.handleKeyMapChange();
        }

        if(event.target.name === 'Competitor'){
            this.CompetitorVal = event.target.value;
            this.handleKeyMapChange();
        }

        if(event.target.name === 'SVSNetwork'){
            this.SVSNetworkVal = event.target.value;
            this.handleKeyMapChange();
        }

        if(event.target.name === 'distanceVal'){
            this.distance = event.target.value
            if(this.distance == 2){
                this.zoomLevel = 14;
            }else if(this.distance == 5){
                this.zoomLevel = 13;
            }else if(this.distance == 10){
                this.zoomLevel = 11.8;
            }else if(this.distance == 25){
                this.zoomLevel = 10;
            }else if(this.distance == 50){
                this.zoomLevel = 9;
            }else{
                this.zoomLevel = 13;
            }
            this.handleKeyMapChange();
        }

        if(event.target.name === 'PotentialMin'){
            this.potentialMinVal = event.target.value;
            this.handleKeyMapChange();
        }

        if(event.target.name === 'PotentialMax'){
            this.potentialMaxVal = event.target.value;
            this.handleKeyMapChange();
        }

        if(event.target.name === 'CompSearch'){
            this.firstCompetitorSearch = event.target.value;
            this.handleKeyMapChange();
        }

    }

    handleListViewShow(){
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }

    handleListViewHide(){
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: variant,
                }),
        );
    }

    handleSearchCompetitorChange(event){
        if(event.detail.selectedRecord != undefined){
            this.template.querySelector('lightning-input[data-my-id=CompSearch]').value = event.detail.selectedRecord.Value;
            this.firstCompetitorSearch = event.detail.selectedRecord.Value;
            console.log('Search for first competitor local = >'+this.firstCompetitorSearch);
            this.handleKeyMapChange();
        }else{
            this.template.querySelector('lightning-input[data-my-id=CompSearch]').value = '';
            this.firstCompetitorSearch = '';
            this.handleKeyMapChange();
        }
    }

    replaceUndefinedValue(value){
        return value === undefined || value === null ? '' : value;
    }

    replaceUndefinedLatLong(value){
        return value === undefined || value === null ? 0 : value;
    }

    replaceFormatDate(value){
        if(value == undefined || value == null){
            return '';
        }else{
            var datetime = new Date(value);
            const user_locale = USER_LOCALE;
            const options = {year:'numeric', month:'2-digit', day:'2-digit'};
            return new Intl.DateTimeFormat(user_locale, options).format(datetime);
        }
    }

    custlbl = {lblSegmentation, 
                lblMainCompetitor, 
                lblMinPotential, 
                lblHVCRoyaltyProgram,
                lblMaxPotential,
                lblDistance,
                lblDisplay,
                lblHideDisplay};
}