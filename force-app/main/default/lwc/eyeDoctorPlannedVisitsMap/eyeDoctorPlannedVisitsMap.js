import { LightningElement, api, track, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_LOCALE from '@salesforce/i18n/locale';

//import apex class here
import getMedicalVisitPlanned from '@salesforce/apex/VPMPlannedVisitsMapController.getMedicalVisitsPlanning';
import getTranslations from '@salesforce/apex/visitZonesMapController.getTranslations';

//import custom label here
import lblDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Display';
import lblHideDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Hide';
import lblDistance from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Distance';

export default class EyeDoctorPlannedVisitsMap extends LightningElement {
    @track isLoading = false;
    @track mapMaker = [];
    @track vCenter;
    @track mapTitle = 'Medical Planned Visit Map';
    @track isDisplayList = true;
    @track displayListView = 'hidden';
    @track zoomLevel = 12;
    @track todayDate;
    @track nextDateWeekend;
    @track SearchStartDate;
    @track SearchEndDate;
    @track distanceValue = '20';

    @track contactsData = [];

    @track translations = [];

    subArea1;
    subArea2;
    subArea3;
    subArea4;
    subArea5;

    connectedCallback(){
        this.getCurrentDate();
        this.SearchStartDate = this.todayDate;
        this.SearchEndDate = this.nextDateWeekend;
        this.handleKeyMapChange();
        
        getTranslations().then(result=>{
            this.translations = result;
            if(this.translations){
                this.subArea1 = this.translations['Sub-area 1'];
                this.subArea2 = this.translations['Sub-area 2'];
                this.subArea3 = this.translations['Sub-area 3'];
                this.subArea4 = this.translations['Sub-area 4'];
                this.subArea5 = this.translations['Sub-area 5'];
            }
        }).catch(error=>{
            this.showToast('Error', 'error', JSON.stringify(error.message));
        });
    }

    handleKeyChange(event){
        if(event.target.name === 'picklistOptDistance'){
            this.distanceValue = event.target.value;
            if(this.distanceValue == 20){
                this.zoomLevel = 12;
            }else if(this.distanceValue == 30){
                this.zoomLevel = 11;
            }else if(this.distanceValue == 50){
                this.zoomLevel = 10;
            }else if(this.distanceValue == 100){
                this.zoomLevel = 9;
            }else if(this.distanceValue == 200){
                this.zoomLevel = 8;
            }else if(this.distanceValue == 300){
                this.zoomLevel = 7;
            }else if(this.distanceValue == 500){
                this.zoomLevel = 6;
            }else{
                this.zoomLevel = 12;
            }
            this.handleKeyMapChange();
        }
    }

    handleDateChange(event){
        if(event.target.name === 'date01'){
            this.todayDate = event.target.value;
            //console.log('New search start date => '+this.todayDate);
        }
        if(event.target.name === 'date02'){
            this.nextDateWeekend = event.target.value;
            //console.log('New search end date => '+this.nextDateWeekend);
        }
    }

    handleSearchBtn(){
        this.SearchStartDate = this.todayDate;
        this.SearchEndDate = this.nextDateWeekend;
        this.handleKeyMapChange();
    }

    handleKeyMapChange(){
        this.isLoading = true;
        getMedicalVisitPlanned({startDate : this.SearchStartDate, endDate : this.SearchEndDate}).then(result=>{
            console.log('Start Date : '+this.SearchStartDate + ' End Date : '+this.SearchEndDate);
            this.mapMaker = [];
            if(result.length > 0){
                for(var i=0; i<result.length; i++){
                    
                    var relateVisit = result[i].visitDataWrapper;
                    let AccTitle = '';
                    let DescriptionVal = '';
                    let ContactDetails = '';

                    if(result[i].AccountRT == 'Clinic'){
                        AccTitle = result[i].ShopName;
                        let sortedVisit = relateVisit.filter(res => res.ContactId != undefined).sort((a,b) => new Date(a.StartDateTime) - new Date(b.StartDateTime));
                        sortedVisit.forEach((res) => {
                            ContactDetails += '<b>Contact Name : </b>'+res.ContactName + '<br>' + 
                                              '<b>Visit Time : </b>'+this.replaceFormatDateTime(res.StartDateTime) + '<br><br>';
                        });
                        DescriptionVal = '<b>Address : </b>'+ this.replaceUndefined(result[i].AccountStreet) + ' ' + this.replaceUndefined(result[i].AccountCity) + ' ' + this.replaceUndefined(result[i].AccountState) + ' '+this.replaceUndefined(result[i].AccountPostalCode) + ' '+ this.replaceUndefined(result[i].AccountCountry) + '<br><br>'
                                         +ContactDetails;
                    }else{
                        AccTitle = result[i].AccountName;
                        DescriptionVal = '<b>Hoya Account Id : </b>'+result[i].AccHoyaAccountId + '<br>' + 
                                         '<b>Next Visit Planned : </b>'+ this.replaceformatDate(result[i].AccNextVisitPlan) + '<br>' +
                                         '<b>Last Store Visit Date : </b>'+this.replaceformatDate(result[i].AccLastStoreVisitDate) + '<br>' + 
                                         '<b>Sub-area : </b>'+this.replaceUndefined(result[i].AccountSubArea) + '<br>' +
                                         '<b>Address : </b>'+ this.replaceUndefined(result[i].AccountStreet) + ' ' + this.replaceUndefined(result[i].AccountCity) + ' ' + this.replaceUndefined(result[i].AccountState) + ' ' + this.replaceUndefined(result[i].AccountPostalCode) + ' ' + this.replaceUndefined(result[i].AccountCountry);
                    }
                    
                    let fillColor;
                    switch(result[i].AccountSubArea){
                        case 'Sub-area 1':
                            fillColor = 'yellow';
                            break;
                        case 'Sub-area 2':
                            fillColor = '#fcb207';
                            break;
                        case 'Sub-area 3':
                            fillColor = '#ec1717';
                            break;
                        case 'Sub-area 4':
                            fillColor = '#13cddc';
                            break;
                        case 'Sub-area 5':
                            fillColor = '#58bd08';
                            break;
                        default:
                            fillColor = '#000F2E';
                            break;
                    }

                    this.mapMaker = [...this.mapMaker,
                        {
                            location : {
                                Latitude : result[i].AccountShippingLatitude,
                                Longitude : result[i].AccountShippingLongitude,
                                Street : result[i].AccountStreet,
                                City : result[i].AccountCity,
                                State : result[i].AccountState,
                                PostalCode : result[i].AccountPostalCode,
                                Country : result[i].AccountCountry,
                            },
                            mapIcon : {
                                path : 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                fillColor : fillColor,
                                fillOpacity : .7,
                                strokeWeight: 1,
                                scale : 1.6,
                            },
                            icon : 'standard:account',
                            title : AccTitle,
                            value : result[i].AccountId,
                            description : DescriptionVal,

                        }

                    ];
                    
                }
                this.vCenter = {
                    location : {
                        Latitude : result[0].AccountShippingLatitude,
                        Longitude : result[0].AccountShippingLongitude,
                        Street : result[0].AccountStreet,
                        City : result[0].AccountCity,
                        State : result[0].AccountState,
                        PostalCode : result[0].AccountPostalCode,
                        Country : result[0].AccountCountry
                    },
                };
            }else{
                this.showToast('Warning', 'Warning', 'Could not find any planned visits for selected period');
                this.mapMaker = [];
            }
            this.isLoading = false;
        }).catch(error=>{
            this.showToast('Error', 'error', 'Error was occurred = > '+JSON.parse(JSON.stringify(error.message)));
            this.mapMaker = [];
            this.isLoading = false;
        });
    }

    getCurrentDate(){
        let currentDate = new Date();
        //currentDate.setDate(currentDate.getDate()+6);
        /*currentDate.setMinutes(
            currentDate.getMinutes() - currentDate.getTimezoneOffset()
        );*/

        let currentDay = currentDate.getDay();
        console.log('Current Day is => '+currentDay);

        let nextweekendDay = new Date();
        let begingingofweek = new Date();
        if(currentDay == 0){
            //this is mean current date is Sunday
            nextweekendDay.setDate(nextweekendDay.getDate()+12);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-6);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }else if(currentDay == 1){
            //this is mean current date is Monday
            nextweekendDay.setDate(nextweekendDay.getDate()+11);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-0);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }else if(currentDay == 2){
            //this is mean current date is Tuesday
            nextweekendDay.setDate(nextweekendDay.getDate()+10);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-1);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }else if(currentDay == 3){
            //this is mean current date is Wed
            nextweekendDay.setDate(nextweekendDay.getDate()+9);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-2);
             begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
            
        }else if(currentDay == 4){
            //this is mean current date is Thurs
            nextweekendDay.setDate(nextweekendDay.getDate()+8);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-3);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }else if(currentDay == 5){
            //this is mean current date is Fri
            
            nextweekendDay.setDate(nextweekendDay.getDate()+7);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-4);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }else if(currentDay == 6){
            //this is mean current date is Sat
            nextweekendDay.setDate(nextweekendDay.getDate()+6);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );
            begingingofweek.setDate(begingingofweek.getDate()-5);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }else{
            nextweekendDay.setDate(nextweekendDay.getDate()+12);
            nextweekendDay.setMinutes(
                nextweekendDay.getMinutes() - nextweekendDay.getTimezoneOffset()
            );

            begingingofweek.setDate(begingingofweek.getDate()-6);
            begingingofweek.setMinutes(
                begingingofweek.getMinutes() - begingingofweek.getTimezoneOffset()
            );
        }

        let formattedNextWeekEndDate = nextweekendDay.toISOString().slice(0,10);
        let formattedBeginningOfWeek = begingingofweek.toISOString().slice(0,10);
        this.nextDateWeekend = formattedNextWeekEndDate;
        this.todayDate = formattedBeginningOfWeek;

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

    get optDistanceValue(){
        return[
            {label : '20', value : '20'},
            {label : '30', value : '30'},
            {label : '50', value : '50'},
            {label : '100', value : '100'},
            {label : '200', value : '200'},
            {label : '300', value : '300'},
            {label : '500', value : '500'}
        ];
    }

    replaceUndefined(value){
        return value === undefined || value === null ? '' : value;
    }

    replaceFormatDateTime(value){
        if(value == undefined){
            return '';
        }else{
            var datetime = new Date(value);
            const user_locale = USER_LOCALE;
            const options = {year:'numeric', month:'2-digit', day:'2-digit', hour:'numeric', minute:'numeric'};
            return new Intl.DateTimeFormat(user_locale, options).format(datetime);
        }
    }
    
    replaceformatDate(value){
        if(value == undefined){
            return '';
        }else{
            var datetime = new Date(value);
            const user_locale = USER_LOCALE;
            const options = {year:'numeric', month:'2-digit', day:'2-digit'};
            return new Intl.DateTimeFormat(user_locale, options).format(datetime);
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

    /*async fetchContactFromAccount(accountId){
        try {
            const response = await getContactMedicalVisitPlanned({ accountId: accountId });
            return JSON.stringify(response);
        } catch (error) {
            this.showToast('Error', 'error', 'An error was occurred : ' + JSON.stringify(error.message));
        }
    }*/

    custLbl = {
        lblDisplay,
        lblHideDisplay,
        lblDistance
    };
}