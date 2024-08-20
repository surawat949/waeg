import { LightningElement,api } from 'lwc';
//Fields
import Contact_obj from '@salesforce/schema/Contact';
import Name from '@salesforce/schema/Contact.Name';
import ReportsTo from '@salesforce/schema/Contact.ReportsToId';
import RecordType from '@salesforce/schema/Contact.RecordTypeId';
import Influence from  '@salesforce/schema/Contact.Influence__c';
import Education from '@salesforce/schema/Contact.Education__c';
import DecisionPower from  '@salesforce/schema/Contact.Decision_Power__c';
import Notes from '@salesforce/schema/Contact.Additional_Notes_on_Contact__c';
import Phone from '@salesforce/schema/Contact.Phone';
import ContactMethod from  '@salesforce/schema/Contact.Preferred_contact_method__c';
import DoNotVisit from  '@salesforce/schema/Contact.Do_not_visit__c';
import Mobile from '@salesforce/schema/Contact.MobilePhone';
import ContactDayTime from  '@salesforce/schema/Contact.Preferred_contact_day_time__c';
import DoNotCall from  '@salesforce/schema/Contact.DoNotCall';
import Fax from '@salesforce/schema/Contact.Fax';
import AppointmentOnly from  '@salesforce/schema/Contact.By_appointment_only__c';
import FaxOpt from  '@salesforce/schema/Contact.HasOptedOutOfFax';
import Email from '@salesforce/schema/Contact.Email';
import EmailOpt from  '@salesforce/schema/Contact.HasOptedOutOfEmail';
import Title from  '@salesforce/schema/Contact.Title';
//import SMSopt from  '@salesforce/schema/Contact.tdc_tsw__SMS_Opt_out__c';
//Custom Labels
import Communication from '@salesforce/label/c.SFDC_V2_MVC_Contact_Details_Comm';

export default class TabContactDetails extends LightningElement {
    @api receivedId;
    Contact_Obj=Contact_obj;
    name = [Name];
    reportsTo =[ReportsTo];
    recordType=[RecordType];
    influence=[Influence];
    education = [Education];
    decisionPower = [DecisionPower];
    notes = [Notes];
    phone=[Phone];
    doNotVisit =[DoNotVisit];
    doNotCall =[DoNotCall];
    faxOpt = [FaxOpt];
    contactMethod=[ContactMethod];
    mobile=[Mobile];
    contactDayTime=[ContactDayTime];
    fax=[Fax];
    appointmentOnly=[AppointmentOnly];
    email = [Email];
    emailOpt =[EmailOpt];
   // smsOpt = [SMSopt];
    custLabel={Communication};
    title=[Title];
}