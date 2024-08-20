/**
 * @Subject : Campaign Overview Map
 * @DevOpsURL : https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1350/
 * @Author : Surawat Sakulmontreechai
 * @Email : surawat.sakulmontreechai@hoya.com
 * @Description : This LWC to support : Task-1350 Campaign Overview map
 * @CreatedDate : 2024-04-23
 * @CreatedBy : Surawat Sakulmontreechai
 * 
 * @changeLog : 2024-04-25
 * =========================================================================
 * reduce the space above, make it fits.
 *  left side, and right side make to reduce space make it fits.
 *  "Display List" button move to the right.
 *  Add the legend to explain what symbol in render map underneath Campaign list
 *  Between search section and map, should double space between search section and map.
 *  Make more fit for the map.
 *  For KM default should be 100 KM, and make the drop down-list, arrange KM. Just proposal, 
 *  100, 200, 300, 500, 700, 900, 1000 km.
 * ==========================================================================
 * @changeLog : 2024-04-26 by Xavier
 * for the KM range should not start from 200 due for the result is so much. should more 
 * specific for KM range. Hence, should be (KM) from 20 - 1000 km range.
 * 20, 30, 50, 100, 200, 300, 500, 800, 1000
 * ============================================================================
 * @changedLog : 2024-04-30 by Xavier
 * change the icon map definition
 * ============================================================================
 * @changedLog : 2024-05-02
 * remove 800 KM and 1000 KM range in KM range. Keep this just only zooming-in and out.
 * ============================================================================
 */
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//apex class import here
import getVisitsCampaignMap from '@salesforce/apex/VPMCampaignOverviewMapController.getAccountCampaignMember';
import getCampaignList from '@salesforce/apex/VPMCampaignOverviewMapController.getCampaignList';
import USER_LOCALE from '@salesforce/i18n/locale';

//custom label import here
import lblDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Display';
import lblHideDisplay from '@salesforce/label/c.SFDC_V_2_tabMVAVisitsClinicNearBy_Hide';
import lblDistance from '@salesforce/label/c.SFDC_V2_MVC_Visits_ContactNearby_Distance';

export default class VpmCampaignOverviewMap extends LightningElement {
    record;
    @track isLoading = false;
    @track mapMarker = [];
    @track vCenter;
    @track mapMarkerTitle = 'Visit Campaign Member';
    @track isDisplayList = true;
    @track displayListView = 'hidden';
    @track zoomLevel = 12;
    @track picklistValue = '';
    @track distanceValue = '20';
    @track formattedDate;

    items1 = [{label : 'All Campaign', value : ''}];

    connectedCallback(){
        this.handleKeyMapChange();
    }

    @wire(getCampaignList) wirePicklistCampaignValues({data, error}){
        if(data){
            for(var i=0;i<data.length;i++){
                this.items1 = [...this.items1, {label : data[i].label, value : data[i].value}];
            }
        }else if(error){
            this.showToast('Error', 'Error', JSON.stringify(error));
        }
    }

    handleKeyMapChange(){
        this.isLoading = true;
        getVisitsCampaignMap({CampaignId : this.picklistValue}).then(result=>{
            this.mapMarker = [];
            if(result.length > 0){
                for(var i=0;i<result.length;i++){
                    let fillcolor, mapIconPath, pathScale;

                    if(result[i].IsPresent == true){
                        if(result[i].VisitedSize > 0 ){
                            mapIconPath = 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z';
                            fillcolor = 'green';
                            pathScale = 1.5;
                        }else{
                            mapIconPath = 'M11,0A11.01245,11.01245,0,0,0,0,11C0,21.36133,9.95166,29.44238,10.37549,29.78125a1.00083,1.00083,0,0,0,1.249,0C12.04834,29.44238,22,21.36133,22,11A11.01245,11.01245,0,0,0,11,0Z';
                            fillcolor = 'green';
                            pathScale = 1.0;
                        }
                    }else{
                        if(result[i].VisitedSize > 0 ){
                            mapIconPath = 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z';
                            fillcolor = 'red';
                            pathScale = 1.5;
                        }else{
                            mapIconPath = 'M11,0A11.01245,11.01245,0,0,0,0,11C0,21.36133,9.95166,29.44238,10.37549,29.78125a1.00083,1.00083,0,0,0,1.249,0C12.04834,29.44238,22,21.36133,22,11A11.01245,11.01245,0,0,0,11,0Z';
                            fillcolor = 'red';
                            pathScale = 1.0;
                        }
                    }

                    this.mapMarker = [...this.mapMarker, 
                        {
                            location : {
                                Street : result[i].AccountShippingStreet,
                                City : result[i].AccountShippingCity,
                                State : result[i].AccountShippingState,
                                PostalCode : result[i].AccountShippingPostalCode,
                                Country : result[i].AccountCountry,
                            },
                            mapIcon: {
                                path: mapIconPath,
                                fillColor: fillcolor,
                                fillOpacity: 0.7,
                                strokeWeight: 1,
                                scale: pathScale,
                            },
                            icons : 'standard:campaign',
                            title : result[i].AccountNameText,
                            value : result[i].AccCampaignName,
                            description :   '<b>Campaign Name : </b>'+this.replaceUndefined(result[i].CampaignName) + '<br>' +
                                            '<b>Hoya Account ID : </b>'+this.replaceUndefined(result[i].AccountHoyaAccountId) + '<br>' + 
                                            '<b>Campaign Presented : </b>'+this.replaceCampaignPresent(result[i].IsPresent) + '<br>' +
                                            '<b>Campaign Priority : </b>'+this.replaceCampaignPresent(result[i].CampaignPriority) + '<br>' +
                                            '<b>Last Store Visit Date : </b>'+this.DateFormatFunction(result[i].LastStoreVisitDate) + '<br>' +
                                            '<b>Address : </b>'+ this.replaceUndefined(result[i].AccountShippingStreet) + ' ' + this.replaceUndefined(result[i].AccountShippingCity) + ' ' + this.replaceUndefined(result[i].AccountShippingState) + ' ' + this.replaceUndefined(result[i].AccountShippingPostalCode) + ' ' + this.replaceUndefined(result[i].AccountCountry),
                        }
                    ];
                }
                this.vCenter = {
                    location : {
                        //Latitude : result[0].AccountShippingLatitude,
                        //Longitude : result[0].AccountShippingLongitude,
                        Street : result[0].AccountShippingStreet,
                        City : result[0].AccountShippingCity,
                        State : result[0].AccountShippingState,
                        PostalCode : result[0].AccountShippingPostalCode,
                        Country : result[0].AccountCountry,
                    },
                };
            }else{
                this.showToast('Warning', 'Warning', 'Could not find any accounts associated with selected campaign. Please try another campaign.');
            }
            this.isLoading = false;
        }).catch(error=>{
            this.showToast('Error', 'Error', JSON.stringify(error));
            this.isLoading = false;
        });
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

    handleListViewShow(){
        this.displayListView = 'visible';
        this.isDisplayList = false;
    }

    handleListViewHide(){
        this.displayListView = 'hidden';
        this.isDisplayList = true;
    }

    handleKeyChange(event){
        //get the value when changed the combo-box.

        if(event.target.name === 'picklistCampaing'){
            this.picklistValue = event.target.value;
            this.handleKeyMapChange();
        }

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

    get picklistCampaignValuesList(){
        return this.items1;
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

    replaceCampaignPresent(value){
        return value === true ? 'Yes' : 'No';
    }

    DateFormatFunction(value){
        if(value == undefined || value == null){
            return '';
        }else{
            var datetime = new Date(value);
            const user_locale = USER_LOCALE;
            const options = {year:'numeric', month:'2-digit', day:'2-digit'};
            return new Intl.DateTimeFormat(user_locale, options).format(datetime);
        }
        
    }

    custLbl = {
        lblDisplay,
        lblHideDisplay,
        lblDistance
    };

}