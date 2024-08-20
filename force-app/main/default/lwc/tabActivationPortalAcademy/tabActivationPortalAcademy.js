import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLastTrainingDate from '@salesforce/apex/tabActivationEquipmentsController.getLastTrainingDate';
import getLastUsageDate from '@salesforce/apex/tabActivationEquipmentsController.getLastMediaUsage';

//Custom Labels
import Seiko_Vision_Academy from '@salesforce/label/c.Seiko_Vision_Academy';
import Seiko_Vision_Academy_Last_Usage from '@salesforce/label/c.Seiko_Vision_Academy_Last_Usage';
import Seiko_Vision_Academy_Last_Shop_Training from '@salesforce/label/c.Seiko_Vision_Academy_Last_Shop_Training';


export default class TabActivationPortalAcademy extends LightningElement {
    @api receivedId;
    LastTraningDate;
    LastUsageDate;
    CustLabel={
        Seiko_Vision_Academy,Seiko_Vision_Academy_Last_Usage,Seiko_Vision_Academy_Last_Shop_Training
    };
    connectedCallback() {
        getLastTrainingDate({accountId : this.receivedId,topic:'SEIKO Vision Academy'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        // last media usage date
        getLastUsageDate({accountId : this.receivedId,tool :'SEIKO Vision Academy%',type:'LikeMatch'})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastUsageDate = response;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
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