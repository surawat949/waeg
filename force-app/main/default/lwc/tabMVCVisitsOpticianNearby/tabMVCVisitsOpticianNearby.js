import { LightningElement, api, wire, track } from 'lwc';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactNearby from '@salesforce/apex/tabMVCOpticianNearby.getContactNearby';
import getVisionaryAlliance from '@salesforce/apex/tabMVCOpticianNearby.getPicklistVisionaryAlliance';

import getCustVisionaryAlliance from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_HVC';
import getlblMyoSmartAuthorize from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_MyoSmart';
import getlblSegment from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import getlblHoyaVisionCenter from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_HCenter';
import getlblDistance from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Distance';
import getlblSeikoVision from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Seiko';
import Opticians_Nearby_section from '@salesforce/label/c.Opticians_Nearby_section';

export default class TabMVCVisitsOpticianNearby extends LightningElement {
    @api receivedId;

    record;
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
    @track zoomLevel = 8;
    @track isDisplayList = true;        //true means display list view on map = hidden
    @track error;

    item1 = [{label : 'No Filter', value : 'No Filter'}];
    error1;
    errors;

    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback() {
        this.handleKeyChangeMap();
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

    handleKeyChangeMap(){
        getContactNearby({recordId : this.receivedId, distance : Math.floor(this.distanceValue), VisionAll : this.VSValues, IsMyoSmart : this.isMyoSmart, IsHvCenter : this.isHoyaVisionCenter, IsSeikoNetwork : this.isSeikoSpecialist, Segmentation : this.segmentation})
        .then(result=>{
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
    }

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
        if(event.target.name === 'IsisMyoSmart'){
            if(event.target.checked){
                this.isMyoSmart = true;
                this.handleKeyChangeMap();
            }else{
                this.isMyoSmart = false;
                this.handleKeyChangeMap();
            }
        }

        if(event.target.name === 'VisionaryAlliance'){
            this.VSValues = event.target.value;
            this.handleKeyChangeMap();
        }

        if(event.target.name === 'Issegmentation'){
            this.segmentation = event.target.value;
            this.handleKeyChangeMap();
        }

        if(event.target.name === 'IsHoyaVisionCenter'){
            if(event.target.checked){
                this.isHoyaVisionCenter = true;
                this.handleKeyChangeMap();
            }else{
                this.isHoyaVisionCenter = false;
                this.handleKeyChangeMap();
            }
        }

        if(event.target.name === 'distance'){
            this.distanceValue = event.target.value;
            this.handleKeyChangeMap();
        }

        if(event.target.name === 'IsSeikoVision'){
            if(event.target.checked){
                this.isSeikoSpecialist = true;
                this.handleKeyChangeMap();
            }else{
                this.isSeikoSpecialist = false;
                this.handleKeyChangeMap();
            }
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