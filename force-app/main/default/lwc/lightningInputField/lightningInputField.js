import { LightningElement, api } from 'lwc';

export default class LightningInputField extends LightningElement {
    @api accountId;
    
    connectedCallback(){
        console.log('get connect callback = > '+this.accountId);
    }

    handleChange(event) {
        console.log(this.accountId);
        const value = event.target.value;
        const valueChangeEvent = new CustomEvent("valuechange", {
            detail: { value }
        });
        // Fire the custom event
        this.dispatchEvent(valueChangeEvent);
    }
}