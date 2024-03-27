import { LightningElement ,api} from 'lwc';
import Contact_obj from '@salesforce/schema/Contact';
import AccountCatalog from '@salesforce/schema/Contact.Account_Catalogue_name__c';
//Custom Labels
import RegHoyaILog from '@salesforce/label/c.Registration_HoyaiLog';

export default class TabContactActivationOrderingSystem extends LightningElement {
    @api receivedId;
    accountCatalog = [AccountCatalog];
    Contact_Obj = Contact_obj;
    custLabel={RegHoyaILog};
}