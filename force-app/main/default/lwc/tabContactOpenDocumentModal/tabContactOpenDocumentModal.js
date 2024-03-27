import { LightningElement ,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Object
import AccountContactRelation_obj from '@salesforce/schema/AccountContactRelation';
export default class TabContactOpenDocumentModal extends LightningElement {
    @api receivedId;
  isModalOpen = false;
  ObjectName=AccountContactRelation_obj;
  
  handleSuccess(event) {  
    this.showSuccessToast();
    // notify parent to refresh the table
    const successEvent = new CustomEvent("savesuccess", {
      detail: 'success'
    });

    // Dispatches the event.
    this.dispatchEvent(successEvent);
    this.closeModal();   
  }

  @api displayModal() {    
      this.isModalOpen = true;
  }

  closeModal() {
    this.isModalOpen = false;       
    
  }

  showSuccessToast() {
    const evt = new ShowToastEvent({
      title: "Success",
      message: "New Referring Optician added",
      variant: "success"
    });
    this.dispatchEvent(evt);
  }
}