import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh'; 

import STORE_LOCATION from '@salesforce/schema/Store_Characteristics__c.Store_Location__c';
import STORE_CHAR_OBJ from '@salesforce/schema/Store_Characteristics__c';
import STORE_SIZE from '@salesforce/schema/Store_Characteristics__c.Store_Size_m__c';
import EMPLOYEE from '@salesforce/schema/Store_Characteristics__c.Employess__c';
import STORE_COMM_POSITIONING from '@salesforce/schema/Store_Characteristics__c.Store_Commercial_Positioning__c';
import NUMBER_OF_STORE_WINDOW from '@salesforce/schema/Store_Characteristics__c.Number_of_Store_Windows__c';
import NUMBER_OF_POS from '@salesforce/schema/Store_Characteristics__c.Number_of_POS_packages__c';
import STATE_OF_SHOP from '@salesforce/schema/Store_Characteristics__c.State_of_the_Shop__c';
import SALES_DESK from '@salesforce/schema/Store_Characteristics__c.Sales_Desks__c';
import BLOCK_ADVERTISING_MAT from '@salesforce/schema/Store_Characteristics__c.Block_Advertising_Material__c';
import LAST_YEAR_REFERENCE from '@salesforce/schema/Store_Characteristics__c.Last_Year_of_Reference__c';
import RETAIL_LAST_YEAR from '@salesforce/schema/Store_Characteristics__c.Retail_Turnover_Last_Year_of_Ref__c';
import ANNUAL_GROWTH_LAST_YEAR from '@salesforce/schema/Store_Characteristics__c.Annual_Growth_Last_Year_of_Ref__c';
import PREVIOUS_YEAR_REFERENCE from '@salesforce/schema/Store_Characteristics__c.Previous_Year_of_Reference__c';
import RETAIL_PREVIOUS_YEAR from '@salesforce/schema/Store_Characteristics__c.Retail_Turnover_Prev_Year_of_Ref__c';
import ANNUAL_GROWTH_PREVIOUS_YEAR from '@salesforce/schema/Store_Characteristics__c.Annual_Growth_Prev_Year_of_Ref__c';
import mirgrateLastYearToPrev from '@salesforce/apex/tabActivationBusiProgStoreInfoController.migrateLastYearToPreYear';
import getStoredPictureAccountRec from '@salesforce/apex/tabActivationBusiProgStoreInfoController.getStoredPictures';
import getStoreCharId from '@salesforce/apex/tabActivationBusiProgStoreInfoController.getStoreId';
import label_viewall from '@salesforce/label/c.ViewAllRelatedList';
import label_new from '@salesforce/label/c.NewButtonRelatedList';
import label_storeCharacter from '@salesforce/label/c.StoreCharacteristic';
import label_storePerformance from '@salesforce/label/c.StorePerformance';
import label_storeRelatedPicture from '@salesforce/label/c.StoreRelatedPictures';
import label_mirgrateLastYear from '@salesforce/label/c.MigrateLastYeartoPrevious';
import label_mirgrateSucessfully from '@salesforce/label/c.MirgateSucessfully';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";


export default class TabActivationBusinessProgramStoreInfo extends  NavigationMixin(LightningElement) {
    @api receivedId;
    showLoading = false;
    objectapiname=STORE_CHAR_OBJ;
    recordId;
    refreshData;
    isLoadAfterUpdate=true;
    isviewMode='view';
    pictureCount;
    isShowDataTable=false;
    isShowViewAll=false;
    isShowpictureCount=false;
    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Related_List__e';
    @track pictureList;
    storeCharFields = [STORE_LOCATION,STORE_SIZE,EMPLOYEE,STORE_COMM_POSITIONING,NUMBER_OF_STORE_WINDOW,NUMBER_OF_POS,STATE_OF_SHOP,SALES_DESK,BLOCK_ADVERTISING_MAT];
    storePerformanceFields=[LAST_YEAR_REFERENCE,RETAIL_LAST_YEAR,ANNUAL_GROWTH_LAST_YEAR,PREVIOUS_YEAR_REFERENCE,RETAIL_PREVIOUS_YEAR,ANNUAL_GROWTH_PREVIOUS_YEAR];
    isShowNewButton=false;
    @track columns = [
        {   label: 'Created Date',
            fieldName: 'CreatedDate',
            type: 'text',
            sortable: true
        },
        {
            label: 'Description',
            fieldName: 'Description__c',
            type: 'text',
            sortable: true 
        },
        {
            label: 'Uploaded By',
            fieldName: 'CreatedByName',
            type: 'text',
            sortable: true
        },
        {
            label: 'Id',
            fieldName: 'picLink',
            type: 'url',
                typeAttributes: {label: {fieldName: 'Name'}, target:'_top'},
            sortable: true

        },
    ];
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        this.getStoreCharId();
        this.getStoredPictureAccountRec();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            let errorData = error;
			let triggerAlert = true;
			if(errorData.advice.reconnect === "handshake" || errorData.advice.reconnect === "none"){
				triggerAlert = false;
                setTimeout(() => {
                    this.handleSubscribe();
                }, 20000); // 20000 milliseconds = 20 seconds
			}
			if(triggerAlert){
                this.showToast('Error', 'error', JSON.stringify(errorData.error));
			}
        });
    }

    refreshList = event=> {
        const refreshRecordEvent = event.data.payload;
        //By checking if refreshRecordEvent.Parent_ID__c matches this.receivedId, the code ensures that only events related to the specific parent record currently being viewed or processed by the component are acted upon. This avoids unnecessary processing of events that are not relevant to the current context.
        if (refreshRecordEvent.Parent_ID__c === this.receivedId) {
            this.getStoredPictureAccountRec();
            this.getStoreCharId();
        }
    }
    handleSubscribe() {
        const messageCallback = (response) => {};    
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }

    handleStorePerformance(){
        this.isLoadAfterUpdate=false;
        this.handleIsLoading(true);
        mirgrateLastYearToPrev({recordID: this.receivedId})
        .then(response =>{
            //updateRecord({ fields: { Id: this.recordId }})
            this.handleRerender();
        })
        .catch(error =>{
            this.handleIsLoading(false);   
            this.showToast('Success', 'Success', error.body.message);

        })
    }   
    //show hide spinner
    handleIsLoading(showLoading){
        this.showLoading = showLoading;           
    }
    handleRerender(){
        setTimeout(() => {
            //eval("$A.get('e.force:refreshView').fire();");
            //this.dispatchEvent(new RefreshEvent());
            this.isLoadAfterUpdate = true; 
            this.showLoading = false;  
            this.showToast('Success', 'Success', 'Mirgate Sucessfully');
         
        },5000);

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
    getStoredPictureAccountRec() {
        getStoredPictureAccountRec({receivedId: this.receivedId})
            .then(data => {
            if(data){
                data = JSON.parse(JSON.stringify(data));
                this.pictureList = data;
                if(this.pictureList.length>0){
                    this.isShowViewAll = true;
                    this.handlePicCount(data);
                    this.pictureList.forEach(res=>{
                        res.picLink = '/' + res.Id;
                        res.CreatedByName=res.CreatedBy.Name;
						res.CreatedDate = this.formattedDate(res.CreatedDate);
                    });
                    this.pictureList = [...this.pictureList].splice(0,5);
                    this.isShowDataTable= true; 
                }
                else{
                    this.pictureCount='0';
                }
                }else{

                    this.isShowDataTable=false;
                    
                }
            });
        }  
		formattedDate(dateString) {
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            const originalDate = new Date(dateString);
            return originalDate.toLocaleDateString(undefined, options);
        }
        handlePicCount(data){
            let allPicData = data;
            if(allPicData.length > 5){
                this.pictureCount = '5+';
            }else{
                this.pictureCount = allPicData.length;
            }
        }
        getStoreCharId() {
            getStoreCharId({receivedId: this.receivedId})
                .then(data => {
                    if(data){
                        data = JSON.parse(JSON.stringify(data));
                        this.recordId = data;
                        this.isShowNewButton = false;
                        this.isviewMode='view';
                    }
                    else{
                        this.isShowNewButton = true;
                        this.isviewMode='readonly';
                    }
                });
        } 
        
        navigateToNewPicturePage() {
            const defaultValues = encodeDefaultFieldValues({
                Account__c : this.receivedId
             });
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Store_Related_Pictures__c',
                    actionName: 'new'
                },
                state: {
                    defaultFieldValues: defaultValues,
                    useRecordTypeCheck : 1,
                    navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
                }
            })
        }  
        navigateToNewCharPag(){
            const defaultValues = encodeDefaultFieldValues({
                Account__c : this.receivedId
             });
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Store_Characteristics__c',
                    actionName: 'new'
                },
                state: {
                    defaultFieldValues: defaultValues,
                    useRecordTypeCheck : 1,
                    navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
                }
            })   
        }
        navigateToRelatedList(){

            this[ NavigationMixin.GenerateUrl ]({
                type : 'standard__recordRelationshipPage',
                attributes : {
                    recordId : this.receivedId,
                    objectApiName : 'Account',
                    relationshipApiName : 'Store_Related_Pictures__r',
                    actionName : 'view'
                }
            }).then(url => {
                window.open(url, '_blank');
            });
        } 
        disconnectedCallback() {
            unsubscribe(this.subscription, () => {
            });   
        }  
    label = {label_viewall, 
            label_new, label_storeCharacter, 
            label_storePerformance, label_storeRelatedPicture, 
            label_mirgrateLastYear, label_mirgrateSucessfully};
}