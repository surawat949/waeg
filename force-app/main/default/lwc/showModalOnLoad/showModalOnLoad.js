import { LightningElement,track } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {

    @track isShowModal = true;

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
}