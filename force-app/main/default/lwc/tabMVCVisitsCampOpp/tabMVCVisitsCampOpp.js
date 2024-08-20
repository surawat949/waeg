import { LightningElement, api,track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

import IdentifiedBusinessOpp from '@salesforce/label/c.IdentifiedBusinessOpp';
import project_id from '@salesforce/label/c.project_id';
import creation_date from '@salesforce/label/c.creation_date';
import project_name from '@salesforce/label/c.project_name';
import opp_status from '@salesforce/label/c.opp_status';
import priority from '@salesforce/label/c.priority';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import add from '@salesforce/label/c.add';

//identified business opportunity pop up 
import label_save from '@salesforce/label/c.tabLabelSave';
import label_Close from '@salesforce/label/c.tabLabelClose';
import label_category1 from '@salesforce/label/c.category';
import label_status from '@salesforce/label/c.Status';
import Project_Description from '@salesforce/label/c.Project_Description';
import headingIBO from '@salesforce/label/c.headingIBO';
import Name from '@salesforce/label/c.Name';
import Next_Steps from '@salesforce/label/c.Next_Steps';
import Priority_Level from '@salesforce/label/c.Priority_Level';
import Expected_Incremental_Sales from '@salesforce/label/c.Expected_Incremental_Sales';
import Subject from '@salesforce/label/c.Subject';
import Comment from '@salesforce/label/c.Comment';
import New_Identified_Opportunity_in_Medical_visit from '@salesforce/label/c.New_Identified_Opportunity_in_Medical_visit';
import Identified_Opportunities_in_Medical_visits from '@salesforce/label/c.Identified_Opportunities_in_Medical_visits';


import getIdentifiedBusinesssOpp from '@salesforce/apex/TabMVCVisitsCampOppController.getBusinessOpportunityRelatedToContact';
import createBusinessOpportunity from '@salesforce/apex/TabMVCVisitsCampOppController.createBusinessOpportunity';

export default class TabMVCVisitsCampOpp extends NavigationMixin(LightningElement) {
    @api receivedId;

    label={ project_id,creation_date,project_name,IdentifiedBusinessOpp,
            opp_status,priority,label_viewall,add,Subject,label_category1,
            Identified_Opportunities_in_Medical_visits,Comment,New_Identified_Opportunity_in_Medical_visit
    }

    //identified business opportunity pop up labels
    IdentifiedBusinessOppData;
    showSpinner = false;
    label_Project_Description=Project_Description;
    labelSave = label_save;
    labelClose = label_Close;
    labelCategory = label_category1;
    labelStatus = label_status;
    labelheadingIBO = headingIBO; 
    name =Name;
    Description = Comment;
    next_Steps = Next_Steps;
    priority_Level = Priority_Level;
    expected_Incremental_Sales = Expected_Incremental_Sales;
    Subject_Label = Subject

    IdentifiedBusinessOppData;
    oppCount = 0;
    displayIdentifiedOppViewAllButton;
    isModalOpen = false; //for opportunity popup

    subject;
    projectName;
    category;
    description;
    nextSteps;
    level;
    status;

    @track businessOppColumns = [
        {
            label: this.label.project_name,
            fieldName: 'nameLink',
            type: 'url',
            typeAttributes: {label: {fieldName: 'Project_Name__c'}, target:'_top'},
            sortable: true 
        },
        {
            label: this.label.Subject,
            fieldName: 'Subject__c',
            type: 'text',
            sortable: true
        },
        {
            label: this.label.creation_date,
            fieldName: 'CreatedDate',
            type: 'date',
            sortable: true
        },
        {
            label: this.label.label_category1,
            fieldName: 'Category__c',
            type: 'text',
            sortable: true 
        },
        {
            label: this.label.Comment,
            fieldName: 'Comments__c',
             type: 'text',
            sortable: true
        },
        {
            label: this.label.opp_status,
            fieldName: 'Status__c',
            type: 'text',
            sortable: true
        }
    ];
    
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        //console.log('child connected call-' + this.receivedId);
    }

    @wire(getIdentifiedBusinesssOpp, {contactId:'$receivedId'}) OppRec(result){
        this.IdentifiedBusinessOppData = result;
        if(result.data && result.data.length>0){
        let data = JSON.parse(JSON.stringify(result.data));
         data.forEach(res=>{
             res.nameLink = '/' + res.Id;
         });
         this.OppRecord = (data.length<=5) ? [...data] : [...data].splice(0,5);
         if(result.data.length > 5){
             this.oppCount = '5+';
             this.displayIdentifiedOppViewAllButton = true;
         }else{
             this.oppCount = data.length;
             this.displayIdentifiedOppViewAllButton = false;
         }
        
         }else if (result.error){
         this.showToast("Error", "Error while getting the Business Opportunity Details : "+result.error.message, 
         "error");
     }
    }

    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

        //Identified business opportunity Creation  - Start
        get categoryOptions(){
            return [
                { label : 'Training', value : 'Training'},
                { label : 'Product Trial', value : 'Product Trial'},
                { label : 'Testimonial', value : 'Testimonial'},
                { label : 'Event', value : 'Event'},
                { label : 'Other', value : 'Other'}
            ];
        }

        get statusOptions(){
            return [
                { label : 'Not Started', value : 'Not Started'},
                { label : 'In progress', value : 'In progress'},
                { label : 'Postponed', value : 'Postponed'},
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
    
        showOppCreatePage(){
            this.isModalOpen= true;
        }
          
        closePopup() {
          this.isModalOpen = false;
          this.status = '';
          this.projectName = '';
          this.description = '';
          this.category = '';
          this.nextSteps = '';
          this.level = '';
          this.subject = '';       
          
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

         subjectCH(event){
            this.subject = event.target.value;
        }

    
        onSave(event){
            if(this.projectName =='' || this.projectName == null){
                //alert('Project Name must have the value, please input some values Project Name field');
                this.showToast('Error', 'Project Name cannot be empty', 'Error');
            }else if(this.category == '' || this.category == null){
                this.showToast('Error', 'Category cannot be empty', 'Error');
            }else if(this.status == '' || this.status == null){
                this.showToast('Error', 'Status cannot be empty', 'Error');
            }else if(this.subject == '' || this.subject == null){
                this.showToast('Error', 'Subject cannot be empty', 'Error');
            }else{
                this.showSpinner = true ;
                createBusinessOpportunity({
                    projectName : this.projectName,
                    contactId : this.receivedId,
                    description : this.description,
                    category : this.category,
                    nextSteps : this.nextSteps,
                    level : this.level,
                    status : this.status,
                    subject : this.subject
                }).then(result=>{
                    this.showSpinner = false;
                    this.closePopup();
                    this.showToast('Success','Successfully Created Business Opportunity','success');
                    this.performRefresh();
                    this.status = '';
                    this.projectName = '';
                    this.description = '';
                    this.category = '';
                    this.nextSteps = '';
                    this.level = '';
                    this.subject = '';
                }).catch(error=>{
                    this.showSpinner = false;
                    this.showToast("Error", "Error Creating Identified Opportunity : "+error.message, "error");
                });
            }
        }
    
        async performRefresh() {
            await refreshApex(this.IdentifiedBusinessOppData);  
        }
    
        //Identified business opportunity Creation  - End
    
}