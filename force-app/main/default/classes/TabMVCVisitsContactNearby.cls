/**
 * @Author : Surawat Sakulmontreechai
 * @Created Date : 2023-08-07
 * @Created by : Surawat Sakulmontreechai
 * @Email : surawat.sakulmontreechai@hoya.com
 * @version : v.1.0
 * @description :   this class support for task #712 in tab-contact nearby
 *                  (com-1040) to renderring for contact nearby
 */

public with sharing class TabMVCVisitsContactNearby {
    
    private static final string CON_OPT_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

    @AuraEnabled(cacheable=true)
    public static List<Contact> gettAllContacts(String ContactId, Double distance, String miyoSmartAttitude, String prescriptionPotential, String preferredMethod, String firstSpeciality,String PreferDayTime){
        try {

            Contact contact = [SELECT Id, Name, FirstName, LastName, MiyoSmart_Attitude__c, Last_contact_visit_date__c, Preferred_contact_method__c,
                                Account.Name, MailingStreet, MailingPostalCode, MailingCity, MailingState, MiyoSmart_Segmentation__c, 
                                MailingCountry, MailingLatitude, MailingLongitude, Account.Clinic_Name__c FROM Contact WHERE
                                Id=:ContactId];
            
            return TabMVCVisitsContactNearby.getContacts(contact, distance, miyoSmartAttitude, prescriptionPotential, preferredMethod, firstSpeciality,PreferDayTime);
            
        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Contact currentCont, Double distance, String miyoSmartAttitude, String prescriptionPotential, String preferredMethod, String firstSpeciality, String PreferDayTime){
        try {

            //System.debug('XXX current contact =>'+currentCont);
            //System.debug('XXX distance =>'+distance);
            //System.debug('XXX MiyoSmart Attitude =>'+miyoSmartAttitude);
            //System.debug('XXX Prescription Potential =>'+prescriptionPotential);
            //System.debug('XXX Preferred Contact =>'+preferredMethod);
            //System.debug('XXX First Speciality =>'+firstSpeciality);
            //System.debug('XXX Professional =>'+professional);
            //System.debug('XXX Preferred Day Time =>'+PreferDayTime);

            List<Contact> result = new List<Contact>();

            String miyoSmartClause = '';
            String prescriptionClause = '';
            String preferenceClasue = '';
            String firstSpecialityClause = '';
        //    String professionalClause = '';

            String aconMiyoSmartClause = '';
            String aconPrescriptionClause = '';
            String aconPreferencClause = '';
            String aconFirstSepcialityClause = '';
            //String aconProfessionalClause = '';

            String orderby1 = ' ORDER BY LastName ASC';
            String orderby2 = ' ORDER BY Contact.LastName ASC';

            Double Latitude = currentCont.MailingLatitude;
            Double Longitude = currentCont.MailingLongitude;
            if (Latitude == null) {
                Latitude = 0;
            }
            if (Longitude == null) {
                Longitude = 0;
            }

            result.add(currentCont);

            String query = 'SELECt Id, FirstName, LastName, Name, MiyoSmart_Attitude__c, Last_contact_visit_date__c, '
                            +'Preferred_contact_method__c, Account.Name, MailingStreet, MailingPostalCode, MailingCity, MailingState, '
                            +'MailingCountry, MailingLatitude, MailingLongitude, Account.Clinic_Name__c, MiyoSmart_Segmentation__c FROM Contact '
                            +'WHERE RecordTypeId=:CON_OPT_RT AND '
                            +'DISTANCE(MailingAddress, GEOLOCATION('+Latitude+', '+Longitude+'), \'km\')<'+distance;
            
            String aconQuery = 'SELECt Id, ContactId, Contact.FirstName, Contact.LastName, '
                                + 'Contact.Name, Contact.MiyoSmart_Attitude__c, Contact.Last_contact_visit_date__c, '
                                + 'Contact.Preferred_contact_method__c, Preferred_contact_day_time__c, Account.Name, Contact.MailingStreet, '
                                + 'Contact.MailingPostalCode, Contact.MailingCity, Contact.MailingState, '
                                + 'Contact.MailingCountry, Contact.MailingLatitude, Contact.MailingLongitude, Account.Clinic_Name__c, Contact.MiyoSmart_Segmentation__c '
                                + 'FROM AccountContactRelation WHERE Contact.RecordTypeId=:CON_OPT_RT AND Preferred_contact_day_time__c=\''+PreferDayTime+'\' AND '
                                + 'DISTANCE(Contact.MailingAddress, GEOLOCATION('+Latitude+', '+Longitude+'), \'km\')<'+distance;
            
            if(String.isNotBlank(miyoSmartAttitude) && String.isBlank(PreferDayTime)){
                miyoSmartClause = ' AND MiyoSmart_Attitude__c LIKE \'%'+miyoSmartAttitude+'%\'';
            }

            if(String.isNotBlank(prescriptionPotential) && String.isBlank(PreferDayTime)){
                prescriptionClause = ' and Prescription_Potential__c LIKE \'%'+prescriptionPotential+'%\'';
            }

            if(String.isNotBlank(preferredMethod) && String.isBlank(PreferDayTime)){
                preferenceClasue = ' and Preferred_contact_method__c LIKE \'%'+preferredMethod+'%\'';
            }

            if(String.isNotBlank(firstSpeciality) && String.isBlank(PreferDayTime)){
                firstSpecialityClause = ' and First_Speciality__c LIKE \'%'+firstSpeciality+'%\'';
            }

           /* if(String.isNotBlank(professional) && String.isBlank(PreferDayTime)){
                professionalClause = ' and Professional_Type__c LIKE \'%'+professional+'%\'';
            }*/


            if(String.isNotBlank(PreferDayTime) && String.isNotBlank(miyoSmartAttitude)){
                aconMiyoSmartClause = ' AND Contact.MiyoSmart_Attitude__c LIKE \'%'+miyoSmartAttitude+'%\'';
            }

            if(String.isNotBlank(PreferDayTime) && String.isNotBlank(prescriptionPotential)){
                aconPrescriptionClause = ' AND Contact.Prescription_Potential__c LIKE \'%'+ prescriptionPotential + '%\'';
            }

            if(String.isNotBlank(PreferDayTime) && String.isNotBlank(preferredMethod)){
                aconPreferencClause = ' AND Contact.Preferred_contact_method__c LIKE \'%' + preferredMethod + '%\'';
            }

            if(String.isNotBlank(PreferDayTime) && String.isNotBlank(firstSpeciality)){
                aconFirstSepcialityClause = ' AND Contact.First_Speciality__c LIKE \'%'+firstSpeciality+'%\'';
            }

           /* if(String.isNotBlank(PreferDayTime) && String.isNotBlank(professional)){
                aconProfessionalClause = ' AND Contact.Professional_Type__c LIKE \'%'+professional+'%\'';
            }*/

            query = query + miyoSmartClause + preferenceClasue + firstSpecialityClause + orderby1;
            //System.debug('XXX SOQL Contact =>'+query);

            aconQuery = aconQuery + aconMiyoSmartClause + aconPrescriptionClause + aconPreferencClause + aconFirstSepcialityClause + orderby2;
            //System.debug('XXX SOQL AccountContactRelateion =>'+aconQuery);

            List<Contact> conList = database.query(query);
            //System.debug('XXX SOQL Contact Size =>'+conList.size());

            List<AccountContactRelation> acList = database.query(aconQuery);
            //System.debug('XXX SOQL AcountContactRelation size =>'+acList.size());

            for(Contact c:conList){
                if(String.isBlank(PreferDayTime)){
                    if(c.Id != currentCont.Id){
                        result.add(c);
                        
                    }
                }else if(String.isNotBlank(PreferDayTime)){
                    for(AccountContactRelation acr : acList){
                        if((c.Id == acr.ContactId)){
                            result.add(c);
                        }
                    }
                }
            }

            //System.debug('XXX Get Contact Nearby List =>'+result.size()+':'+result);
            return result;

        } catch (Exception e) {
            //LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPickListMiyoSmartAttitude(){
        Schema.DescribeFieldResult fieldResult = Contact.MiyoSmart_Attitude__c.getDescribe();
        List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
        List<optionSet> dataset = new List<optionSet>();

        for(Schema.PicklistEntry picklistval : pEntry){
            String pListLabelName = picklistval.getLabel();
            String pListValue = picklistval.getValue();
            dataset.add(new optionSet(pListLabelName, pListValue));
        }

        return dataset;

    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistPrescriptionPotential(){
        Schema.DescribeFieldResult fieldResult = Contact.Prescription_Potential__c.getDescribe();
        List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
        List<optionSet> dataset = new List<optionSet>();

        for(Schema.PicklistEntry picklistval : pEntry){
            String pListLabelName = picklistval.getLabel();
            String pListValue = picklistval.getValue();
            dataset.add(new optionSet(pListLabelName, pListValue));
        }

        return dataset;

    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistPreferredContact(){
        Schema.DescribeFieldResult fieldResult = Contact.Preferred_contact_method__c.getDescribe();
        List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
        List<optionSet> dataset = new List<optionSet>();

        for(Schema.PicklistEntry picklistval : pEntry){
            String pListLabelName = picklistval.getLabel();
            String pListValue = picklistval.getValue();
            dataset.add(new optionSet(pListLabelName, pListValue));
        }

        return dataset;
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistFirstSpeciality(){
        Schema.DescribeFieldResult fieldResult = Contact.First_Speciality__c.getDescribe();
        List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
        List<optionSet> dataset = new List<optionSet>();

        for(Schema.PicklistEntry picklistval : pEntry){
            String pListLabelName = picklistval.getLabel();
            String pListValue = picklistval.getValue();
            dataset.add(new optionSet(pListLabelName, pListValue));
        }

        return dataset;
    }

   /* @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistProfessionalType(){
        Schema.DescribeFieldResult fieldResult = Contact.Professional_Type__c.getDescribe();
        List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
        List<optionSet> dataset = new List<optionSet>();

        for(Schema.PicklistEntry picklistval : pEntry){
            String pListLabelName = picklistval.getLabel();
            String pListValue = picklistval.getValue();
            dataset.add(new optionSet(pListLabelName, pListValue));
        }

        return dataset;
    }*/

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPreferredDayTime(){
        Schema.DescribeFieldResult fieldResult = AccountContactRelation.Preferred_contact_day_time__c.getDescribe();
        List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
        List<optionSet> dataset = new List<optionSet>();

        for(Schema.PicklistEntry picklistval : pEntry){
            String pListLabelName = picklistval.getLabel();
            String pListValue = picklistval.getValue();
            dataset.add(new optionSet(pListLabelName, pListValue));
        }
        return dataset;
    }

    public class optionSet{
        public optionSet(String label, String values){
            this.Label = label;
            this.values = values;
        }

        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String values{get;set;}
    }


}