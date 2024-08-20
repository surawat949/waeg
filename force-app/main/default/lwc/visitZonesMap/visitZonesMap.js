import { LightningElement, track, wire,api } from 'lwc';
//import apex class start here
import { refreshApex } from '@salesforce/apex';
import getAccountDataList from '@salesforce/apex/visitZonesMapController.getAccountForMapData';
import getTranslations from '@salesforce/apex/visitZonesMapController.getTranslations';
import USER_LOCALE from '@salesforce/i18n/locale';
import Visit_Zones_Map_Warning from '@salesforce/label/c.Visit_Zones_Map_Warning';
import Last_7_days_visits from '@salesforce/label/c.Last_7_days_visits';
import Last_30_days_visits from '@salesforce/label/c.Last_30_days_visits';

import CURRENT_USERID from '@salesforce/user/Id';

//import lwc funtions start here
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VisitZonesMap extends LightningElement {
    record;
    wireData;
    counting1 = 0;
    counting2 = 0;
    counting3 = 0;
    counting4 = 0;
    counting5 = 0;
    counting6 = 0; //not selected
    showMap = true;
    @track isLoading = false;
    @track VisitZone = '';
    @track mapMaker = [];
    @track vCenter;
    @track mapMakerTitle = 'Account Visit Zone Map';
    @track isDisplayList = true;
    @track displayListView = 'hidden';
    @track zoomLevel = 8;
    @track IsSelected;
    IsCheckBoxChecked=true;
    _userId;
    subArea1;
    subArea2;
    subArea3;
    subArea4;
    subArea5;
    notSelected;
    @api numberOfDays = 7;
    @api iscustomerReviewtab = false;

    Last_7_days_visits = Last_7_days_visits;
    Last_30_days_visits = Last_30_days_visits;

    @api 
    get userId(){
        return this._userId;
    }

    renderedCallback(){
        if(this.iscustomerReviewtab && !this._userId){
            //this.updateCheckBox(false,true);
        }
    }

    updateCheckBox(checked,disableSelection){
        if(this.template.querySelector('[data-id="Not_Selected"]')){
            this.template.querySelector('[data-id="Not_Selected"]').checked = checked;
            this.template.querySelector('[data-id="Not_Selected"]').disabled = disableSelection;
        }
    }

    set userId(val){
        this._userId = val;
        console.log('Update called'+val);
        console.log('Update called'+this._userId);
        //this.updateCheckBox(true,false);
    }

    async connectedCallback(){
        const translations = await getTranslations();
        console.log('Method1 result: ' + JSON.stringify(translations));
        if(translations){
            this.subArea1 = translations["Sub-area 1"];
            this.subArea2 = translations["Sub-area 2"];
            this.subArea3 = translations["Sub-area 3"];
            this.subArea4 = translations["Sub-area 4"];
            this.subArea5 = translations["Sub-area 5"];
            this.notSelected = translations["Not Selected"];
        }
        if(!this.iscustomerReviewtab){
            this._userId = CURRENT_USERID;
            this.IsSelected = true;
        }else{
            this.isLoading = false;
            this.IsCheckBoxChecked = false;
            this.IsSelected = false;
        }
    }

    @wire(getAccountDataList, {ZoneName : '$VisitZone', IsSelected : '$IsSelected',userId: '$_userId', numberofDays : '$numberOfDays' })
    getAccountDataListWire(wireResult){
        this.isLoading = true;
        const { data, error } = wireResult;
        this.wireData = wireResult;
        if(data){
            this.mapMaker = [];
            if(data.length > 0){
                data.forEach(dataItem=>{
                    let descritptionVal = '<strong>Hoya Account Id : </strong>'+dataItem.Hoya_Account_Id + '<br><strong>Visit Zone : </strong>'+dataItem.VisitZone +
                                            '<br><strong>Segmentation : </strong>'+dataItem.Segmentation +'<br><strong>Total Visit Planned : </strong>' + dataItem.TotalVisitsPlanned+
                                            '<br><strong>Last Direct Visit Date : </strong>'+this.replaceFormatDate(dataItem.LastVisitDate) +'<br><strong>Address : </strong>' + (dataItem.AccountStreet ? dataItem.AccountStreet + ' ' : '') + (dataItem.AccountCity ? dataItem.AccountCity + ' ' : '' )+ (dataItem.AccountState ? dataItem.AccountState + ' ' : '' )+(dataItem.AccountPostalCode ? dataItem.AccountPostalCode + ' ' : '')+ (dataItem.AccountCountry ? dataItem.AccountCountry : '');
                    let fillcolor;
                    switch(dataItem.VisitZone){
                        case 'Sub-area 1':
                        fillcolor = 'yellow';
                        break;

                        case 'Sub-area 2':
                        fillcolor = '#fcb207';
                        break;

                        case 'Sub-area 3':
                        fillcolor = '#ec1717';
                        break;

                        case 'Sub-area 4':
                        fillcolor = '#13cddc';
                        break;

                        case 'Sub-area 5':
                        fillcolor = '#58bd08';
                        break;

                        default :
                        fillcolor = '#000F2E';
                        break;
                    }

                    if(dataItem.VisitCouter > 0){
                        this.mapMaker = [...this.mapMaker,
                            {
                                location: {
                                    //Latitude: dataItem.AccountShippingLatitude,
                                    //Longitude: dataItem.AccountShippingLongitude,
                                    Street: dataItem.AccountStreet,
                                    City: dataItem.AccountCity,
                                    State: dataItem.AccountState,
                                    PostalCode: dataItem.AccountPostalCode,
                                    Country: dataItem.AccountCountry,
                                },
                                mapIcon: {
                                    path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
                                    fillColor: fillcolor,
                                    fillOpacity: 0.7,
                                    strokeWeight: 1,
                                    scale: 1.3,
                                },
                                icons: 'standard:account',
                                title: dataItem.AccountName,
                                value: dataItem.AccountId,
                                description: descritptionVal,
                            }
                        ];
                    }else{
                        this.mapMaker = [...this.mapMaker,
                            {
                                location: {
                                    //Latitude: dataItem.AccountShippingLatitude,
                                    //Longitude: dataItem.AccountShippingLongitude,
                                    Street: dataItem.AccountStreet,
                                    City: dataItem.AccountCity,
                                    State: dataItem.AccountState,
                                    PostalCode: dataItem.AccountPostalCode,
                                    Country: dataItem.AccountCountry,
                                },
                                mapIcon: {
                                    path: 'M11,0A11.01245,11.01245,0,0,0,0,11C0,21.36133,9.95166,29.44238,10.37549,29.78125a1.00083,1.00083,0,0,0,1.249,0C12.04834,29.44238,22,21.36133,22,11A11.01245,11.01245,0,0,0,11,0Z',
                                    fillColor: fillcolor,
                                    fillOpacity: 0.7,
                                    strokeWeight: 1,
                                    scale: 0.85,
                                },
                                icon: 'standard:account',
                                title: dataItem.AccountName,
                                value: dataItem.AccountId,
                                description: descritptionVal,
                            }
                        ];
                    }
                });
                this.vCenter = {
                    location : {
                        //Latitude : data[0].AccountShippingLatitude,
                        //Longitude : data[0].AccountShippingLongitude,
                        Street : data[0].AccountStreet,
                        City : data[0].AccountCity,
                        State : data[0].AccountState,
                        PostalCode : data[0].AccountPostalCode,
                        Country : data[0].AccountCountry,
                    }
                }
                this.zoomLevel = 8;
            }else{
                this.showToast('Warning', 'Warning', Visit_Zones_Map_Warning);
            }
            this.showMap = true;
            this.isLoading = false;
        }else if(error){
            this.showMap = true;
            this.showToast('Error', 'Error', JSON.stringify(error));
            this.isLoading = false;
        }
    }
    async refreshComponent(){
        this.showMap = false;
        this.VisitZone = '';
        return refreshApex(this.wireData);
    }

    handleClickSubarea1 = () =>{
        this.refreshComponent();
        ++this.counting1;
        this.counting2 = 0;
        this.counting3 = 0;
        this.counting4 = 0;
        this.counting5 = 0;
        this.counting6 = 0;
        var fraction = this.counting1 % 2;
        if(fraction == 1){
            var divBlock = this.template.querySelector('[data-id="sub_area_1"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class1';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = true;
            }
            this.VisitZone = 'Sub-area 1';
			this.IsSelected = true;           
        }else{
            var divBlock = this.template.querySelector('[data-id="sub_area_1"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
            }
            this.VisitZone = '';
            this.IsSelected = true;
        }
    }

    handleClickSubarea2 = () =>{
        this.refreshComponent();
        ++this.counting2;
        this.counting1 = 0;
        this.counting3 = 0;
        this.counting4 = 0;
        this.counting5 = 0;
        this.counting6 = 0;
        var fraction = this.counting2 % 2;
        if(fraction == 1){
            var divBlock = this.template.querySelector('[data-id="sub_area_2"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class1';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = true;
            }
            this.VisitZone = 'Sub-area 2';
            this.IsSelected = true;
        }else{
            var divBlock = this.template.querySelector('[data-id="sub_area_2"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
            }
            this.VisitZone = '';
            this.IsSelected = true;
        }
        
    }

    handleClickSubarea3 = () =>{
        this.refreshComponent();
        ++this.counting3;
        this.counting1 = 0;
        this.counting2 = 0;
        this.counting4 = 0;
        this.counting5 = 0;
        this.counting6 = 0;
        var fraction = this.counting3 % 2;
        if(fraction == 1){
            var divBlock = this.template.querySelector('[data-id="sub_area_3"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class1';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = true;
            }
            this.VisitZone = 'Sub-area 3';
            this.IsSelected = true;
        }else{
            var divBlock = this.template.querySelector('[data-id="sub_area_3"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
            }
            this.VisitZone = '';
            this.IsSelected = true;
        }
        
    }

    handleClickSubarea4 = () =>{
        this.refreshComponent();
        ++this.counting4;
        this.counting1 = 0;
        this.counting2 = 0;
        this.counting3 = 0;
        this.counting5 = 0;
        this.counting6 = 0;
        var fraction = this.counting4 % 2;
        if(fraction == 1){
            var divBlock = this.template.querySelector('[data-id="sub_area_4"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class1';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = true;
            }
            this.VisitZone = 'Sub-area 4';
            this.IsSelected = true;
        }else{
            var divBlock = this.template.querySelector('[data-id="sub_area_4"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class1';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
            }
            this.VisitZone = '';
            this.IsSelected = true;
        }
    }

    handleClickSubarea5 = () =>{
        this.refreshComponent();
        ++this.counting5;
        this.counting1 = 0;
        this.counting2 = 0;
        this.counting3 = 0;
        this.counting4 = 0;
        this.counting6 = 0;
        var fraction = this.counting5 % 2;
        if(fraction == 1){
            var divBlock = this.template.querySelector('[data-id="sub_area_5"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class1';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = true;
            }
            this.VisitZone = 'Sub-area 5';
            this.IsSelected = true;
        }else{
            var divBlock = this.template.querySelector('[data-id="sub_area_5"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
            }
            this.VisitZone = '';
            this.IsSelected = true;
        }
    }
    
    handleClickSubarea6 = () =>{
        this.refreshComponent();
        ++this.counting6;
        this.counting1 = 0;
        this.counting2 = 0;
        this.counting3 = 0;
        this.counting4 = 0;
        this.counting5 = 0;
        var fraction = this.counting6 % 2;
        if(fraction == 1){
            var divBlock = this.template.querySelector('[data-id="sub_area_6"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class1';
                this.template.querySelector('[data-id="Not_Selected"]').checked = false;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = true;
            }
            this.VisitZone = 'Not Selected';
            this.IsSelected = true;
        }else{
            var divBlock = this.template.querySelector('[data-id="sub_area_6"]');
            if(divBlock){
                this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
                this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
                this.template.querySelector('[data-id="Not_Selected"]').checked = true;
                this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
            }
            this.VisitZone = '';
            this.IsSelected = true;
        }
        
    }

    hanndledCheckboxChanged(event){
        this.IsCheckBoxChecked = event.target.checked;
        if(event.target.checked == true){
            this.showMap = false;
            this.IsSelected = true;  
        }else{
            this.showMap = false;
            this.IsSelected = false;
        }

    }

    handleRefreshData(){
        this.showMap = false;
        // Below two lines are required in case if somebody does nothing and clicks refresh button directly then 
        // to get the wire method called automatically. wire will understand that there is a change in visitZone.
        this.VisitZone = null;
        this.VisitZone = '';
        this.IsSelected = true;

        this.counting1 = 0;
        this.counting2 = 0;
        this.counting3 = 0;
        this.counting4 = 0;
        this.counting5 = 0;
        this.counting6 = 0;
        
        this.template.querySelector('[data-id="sub_area_1"]').className = 'class2';
        this.template.querySelector('[data-id="sub_area_2"]').className = 'class2';
        this.template.querySelector('[data-id="sub_area_3"]').className = 'class2';
        this.template.querySelector('[data-id="sub_area_4"]').className = 'class2';
        this.template.querySelector('[data-id="sub_area_5"]').className = 'class2';
        this.template.querySelector('[data-id="sub_area_6"]').className = 'class2';
        this.template.querySelector('[data-id="Not_Selected"]').checked = true;
        this.template.querySelector('[data-id="Not_Selected"]').disabled = false;
        
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