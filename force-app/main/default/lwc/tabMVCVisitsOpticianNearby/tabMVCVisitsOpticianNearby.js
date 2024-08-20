import { LightningElement, api, wire, track } from 'lwc';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactNearby from '@salesforce/apex/tabMVCOpticianNearby.getContactNearby';
import getVisionaryAlliance from '@salesforce/apex/tabMVCOpticianNearby.getPicklistVisionaryAlliance';
import { refreshApex } from '@salesforce/apex';

import getCustVisionaryAlliance from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_HVC';
import getlblMyoSmartAuthorize from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_MyoSmart';
import getlblSegment from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import getlblHoyaVisionCenter from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_HCenter';
import getlblDistance from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Distance';
import getlblSeikoVision from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Seiko';
import Opticians_Nearby_section from '@salesforce/label/c.Opticians_Nearby_section';

export default class TabMVCVisitsOpticianNearby extends LightningElement {
    @api receivedId;

    wireRecord;
    @track VSValues = '';
    @track segmentation = '';
    @track isLoading = false;
    @track isMyoSmart = false;
    @track isHoyaVisionCenter = false;
    @track isSeikoSpecialist = false;
    @track distanceValue = '5';
    @track mapMarkers = [];
    @track mapMarker = [];
    @track vCenter;
    @track markersTitle = 'Optician Nearby';
    @track zoomLevel = 13;
    @track isDisplayList = true;        //true means display list view on map = hidden
    @track error;


    item1 = [{label : 'No Filter', value : 'No Filter'}];
    error1;
    errors;
    showMap = true;

    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback() {
        /*
        this.isLoading = true;
        this.handleKeyChangeMap();
        this.isLoading = false;
        */
    }

    @api 
    async handleRefreshEvent(){
        this.isLoading = true;
        this.handleListViewHide();
        this.showMap = false;
        //this.handleKeyChangeMap();
        return refreshApex(this.wireRecord);
        
    }

    @wire(getVisionaryAlliance) wirePicklistValues({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.item1 = [...this.item1, {label : data[i].label, value : data[i].values}];
            }
            this.error1 = undefined;
        }else if(error){
            this.data = undefined;
            this.error1 = error;
            this.showToast('Error', 'error', this.error1);
        }
    }

    @wire(getContactNearby, {recordId : '$receivedId', distance : '$distanceValue', VisionAll : '$VSValues', IsMyoSmart : '$isMyoSmart', IsHvCenter : '$isHoyaVisionCenter', IsSeikoNetwork : '$isSeikoSpecialist', Segmentation : '$segmentation'})
    getAccountByContactNearbyWire(wireResult){
        this.isLoading = true;

        const {data, error} = wireResult;
        this.wireRecord = wireResult;
        
        if(data){
            this.mapMarker = [];
            console.log('Data records == > '+data.length);
            if(data.length > 0){
                data.forEach(dataItem=>{
                    //let MapDescription1 = 'Hoya Account ID : '+dataItem.accountHoyaAccId+'<br>'+dataItem.accountShippingStreet+'&nbsp;'+dataItem.accountShippingCity+'&nbsp;'+dataItem.accountShippingState+'<br>Phone : '+dataItem.accountPhone;
                    //let MapDescription2 = 'Hoya Account ID : '+dataItem.accountHoyaAccId+'<br>Brand :'+dataItem.accountBrand+'<br>Segmentation : '+dataItem.accountSegmentation+'<br>1st Competitor Global : '+dataItem.FirstCompetitorGlobal+'<br>1st Competitor Local : '+dataItem.FirstCompetitorLocal+'<br>1st Competitor SOW : '+dataItem.FirstCompetitorSOW+'<br>MiyoSmart Authorize Dealer : '+dataItem.accountMyoSmart+'<br>Street : '+dataItem.accountShippingStreet+'&nbsp;'+dataItem.accountShippingCity+'&nbsp;'+dataItem.accountShippingState;
                    let MapDescription =    '<b>Hoya Account Id : </b>'+this.replaceUndefine(dataItem.accountHoyaAccId) + '<br>' + 
                                        '<b>Brand : </b>' + this.replaceUndefine(dataItem.accountBrand) + '<br>'+
                                        '<b>Segmentation : </b>' + this.replaceUndefine(dataItem.accountSegmentation) + '<br>' + 
                                        '<b>Main Competitor : </b>' + this.replaceUndefine(dataItem.FirstCompetitorLocal) + '<br>' +
                                        '<b>Miyo Smart Authorize Dealer : </b>'+ this.replaceUndefine(dataItem.accountMyoSmart) + '<br>' +
                                        '<b>Address : </b>'+ this.replaceUndefine(dataItem.accountShippingStreet) + ' ' + this.replaceUndefine(dataItem.accountShippingCity) + ' ' + this.replaceUndefine(dataItem.accountShippingState) + ' ' + this.replaceUndefine(dataItem.accountShippingPostalCode) + ' ' + this.replaceUndefine(dataItem.accountShippingCountry);
                    if(dataItem.accountRecType == 'Clinic'){
                        this.mapMarker = [...this.mapMarker,
                            {
                                location : {
                                    //Latitude : dataItem.accountShippingLatitude,
                                    //Longitude : dataItem.accountShippingLongitude,
                                    Street : dataItem.accountShippingStreet,
                                    City : dataItem.accountShippingCity,
                                    State : dataItem.accountShippingState,
                                    Country : dataItem.accountShippingCountry,
                                    PostalCode : dataItem.accountShippingPostalCode
                                },
                                mapIcon : {
                                    path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                    fillColor: '#3338FF',
                                    fillOpacity: .7,
                                    strokeWeight: 1,
                                    scale: .15,     
                                },
                                icon : 'standard:account',
                                title : dataItem.accountName,
                                value : dataItem.accountId,
                                description : MapDescription
                            }
                        ];
                    }else if(dataItem.accConsIsDirect == false){
                        this.mapMarker = [...this.mapMarker,
                            {
                                location : {
                                    //Latitude : dataItem.accountShippingLatitude,
                                    //Longitude : dataItem.accountShippingLongitude,
                                    Street : dataItem.accountShippingStreet,
                                    City : dataItem.accountShippingCity,
                                    State : dataItem.accountShippingState,
                                    Country : dataItem.accountShippingCountry,
                                    PostalCode : dataItem.accountShippingPostalCode
                                },
                                mapIcon: {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: 'green',
                                    fillOpacity: 0.7,
                                    strokeWeight: 1,
                                    scale: 1.5,
                                },
                                icon : 'standard:account',
                                title : dataItem.ClinicName,
                                value : dataItem.accountId,
                                description : MapDescription
                            }

                        ];
                    }else{
                        //show red pin on the map
                        this.mapMarker = [...this.mapMarker,
                            {
                                location : {
                                    //Latitude : dataItem.accountShippingLatitude,
                                    //Longitude : dataItem.accountShippingLongitude,
                                    Street : dataItem.accountShippingStreet,
                                    City : dataItem.accountShippingCity,
                                    State : dataItem.accountShippingState,
                                    Country : dataItem.accountShippingCountry,
                                    PostalCode : dataItem.accountShippingPostalCode
                                },
                                icon : 'standard:account',
                                title : dataItem.accountName,
                                value : dataItem.accountId,
                                description : MapDescription
                            }
                        ];
                    }
                });
                this.vCenter = {
                    location : {
                        //Latitude : data[0].accountShippingLatitude,
                        //Longitude : data[0].accountShippingLongitude,
                        Street : data[0].accountShippingStreet,
                        City : data[0].accountShippingCity,
                        State : data[0].accountShippingState,
                        Country : data[0].accountShippingCountry,
                        PostalCode : data[0].accountShippingCountry
                    }
                }
                this.showMap = true;
                this.isLoading = false;
            }else{
                this.showToast('Warning', 'Warning', 'Address details missing');
                this.showMap = true;
                this.isLoading = false;
            }
        }else if(error){
            this.showToast('Error', 'Error', JSON.stringify(error));
            console.log('An error was occured ==> '+JSON.stringify(error));
            this.showMap = true;
            this.isLoading = false;
        }
    }
    /*
    handleKeyChangeMap(){
        getContactNearby({recordId : this.receivedId, distance : Math.floor(this.distanceValue), VisionAll : this.VSValues, IsMyoSmart : this.isMyoSmart, IsHvCenter : this.isHoyaVisionCenter, IsSeikoNetwork : this.isSeikoSpecialist, Segmentation : this.segmentation})
        .then(result=>{
            console.log('(1) Record Id from handledKeyChangeMap == > '+this.receivedId);
            console.log('(2) Distance from handled keymap change ==> '+this.distanceValue);
            console.log('(3) Vision All == > '+this.VSValues);
            console.log('(4) Is miyo smart ==> '+this.isMyoSmart);
            console.log('(5) Is HVC Center ==> '+this.isHoyaVisionCenter);
            console.log('(6) Is seiko network ===> '+this.isSeikoSpecialist);
            console.log('(7) segmentation == > '+this.segmentation);
            console.log('Data loading from handledKeyChangeMap == > '+result.length +' records == > '+JSON.stringify(result));
            this.mapMarker = [];
            //console.log('Record seult == > '+result.length);
            if(result.length > 0){
                for(var i=0; i<result.length; i++){
                    if(result[i].accountRecType=='Clinic'){
                        //show star on map
                        this.mapMarker = [...this.mapMarker, 
                            {
                                location : {
                                    Latitude : result[i].accountShippingLatitude,
                                    Longitude : result[i].accountShippingLongitude,
                                    Street : result[i].accountShippingStreet,
                                    City : result[i].accountShippingCity,
                                    State : result[i].accountShippingState,
                                    Country : result[i].accountShippingCountry,
                                    PostalCode : result[i].accountShippingPostalCode
                                },
                                mapIcon : {
                                    path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                    fillColor: '#3338FF',
                                    fillOpacity: .7,
                                    strokeWeight: 1,
                                    scale: .15,             
                                },
                                icon : 'standard:account',
                                title : result[i].ClinicName,
                                value : result[i].accountId,
                                description : 'Hoya Account ID : '+result[i].accountHoyaAccId+'<br>'+result[i].accountShippingStreet+'&nbsp;'+result[i].accountShippingCity+'&nbsp;'+result[i].accountShippingState+'<br>Phone : '+result[i].accountPhone,
                            }
                        ];
                    }else if(result[i].accConsIsDirect == false){
                        //show green pin on the map
                        this.mapMarker = [...this.mapMarker, 
                            {
                                location : {
                                    Latitude : result[i].accountShippingLatitude,
                                    Longitude : result[i].accountShippingLongitude,
                                    Street : result[i].accountShippingStreet,
                                    City : result[i].accountShippingCity,
                                    State : result[i].accountShippingState,
                                    Country : result[i].accountShippingCountry,
                                    PostalCode : result[i].accountShippingPostalCode
                                },
                                mapIcon: {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: 'green',
                                    fillOpacity: 0.7,
                                    strokeWeight: 1,
                                    scale: 1.5,
                                },
                                icon : 'standard:account',
                                title : result[i].accountName,
                                value : result[i].accountId,
                                description : 'Hoya Account ID : '+result[i].accountHoyaAccId+'<br>'+result[i].accountShippingStreet+'&nbsp;'+result[i].accountShippingCity+'&nbsp;'+result[i].accountShippingState+'<br>Phone : '+result[i].accountPhone,
                            }
                        ];

                    }else{
                        // show red pin on map
                        this.mapMarker = [...this.mapMarker, 
                            {
                                location : {
                                    Latitude : result[i].accountShippingLatitude,
                                    Longitude : result[i].accountShippingLongitude,
                                    Street : result[i].accountShippingStreet,
                                    City : result[i].accountShippingCity,
                                    State : result[i].accountShippingState,
                                    Country : result[i].accountShippingCountry,
                                    PostalCode : result[i].accountShippingPostalCode
                                },
                                icon : 'standard:account',
                                title : result[i].accountName,
                                value : result[i].accountId,
                                description : 'Hoya Account ID : '+result[i].accountHoyaAccId+'<br>Brand :'+result[i].accountBrand+'<br>Segmentation : '+result[i].accountSegmentation+'<br>1st Competitor Global : '+result[i].FirstCompetitorGlobal+'<br>1st Competitor Local : '+result[i].FirstCompetitorLocal+'<br>1st Competitor SOW : '+result[i].FirstCompetitorSOW+'<br>MiyoSmart Authorize Dealer : '+result[i].accountMyoSmart+'<br>Street : '+result[i].accountShippingStreet+'&nbsp;'+result[i].accountShippingCity+'&nbsp;'+result[i].accountShippingState,
                            }
                        ];
                    } 
                }
                this.vCenter = {
                    location : {
                        Latitude : result[0].accountShippingLatitude,
                        Longitude : result[0].accountShippingLongitude,
                        Street : result[0].accountShippingStreet,
                        City : result[0].accountShippingCity,
                        State : result[0].accountShippingState,
                        Country : result[0].accountShippingCountry,
                        PostalCode : result[0].accountShippingPostalCode
                    },
                }
            }else{
                this.showToast('Warning', 'Warning', 'Address details missing');
            }
        })
        .catch(error=>{
            this.errors = error;
            console.log('Error was occured == > '+JSON.stringify(this.error));
            this.showToast('Error', 'error', JSON.stringify(this.errors));
        });
    }*/

    get VSAllianceValues(){
        return this.item1;
    }

    get optSegmentation(){
        return [
            { label : 'No Filter', value : 'No Filter'},
            { label : 'A1', value : 'A1'},
            { label : 'A2', value : 'A2'},
            { label : 'A3', value : 'A3'},
            { label : 'B1', value : 'B1'},
            { label : 'B2', value : 'B2'},
            { label : 'B3', value : 'B3'},
            { label : 'C1', value : 'C1'},
            { label : 'C2', value : 'C2'},
            { label : 'C3', value : 'C3'}
        ]
    }

    get optDistanceValue(){
        return [
            { label : '1km', value : '1'},
            { label : '2km', value : '2'},
            { label : '5km', value : '5'},
            { label : '10km', value : '10'},
            { label : '25km', value : '25'},
            { label : '50km', value : '50'}
        ]
    }

    handleKeyChange(event){
        this.isLoading = true;
        if(event.target.name === 'IsisMyoSmart'){
            if(event.target.checked){
                this.isMyoSmart = true;
                //this.handleKeyChangeMap();
                this.handleRefreshEvent();
                
            }else{
                this.isMyoSmart = false;
                //this.handleKeyChangeMap();
                this.handleRefreshEvent();
            }
        }

        if(event.target.name === 'VisionaryAlliance'){
            this.VSValues = event.target.value;
            //this.handleKeyChangeMap();
            this.handleRefreshEvent();
        }

        if(event.target.name === 'Issegmentation'){
            this.segmentation = event.target.value;
            //this.handleKeyChangeMap();
            this.handleRefreshEvent();
        }

        if(event.target.name === 'IsHoyaVisionCenter'){
            if(event.target.checked){
                this.isHoyaVisionCenter = true;
                //this.handleKeyChangeMap();
                this.handleRefreshEvent();
            }else{
                this.isHoyaVisionCenter = false;
                //this.handleKeyChangeMap();
                this.handleRefreshEvent();
            }
        }

        if(event.target.name === 'distance'){
            this.distanceValue = event.target.value;

            if(this.distanceValue == '1'){
                this.zoomLevel = 15;
            }else if(this.distanceValue == '2'){
                this.zoomLevel = 14;

            }else if(this.distanceValue == '5'){
                this.zoomLevel = 13;

            }else if(this.distanceValue == '10'){
                this.zoomLevel = 11.8;
            }else if(this.distanceValue == '25'){
                this.zoomLevel = 10;
            }else if(this.distanceValue == '50'){
                this.zoomLevel = 9
            }else{
                this.zoomLevel = 13;
            }
            //this.handleKeyChangeMap();
            this.handleRefreshEvent();
        }

        if(event.target.name === 'IsSeikoVision'){
            if(event.target.checked){
                this.isSeikoSpecialist = true;
                //this.handleKeyChangeMap();
                this.handleRefreshEvent();
            }else{
                this.isSeikoSpecialist = false;
                //this.handleKeyChangeMap();
                this.handleRefreshEvent();
            }
        }
        this.isLoading = false;
    }

    handleListViewShow(){
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }

    handleListViewHide(){
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }

    replaceUndefine(value){
        return value === undefined || value === null ? '' : value;
    }

    label = {getCustVisionaryAlliance, 
            getlblMyoSmartAuthorize, 
            getlblSegment, 
            getlblHoyaVisionCenter, 
            getlblDistance,
            getlblSeikoVision,
            Opticians_Nearby_section};

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                    title: title,
                    message: message,
                    variant: variant,
            }),
        );
    }
}