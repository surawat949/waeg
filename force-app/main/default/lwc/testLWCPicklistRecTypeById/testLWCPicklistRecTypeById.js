import { LightningElement, wire, track} from 'lwc';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';

export default class TestLWCPicklistRecTypeById extends LightningElement {
    @track value;
    @track options;

    @wire(getPicklistValuesByRecordType, {objectApiName : 'Task', recordTypeId: '012Fg000000vX7JIAU'})
    STATUS_PICKLIST_VALUE({data,error}){
        if(data){
            this.options = data.picklistFieldValues.Status.values;
            console.log(data);
        }else if(error){
            console.log('Error = >'+JSON.stringify(error));
        }
    }

    handleChange(event){
        this.value = event.target.value;
        console.log('handle change event ==>'+this.value);
    }
}