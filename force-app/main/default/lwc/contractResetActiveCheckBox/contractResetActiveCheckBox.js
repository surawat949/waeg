import { LightningElement,api} from 'lwc';
// import show toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import update record api
import updateCheckBox from '@salesforce/apex/ContractResetActiveCheckBoxController.updateRecord';
import { getRecord } from 'lightning/uiRecordApi';




export default class ContractResetActiveCheckBox extends LightningElement {
    @api recordId;
    recordTypeIdFromRenderedCallBack;
    
    renderedCallback() {
        console.log('rendered------------');
        console.log(this.recordId + ' is provided');
        updateCheckBox({recordtypeID: this.recordId})
            .then((result) => {
              console.log('>>>>');  
              this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contracted Updated!',
                    variant: 'success'
                })
            );
            console.log('success!');
              window.location.reload();
            })
            .catch((error) => {
                console.log('>>>>'+error.body.message);  
            });
    }
    connectedCallback(){
        console.log('>>>'+this.recordId);
        updateCheckBox({recordtypeID: this.recordId})
            .then((result) => {
              console.log('>>>>');  
            })
            .catch((error) => {
                console.log('>>>>'+error.body.message);  
            });
        }        
   

}