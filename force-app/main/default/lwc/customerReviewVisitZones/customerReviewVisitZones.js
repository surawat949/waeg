import { LightningElement,wire,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomerReviewVisitZones extends LightningElement {
    currentUserId;
    isLoading = false;

    @api 
    set representativeId(val){
        this.currentUserId = val;
    }

    get representativeId(){
        return this.currentUserId;
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