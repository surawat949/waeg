// HOYA. Pim Uijttewaal 9-2-2015
// to convert for TravelRequests to autoshare records
// https://developer.salesforce.com/page/Using_Apex_Managed_Sharing_to_Create_Custom_Record_Sharing_Logic

    trigger Travel_Request_Share_With_Manager on Travel_Request__c (after insert) {

    // We only execute the trigger after a Travel Request record has been inserted 
    // because we need the Id of the Travel Request record to already exist.
    //if(trigger.isInsert){
     
    // Travel Request__Share is the "Share" table that was created when the
    // Organization Wide Default sharing setting was set to "Private".
    // Allocate storage for a list of Travel Request__Share records.
    //List<Travel_Request__Share> trShares  = new List<Travel_Request__Share>();

    // For each of the Travel Request records being inserted, do the following:
     //for(Travel_Request__c tr : trigger.new){

        // Create a new Travel Request__Share record to be inserted in to the Travel Request_Share table.
        //Travel_Request__Share ManagerShare = new Travel_Request__Share();
            
        // Populate the Travel Request__Share record with the ID of the record to be shared.
        //ManagerShare.ParentId = tr.Id;
            
        // Then, set the ID of user or group being granted access. In this case,
        // we’re setting the Id of the Hiring Manager that was specified by 
        // the Recruiter in the Manager_Record_Owner__c lookup field on the Travel Request record.  
        // (See Image 1 to review the Travel Request object's schema.)
       // ManagerShare.UserOrGroupId = tr.Manager_Record_Owner__c;
            
        // Specify that the Hiring Manager should have edit access for 
        // this particular Travel Request record.
       // ManagerShare.AccessLevel = 'edit';
            
        // Specify that the reason the Hiring Manager can edit the record is 
        // because he’s the Hiring Manager.
        // (sharewithmanager__c is the Apex Sharing Reason that we defined earlier.)
      //  ManagerShare.RowCause = Schema.Travel_Request__Share.RowCause.sharewithmanager__c;
            
        // Add the new Share record to the list of new Share records.
       // trShares.add(ManagerShare);
    //}
        
    // Insert all of the newly created Share records and capture save result 
   // Database.SaveResult[] trShareInsertResult = Database.insert(trShares,false);
        
    // Error handling code omitted for readability.
    //}
}