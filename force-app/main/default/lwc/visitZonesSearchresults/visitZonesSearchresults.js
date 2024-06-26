import { LightningElement,api } from 'lwc';

export default class VisitZonesSearchresults extends LightningElement {
    _results;

    @api 
    set results(val){
        this._results = val;
    }

    get results(){
        return  this._results;
    }

    get showResults(){
        return (this.results.length >0);
    }

    handleDragStart(event) {
        console.log('dragg',JSON.stringify( event.target.dataset));
        const itemId = event.target.dataset.itemId;
        const draggedItem = this.leftItems.find(item => item.id == itemId);
        event.dataTransfer.setData('item', JSON.stringify(draggedItem));
        event.dataTransfer.effectAllowed = 'move';
    }
}