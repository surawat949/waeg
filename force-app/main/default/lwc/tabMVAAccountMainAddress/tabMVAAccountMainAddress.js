import { LightningElement,api, track, wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import label_AccAddress from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_MainAddress';
import label_AccClinicProfile from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_Profile';
import label_AccLocation from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_Location';
import label_updatedSuccessfull from '@salesforce/label/c.SFDC_V_2_tabMVAAccount_UpdateSucessfull';
//import getfetchAccMap from '@salesforce/apex/tabAccountAddressLWCController.fetchAccforMapAccountId';
import getfetchAccMapAccId from '@salesforce/apex/tabMVAAccountController.fetchAccforMapAccountId';

//fields import here
import ACC_NAME from '@salesforce/schema/Account.Name';
import ACC_SHIPPING_STREET from '@salesforce/schema/Account.ShippingStreet';
import ACC_SHOP_NAME from '@salesforce/schema/Account.Shop_Name__c';
import ACC_SHIPPING_POSTAL_CD from '@salesforce/schema/Account.ShippingPostalCode';
import ACC_PHONE from '@salesforce/schema/Account.Phone';
import ACC_HOYA_ACC_ID from '@salesforce/schema/Account.Hoya_Account_ID__c';
import ACC_SHIPPING_CITY from '@salesforce/schema/Account.ShippingCity';
import ACC_FAX from '@salesforce/schema/Account.Fax';
import ACC_PARENTID from '@salesforce/schema/Account.ParentId';
import ACC_SHIPPING_STATE from '@salesforce/schema/Account.ShippingState';
import ACC_EMAIL from '@salesforce/schema/Account.email__c';
import ACC_STATUS from '@salesforce/schema/Account.Account_Status__c';
import ACC_SHIPPINGCOUNTRY from '@salesforce/schema/Account.ShippingCountry';
import ACC_WEBSITE from '@salesforce/schema/Account.Website';
import ACC_CLINIC_TYPE from '@salesforce/schema/Account.Clinic_type__c';
import ACC_CLINIC_SUB_TYPE from '@salesforce/schema/Account.Clinic_Sub_type__c';
import ACC_CLINIC_SPECIALITY from '@salesforce/schema/Account.Clinic_Speciality__c';
import ACC_QIDE_LMS from '@salesforce/schema/Account.QIDC__OK_MDM_Is_Privacy_Law_Enabled_IMS__c';


import Account_obj from '@salesforce/schema/Account';


//import TabAccountAddressToCreateNewTaskModal from 'c/tabAccountAddressToCreateNewTaskModal';

export default class TabMVAAccountMainAddress extends LightningElement {
    @api receivedId;
    record;
    @track isLoading = false;
    @track error;
    @track mapMarkers = [];
    @track markersTitle = 'Account';
    @track zoomLevel = 13;
    fields1 = [ACC_NAME, ACC_SHIPPING_STREET];
    fields2 = [ACC_SHOP_NAME, ACC_SHIPPING_POSTAL_CD, ACC_PHONE, ACC_HOYA_ACC_ID, ACC_SHIPPING_CITY, ACC_FAX, ACC_PARENTID, ACC_SHIPPING_STATE, ACC_EMAIL, ACC_STATUS, ACC_SHIPPINGCOUNTRY, ACC_WEBSITE];
    fields3 = [ACC_CLINIC_TYPE, ACC_CLINIC_SUB_TYPE, ACC_CLINIC_SPECIALITY];
    fields4 = [ACC_QIDE_LMS];
    ObjectApiName = Account_obj;
    lblUpdateSuccess = label_updatedSuccessfull;
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }

    
    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }

    @wire(getfetchAccMapAccId, {recordId : '$receivedId'})
    wireAccount({error, data}){
        if(data){
            this.record = data[0];
            data.forEach(dataItem=>{
                this.mapMarkers = [...this.mapMarkers,
                    {
                        location : {
                            Latitude : dataItem.ShippingLatitude,
                            Longitude : dataItem.ShippingLongitude,
                            City : dataItem.ShippingCity,
                            Country : dataItem.ShippingCountry,
                            Street : dataItem.ShippingStreet,
                            State : dataItem.ShippingState,
                            PostalCode : dataItem.ShippingPostalCode
                        },
                        icon : 'standard:account',
                        title : dataItem.Name,
                    }
                ];
            });
            this.error=undefined;
        }else if(error){
            this.error = error;
            //console.log('XXX An error was occurred : '+this.error);
            this.showToast('Error', 'error', error);
        }
    }

    get Street(){
        return this.record?.ShippingStreet;
    }

    get City(){
        return this.record?.ShippingCity;
    }

    get State(){
        return this.record?.ShippingState;
    }

    get Country(){
        return this.record?.ShippingCountry;
    }

    get PostalCode(){
        return this.record?.ShippingPostalCode;
    }

    get urlGoogle(){
        return 'https://www.google.com/maps/?q='+this.Street+' '+this.City+' '+this.State+' '+this.PostalCode+' '+this.Country;
        //console.log('XXX Get Url Google '+JSON.stringify(this.urlGoogle));
    }

    get urlGoogleLabel(){
        return this.Street+'\n\n'+this.City+'\n\n'+this.State+'\n\n'+this.PostalCode+'\n\n'+this.Country;
        //console.log('XXX Get Url Google labe = >'+this.urlGoogleLabel);
    }

    handleEdit(){
        this.showEditfield = !this.showEditfield;
    }
    handleSuccess(event){
        this.showToast('Success', 'success', this.lblUpdateSuccess);
        this.showEditfield = false;
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

    label = {label_AccAddress, label_AccClinicProfile, label_AccLocation, label_updatedSuccessfull};
}