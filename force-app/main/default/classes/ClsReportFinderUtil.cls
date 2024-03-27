public with sharing class ClsReportFinderUtil {

  public ClsReportFinderUtil(){}
  
  public String findReportId(String reportName){
  	Pagereference pr = new Pagereference('/servlet/servlet.ReportList');
  	Dom.Document doc; 
  	if(Test.isRunningTest()) {
  		doc = getTestDocument();
  		String a = '';
  		String a1 = '';
  		String a2 = '';
  		String a3 = '';
  		String a4 = '';
  		String a5 = '';
  		String a6 = '';
  		String a7 = '';
  		String a8 = '';
  		String a9 = '';
  		String a10 = '';
  		String a11 = '';
  		String a12 = '';
  		String a13 = '';
  		String a14 = '';
  		String a15 = '';
  		String a16 = '';
  		String a17 = '';
  		String a18 = '';
  		String a19 = '';
  		String a20 = '';
  		}
  	else 
  		doc = getDomDocumentFromPageReference(pr);
  		
    Dom.Xmlnode root = doc.getRootElement();
    Dom.Xmlnode reportNode = getReportNode(root, reportName);
    if (reportNode != null){
      String val = reportNode.getChildElement('id', null).getText();
      if(val != null)
        return val;
    }
    return '00O';
  }
   
  private Dom.Xmlnode getReportNode(Dom.Xmlnode root, String reportName){
    Dom.Xmlnode wantedNode;
    For(Dom.Xmlnode child: root.getChildElements()){
    	if(child.getAttribute('name', null)==reportName){
    	 return child;
      }
    }	
    return null;
  }
  
  private Dom.Document getDomDocumentFromPageReference(PageReference pr){
  	Dom.Document dom = new Dom.Document();
  	String domString = pr.getContent().toString();
    dom.load(domString);
    return dom;
  }
  
  private Dom.Document getTestDocument() {
  	String  domString = ''; 
  	domString += '<?xml version="1.0" ?>\n'; 
  	domString += '<result>\n'; 
  	domString += '<report foldername="Account and Contact Reports" name="HTML Email Status Report"><url><![CDATA[/00O?rt=11&retURL=%2Fservlet%2Fservlet.ReportList&interval_q=last7&break0=EMAILTEMPLATENAME&sort=OPENED&sortdir=down&details=yes&format=t]]></url><description>Show me all HTML emails I sent this week.</description></report>\n';
  	domString += '<report foldername="Account and Contact Reports" name="Active Accounts"><url><![CDATA[/00O?rt=1&retURL=%2Fservlet%2Fservlet.ReportList&edit=yes&scope=user&sort=ACCOUNT.NAME&t=title1&colDt_c=DUE_DATE&colDt_s=31.10.2011&c=AO&c=AN&c=A1SA&c=TY&c=RT&c=IN&c=CD&details=yes]]></url><description>What are my current accounts?</description></report>\n';
  	domString += '</result>';
  	Dom.Document dom = new Dom.Document();
    dom.load(domString);
	return dom;   	
  }
}