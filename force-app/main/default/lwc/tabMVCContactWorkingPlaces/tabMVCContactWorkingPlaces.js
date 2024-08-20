import { LightningElement, api, track } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

//apex code import here
import getRelatedClinicsByContactId from '@salesforce/apex/tabMVCContactController.getRelatedClinicsByContactId';

import other_Related_Clinics from '@salesforce/label/c.Other_Related_Clinics';
import Account from '@salesforce/label/c.Account';
import Clinic_Name from '@salesforce/label/c.Clinic_Name';
import Preferred_Place_for_Visit from '@salesforce/label/c.Preferred_Place_for_Visit';
import Contact_Role from '@salesforce/label/c.Contact_Role';
import Activity_Phone from '@salesforce/label/c.Activity_Phone';
import Preferred_Contact_day_time from '@salesforce/label/c.Preferred_Contact_day_time';
import Relation_Id from '@salesforce/label/c.Relation_Id';
import Shipping_Street from '@salesforce/label/c.Shipping_Street';
import Shipping_State from '@salesforce/label/c.Shipping_State';
import Shipping_City from '@salesforce/label/c.Shipping_City';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TabMVCContactWorkingPlaces extends NavigationMixin(LightningElement) {
    
    @api receivedId;
    isDataExists;
    data;
    mapMakers = [];      //for lightning map manifest
    mapTitle = 'Working Places Address';
    vCenter;
    isLoading = true;

    @track zoomLevel = 9;
    @track IsdisplayList = true;

    lables={
        other_Related_Clinics
    }

    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Related_List_ACR__e';

    constructor() {
        super();
        // passed parameters are not yet received here
    }

    connectedCallback() {
        this.getRelatedClinic();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
			let triggerAlert = true;
			if(errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none"){
				triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); // 20000 milliseconds = 20 seconds
			}
			if(triggerAlert){
                this.showToast('Error',JSON.stringify(error),'Error');
			}
        });     
    }

    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.getRelatedClinic();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    columns =  [
        {label: Account, fieldName: 'AccountId', typeAttributes: {label: { fieldName: 'AccountName' }}, type: 'url',target: 'blank',wrapText: true },
        {label : Clinic_Name, fieldName : 'ClinicName', type : 'text', wrapText : true},
        {label : Contact_Role, fieldName : 'ContactRole', type : 'text', wrapText : true},
        {label : Activity_Phone, fieldName : 'ActivityPhone', type : 'text', wrapText : true},
        {label : Preferred_Contact_day_time, fieldName : 'PreferContactDayTime', type : 'text', wrapText : 'text'},
        {label : Relation_Id, fieldName: 'RelationId', typeAttributes: {label: {fieldName: 'Id'}}, type: 'url',target: 'blank',wrapText: true }
    ]

    columns2 = [
        {label : Account, fieldName: 'AccountId', typeAttributes : {label : {fieldName: 'AccountName'}}, type: 'url', target:'blank', wrapText: true},
        {label : Clinic_Name, fieldName: 'ClinicName', type: 'text', wrapText: true},
        {label : Preferred_Place_for_Visit, fieldName : 'PreferPlaceVisit', type: 'boolean', cellAttributes : {alignment: 'center'}, wrapText: true},
        {label : Shipping_Street, fieldName : 'ShippingStreet', type: 'text', wrapText : true},
        {label : Shipping_City, fieldName : 'ShippingCity', type: 'text', wrapText: true},
        {label : Shipping_State, fieldName : 'ShippingState', type : 'text', wrapText: true}
    ]

    getRelatedClinic(){
        getRelatedClinicsByContactId({contactId : this.receivedId})
        .then(result=>{
            console.log(result);
            debugger;
            this.mapMakers = [];
            if(result.length>0){
                //Lightning Map Markers render here.
                for(var i=0;i<result.length;i++){
                    //fetch current record first

                    let ClinicName = '';
                    let PreferredPlaceVisit = '';
                    let AccountShippingStreet = '';
                    let AccountShippingCity = '';
                    let AccountShippingState = '';
                    let AccountName = '';

                    if(AccountName == undefined){
                        AccountName = '';
                    }else{
                        AccountName = result[i].Account.Name;
                    }

                    if(ClinicName == undefined){
                        ClinicName = '';
                    }else{
                        ClinicName = result[i].Account.Clinic_Name__c;
                    }

                    if(PreferredPlaceVisit == undefined){
                        PreferredPlaceVisit = 'No';
                    }else{
                        if(result[i].Preferred_place_for_visit__c == false){
                            PreferredPlaceVisit = 'No';
                        }else{
                            PreferredPlaceVisit = 'Yes';
                        }
                    }

                    if(AccountShippingStreet == undefined){
                        AccountShippingStreet = '';
                    }else{
                        AccountShippingStreet = result[i].Account.ShippingStreet;
                    }

                    if(AccountShippingCity == undefined){
                        AccountShippingCity = '';
                    }else{
                        AccountShippingCity = result[i].Account.ShippingCity;
                    }

                    if(AccountShippingState == undefined){
                        AccountShippingState = '';
                    }else{
                        AccountShippingState = result[i].Account.ShippingState;
                    }

                    if(AccountName == undefined){AccountName = '';}
                    if(ClinicName == undefined){ClinicName = '';}
                    if(PreferredPlaceVisit == undefined){PreferredPlaceVisit = 'No';}
                    if(AccountShippingStreet == undefined){AccountShippingStreet = '';}
                    if(AccountShippingCity == undefined){AccountShippingCity = '';}
                    if(AccountShippingState == undefined){AccountShippingState = '';}

                    if(result[i].ContactId == this.receivedId){
                        if(result[i].Preferred_place_for_visit__c == true){
                            this.mapMakers = [...this.mapMakers,
                                {
                                    location : {
                                        Latitude : result[i].Account.ShippingLatitude,
                                        Longitude : result[i].Account.ShippingLongitude,
                                        Street : result[i].Account.ShippingStreet,
                                        City : result[i].Account.ShippingCity,
                                        State : result[i].Account.ShippingState,
                                        PostalCode : result[i].Account.ShippingPostalCode,
                                        Country : result[i].Account.ShippingCountry

                                    },
                                    mapIcon : {
                                        path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                        fillColor: '#FB0808',       //red star for the prefered to visits.
                                        fillOpacity: .7,
                                        strokeWeight: 1,
                                        scale: .15,
                                    },
                                    icon : 'standard:account',
                                    title : AccountName,
                                    value : result[i].Id,
                                    description : 'Clinic Name : '+ClinicName + '<br>Prefered Place Visits : ' + PreferredPlaceVisit
                                                    + '<br>Shipping Street : ' + AccountShippingStreet + '<br>Shipping City : ' + AccountShippingCity
                                                    + '<br>Shipping state : ' + AccountShippingState,
                                    
                                }
                            
                            ];
                        }else{
                            this.mapMakers = [...this.mapMakers,
                                {
                                    location : {
                                        Latitude : result[i].Account.ShippingLatitude,
                                        Longitude : result[i].Account.ShippingLongitude,
                                        Street : result[i].Account.ShippingStreet,
                                        City : result[i].Account.ShippingCity,
                                        State : result[i].Account.ShippingState,
                                        PostalCode : result[i].Account.ShippingPostalCode,
                                        Country : result[i].Account.ShippingCountry

                                    },
                                    mapIcon : {
                                        path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                        fillColor: '#3338FF',       //blue star for the others, not prefered to visits.
                                        fillOpacity: .7,
                                        strokeWeight: 1,
                                        scale: .15,
                                    },
                                    icon : 'standard:account',
                                    title : AccountName,
                                    value : result[i].Id,
                                    description : 'Clinic Name : '+ClinicName + '<br>Prefered Place Visits : ' + PreferredPlaceVisit 
                                                    + '<br>Shipping Street : ' + AccountShippingStreet + '<br>Shipping City : ' + AccountShippingCity
                                                    + '<br>Shipping state : ' + AccountShippingState,
                                    
                                }
                            
                            ];
                        }
                    }else{
                        //fetch other rest records here
                        if(result[i].Preferred_place_for_visit__c == true){
                            this.mapMakers = [...this.mapMakers,
                                {
                                    location : {
                                        Latitude : result[i].Account.ShippingLatitude,
                                        Longitude : result[i].Account.ShippingLongitude,
                                        Street : result[i].Account.ShippingStreet,
                                        City : result[i].Account.ShippingCity,
                                        State : result[i].Account.ShippingState,
                                        PostalCode : result[i].Account.ShippingPostalCode,
                                        Country : result[i].Account.ShippingCountry

                                    },
                                    mapIcon : {
                                        path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                        fillColor: '#FB0808',       //red star for the prefered to visits.
                                        fillOpacity: .7,
                                        strokeWeight: 1,
                                        scale: .15,
                                    },
                                    icon : 'standard:account',
                                    title : AccountName,
                                    value : result[i].Id,
                                    description : 'Clinic Name : '+ClinicName + '<br>Prefered Place Visits : ' + PreferredPlaceVisit
                                                    + '<br>Shipping Street : ' + AccountShippingStreet + '<br>Shipping City : ' + AccountShippingCity
                                                    + '<br>Shipping state : ' + AccountShippingState,
                                    
                                }
                            
                            ];
                        }else{
                            this.mapMakers = [...this.mapMakers,
                                {
                                    location : {
                                        Latitude : result[i].Account.ShippingLatitude,
                                        Longitude : result[i].Account.ShippingLongitude,
                                        Street : result[i].Account.ShippingStreet,
                                        City : result[i].Account.ShippingCity,
                                        State : result[i].Account.ShippingState,
                                        PostalCode : result[i].Account.ShippingPostalCode,
                                        Country : result[i].Account.ShippingCountry

                                    },
                                    mapIcon : {
                                        path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                        fillColor: '#3338FF',       //blue star for the others, not prefered to visits.
                                        fillOpacity: .7,
                                        strokeWeight: 1,
                                        scale: .15,
                                    },
                                    icon : 'standard:account',
                                    title : AccountName,
                                    value : result[i].Id,
                                    description : 'Clinic Name : '+ ClinicName + '<br>Prefered Place Visits : ' + PreferredPlaceVisit 
                                                    + '<br>Shipping Street : ' + AccountShippingStreet+ '<br>Shipping City : ' + AccountShippingCity
                                                    + '<br>Shipping state : ' + AccountShippingState,
                                    
                                }
                            
                            ];
                        }
                    }
                }
                //figure it out for the centering of the map (current record should be the center)
                for(var k=0;k<result.length;k++){
                    if(result[k].ContactId == this.receivedId){
                        this.vCenter = {
                            location : {
                                Latitude : result[k].Account.ShippingLatitude,
                                Longitude : result[k].Account.ShippingLongitude,
                                Street : result[k].Account.ShippingStreet,
                                City : result[k].Account.ShippingCity,
                                State : result[k].Account.ShippingState,
                                PostalCode : result[k].Account.ShippingPostalCode,
                                Country : result[k].Account.ShippingCountry

                            },
                        };
                        break;
                    }

                }

                this.isDataExists = true;
                this.data = JSON.parse(JSON.stringify(result));
                debugger;
                this.data.forEach(row=>{
                    row.AccountId = '/'+row.AccountId,
                    row.AccountName = row.Account.Name,
                    row.ClinicName = row.Account.Clinic_Name__c,
                    row.PreferPlaceVisit = row.Preferred_place_for_visit__c,
                    row.ShippingStreet = row.Account.ShippingStreet,
                    row.ShippingCity = row.Account.ShippingCity,
                    row.ShippingState = row.Account.ShippingState,
                    row.ContactRole = row.Contact_role__c,
                    row.ActivityPhone = row.Activity_Phone__c,
                    row.PreferContactDayTime = row.Preferred_contact_day_time__c,
                    row.RelationId = '/'+row.Id,
                    row.Id = row.Id

                });
                this.isLoading = false;
            }else{
                this.showToast('Warning', 'Address details are missing', 'Warning');
                this.isLoading = false;
            }
        }).catch(error=>{
            this.showToast('Error', JSON.stringify(error), 'Error');
        });
    }

    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    navigateToContactRelationship(event){
        this.navigateToNewPage('AccountContactRelation');
    }

    navigateToNewPage(objectName){
        const defaultValue = encodeDefaultFieldValues({
            ContactId : this.receivedId
        });
		
        this[NavigationMixin.Navigate]({
            type : 'standard__objectPage',
            attributes : {
                objectApiName : objectName,
                actionName : 'new'
            },
            state: {
                defaultFieldValues: defaultValue,
                useRecordTypeCheck : 1,
                navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
            }
        });
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, () => {
        });   
    } 
    
    handleListViewShow(){
        this.displayListView = 'visible';
        this.IsdisplayList = false;
    }

    handleListViewHide(){
        this.displayListView = 'hidden';
        this.IsdisplayList = true;
    }

}