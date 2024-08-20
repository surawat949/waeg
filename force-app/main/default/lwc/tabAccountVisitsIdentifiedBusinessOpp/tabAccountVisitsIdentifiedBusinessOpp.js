import { LightningElement,wire,api } from 'lwc';
import LightningModal from 'lightning/modal';

import label_save from '@salesforce/label/c.tabLabelSave';
import label_Close from '@salesforce/label/c.tabLabelClose';
import label_category from '@salesforce/label/c.category';
import label_status from '@salesforce/label/c.Status';
import Project_Description from '@salesforce/label/c.Project_Description';
import headingIBO from '@salesforce/label/c.headingIBO';
import Name from '@salesforce/label/c.Name';
import description from '@salesforce/label/c.Description';
import Next_Steps from '@salesforce/label/c.Next_Steps';
import Priority_Level from '@salesforce/label/c.Priority_Level';
import Expected_Incremental_Sales from '@salesforce/label/c.Expected_Incremental_Sales';
import Monthly_Incremental from '@salesforce/label/c.Monthly_Incremental';

import createBusinessOpportunity from '@salesforce/apex/TabVisitsCampOppController.createBusinessOpportunity';

export default class TabAccountVisitsIdentifiedBusinessOpp extends LightningModal {

    showSpinner = false;
    
    label_Project_Description=Project_Description;
    labelSave = label_save;
    labelClose = label_Close;
    labelCategory = label_category;
    labelStatus = label_status;
    labelheadingIBO = headingIBO; 
    name =Name;
    Description = description;
    next_Steps = Next_Steps;
    priority_Level = Priority_Level;
    expected_Incremental_Sales = Expected_Incremental_Sales;
    monthly_Incremental = Monthly_Incremental;

    @api receivedId;
    isModalOpen = false
    projectName;
    description;
    category;
    nextSteps;
    status;
    level;
    monthlyInc;
    errors = '';

    @api displayModal() {  
        console.log('>>>here1');  
        this.isModalOpen = true;
    }

    get categoryOptions(){
        return [
            { label : 'Product Mix', value : 'Product Mix'},
            { label : 'Instrument', value : 'Instrument'},
            { label : 'Service', value : 'Service'},
            { label : 'Challenge', value : 'Challenge'},
            { label : 'Promotion', value : 'Promotion'},
            { label : 'Event', value : 'Event'},
            { label : 'ECP’s project', value : 'ECP’s project'},
            { label : 'Other', value : 'Other'}
        ];
    }
  
    closePopup() {
      this.isModalOpen = false;       
      
    }

    get statusOptions(){
        return [
            { label : 'Not Started', value : 'Not Started'},
            { label : 'In progress', value : 'In progress'},
            { label : 'Posponed', value : 'Posponed'},
            { label : 'Abandoned', value : 'Abandoned'},
            { label : 'Delivered', value : 'Delivered'}
        ];
    }

    get levelOptions(){
        return [
            { label : '1', value : '1'},
            { label : '2', value : '2'},
            { label : '3', value : '3'}
        ];
    }


    projectNameCH(event){
        this.projectName = event.target.value; 
     }
 
     categoryCH(event){
           this.category = event.target.value;
     }
 
     descriptionCH(event){
         this.description = event.target.value;
     }
 
     nextStepsCH(event){
         this.nextSteps = event.target.value;
     }
 
     statusCH(event){
         this.status = event.target.value;
     }
 
     levelCH(event){
         this.level = event.target.value;
     }
 
     statusCH(event){
         this.status = event.target.value;
     }
 
     monthlyIncCH(event){
         this.monthlyInc = event.target.value;
     }

    onSave(event){
        if(this.projectName =='' || this.projectName == null){
            alert('Project Name must have the value, please input some values Project Name field');
        }
        else{
            this.showSpinner = true ;
            createBusinessOpportunity({
                projectName : this.projectName,
                accountId : this.receivedId,
                description : this.description,
                category : this.category,
                nextSteps : this.nextSteps,
                level : this.level,
                monthlyInc : this.monthlyInc,
                status : this.status
            }).then(result=>{
                this.showSpinner = false;
                //this.showSuccessToast();
                //this.updateRecordView();

                //this.passMessageToParent();
                // notify parent to refresh the datatable

                const successEvent = new CustomEvent("savesuccess", {
                    detail: 'success'
                });
                // Dispatches the event.
                this.dispatchEvent(successEvent);

                this.closePopup();

            }).catch(error=>{
                this.showSpinner = false;
                this.errors = 'Error Creating Identified Opportunity' + error.message ;
            });
        }
    }

    async passMessageToParent(){
        // notify parent to refresh the datatable
        const successEvent = new CustomEvent("savesuccess", {
            detail: 'success'
        });
        // Dispatches the event.
        this.dispatchEvent(successEvent);
    }

 /*    closePopup() {
        //window.location.reload();
        //this.close();
    }

   updateRecordView(){
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");
        },1000);
    }*/

}