/**
 * @filename : tabAccountSystem.html
 * @description : tabAccountSystem.html to support Account Address in SFDC V.2.0 Project
 * @Author : Surawat Sakulmontreechai
 * @Group : Account Tab
 * @Created By : Surawat Sakulmontreechai
 * @Created Date : 2023-06-06
 * @LastModified By : -
 * @LastModified Date : -
 * @Email : surawat.sakulmontreechai@hoya.com
 * @Noted & description :   System information tab implement into Account tab
 */

import { LightningElement, api } from 'lwc';
import Account_CreatedDate from '@salesforce/schema/Account.CreatedDate';
import Account_CreatedBy from '@salesforce/schema/Account.CreatedById';
import Account_LastModifiedDate from '@salesforce/schema/Account.LastModifiedDate';
import Account_LastModifiedBy from '@salesforce/schema/Account.LastModifiedById';
import Account_RecordType_Name from  '@salesforce/schema/Account.RecordTypeId';
import Account_obj from '@salesforce/schema/Account';

import label_sysInfo from '@salesforce/label/c.tabAccSystemInfo';

export default class TabAccountSystem extends LightningElement {
    /*
    accountCreatedDate = Account_CreatedDate;
    accountCreatedBy = Account_CreatedBy;
    acocuntLastmodifiedDate = Account_LastModifiedDate;
    accountLastmodifiedBy = Account_LastModifiedBy;
    accountRecordTypeName = Account_RecordType_Name;
    */
    
    @api receivedId;
    objectApiName = Account_obj;
    ACC_FIELDS = [Account_CreatedBy, Account_CreatedDate, Account_LastModifiedBy, Account_LastModifiedDate, Account_RecordType_Name];
    //fields = [Account_CreatedBy, Account_CreatedDate, Account_LastModifiedBy, Account_LastModifiedDate];
    

    label = {label_sysInfo};
}