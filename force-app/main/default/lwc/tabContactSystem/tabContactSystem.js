import { LightningElement ,api} from 'lwc';
//Custom Labels
import system_information from '@salesforce/label/c.tabAccSystemInfo';
import createdBy from '@salesforce/label/c.Created_By';
import lastModifiedBy from '@salesforce/label/c.Last_Modified_By';
import contactOwner from '@salesforce/label/c.Contact_Owner';
//Object
import Contact_obj from '@salesforce/schema/Contact';
//Fields
import CreatedDate from '@salesforce/schema/Contact.CreatedDate';
import CreatedBy from '@salesforce/schema/Contact.CreatedById';
import LastModifiedDate from '@salesforce/schema/Contact.LastModifiedDate';
import LastModifiedBy from '@salesforce/schema/Contact.LastModifiedById';
import HoyaAccId from  '@salesforce/schema/Contact.Hoya_Account_Id__c';
import Owner from '@salesforce/schema/Contact.OwnerId';
import brand from  '@salesforce/schema/Contact.Account_Brand__c';
import OwnerCompany from '@salesforce/schema/Contact.Contact_Owner_Company__c';


export default class TabContactSystem extends LightningElement {
    @api receivedId;
    Contact_Obj=Contact_obj;
    custLabel = {   
        system_information,createdBy,lastModifiedBy,contactOwner
    }
    createdBy = [CreatedBy];
    createdDate = [CreatedDate];
    lastModifiedBy = [LastModifiedBy];
    lastModifiedDate = [LastModifiedDate];
    hoyaAccId = [HoyaAccId];
    owner = [Owner];
    brand = [brand];
    ownerCompany = [OwnerCompany];
}