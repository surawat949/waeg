/**
*  This class is to run visit KPI batch
*
@author Yuda Zheng
@created 2014-07-07
@version 1.0
@since 29.0 (Force.com ApiVersion)
*
@changelog
* 2014-07-07 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
*/
public with sharing class CtrlRunVisitKPIBatch {
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  public string batchprocessid        {get;set;} 
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
  public CtrlRunVisitKPIBatch(){
    
    
  }
  /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
  * This method is used to
  *
  @author   Yuda Zheng
  @created 2014-07-07
  @version 1.0
  @since   29.0 (Force.com ApiVersion)
  * 
  *
  *
  @changelog
  * 2014-07-07 Yuda Zheng <yuda.zheng@itbconsult.com>
  * - Created
  */ 
  public void runVisitKPIBatch(){
    try{
            BatchCls_UpdateVisitKPI batchUpdateVisitKPI = new BatchCls_UpdateVisitKPI(Date.today(), ClsVisitUtil.getFirstUnCalculatedVisitDate());
          batchprocessid = DataBase.executeBatch(batchUpdateVisitKPI);
        }
        catch(Exception ex){ApexPages.addMessages(ex);
        }
    
    
    
  }

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************

    //********************************* -=END inner classes=- *************************************
}