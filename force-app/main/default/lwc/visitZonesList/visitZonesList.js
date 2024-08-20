import { LightningElement,api, track } from 'lwc';

export default class VisitZonesList extends LightningElement {

    @api records;
    @api stage;
    @api tranlated;
    @api pickvals;
    @api showspinner;
    @track originalStage;
    @track tranlatedStage;
    handleItemDrag(evt){
        console.log('handleItemDrag called with:', evt.detail);
        this.originalStage = this.stage;
        this.tranlatedStage = this.tranlated;
        const event = new CustomEvent('listitemdrag', {
            detail: evt.detail,
            bubbles: true,
            composed: true    
        })
        this.dispatchEvent(event)
        console.log('CustomEvent dispatched successfully:', event);
    }
    handleDragOver(evt){
        evt.preventDefault()
    }
    /*
    handleDrop(evt){
        const event = new CustomEvent('itemdrop', {
            detail: this.stage
        })
        this.dispatchEvent(event)
    }
    */
    handleDrop(evt) {
        console.log('handleDrop called with stage visitzoneList:', this.stage);
        console.log('handleDrop evt visitzoneList recordId:', evt.dataTransfer.getData('recordId'));
        console.log('handleDrop evt visitzoneList stage:', evt.dataTransfer.getData('stage'));
        let recordId = evt.dataTransfer.getData('recordId');
        let stage = evt.dataTransfer.getData('stage');
        if (stage === this.stage) {
            console.log('Dropped in the same column, no update needed.');
            return; // Exit if dropped in the same column
        }
        const event = new CustomEvent('itemdrop', {
            detail: {recordId : recordId,stage : this.stage, tranlated : this.tranlated},
            bubbles: true,
            composed: true        
        });
        this.dispatchEvent(event);
        console.log('CustomEvent dispatched successfully:', event);

    }
    handleCardDelete(evt) {
        const cardId = evt.detail.cardId;
        console.log('cardId '+cardId);
        const deleteEvent = new CustomEvent('deletecard', {
            detail: {
                cardId
            }
        });
        this.dispatchEvent(deleteEvent);
    }
    
}