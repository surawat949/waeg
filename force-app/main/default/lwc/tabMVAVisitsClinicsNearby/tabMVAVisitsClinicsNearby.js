import { LightningElement, api, wire, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//import ContactTypePickList from '@salesforce/apex/tabMVAVisitsClinicNearbyController.getAccClinicTypeValue';
import getContactNearby from '@salesforce/apex/tabMVAVisitsClinicNearbyController.getAccountsNearBy';
import USER_LOCALE from '@salesforce/i18n/locale';
import { refreshApex } from '@salesforce/apex';

//import FilterType from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_AccType';
import ClnicNearby from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy';
import MyoSmart from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_MyoSmart';
import noOfPrescribers from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Prescribe';
import lblDisplayList from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Display';
import lblHideList from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Hide';

let i = 0;

export default class TabMVAVisitsClinicsNearby extends LightningElement {
    @api receivedId;

    mapRecord;

    @track isLoading = false;
    @track fstNumber;
    @track sndNumber;
    @track distanceNo = 5;
   // @track ClinicType = '';
    @track numberOfPrescriber = 0;
    @track isMiyoSmart = '';
    @track mapMaker = [];
    @track myJson = [];
    @track wireGetNearbylist = [];
    @track vCenter;
    @track errors;
    @track markerTitle = 'Account';
    @track displayListView = 'hidden';
    @track isDisplayList = true;        //true is mean display list view on map = hidden
    @track zoomLevel = 13;

    //item1 = [{ label : 'No Filter', value : 'No Filter'}];

    value = '5';
    valueNoFilter = 'No Filter Selected';

    error1;

    connectedCallback(){
        //console.log('Received Id == > '+this.receivedId);
        refreshApex(this.wireGetNearbylist);
        this.handleKeyChangeMap();
    }

    handleKeyChangeMap(){
        getContactNearby({recordId : this.receivedId, distance : Math.floor(this.distanceNo), MiyoSmartAuth : this.isMiyoSmart, prescribers : this.numberOfPrescriber})
        .then(result =>{
            //this.mapRecord = result[0];
            this.wireGetNearbylist = result;
            this.mapMaker = [];
                for(var i=0;i<result.length;i++){
                    let counting = result[i].Contacts;
                    if(counting == null || counting == undefined){
                        counting = 0;
                    }else{
                        counting = result[i].Contacts.length;
                    }
                    let allRelatedCounting = result[i].AccountContactRelations;
                    if(allRelatedCounting == null || allRelatedCounting == undefined){
                        allRelatedCounting = 0;
                    }else{
                        allRelatedCounting = result[i].AccountContactRelations.length;
                    }
                    let descriptionBlue =   '<b>Clinic Name : </b>'+result[i].Clinic_Name__c + '<br>' + 
                                        '<b>Hoya Account ID : </b>'+result[i].Hoya_Account_ID__c + '<br>' + 
                                        '<b>Number of preferred Prescribers : </b>'+counting + '<br>' + 
                                        '<b>Total number of prescribers : </b>'+allRelatedCounting + '<br>' +
                                        '<b>Last direct visit date : </b>'+this.replaceFormatDate(result[i].Last_Visit_date__c) + '<br>' +
                                        '<b>Address : </b>'+this.replaceUndefineValue(result[i].Shop_Street__c) + ' ' + this.replaceUndefineValue(result[i].Shop_City__c) + ' ' + this.replaceUndefineValue(result[i].Shop_State__c) + ' ' + this.replaceUndefineValue(result[i].Shop_Postal_Code__c) + ' ' + this.replaceUndefineValue(result[i].Shop_Country__c) + '<br>' +
                                        '<b>Phone : </b>'+this.replaceUndefineValue(result[i].Phone);
                    
                    let descriptionRed =    '<b>Hoya Account Id : </b>'+this.replaceUndefineValue(result[i].Hoya_Account_ID__c) + '<br>' +
                                            '<b>Brand : </b>'+this.replaceUndefineValue(result[i].Brand__c) + '<br>' +
                                            '<b>Segmentation : </b>'+this.replaceUndefineValue(result[i].Segmentation_Net__c) + '<br>' +
                                            '<b>Main Competitor : </b>'+this.replaceUndefineValue(result[i].First_Competitor_local_name__c) + '<br>' +
                                            '<b>MiyoSmart Authorize Dealer : </b>' + this.replaceMiyoSmartAuthorize(result[i].Myo_Smart_AuthorizeDealer__c) + '<br>' +
                                            '<b>Address : </b>'+this.replaceUndefineValue(result[i].Shop_Street__c) + ' ' + this.replaceUndefineValue(result[i].Shop_City__c) + ' ' + this.replaceUndefineValue(result[i].Shop_State__c) + ' ' + this.replaceUndefineValue(result[i].Shop_Postal_Code__c) + ' ' + this.replaceUndefineValue(result[i].Shop_Country__c);
                    if(i==0){
                        if(result[i].RecordType.DeveloperName == 'Clinic'){
                            this.mapMaker = [...this.mapMaker,
                                {
                                    location : {
                                        //Latitude : result[i].ShippingLatitude,
                                        //Longitude : result[i].ShippingLongitude,
                                        City : result[i].Shop_City__c,
                                        Country : result[i].Shop_Country__c,
                                        Street : result[i].Shop_Street__c,
                                        State : result[i].Shop_State__c,
                                        PostalCode : result[i].Shop_Postal_Code__c
                                    },
                                    mapIcon : {
                                        path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                        fillColor: '#3338FF',
                                        fillOpacity: .7,
                                        strokeWeight: 1,
                                        scale: .15,
                                    },
                                    icon : 'standard:account',
                                    title : result[i].Name,
                                    value : result[i].Id,
                                    description : descriptionBlue
                                }
            
                            ];
                        }
                    }else{
                        if(result[i].RecordType.DeveloperName == 'Clinic'){
                            this.mapMaker = [...this.mapMaker,
                                {
                                    location : {
                                        //Latitude : result[i].ShippingLatitude,
                                        //Longitude : result[i].ShippingLongitude,
                                        City : result[i].Shop_City__c,
                                        Country : result[i].Shop_Country__c,
                                        Street : result[i].Shop_Street__c,
                                        State : result[i].Shop_State__c,
                                        PostalCode : result[i].Shop_Postal_Code__c
                                    },
                                    mapIcon : {
                                        path:'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                        fillColor: '#0000FF',
                                        fillOpacity: 1,
                                        strokeWeight: 1.1,
                                        scale: 1.5
                                    },
                                    icon : 'standard:account',
                                    title : result[i].Name,
                                    value : result[i].Id,
                                    description : descriptionBlue
                                }
            
                            ];
                        }else{
                            this.mapMaker = [...this.mapMaker,
                                {
                                    location : {
                                        //Latitude : result[i].ShippingLatitude,
                                        //Longitude : result[i].ShippingLongitude,
                                        City : result[i].Shop_City__c,
                                        Country : result[i].Shop_Country__c,
                                        Street : result[i].Shop_Street__c,
                                        State : result[i].Shop_State__c,
                                        PostalCode : result[i].Shop_Postal_Code__c
                                    },
                                    icon : 'standard:account',
                                    title : result[i].Name,
                                    value : result[i].Id,
                                    description : descriptionRed
                                }
            
                            ];
                        }
                    }
                }
            
            this.vCenter = {
                location : {
                    //Latitude : result[0].ShippingLatitude,
                    //Longitude : result[0].ShippingLongitude,
                    Street : result[0].Shop_Street__c,
                    City : result[0].Shop_City__c,
                    State : result[0].Shop_State__c,
                    Country : result[0].Shop_Country__c,
                    PostalCode : result[0].Shop_Postal_Code__c
                },
            };
            
        })
        .catch(error=>{
            this.errors = error;
            //console.log('XXX Get Map Error = >'+JSON.stringify(this.errors));
            this.showToast('Error', 'error', this.errors);
        });
    }

   /* @wire(ContactTypePickList) wireClinicTypeValue({data,error}){
        if(data){
            for(i=0;i<data.length;i++){
                this.item1 = [...this.item1, {value : data[i].values, label : data[i].label}];
            }
            this.error1 = undefined;
        }else if(error){
            this.data = undefined;
            this.error1 = error;
            //console.log('XXX Get Clinic Type Picklist Values Error =>'+JSON.stringify(this.error1));
            this.showToast('Error', 'error', this.error1);
        }
    }*/

    onKeyChange(event){
        if(event.target.name === 'distance'){
            refreshApex(this.wireGetNearbylist);
            this.distanceNo = Math.floor(event.target.value);
            this.handleKeyChangeMap();
        }
        /*if(event.target.name === 'ClinicType'){
            refreshApex(this.wireGetNearbylist);
            this.ClinicType = event.target.value;
            this.handleKeyChangeMap();
        }*/
        if(event.target.name === 'MiyoSmart'){
            refreshApex(this.wireGetNearbylist);
            this.isMiyoSmart = event.target.value;
            this.handleKeyChangeMap();
        }
        if (event.target.name === 'Prescriber') {
            refreshApex(this.wireGetNearbylist);
            this.numberOfPrescriber = Math.floor(event.target.value);
            this.handleKeyChangeMap();
        }

        if(event.target.name === 'distance'){
            this.distanceNo = event.target.value;
            if(this.distanceNo == 1){
                this.zoomLevel = 15;

            }else if(this.distanceNo == 2){
                this.zoomLevel = 14;;
            }else if(this.distanceNo == 5){
                this.zoomLevel = 13;
            }else if(this.distanceNo == 10){
                this.zoomLevel = 11.8;
            }else if(this.distanceNo == 25){
                this.zoomLevel = 10;
            }else if(this.distanceNo == 50){
                this.zoomLevel = 9;
            }else{
                this.zoomLevel = 13;
            }
            this.handleKeyChangeMap();
        }
    }

    get options(){
        return [
            { label : '1km', value : '1'},
            { label : '2km', value : '2'},
            { label : '5km', value : '5'},
            { label : '10km', value : '10'},
            { label : '25km', value : '25'},
            { label : '50km', value : '50'}
        ];
    }


    get optionsMiyosmart(){
        return [
            { label : 'No Filter', value : 'No Filter'},
            { label : 'YES', value : 'YES'},
            { label : 'NO', value : 'NO'}
            
        ];
    }

    get optionsPrescriber(){
        return [
            { label : 'No Filter', value : 'No Filter'},
            { label : '1', value : '1'},
            { label : '2', value : '2'},
            { label : '3', value : '3'},
            { label : '4', value : '4'},
            { label : '5', value : '5'},
            { label : '6', value : '6'},
            { label : '7', value : '7'},
            { label : '8', value : '8'},
            { label : '9', value : '9'},
            { label : '10', value : '10'}
        ];
    }

    get ClinicTypeOpt(){
        return this.item1;
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
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    replaceUndefineValue(value){
        return value === undefined || value === null ? '' : value;
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

    replaceMiyoSmartAuthorize(value){
        return value === false || value === undefined || value === null ? 'No' : 'Yes';
    }

    label = {ClnicNearby, MyoSmart,noOfPrescribers, lblDisplayList, lblHideList, lblDisplayList};
}