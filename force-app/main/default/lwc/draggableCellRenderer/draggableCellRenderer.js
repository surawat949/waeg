import { LightningElement, api } from 'lwc';

export default class DraggableCellRenderer extends LightningElement {
    @api name;
    @api recordId;

    handleDragStart(event) {
        event.dataTransfer.setData('text', this.recordId);
    }
}