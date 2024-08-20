global class serviceFlow_SendEmailUtility { 
       
    global static Map < String, List < String >> getDefaultManagers()
    {
        Map < String, List < String >> defaultManagersMap = new Map < String, List < String >> ();
        for (serviceFlow_DefaultManagersEmails__mdt sdm : serviceFlow_DefaultManagersEmails__mdt.getAll().values())
        {
            defaultManagersMap.put(sdm.Label, sdm.Default_Emails__c.split(';'));
        }
        return defaultManagersMap;
    }
    global static void sendEmailToManagers(List < String > managerEmailList, String csvString)
    {
        Blob csvBlob = blob.valueOf(csvString);
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        csvAttachment.setFileName(System.Label.serviceFlow_DeleteFileName);
        csvAttachment.setBody(csvBlob);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(System.Label.serviceFlow_DeletedReportSubject);
        email.setToAddresses(managerEmailList);
        email.setHtmlBody(System.Label.serviceFlow_DeletedActivitiesContent);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]
        {
            csvAttachment
        });
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]
        {
            email
        });
    }
    global static Map < String, List < String >> getManagerEmailsBasedOnCountry(Set < String > countrySet)
    {
        Map < String, List < String >> mapOfCountryUsersEmails = new Map < String, List < String >> ();
        for (User newUser: [Select Id,UserName,ManagerId,Manager.Name,Manager.Email,Country_for_Customer_Support__c FROM User 
                               Where IsActive = true AND ManagerId != null AND Country_for_Customer_Support__c != null AND Country_for_Customer_Support__c IN: countrySet Order By Country_for_Customer_Support__c ASC])
        {
            if (mapOfCountryUsersEmails.containsKey(newUser.Country_for_Customer_Support__c))
            {
                List < String > userEmails = mapOfCountryUsersEmails.get(newUser.Country_for_Customer_Support__c);
                userEmails.add(newUser.Manager.Email);
                mapOfCountryUsersEmails.put(newUser.Country_for_Customer_Support__c, userEmails);
            }
            else
            {
                mapOfCountryUsersEmails.put(newUser.Country_for_Customer_Support__c, new List < String >
                {
                    newUser.Manager.Email
                });
            }
        }
        return mapOfCountryUsersEmails;
    }
    global static void finish(Map < String, List < serviceFlow_Activities_Tracking__c >> mapOfCountriesListOfActivities)
    {
        String csvString = 'Id ' + ',' + 'Name' + ',' + 'Assigned To Name' + ',' + 'Subject' + ',' + 'Sub Subject' + ',' + 'Hoya Reference Number' + ',' + 'ECP Patient Order Number' + ',' + 'Hoya Account ID' + ',' + 'Account Name' + ',' + 'Created Date' + ',' + 'Task Subtype' + ',' + 'Origin \n';
        if (mapOfCountriesListOfActivities.size() > 0)
        {
            Map < String, List < String >> mapOfCountryUsersEmails = getManagerEmailsBasedOnCountry(mapOfCountriesListOfActivities.keySet());
            Map < String, List < String >> defaultManagersMap = getDefaultManagers();
            for (String countryName: mapOfCountriesListOfActivities.keySet())
            {

                List < String > managerEmailList = (mapOfCountryUsersEmails.containsKey(countryName) && mapOfCountryUsersEmails.get(countryName).size() > 0) ? mapOfCountryUsersEmails.get(countryName) : defaultManagersMap.get(countryName);
                List < serviceFlow_Activities_Tracking__c > listOfActivities = (mapOfCountriesListOfActivities.containsKey(countryName)) ? mapOfCountriesListOfActivities.get(countryName) : new List < serviceFlow_Activities_Tracking__c > ();
                if (listOfActivities.size() > 0)
                {
                    for (serviceFlow_Activities_Tracking__c s: listOfActivities)
                    {
                        csvString += s.Id + ',' + emptyCheck(s.Name) + ',' + emptyCheck(s.Assigned_To__r.name) + ',' + emptyCheck(s.Subject__c) + ',' + emptyCheck(s.Sub_Subject__c) + ',' + emptyCheck(s.Hoya_reference_number__c) + ',' + emptyCheck(s.ECP_patient_order_number__c) + ',' + emptyCheck(s.Hoya_Account_ID__c) + ',' + emptyCheck(s.Related_To_Account__r.Name) + ',' + s.Created_Date__c + ',' + s.Task_Subtype__c + ',' + s.Origin__c + '\n';
                    }
                }
                if (managerEmailList.size() > 0)
                {
                    serviceFlow_SendEmailUtility.sendEmailToManagers(managerEmailList, csvString);
                }
            }
        }
    }
    global static string emptyCheck(String fieldValue)
    {
        return String.isNotBlank(fieldValue) ? fieldValue : '';
    }
}