import { LightningElement,api  } from 'lwc';
import LightningModal from 'lightning/modal';


export default class VisitZonesModal extends LightningModal {
    @api header;
    @api body;
    @api buttonlabel;
    @api hidecancel = false;

    handleCancel() {
        this.close('Cancel');
    }

    handleConfirm() {
       this.close('Confirm');
    }
}