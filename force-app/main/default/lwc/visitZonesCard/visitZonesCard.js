import { LightningElement,api ,track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation'

//Custom Labels
import SFDC_V2_Seg from '@salesforce/label/c.SFDC_V2_Seg';
import SFDC_V2_SV from '@salesforce/label/c.SFDC_V2_SV';
import SFDC_Visits_Planned from '@salesforce/label/c.SFDC_Visits_Planned';
import Do_Not_Visit from '@salesforce/label/c.Do_Not_Visit';
import SFDC_V2_Chain from '@salesforce/label/c.SFDC_V2_Chain';
import SFDC_V2_Prospect from '@salesforce/label/c.SFDC_V2_Prospect';
import SFDC_V2_Occasional_Customer from '@salesforce/label/c.SFDC_V2_Occasional_Customer';
import SFDC_V2_NoContact from '@salesforce/label/c.SFDC_V2_NoContact';
import SFDC_V2_RemoveAcc from '@salesforce/label/c.SFDC_V2_RemoveAcc';
import SFDC_V2_ModalConf from '@salesforce/label/c.SFDC_V2_ModalConf';
import SFDC_V2_ModalConf1 from '@salesforce/label/c.SFDC_V2_ModalConf1';
import Confirm_Action from '@salesforce/label/c.Confirm_Action';
import SFDC_V2_Confirm from '@salesforce/label/c.SFDC_V2_Confirm';
import tabLabelClose from '@salesforce/label/c.tabLabelClose';
import ButtonCancel from '@salesforce/label/c.ButtonCancel';

export default class VisitZonesCard extends NavigationMixin(LightningElement) {
    @api stage
    @api tranlated;
    @api record
    @api pickvals;
    @api accVisMap; 
    @api showspinner;
    @track linkClass = '';
    @track isModalOpen = false;
    @track dropZone = null; 
    showVisionaryFlag = false;
    showDoNotVisitFlag = false;
    showChainsFlag = false;
    showProspectFlag = false;
    showOccasionalCustomerFlag = false;
    showNoRecentContactFlag = false;

    custLabel ={
        tabLabelClose,ButtonCancel,Confirm_Action,SFDC_V2_Confirm,SFDC_V2_Seg,SFDC_V2_SV,SFDC_Visits_Planned,SFDC_V2_Occasional_Customer,
        Do_Not_Visit,SFDC_V2_Chain,SFDC_V2_Prospect,SFDC_V2_NoContact,SFDC_V2_RemoveAcc,SFDC_V2_ModalConf,SFDC_V2_ModalConf1
    }
    get strategicValueNetSales() {
        return this.record.Strategic_Value_Net_Sales__c == null || this.record.Strategic_Value_Net_Sales__c == undefined ? 0 : this.record.Strategic_Value_Net_Sales__c;
    }
    connectedCallback() {
        if(this.record.Seiko_Network__c == 'Seiko Vision Specialist' || this.record.Seiko_Network__c == 'Visionary Alliance'){
            this.showVisionaryFlag = true;
        }
        if(this.record.Total_Visits_Planned__c <=0  || this.record.Total_Visits_Planned__c == undefined){
            this.showDoNotVisitFlag = true;
        }
        if(this.record.CHCUSTCLASSIFICATIONID__c == 'Chain' ){
            this.showChainsFlag = true;
        }
        if(this.record.Lenses_Net_Sales_Last_12Mo__c <= 0  || this.record.Lenses_Net_Sales_Last_12Mo__c == undefined){
            this.showProspectFlag = true;
        } else if(this.record.Lenses_Net_Sales_Last_12Mo__c > 0 && this.isSegmentationA3B3C3){
            this.showOccasionalCustomerFlag = true;
        }
        if(this.record.Days_since_the_last_visit__c > 180){
            this.showNoRecentContactFlag = true;
        }
        
        const idsToHighlight = this.pickvals[0].accVisMap;
        if (idsToHighlight.includes(this.record.Id)) {
            this.cardStyle = 'background-color: #eaf2f5;width:19vh;';
        }else{
            this.cardStyle = 'width:19vh;';
        }
    }
    get isSegmentationA3B3C3() {
        return ['A3', 'B3', 'C3'].includes(this.record.Segmentation_Net__c);
    }
    get isSameStage(){
        return this.stage === this.record.TACTICOM_SOF__c
    }
    navigateAccHandler(event){
        event.preventDefault();
        this.linkClass = 'visited';
        this.navigateHandler(event.target.dataset.id, 'Account')
    }
    navigateHandler(Id, apiName) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                objectApiName: apiName,
                actionName: 'view',
            },
        }).then(url => {
            window.open(url, "_blank");
        });
    }
    itemDragStart(evt){
        this.showspinner = true;
        console.log('itemDragStart called with record Id:', this.record.Id);
        evt.dataTransfer.setData('recordId', this.record.Id);
        evt.dataTransfer.setData('stage',this.stage);
        evt.dataTransfer.setData('tranlated',this.tranlated);
        
        evt.dataTransfer.effectAllowed = 'move';
        const event = new CustomEvent('itemdrag', {
            detail: this.record.Id
        })
        //this.dispatchEvent(event)
    }
    handleDelete(event) {
        this.dropZone = event.target.dataset.id;
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    confirmDelete() {
        this.showspinner = true;
        const cardId = this.dropZone;
        const deleteEvent = new CustomEvent('deletecard', {
            detail: {
                cardId
            }
        });
        this.dispatchEvent(deleteEvent);
        this.closeModal();
    }
    showDeleteButton() {
        this.template.querySelector('.delete-button').style.opacity = '1';
    }

    hideDeleteButton() {
        this.template.querySelector('.delete-button').style.opacity = '0';
    }
}