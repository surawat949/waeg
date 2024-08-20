import { LightningElement ,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Custom Labels
import VisurealMaster from '@salesforce/label/c.AccountActivationVisuRealMaster';
import VisurealMasterUsage from '@salesforce/label/c.AccountActivationVisuRealMasterUsage';
import VisuMLastTraining from '@salesforce/label/c.VisuReal_Master_Last_Training';
//Apex
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
//import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';

export default class TabActivationEquipmentsVisurealMaster extends LightningElement {
    @api receivedId;    
    masterLastUsageDate;
    masterLastTraningDate;
    customlabel = {
        VisurealMaster,VisurealMasterUsage,VisuMLastTraining
    };
    connectedCallback() {
          //Visureal Master
          getLastTrainingDate({accountId : this.receivedId,topic : 'HOYA VisuReal MASTER'})
          .then(response => {
              response = JSON.parse(JSON.stringify(response)); 
              this.masterLastTraningDate = response;
          })
          .catch(error => {
              this.showToast('Error', 'Error', error.message);
          })
          // last media usage date
          /*getLastUsageDate({accountId : this.receivedId,tool : 'Hoyailog orders with visuReal'})
          .then(response => {
              response = JSON.parse(JSON.stringify(response)); 
             // this.masterLastUsageDate = response;
          })
          .catch(error => {
              this.showToast('Error', 'Error', error.message);
          })*/
    }
    showToast(title, message, variant, mode){
        const event = new ShowToastEvent({
            title : title,
            message : message,
            variant : variant,
            mode : mode
        });
        this.dispatchEvent(event);
    }
}