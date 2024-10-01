import { LightningElement, api ,wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
//Fields
import MyopiaPrescriptions from '@salesforce/schema/Contact.Myopia_Control_Prescriptions_Per_Week__c'; 
import MyopicChildPatients from '@salesforce/schema/Contact.Myopic_Child_Patients_Per_Week__c'; 
import MiyosmartPrescriptions from '@salesforce/schema/Contact.MiyoSmart_Prescriptions_Per_Week__c'; 
import MyopiaTreatment from '@salesforce/schema/Contact.Myopia_Control_Favorite_Treatment__c'; 
import MyopiaFirstCompetitor from '@salesforce/schema/Contact.Myopia_Control_1st_Lens_Competitor__c'; 
import MiyoSOWVsMyopiaPrescriptions from '@salesforce/schema/Contact.Miyo_SOW_Vs_M_C_Prescriptions__c';
import MiyosmartAttitude from '@salesforce/schema/Contact.MiyoSmart_Attitude__c';
import MiyoSmartSegmentation from '@salesforce/schema/Contact.MiyoSmart_Segmentation__c';
//labels
import MiyosmartPotential from '@salesforce/label/c.tabContactMiyosmartPotential';
import MiyomsmartReferringOpts from '@salesforce/label/c.tabContactMiyosmartRefOpticians';
import MiyosmartSales from '@salesforce/label/c.tabContactMiyosmartSales';
import MiyoSmartRelatedList from '@salesforce/label/c.tabActivationMiyoSmartRelatedList';
import Brand from '@salesforce/label/c.AccountBrand';
import Account from '@salesforce/label/c.AccountName';
import ShopStreet from '@salesforce/label/c.ShopStreet';
import PostalCode from '@salesforce/label/c.PostalCode';
import ShopCity from '@salesforce/label/c.ShopCity';
import MiyoQtyLast12Mo from '@salesforce/label/c.MiyoSmartQtyLast12Mo';
import MiyoQtyLastMo from '@salesforce/label/c.MiyoSmartQtyLastMo';
import OrderMiyoSmartName from '@salesforce/label/c.OrderMiyoSmartName';
import OrderDate from '@salesforce/label/c.OrderDate';
import Quantity from '@salesforce/label/c.Quantity';
import ReceiveNumber from '@salesforce/label/c.ReceiveNumber';
import NewButton from '@salesforce/label/c.NewButtonRelatedList';
import ViewAll from '@salesforce/label/c.ViewAllRelatedList';
import IsMiyoSmartTrainingCompleted from '@salesforce/label/c.MiyoSmartTrainingComplete';
import LastMiyoSmartTrainingDate from '@salesforce/label/c.LastMiyoSmartDate';

//object
import Contact_obj from '@salesforce/schema/Contact';
//Apex
import getLastTrainingDate from '@salesforce/apex/TabMVCActivationController.getLastTrainingDate';
import getOrderMiyoRelatedList from '@salesforce/apex/TabMVCActivationController.getOrdersMiyoSmartRelatedList';
import getRefOptsList from '@salesforce/apex/TabMVCActivationController.getRefferingOptsLst';
import { subscribe, MessageContext } from 'lightning/messageService';
import UPDATE_DATA_CHANNEL from '@salesforce/messageChannel/refreshContact__c';
export default class TabMVCActivationMiyosmart extends NavigationMixin(LightningElement){ 
    @api receivedId;
    isLoading = true;
    LastTraningDate;
    ObjectApiName = Contact_obj;
    columns;
    RefOptsColumns;
    data;
    subscription =null;
    isRefOptDataExist =false;
    isDataExist = false;
    messageData;
    orderMiyoSmartRelatedList;
    recCount = 0;
    PotentialFields = [MyopicChildPatients,MyopiaPrescriptions,MiyosmartPrescriptions,MiyoSmartSegmentation,MyopiaFirstCompetitor,MiyoSOWVsMyopiaPrescriptions];
    MyopiaTreatment = [MyopiaTreatment];
    MiyoSmartAttitude = [MiyosmartAttitude];
    custLabel = {
        MiyosmartPotential,
        MiyomsmartReferringOpts,
        MiyosmartSales,
        MiyoSmartRelatedList,NewButton,ViewAll,IsMiyoSmartTrainingCompleted,LastMiyoSmartTrainingDate
    }
    isTrainingComplete;
    constructor() {
        super();
        // passed parameters are not yet received here
    }     
    createNewOrderMiyoSmart(event){
        this.navigateToNewPage('Order_MiyoSmart__c');
    }
    @wire(MessageContext)
    messageContext;
    SubscribeToMessageChannel(){
        this.subscription = subscribe(
            this.messageContext,UPDATE_DATA_CHANNEL,
            (message) => this.handleMessage(message)
        );
       }
    
       handleMessage(message){
        alert("message.recordId "+JSON.stringify(message));
        this.messageData = message.data;
       
        }
    navigateToNewPage(objectName){
        const defaultValues = encodeDefaultFieldValues({
            Contact__c : this.receivedId
        }); 
        this[ NavigationMixin.Navigate]({
             type : 'standard__objectPage',
             attributes : {
                 objectApiName : objectName,
                 actionName : 'new'
             },
             state: {
                 defaultFieldValues: defaultValues,
                 useRecordTypeCheck : 1,
                 navigationLocation: 'RELATED_LIST'  //to avoid prevention of moving to newly created record
             }
        });
    }
    columns = [
        {label: OrderMiyoSmartName, fieldName: 'OrderMiyoSmartLink', type: 'url', typeAttributes: {label:{fieldName: 'Name'}, target:'_top'}},
        {label: Account, fieldName: 'AccountIdLink', type: 'url', typeAttributes: {label:{fieldName: 'Account'}, target:'_top'}},
        {label: OrderDate, fieldName: 'Order_Date__c', type: 'date', typeAttributes: { day: "numeric",month: "numeric",year: "numeric"}},
        {label: Quantity, fieldName: 'Quantity__c', type: 'text'},
        {label: ReceiveNumber, fieldName: 'receive_number__c', type: 'text'}
    ];
    RefOptsColumns = [
        {label: Brand, fieldName: 'Brand', type: 'text'},
        {label: Account, fieldName: 'AccountId', type: 'url', typeAttributes: {label:{fieldName: 'AccountName'}, target:'_top'}},
        {label: ShopStreet, fieldName: 'ShopStreet', type: 'text'},
        {label: PostalCode, fieldName: 'PostalCode', type: 'text'},
        {label: ShopCity, fieldName: 'City', type: 'text'},
        {label: MiyoQtyLast12Mo, fieldName: 'MiyoQtyL12Mo', type: 'numeric'},
        {label: MiyoQtyLastMo, fieldName: 'MiyoQtylastMo', type: 'numeric'}
    ];
    getTableData() {
        console.log('>>>data');
        this.isDataExists = false;
        getRefOptsList({contactId: this.receivedId,isMiyoSmart : true}).then((result) => {  
        if(result){
            this.isLoading = false;
            this.data = JSON.parse(JSON.stringify(result));
            if( this.data.length > 0)
                this.isRefOptDataExist = true;
            this.data.forEach(res=>{
                res.Brand = res.brand;
                res.AccountId = '/' + res.accountId;
                res.AccountName = res.accountName;
                res.ShopStreet = res.shopStreet;
                res.PostalCode = res.postalCode;
                res.City = res.shopCity;
                res.MiyoQtyL12Mo = res.miyo12MoQty;
                res.MiyoQtylastMo = res.miyoLastMoQty;
            });
            this.error = undefined;
        } 		
        }).catch((error) => {
            this.error = error;
            this.data = undefined;
        });
    }
    connectedCallback() {
        console.log('>>>tester');
	    this.getTableData();
        this.SubscribeToMessageChannel();
        getLastTrainingDate({contactId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            this.LastTraningDate = response;
            if(this.LastTraningDate != null && this.LastTraningDate != undefined && this.LastTraningDate !='') 
                this.isTrainingComplete = true;
            else
                this.isTrainingComplete = false;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })
        getOrderMiyoRelatedList({contactId : this.receivedId})
        .then(response => {
            response = JSON.parse(JSON.stringify(response)); 
            response.forEach(res=>{  
                res.OrderMiyoSmartLink = '/' + res.Id;
                res.Account = res.Account__r.Name;
                res.AccountIdLink = '/' + res.Account__c;
            });          
            let relatedLst = response;
            this.orderMiyoSmartRelatedList = (relatedLst.length <= 5) ? [...relatedLst] : [...relatedLst].splice(0,5);
            
            if(relatedLst.length>5){
                this.recCount='5+';
            }
            else{
                this.recCount=relatedLst.length;
            }
            if(this.recCount > 0)
                this.isDataExist =true;
        })
        .catch(error => {
            this.showToast('Error', 'Error', error.message);
        })

    }
    navigateToRelatedList(){
        this[ NavigationMixin.GenerateUrl ]({
            type : 'standard__recordRelationshipPage',
            attributes : {
                recordId : this.receivedId,
                objectApiName : 'Contact',
                relationshipApiName : 'Orders_MiyoSmart__r',
                actionName : 'view'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
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