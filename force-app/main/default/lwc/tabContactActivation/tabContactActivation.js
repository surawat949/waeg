import { LightningElement ,api} from 'lwc';
//Custom Labels
import portal from '@salesforce/label/c.Portal_Name';
import orderingSystem from '@salesforce/label/c.Ordering_System';
export default class TabContactActivation extends LightningElement {
    @api recordId;
    custLabel = {
        portal,orderingSystem
    }
}