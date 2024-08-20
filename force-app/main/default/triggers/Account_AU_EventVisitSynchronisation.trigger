/**
 * This trigger is used to synchronize from Account to Event and Visit
 *
 * @author      Qiang Liu
 * @created     2016-06-02
 * @version     1.0
 * @since       25.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2016-06-03 Qiang Liu <qiang.liu@itbconsult.com>
 * - Created
 */
trigger Account_AU_EventVisitSynchronisation on Account (after update) {
    
    //ClsVisitUtil.syncEventFromAccount(trigger.New);
    
}