import { LightningElement } from 'lwc';
import NoHeader from '@salesforce/resourceUrl/HideLightningHeader';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class VisitZonesContainer extends LightningElement {
    showFilters = true;
    showZones = true;
    constructor(){
        super();
        loadStyle(this, NoHeader);
    }

    get filterText(){
        return this.showFilters ? 'Hide Filters' : 'Show Filters';
    }

    get zoneText(){
        return this.showZones ? 'Hide Visit Zones' : 'Show Visit Zones';
    }

    toggleFilter(){
        this.showFilters = !this.showFilters;
    }

    toggleZone(){
        this.showZones = !this.showZones;
    }

    get section1(){
        return this.showZones ? 'filterssection' : 'fullwidth';
    }
     get section2(){
        return this.showZones ? 'customwidth2 borderLine' : 'hidesection';
    }
    handleRemoveFilters(){
        if(this.template.querySelector('c-visit-zones-filters')){
            this.template.querySelector('c-visit-zones-filters').resetFilters();
        }
    }
    handlerefreshData(){
        if(this.template.querySelector('c-visit-zones-filters')){
            this.template.querySelector('c-visit-zones-filters').refreshData();
        }
    }
    handlerefreshcardData(){
         if(this.template.querySelector('c-visit-zones')){
            this.template.querySelector('c-visit-zones').refreshcardData();
        }
    }
}