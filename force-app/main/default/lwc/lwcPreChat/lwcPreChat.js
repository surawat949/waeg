import BasePrechat from 'lightningsnapin/basePrechat';
import { assignHandler, maximize } from 'lightningsnapin/minimized';
import { api, track } from 'lwc';
import botPreChatFormCSS from "@salesforce/resourceUrl/botPreChatFormCSS";
import { loadStyle } from "lightning/platformResourceLoader";
 
export default class LwcPreChat extends BasePrechat {
    @api prechatFields;
    @api prechatFormDetails;
    @track fields;
    @track namelist;
    @track message;

    constructor() {
        super();
        assignHandler("prechatState", this.setMinimizedMessage.bind(this));
        assignHandler("offlineSupportState", this.setMinimizedMessage.bind(this));
        assignHandler("waitingState", this.setMinimizedMessage.bind(this));
        assignHandler("queueUpdate", this.setMinimizedQueuePosition.bind(this));
        assignHandler("waitingEndedState", this.setMinimizedMessage.bind(this));
        assignHandler("chatState", this.setMinimizedChatState.bind(this));
        assignHandler("chatTimeoutUpdate", this.setMinimizedMessage.bind(this));
        assignHandler("chatUnreadMessage", this.setMinimizedMessage.bind(this));
        assignHandler("chatTransferringState", this.setMinimizedMessage.bind(this));
        assignHandler("chatEndedState", this.setMinimizedMessage.bind(this));
        assignHandler("reconnectingState", this.setMinimizedMessage.bind(this));
        assignHandler("postchatState", this.setMinimizedMessage.bind(this));
    }
    handleClick() {
        maximize();
    }
    setMinimizedMessage(eventData) {
        this.message = eventData.label;
    }
    setMinimizedQueuePosition(eventData) {
        this.message = eventData.label;
        if (eventData.queuePosition) {
            this.message += " " + eventData.queuePosition;
        }
    }
    setMinimizedChatState(eventData) {
        this.message = eventData.agentName;
    }
    connectedCallback() {
        this.startChatLabel = "Start Chat";
        
        if (this.prechatFields) {
            console.log("PrechatFormDetails********"+JSON.stringify(this.prechatFormDetails));
            console.log("********"+JSON.stringify(this.prechatFields));
            this.fields = this.prechatFields.map(field => {
                field = JSON.parse(JSON.stringify(field));
                field.type = field.type.replace('input', '');
                const { label, name, value, required, maxLength, type } = field;
                return { label, name, value, required, maxLength, type };
            });
            console.log("********"+JSON.stringify(this.fields));
            this.namelist = this.fields.map(field => field.name);
            this.startChat(this.fields);
        }
    }
    renderedCallback() {
        Promise.all([
            loadStyle(this, botPreChatFormCSS),
        ]).then(() => { });
        if(!this.inputFocused) {
            let lightningInputElement = this.template.querySelector("lightning-input");
            if (lightningInputElement) {
                lightningInputElement.focus();
                this.inputFocused = true;
            };
        }
    }
    get hasFields() {
        return this.fields && this.fields.length > 0;
    }
    handleStartChat(event) {
        event.preventDefault();
        let inputElements = this.template.querySelectorAll("lightning-input");
        if (inputElements && this.checkInputValidity(inputElements)) {
            inputElements.forEach(input => {
                this.fields[this.namelist.indexOf(input.name)].value = input.value;
            });
            if (this.validateFields(this.fields).valid) {
                this.startChat(this.fields);
            } else {
                // Error handling if fields do not pass validation.
            }
        }
    }
 
    checkInputValidity(inputElements) {
        const allValid = [...inputElements].reduce(
            (validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        return allValid;
    }
}