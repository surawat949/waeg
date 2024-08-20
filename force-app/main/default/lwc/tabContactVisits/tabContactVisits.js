import { LightningElement ,api} from 'lwc';
//Custom Labels
import contactFollowUp from '@salesforce/label/c.Contact_FollowUp';
//Object
import Contact_obj from '@salesforce/schema/Contact';
//fileds
import visitDate from '@salesforce/schema/Contact.Last_contact_visit_date__c';
import digitalVisits from '@salesforce/schema/Contact.Contact_Visits_Performed__c';
import directVisits from '@salesforce/schema/Contact.Contact_Digital_Visits_Performed__c';
import totalVisits from '@salesforce/schema/Contact.Contact_Total_Visits_Performed__c';
export default class TabContactVisits extends LightningElement {
 @api recordId;
 Contact_Obj = Contact_obj;
 fields=[visitDate];
 fields2 = [totalVisits, digitalVisits, directVisits]
 custLabel={contactFollowUp}
}