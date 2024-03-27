import { LightningElement, api, track, wire} from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//apex import class start here
import getAccountMapFetch from '@salesforce/apex/TabVisitsEcpNearby.getAccountsMap';
import getSeikoNetworkPicklist from '@salesforce/apex/TabVisitsEcpNearby.getSVSNetworkPicklistVal';
//End

//custom label start here -
import lblSegmentation from '@salesforce/label/c.SFDC_V_2_MVC_ContactRef_Segment';
import lblMainCompetitor from '@salesforce/label/c.SFDC_V2_Account_ECP_Nearby_MainCompetitor';
import lblMinPotential from '@salesforce/label/c.SFDC_V2_Account_ECP_Nearby_MinPotential';
import lblHVCRoyaltyProgram from '@salesforce/label/c.SFDC_V2_Account_ECP_Nearby_HVC';
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
					if(i==0){
						let AccountName = '';
						let HoyaAccountId = '';
						let AccountStreet = '';
						let AccountCity = '';
						let AccountState = '';
						let AccountCountry = '';
						let AccountPostalCode = '';
						let AccountShippingLatitude = 0;
						let AccountShippingLongitude = 0;
						let AccountBrand = '';
						let AccountSegment = '';
						let AccountMainCompetitor = '';

						if(result[i].Name != undefined){
							AccountName = result[i].Name;
						}

						if(result[i].Hoya_Account_ID__c != undefined){
							HoyaAccountId = result[i].Hoya_Account_ID__c;
						}

						if(result[i].ShippingStreet != undefined){
							AccountStreet = result[i].ShippingStreet;
						}

						if(result[i].ShippingCity != undefined){
							AccountCity = result[i].ShippingCity;
						}

						if(result[i].ShippingState != undefined){
							AccountState = result[i].ShippingState;
						}

						if(result[i].ShippingCountry != undefined){
							AccountCountry = result[i].ShippingCountry;
						}

						if(result[i].ShippingPostalCode != undefined){
							AccountPostalCode = result[i].ShippingPostalCode;
						}
                    
						if(result[i].ShippingLatitude != undefined){
							AccountShippingLatitude = result[i].ShippingLatitude;
						}
                    
						if(result[i].ShippingLongitude != undefined){
							AccountShippingLongitude = result[i].ShippingLongitude;
						}

						if(result[i].Brand__c != undefined){
							AccountBrand = result[i].Brand__c;
						}

						if(result[i].Segmentation_Net__c != undefined){
							AccountSegment = result[i].Segmentation_Net__c;
						}

						if(result[i].First_Competitor_local_name__c != undefined){
							AccountMainCompetitor = result[i].First_Competitor_local_name__c;
						}

						this.mapMaker = [...this.mapMaker,
							{
								location : {
									Latitude : AccountShippingLatitude,
									Longitude : AccountShippingLongitude,
									Street : AccountStreet,
									City : AccountCity,
									State : AccountState,
									PostalCode : AccountPostalCode,
									Country : AccountCountry
								},
								mapIcon : {
									path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
									fillColor: '#3338FF',
									fillOpacity: .7,
									strokeWeight: 1,
									scale: .15,             
								},
								icon : 'standard:account',
								title : AccountName,
								value : result[i].Id,
								description : 'Hoya Account Id : '+HoyaAccountId+'<br>Brand : '+AccountBrand+'<br>Segmentation : '+AccountSegment+'<br>Main Competitor : '+AccountMainCompetitor+'<br>Street : '+AccountStreet+' '+AccountCity+' '+AccountState+' '+AccountPostalCode+' '+AccountCountry,
							}
						];
					}else{
						let AccountName = '';
						let HoyaAccountId = '';
						let AccountStreet = '';
						let AccountCity = '';
						let AccountState = '';
						let AccountCountry = '';
						let AccountPostalCode = '';
						let AccountShippingLatitude = 0;
						let AccountShippingLongitude = 0;
						let AccountBrand = '';
						let AccountSegment = '';
						let AccountMainCompetitor = '';

						if(result[i].Name != undefined){
							AccountName = result[i].Name;
						}

						if(result[i].Hoya_Account_ID__c != undefined){
							HoyaAccountId = result[i].Hoya_Account_ID__c;
						}

						if(result[i].ShippingStreet != undefined){
							AccountStreet = result[i].ShippingStreet;
						}

						if(result[i].ShippingCity != undefined){
							AccountCity = result[i].ShippingCity;
						}

						if(result[i].ShippingState != undefined){
							AccountState = result[i].ShippingState;
						}

						if(result[i].ShippingCountry != undefined){
							AccountCountry = result[i].ShippingCountry;
						}

						if(result[i].ShippingPostalCode != undefined){
							AccountPostalCode = result[i].ShippingPostalCode;
						}
                    
						if(result[i].ShippingLatitude != undefined){
							AccountShippingLatitude = result[i].ShippingLatitude;
						}

						if(result[i].ShippingLongitude != undefined){
							AccountShippingLongitude = result[i].ShippingLongitude;
						}

						if(result[i].Brand__c != undefined){
							AccountBrand = result[i].Brand__c;
						}

						if(result[i].Segmentation_Net__c != undefined){
							AccountSegment = result[i].Segmentation_Net__c;
						}

						if(result[i].First_Competitor_local_name__c != undefined){
							AccountMainCompetitor = result[i].First_Competitor_local_name__c;
						}

						this.mapMaker = [...this.mapMaker,
							{
								location : {
									Latitude : AccountShippingLatitude,
									Longitude : AccountShippingLongitude,
									Street : AccountStreet,
									City : AccountCity,
									State : AccountState,
									PostalCode : AccountPostalCode,
									Country : AccountCountry
								},
									icon : 'standard:account',
									title : AccountName,
								value : result[i].Id,
								description : 'Hoya Account Id : '+HoyaAccountId+'<br>Brand : '+AccountBrand+'<br>Segmentation : '+AccountSegment+'<br>Main Competitor : '+AccountMainCompetitor+'<br>Street : '+AccountStreet+' '+AccountCity+' '+AccountState+' '+AccountPostalCode+' '+AccountCountry,
							}
						];
					}
				}
				this.vCenter = {
					location : {
						Latitude : result[0].ShippingLatitude,
						Longitude : result[0].ShippingLongitude,
						Street : result[0].ShippingStreet,
						City : result[0].ShippingCity,
						State : result[0].ShippingState,
						PostalCode : result[0].ShippingPostalCode,
						Country : result[0].ShippingCountry
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

    custlbl = {lblSegmentation, 
                lblMainCompetitor, 
                lblMinPotential, 
                lblHVCRoyaltyProgram,
                lblMaxPotential,
                lblDistance,
                lblDisplay,
                lblHideDisplay};
}