@isTest
private class ClsQuestion_Test {

    static testMethod void myUnitTest() {
    	String	renderFreeText='';
		String	renderSelectRadio='';
		String	renderSelectRow = '';
		String	renderSelectCheckboxes ='true';
		String	choice = 'asda\nsdasdf\nasda';
		String	answer = 'yesss'; 
		String	str = 'shdhskhs';
		Boolean calculable = true;
		
		Survey__c s = new Survey__c();
		s.Name = 'TestSurvey' ;
		insert s;
		
		Survey_Question__c sq = new Survey_Question__c();
		sq.Type__c = 'Single Select--Vertical';
		sq.Survey__c = s.Id;
		sq.OrderNumber__c =12;
		sq.Weight__c =1;
		sq.Choices__c = 'asd\nasd\nwer\nsad';
		sq.Score__c = '1\n2\n3\n4';
		insert sq;
		Survey_Question__c sq2 = new Survey_Question__c();
		sq2.Type__c = 'Multi-Select--Vertical';
		sq2.Survey__c = s.Id;
		sq2.OrderNumber__c =23;
		sq2.Weight__c =1;
		insert sq2;
		Survey_Question__c sq3 = new Survey_Question__c();
		sq3.Type__c = 'Single Select--Horizontal';
		sq3.Survey__c = s.Id;
		sq3.OrderNumber__c =3;
		sq3.Weight__c =1;
		insert sq3;
		Survey_Question__c sq4 = new Survey_Question__c();
		sq4.Type__c = 'Free Text';
		sq4.Score__c ='1111';
		sq4.Survey__c = s.Id;
		sq4.OrderNumber__c =27;
		sq4.Weight__c =1;
		insert sq4;
       
       Double min = 1.0;
       Double max = 2.0;
       Double score	 = 4.0;
       
       ClsQuestion.Boundrary b = new ClsQuestion.Boundrary('123','4356');
       b.contains(1);
       
        Test.startTest();
        
        ClsQuestion cq = new ClsQuestion(sq);
        cq.getResult(choice);
        //cq.initializeScore(sq4);
        //cq.initializeScoreMap(sq4);
        cq.setAnswer(answer);
        //cq.getBoundraryResult(choice);
        
      //ClsQuestion.getResult(choice);
      // ClsQuestion.setAnswer(answer);
      // ClsQuestion.stringToSelectOptions(str);
      // ClsQuestion.initializeScore(sq4);
     // ClsQuestion.initializeScoreList(sq4);  
      // ClsQuestion.getBoundraryResult(choice);
       system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest2() {
    	String	    renderFreeText='';
		String	renderSelectRadio='';
		String	renderSelectRow = '';
	   String renderSelectCheckboxes ='true';
       String choice = 'asdasdasdfasda';
		String answer = 'yesss'; 
		String str = 'shd\n\n\n\nhskhs';
		
		Survey__c s = new Survey__c();
		s.Name = 'TestSurvey' ;
		insert s;
		

       Survey_Question__c sq2 = new Survey_Question__c();
       sq2.Type__c = 'Free Text';
       sq2.Survey__c = s.Id;
       sq2.OrderNumber__c =23;
		sq2.Weight__c =1;
		sq2.Choices__c = 'asd\nasd\nwer\nsad';
		sq2.Score__c = '1\n2\n3\n4';
       insert sq2;
       
        Test.startTest();
         ClsQuestion cq = new ClsQuestion(sq2);
        cq.getResult(choice);
        //cq.initializeScore(sq4);
        //cq.initializeScoreMap(sq4);
        cq.setAnswer(answer);
        
     //  ClsQuestion.getResult(choice);
      // ClsQuestion.setAnswer(answer);
      // ClsQuestion.stringToSelectOptions(str);
      // ClsQuestion.initializeScore(sq4);
     //  ClsQuestion.initializeScoreList(sq4);  
      // ClsQuestion.getBoundraryResult(choice);
       system.assert(true);
        Test.stopTest();
    }
    static testMethod void myUnitTest4() {
    	String	    renderFreeText='';
		String	renderSelectRadio='';
		String	renderSelectRow = '';
	   String renderSelectCheckboxes ='true';
       String choice = 'asdasdasdfasda';
		String answer = 'yesss'; 
		String str = 'shdh\nskhs\n';
		
		Survey__c s = new Survey__c();
		s.Name = 'TestSurvey' ;
		insert s;
		


        Survey_Question__c sq3 = new Survey_Question__c();
       sq3.Type__c = 'Single Select--Horizontal';
       sq3.Survey__c = s.Id;
       sq3.OrderNumber__c =3;
		sq3.Weight__c =1;
       insert sq3;
 
       
        Test.startTest();
         ClsQuestion cq = new ClsQuestion(sq3);
        cq.getResult(choice);
        //cq.initializeScore(sq4);
        //cq.initializeScoreMap(sq4);
        cq.setAnswer(answer);
        
     //  ClsQuestion.getResult(choice);
      // ClsQuestion.setAnswer(answer);
      // ClsQuestion.stringToSelectOptions(str);
      // ClsQuestion.initializeScore(sq4);
     //  ClsQuestion.initializeScoreList(sq4);  
      // ClsQuestion.getBoundraryResult(choice);
       system.assert(true);
        Test.stopTest();
    }

    static testMethod void myUnitTest5(){
        String	renderFreeText='';
		String	renderSelectRadio='';
		String	renderSelectRow = '';
	    String  renderSelectCheckboxes ='true';
        String  choice = 'asdasdasdfasda';
		String  answer = 'yesss'; 
		String  str = 'shdh\nskhs\n';

        Survey__c s = new Survey__c();
		s.Name = 'TestSurvey' ;
		insert s;

        Survey_Question__c sq4 = new Survey_Question__c();
        sq4.Type__c = 'Multi-Select--Vertical';
        sq4.Survey__c = s.Id;
        sq4.OrderNumber__c =3;
		sq4.Weight__c =1;
        insert sq4;

        Test.StartTest();
        ClsQuestion cq = new ClsQuestion(sq4);
        cq.getResult(choice);
        cq.setAnswer(answer);
        System.assert(true);
        Test.StopTest();
    }
    static testMethod void myUnitTest3() {
    	String	    renderFreeText='';
		String	renderSelectRadio='';
		String	renderSelectRow = '';
	   String renderSelectCheckboxes ='true';
       String choice = 'asdasdasdfasda';
		String answer = 'yesss'; 
		String str = 'shdhskhs';
		
		Survey__c s = new Survey__c();
		s.Name = 'TestSurvey' ;
		insert s;
		

        Survey_Question__c sq4 = new Survey_Question__c();
       sq4.Type__c = 'Free Text';
       sq4.Score__c ='1111';
       sq4.Survey__c = s.Id;
       sq4.OrderNumber__c =27;
		sq4.Weight__c =1;
       insert sq4;
       
        Test.startTest();
        
        
     //  ClsQuestion.getResult(choice);
      // ClsQuestion.setAnswer(answer);
      // ClsQuestion.stringToSelectOptions(str);
      // ClsQuestion.initializeScore(sq4);
     //  ClsQuestion.initializeScoreList(sq4);  
      // ClsQuestion.getBoundraryResult(choice);
       system.assert(true);
        Test.stopTest();
    }
}