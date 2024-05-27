import {LightningElement, api, wire} from 'lwc';
// Apex
import getContactList from '@salesforce/apex/TabActivationMedicalProgramController.getContactList';
import getContactNearby from '@salesforce/apex/TabActivationMedicalProgramController.getContactNearby';
import deleteRelationShip from '@salesforce/apex/TabActivationMedicalProgramController.deleteRelationShip';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
// Labels
import New from '@salesforce/label/c.NewButtonRelatedList';
import Referring_Prescribers from '@salesforce/label/c.SFDC_V_2_Referring_Prescriber';
import Prescribers_Nearby from '@salesforce/label/c.SFDC_V_2_Prescribers_Nearby';
import First_Speciality from '@salesforce/label/c.SFDC_V_2_Prescribers_First_Speciality';
import Miyosmart_Attitude from '@salesforce/label/c.SFDC_V_2_Prescribers_Miyosmart_Attitude';
import Total_Prescribing_Segmentation from '@salesforce/label/c.SFDC_V_2_Prescribers_Total_Prescribing_Segmentation';
import Miyosmart_Segmentation from '@salesforce/label/c.SFDC_V_2_Prescribers_Miyosmart_Segmentation';
import Contact_Near_By from '@salesforce/label/c.SFDC_V_2_Prescribers_Contact_Near_By';
import {refreshApex} from '@salesforce/apex';
import getUserDetail from '@salesforce/apex/tabChatterProfileUserDetail.getUserDetail';

export default class TabActivationMedicalProgramPrescribers extends LightningElement {
    @api receivedId;
    wiredResults;
    data = [];
    showAllTab=false;
    error;
    isLoading = false;
    isDataExists = false;
    isModalOpen = false;
    fsValues = '';
    miyosmartAttitudeValue = '';
    contactNearByValue = '5';
    miyosmartSegmentationvalue = '';
    totalPrescribingSValue = '';
    isDisplayList = true;
    zoomLevel = 13;
    mapMarker = [];
    markersTitle = 'Prescribers Nearby';
    custLabel = {
        New,
        Referring_Prescribers,
        Prescribers_Nearby,
        Contact_Near_By,
        Miyosmart_Segmentation,
        Total_Prescribing_Segmentation,
        Miyosmart_Attitude,
        First_Speciality
    }
    Columns = [
        {
            label: 'Name',
            fieldName: 'ContactId',
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'Name'
                },
                target: '_top'
            }
        },
        {
            label: 'Education',
            fieldName: 'Education',
            type: 'text'
        },
        {
            label: 'Account Name',
            fieldName: 'accountName',
            type: 'text'
        },
        {
            label: 'Postal Code',
            fieldName: 'PostalCode',
            type: 'text'
        }, {
            label: 'City',
            fieldName: 'City',
            type: 'text'
        }, {
            label: 'Delete',
            type: 'button',
            initialWidth: 135,
            typeAttributes: {
                label: 'Delete',
                name: 'Delete',
                title: 'Delete record'
            }
        }
    ]

    get firstSpecialityOptions() {
        return [
            {
                label: 'No Filter',
                value: 'No Filter'
            },
            {
                label: 'Ophthalmologist',
                value: 'Ophthalmologist'
            },
            {
                label: 'Other',
                value: 'Other'
            },
            {
                label: 'Paediatrics',
                value: 'Paediatrics'
            }, {
                label: 'Ear-nose-throat diseases',
                value: 'Ear-nose-throat diseases'
            }, {
                label: 'Internal Medicine',
                value: 'Internal Medicine'
            }, {
                label: 'Anaesthesiology',
                value: 'Anaesthesiology'
            }, {
                label: 'General Medicine',
                value: 'General Medicine'
            }
        ]
    }

    get miyosmartAttitudeOptions() {
        return [
            {
                label: 'No Filter',
                value: 'No Filter'
            }, {
                label: 'Promoter	',
                value: 'Promoter'
            }, {
                label: 'Neutral',
                value: 'Neutral'
            }, {
                label: 'Detractor',
                value: 'Detractor'
            }
        ]
    }

    get totalPrescribingSValueOptions() {
        return [
            {
                label: 'No Filter',
                value: 'No Filter'
            },
            {
                label: 'A',
                value: 'A'
            },
            {
                label: 'B',
                value: 'B'
            },
            {
                label: 'C',
                value: 'C'
            }, {
                label: 'Uncategorized',
                value: 'Uncategorized '
            }

        ]
    }


    get miyosmartSegmentationOptions() {
        return [
            {
                label: 'No Filter',
                value: 'No Filter'
            },
            {
                label: 'A',
                value: 'A'
            },
            {
                label: 'B',
                value: 'B'
            },
            {
                label: 'C',
                value: 'C'
            }, {
                label: 'Uncategorized',
                value: 'Uncategorized '
            }
        ]
    }
    get contactNearByValueOptions() {
        return [
            {
                label: '1km',
                value: '1'
            },
            {
                label: '2km',
                value: '2'
            },
            {
                label: '5km',
                value: '5'
            },
            {
                label: '10km',
                value: '10'
            }, {
                label: '25km',
                value: '25'
            }, {
                label: '50km',
                value: '50'
            }
        ]
    }

    constructor() {
        super();
    }
    connectedCallback() {
        this.getTableData();
        this.handleKeyChangeMap();
    }

    handleKeyChange(event) {

        if (event.target.name === 'FirstSpeciality') {
            this.fsValues = event.target.value;
            this.handleKeyChangeMap();
        }

        if (event.target.name === 'MiyosmartAttitude') {
            this.miyosmartAttitudeValue = event.target.value;
            this.handleKeyChangeMap();
        }
        if (event.target.name === 'TotalPrescribingSegmentation') {
            this.totalPrescribingSValue = event.target.value;
            this.handleKeyChangeMap();
        }

        if (event.target.name === 'MiyosmartSegmentation') {
            this.miyosmartSegmentationvalue = event.target.value;
            this.handleKeyChangeMap();
        }
        if (event.target.name === 'ContactNearBy') {
            this.contactNearByValue = event.target.value;
            if(this.contactNearByValue == 1){
                this.zoomLevel = 15;
            }
            else if(this.contactNearByValue == 2){
                this.zoomLevel = 14;
            }else if(this.contactNearByValue == 5){
                this.zoomLevel = 13;
            }else if(this.contactNearByValue == 10){
                this.zoomLevel = 11.8;
            }else if(this.contactNearByValue == 25){
                this.zoomLevel = 10;
            }else if(this.contactNearByValue == 50){
                this.zoomLevel = 9;
            }else{
                this.zoomLevel = 13;
            }
            this.handleKeyChangeMap();
        }
        
    }

    handleListViewShow() {
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }
    showPopUp() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    async performRefresh() {
        this.getTableData();

    }
    async showPopUp() {
        this.template.querySelector('c-tab-contact-create-reffering-prescriber-modal').displayModal();
    }

    handleListViewHide() {
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }

    getTableData() {
        getContactList({recordId: this.receivedId}).then((result) => {
            this.data = result;

            if (this.data) {
                this.isLoading = false;
                if (this.data.length > 0) 
                    this.isDataExists = true;
                

                this.data.forEach(res => {
                    res.ContactId = '/' + res.ContactId;
                    res.Name = res.Contact.Name;
                    res.Education = res.Contact.Education__c;
                    res.accountName = res.Contact.Account.Name;
                    res.Title = res.Contact.Salutation;
                    res.City = res.Contact.MailingCity;
                    res.PostalCode = res.Contact.MailingPostalCode;
                    res.recordId = res.ContactId;
                })
                this.error = undefined;
            }

        }).catch((error) => {
            this.error = error;
            this.data = undefined;
        });


    }

    handleRowAction(event) {

        const actionName = event.detail.action.name;

        const row = event.detail.row;
        deleteRelationShip({recordId: row.Id}).then(result => {

            this.isLoading = false;
            refreshApex(this.data);
            this.showToastMethod('Success Message', 'Record deleted successfully ', 'success', 'dismissible');
            this.getTableData();
            return refreshApex(this.data);

        }).catch(error => {
            this.error = error;
            this.showToastMethod('Error', this.error, 'error', 'dismissible');
        });


    }

    showToastMethod(title, message, variant, mode) {
        const evt = new ShowToastEvent({title: title, message: message, variant: variant, mode: mode});


        this.dispatchEvent(evt);

    }

    handleDeleteRow(recordIdToDelete) {

        this.isLoading = true;
        
        deleteRelationShip(recordIdToDelete).then(result => {
            this.data = result;
            this.isLoading = false;
            const evt = new ShowToastEvent({title: 'Success Message', message: 'Record deleted successfully ', variant: 'success', mode: 'dismissible'});
            this.dispatchEvent(evt);

            return refreshApex(this.data);

        }).catch(error => {
            this.error = error;
            this.showToastMethod('Error', this.error, 'error', 'dismissible');
        });

    }
    handleKeyChangeMap() { 
        getContactNearby({
            recordId: this.receivedId,
            distance: Math.floor(this.contactNearByValue),
            firstSpeciality: this.fsValues,
            miyosmartAttitude: this.miyosmartAttitudeValue,
            totalPrescribingSegmentation: this.totalPrescribingSValue,
            miyosmartSegmentation: this.miyosmartSegmentationvalue
        }).then(result => { 
            this.mapMarker = [];
            if (result.length > 0){ 
                for (var i = 0; i < result.length; i++) {
                    if (i == 0) { // show star on map
                        this.mapMarker = [
                            ...this.mapMarker, {
                                location: {
                                    Latitude: result[i].accountShippingLatitude,
                                    Longitude: result[i].accountShippingLongitude,
                                    Street: result[i].accountShippingStreet,
                                    City: result[i].accountShippingCity,
                                    State: result[i].accountShippingState,
                                    Country: result[i].accountShippingCountry,
                                    PostalCode: result[i].accountShippingPostalCode
                                },
                                mapIcon: {
                                    path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                                    fillColor: '#3338FF',
                                    fillOpacity: .7,
                                    strokeWeight: 1,
                                    scale: .15
                                },
                                icon: 'standard:account',
                                title: result[i].accountName,
                                value: result[i].accountId,
                                description: 'Hoya Account ID : ' + result[i].accountHoyaAccId + '<br>' + result[i].accountShippingStreet + '&nbsp;' + result[i].accountShippingCity + '&nbsp;' + result[i].accountShippingState + '<br>Phone : ' + result[i].accountPhone
                            }
                        ];
                    } else {

                        // show red pin on map
                        this.mapMarker = [
                            ...this.mapMarker, {
                                location: {
                                    Latitude: result[i].accountShippingLatitude,
                                    Longitude: result[i].accountShippingLongitude,
                                    Street: result[i].accountShippingStreet,
                                    City: result[i].accountShippingCity,
                                    State: result[i].accountShippingState,
                                    Country: result[i].accountShippingCountry,
                                    PostalCode: result[i].accountShippingPostalCode
                                },
                                icon: 'standard:account',
                                title: result[i].contactName,
                                value: result[i].contactId,
                                description: 'Hoya Account ID : ' + result[i].accountHoyaAccId + '<br>' + result[i].accountShippingStreet + '&nbsp;' + result[i].accountShippingCity + '&nbsp;' + result[i].accountShippingState + '<br>Phone : ' + result[i].accountPhone

                            }
                        ];
                    }
                }
            

				this.vCenter = {
					location: {
						Latitude: result[0].accountShippingLatitude,
						Longitude: result[0].accountShippingLongitude,
						Street: result[0].accountShippingStreet,
						City: result[0].accountShippingCity,
						State: result[0].accountShippingState,
						Country: result[0].accountShippingCountry,
						PostalCode: result[0].accountShippingPostalCode
					}
				}
			}else{
                this.showToastMethod('Warning', 'Address details missing', 'Warning', 'dismissible');
            }

        }).catch(error => {
            this.errors = error;
            this.showToastMethod('Error', this.error, 'error', 'dismissible');


        });
    }
    @wire(getUserDetail)
    allStages({data }) {
        if (data) {
            this.showAllTab = data;
        } 
        else{
            this.showAllTab = false;
        }
    }

}