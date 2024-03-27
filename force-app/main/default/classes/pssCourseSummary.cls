public with sharing class pssCourseSummary{          
    
    public final Account acct;
   
    public integer count =0;
    public integer countContact {get; set;}
    public integer countCompleteCourse {get; set;}
    public integer countCohortCourses {get; set;}
    public Double AvgCourseCompleted {get; set;}
    public integer countContactWhoCompletedCourse {get; set;}
    AggregateResult[] cohortCompletedCourses {get; set;}
    Set<ID> Contactids = new Set<ID>();
    public List <Contact> contactList = new List <Contact> ();
    //public List <pss_Course_Enrollment__c> mapStrByLstzips = new List <pss_Course_Enrollment__c> ();
    
    Map <Id,integer> ContactMap = new Map <Id,integer>();
   
     
    public List <pss_Course_Enrollment__c> enrollmentList = new List <pss_Course_Enrollment__c> ();

    public pssCourseSummary(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        countCompleteCourse =0;
        countContactWhoCompletedCourse =0;
        countContact=0;
       
        getNumberofCoursesperUser(); 
    }
    
    
    public PageReference getNumberofCoursesperUser() {
   
    contactList = [select id,Name from Contact where AccountId =: acct.id];
     ////CONTACT COUNT ////
    countContact = [SELECT COUNT()    FROM Contact WHERE AccountId != NULL and  AccountId =: acct.id];
    for(Contact c: contactList)
    {
         Contactids.add(c.id);
        
    }
    
     ////COURSE COMPLETED CONTACT COUNT ///
    countCompleteCourse = [SELECT  COUNT()  FROM pss_Course_Enrollment__c WHERE Is_Completed__c = true and  Contact__c != NULL and  Contact__c IN :Contactids ];
    //list<AggregateResult> 
    cohortCompletedCourses = [SELECT Contact__r.Name cid,  COUNT(Contact__c)CountasperContact  FROM pss_Course_Enrollment__c WHERE Is_Completed__c = true and  Contact__c != NULL and  Contact__c IN :Contactids group by Contact__r.Name];
    countContactWhoCompletedCourse = cohortCompletedCourses.size();
    
    
    
    ////COHORT All COURSE COUNT ////
    List<pss_Course_Enrollment__c> lstzips= [select id,Contact__c, Course__c from pss_Course_Enrollment__c where Contact__c != NULL and  Contact__c IN :Contactids];
    Map<String,pss_Course_Enrollment__c> mapStrByzip = new Map<String,pss_Course_Enrollment__c>();
    for(pss_Course_Enrollment__c zipone:lstzips){
        
        mapStrByzip.put(zipone.Course__c,zipone);//This is map and hence it will always have unique values 
    }
    countCohortCourses = mapStrByzip.size();
    
    ////COHORT All COURSE COUNT ////
    
    /// Debugs ///
    system.debug('countCohortCourses '+countCohortCourses);
    system.debug('countCompleteCourse COUNT CONTACT '+countContactWhoCompletedCourse);
    system.debug('countContact '+countContact);
    system.debug('total Completed courses  ALL USERS'+countCompleteCourse);
    
    ////AVERAGE COURSE COMPLETION COUNT ////
    if(countContactWhoCompletedCourse >0)
    {
       // AvgCourseCompleted = Double.valueOf(countCompleteCourse)/countContact; 
       AvgCourseCompleted = Double.valueOf(countCompleteCourse)/countContactWhoCompletedCourse;
    }
    else
    {
        AvgCourseCompleted=0;
    }
    system.debug('AvgCourseCompleted'+AvgCourseCompleted);  
     
    
    return null;

    }
    
  
    
    public AggregateResult[] results {
        get {
            return [SELECT Course__r.Name Id, COUNT(id) ContactCourse , Course__r.Name  FROM pss_Course_Enrollment__c WHERE Is_Completed__c = true and  Contact__c != NULL and  Contact__c IN : Contactids GROUP BY Course__r.Name  ORDER BY  COUNT(id) DESC];
        }
    }
    
    
}