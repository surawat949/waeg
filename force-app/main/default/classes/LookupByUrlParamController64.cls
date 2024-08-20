public class LookupByUrlParamController64 {

    public String customerName;
    public String phone;
    public String customerNumber;
    public String email;

    
    public LookupByUrlParamController64 () { }

    // Main method that takes the incoming parameters and first checks accounts, before checking contacts
    public string redirectToCustomer() {
        String customerUrl;
        
        
        Map<String,String> params = ApexPages.currentPage().getParameters();
        
        if(params.size() > 0) {
            customerName = params.get('customer_name');
            customerNumber = params.get('customer_number');
            phone = params.get('phone');   
            email =  params.get('email');
            
            //Call method to check for an account matching these parameters
            customerUrl = redirectToAccount();
        
            if ( customerUrl == 'null')
            {
                //No account match check for a contact
                customerUrl = redirectToContact();
            }
            
        }

        return customerUrl;
                   
    }   

    public string redirectToAccount(){
        String query;
        Account account;
        Boolean paramAdded = False;
        
        //assemble the database query based on the passed in parameters
        query = 'SELECT ID FROM Account WHERE ';// WHERE (ID is not null ';
        
        // Check the Customer Name
        if(customerName != null) {
          
            query += ' name like \'%' + customerName + '%\'';
            paramAdded = True;
            
        } 
         
        // Check the Account Number 
        if(customerNumber != null) {
         
            if(paramAdded)
            {
            	query += ' AND';
            }
            query += '  AccountNumber = \''+ customerNumber + '\'';
            paramAdded = True;
            
        }
        
        // Check the Phone field in original or US format 
        if (phone != null) {
            
            if (USFormatPhone(phone) != null)
            {
                if(paramAdded)
            	{
            		query += ' AND';
            	}
                query += ' (phone = \'' + phone  +'\''+
                                +' OR phone = \'' + USFormatPhone(phone) +'\''+                             
                                +') ';
                paramAdded = True;
            }
            else
            {
                if(paramAdded)
            	{
            		query += ' AND';
            	}
                query += ' (phone = \'' + phone + '\') ';
                paramAdded = True;
            }
        }
        
        // Run the compiled query if params added
        if (paramAdded) {
	        try {
	
    	       query += ' LIMIT 1';
        	   account = Database.query(query);
            	
        	} catch (System.queryException e) {//no entry found for lookup item, display empty account page
	            //system.debug(e.getMessage());
	            account = null;
	        }   
        }                             
        // Return the Account reference if a match is found. Otherwise return null   
        String accountUrl = 'null';
        
        if(account != null) {
            accountUrl = '/' + account.Id;
            
        }
        
        return accountUrl;
    }
        
    //Function to search for contacts matching the passed in parameters
    public string redirectToContact(){
        //Declare local variables
        String contactQuery;
        Contact contact = null;
        Boolean paramAdded = False;
        
        //assemble query based on parameters passed
        contactQuery = 'select ID from Contact WHERE';
        
                 
        // Check the Phone fields in original or US format 
        if (phone != null) {
            if (USFormatPhone(phone) != null)
            {
                if(paramAdded)
            	{
            		contactQuery += ' AND';
            	}
                contactQuery += ' (phone = \'' + phone +'\''+
                                +' OR phone = \'' + USFormatPhone(phone) +'\''+
                                +' OR MobilePhone = \'' + phone +'\''+
                                +' OR MobilePhone = \'' + USFormatPhone(phone) +'\''+
                                +' OR HomePhone = \'' + phone +'\''+
                                +' OR HomePhone = \'' + USFormatPhone(phone) +'\''+         
                                +' OR OtherPhone = \'' + phone    +'\''+                 
                                +' OR OtherPhone = \'' + USFormatPhone(phone) +'\''+                               
                                +') ';
                paramAdded = True;
            }
            else //the phone number could not be parsed into a US format so just the original format checked
            {
                if(paramAdded)
            	{
            		contactQuery += ' AND';
            	}
                contactQuery += ' (phone = \'' + phone +'\''+  
                                + ' OR MobilePhone = \'' + phone +'\''+  
                                + ' OR HomePhone = \'' + phone +'\''+  
                                + ' OR OtherPhone = \'' + phone +'\''+  
                                + ') ';
                paramAdded = True;
            }
        }

        // Check the email address           
        if (email != null) {
            if(paramAdded)
            {
            	contactQuery += ' AND';
            }
            contactQuery += ' Email = \'' + email + '\'';
            paramAdded = True;
        }

        //execute query if params added
        if (paramAdded)
        {
        	try
        	{
	
	            //Limit results to one record
	            contactQuery += ' LIMIT 1';
	           //execute the created SQL            
	           contact = Database.query(contactQuery);
	        
	        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
	            //system.debug(e.getMessage());
	            contact = null;
	        }   
        }
        
        // Return the Contact ID if found, otherwise return the handle to create a new contact.  
        String contactUrl;
        if(contact != null) {

            contactUrl = '/' + contact.Id;
                      
        } 
        else {
            
            contactUrl = '/003/e';
        }
        
        return contactUrl;
        
    }

    public string USFormatPhone(String lphone) {
        //This function is used to parse the phone number passed and format into the US phone format for searching
        
        //Declare variables
        String npa;
        String nnx;
        String extension;
        String rphone;
        
        //  Added logic for NA mobile phone numbers
        if (lphone.length() == 10) {
            npa = lphone.substring(0,3);
            nnx = lphone.substring(3,6);
            extension = lphone.substring(6,10);
            rphone = '(' + npa + ') ' + nnx + '-' + extension;
        }

        //return the parsed phone number to the search function
        return rphone;
    }
}