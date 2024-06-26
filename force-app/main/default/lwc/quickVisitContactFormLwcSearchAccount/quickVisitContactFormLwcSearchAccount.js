import { LightningElement, api, track} from 'lwc';
import getAccountIdFromContact from '@salesforce/apex/QuickVisitAuraController.getContact';
import { RefreshEvent } from 'lightning/refresh';

export default class QuickVisitContactFormLwcSearchAccount extends LightningElement {
    @api AccountIdData;
    @api ContactIdData;

    @track AccountId;

    constructor() {
        super();
        
    }    
    connectedCallback(){
        alert('Default Account Loaded Successfully');
        this.updateRecordView();
        this.getAccountId();
    }

    async getAccountId(){
        getAccountIdFromContact({recordId : this.ContactIdData}).then(result=>{
            this.AccountIdData = result.AccountId;
            console.log('Account Id=>'+this.AccountIdData);
        }).catch(error=>{
            console.log('Error'+JSON.parse(JSON.stringify(error)));
        });
    }

    ValueChange(event){
        this.AccountId = event.target.value;
        
    }
    
    callParent(event){
        let parameter = {AccountId : this.AccountId};
        let ev = new CustomEvent('childmethod', {
            detail : parameter
        });
        this.dispatchEvent(ev);
    }
    
    handleLookupValueChange(event){
        if(event.detail.selectedRecord != undefined){
            this.AccountId = event.detail.selectedRecord.AccountId;
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value = event.detail.selectedRecord.AccountId;
            this.callParent();
        }else{
            //this.AccountId = undefined;
            this.AccountId = null;
            this.template.querySelector('lightning-input[data-my-id=form-input-1]').value = null;
            this.callParent();
        }
    }

    updateRecordView(){
        setTimeout(() => {
            
        },1000);
        this.dispatchEvent(new RefreshEvent());
    }
    
}