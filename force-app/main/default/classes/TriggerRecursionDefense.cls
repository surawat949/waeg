/**
 * This trigger used to update object visit
 *
 @author    Peng Zhu
 @created   2013-03-28
 @version 	1.0
 @since 	25.0 (Force.com ApiVersion)
 *
 @changelog
 * 2011-10-20 Haobo Song <haobo.song@itbconsult.com>
 * - Created 
 */ 
public with sharing class TriggerRecursionDefense {
	//flags whether Visit and Events are synchronized in a transaction
    public static Boolean visitEventSync = false;
    //flags whether Visit and Events are synchronized in a transaction
    public static Boolean calculateVisitsOnAccount = false;
    //flags whether the trigger is null
    public static set<Id> set_Account_Campaing_Member_AIU_postInAccountFeed ; 
}