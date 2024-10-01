import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Support_Img from "@salesforce/resourceUrl/Get_Support";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import getRecordTypeId from '@salesforce/apex/TabAccountNewTaskLWCController.taskRecordTypeId';
import getAccountId from '@salesforce/apex/TabAccountNewTaskLWCController.getAccountId';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TabAccountNewTask extends NavigationMixin(LightningElement) {
    // Navigate to New Account Page
    @api recordId;
    recordTypeId;
    SupportImg = Support_Img;
    nevigateFromContact=false;
    nevigateFromAccount=false;
    accountId;
    isHeaderVisible = true;

    get headerClass() {
        return this.isHeaderVisible ? '' : 'hidden';
    }

    toggleHeader() {
        this.isHeaderVisible = !this.isHeaderVisible;
    }
    @wire(getRecordTypeId)
        wiredGetRecordType({ error, data }) {
            if (data) {
                this.recordTypeId = data;
            }
            else{
                this.showToast('Error', 'Error', error);
            }
            
        }

    connectedCallback() {
      if(this.recordId.startsWith('001')){
        this.nevigateFromAccount=true; 
      }
      if(this.recordId.startsWith('003')){
        this.nevigateFromContact =true;
        getAccountId({recordtypeID: this.recordId})
        .then(result =>{
          this.accountId = result;
        })
        .catch(error =>{
            this.showToast('Error', 'Error', error);

        })
      }
    }
    navigateToNewTaskPage() {
        if(this.nevigateFromAccount){
                const defaultValues= encodeDefaultFieldValues({
            WhatId : this.recordId,
            RecordTypeId : this.recordTypeId,
         });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
            }
        });
    }
    else if(this.nevigateFromContact){
        const defaultValues= encodeDefaultFieldValues({
            WhatId : this.accountId,
            WhoId : this.recordId,
            RecordTypeId : this.recordTypeId,
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                }
            });    
        }
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