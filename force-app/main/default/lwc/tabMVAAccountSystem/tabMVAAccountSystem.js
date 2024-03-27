import { LightningElement, api } from 'lwc';

import Account_CreatedDate from '@salesforce/schema/Account.CreatedDate';
import Account_CreatedBy from '@salesforce/schema/Account.CreatedById';
import Account_LastModifiedDate from '@salesforce/schema/Account.LastModifiedDate';
import Account_LastModifiedBy from '@salesforce/schema/Account.LastModifiedById';
import Account_RecordType_Name from  '@salesforce/schema/Account.RecordTypeId';
import Account_OneKeyId from '@salesforce/schema/Account.QIDC__OneKeyId_IMS__c';
import Account_obj from '@salesforce/schema/Account';

import system_information from '@salesforce/label/c.tabAccSystemInfo';

export default class TabMVAAccountSystem extends LightningElement {
    @api receivedId;

    custLabel = {
        system_information
    }

    objectapiname = Account_obj;
    accountCreatedDate = Account_CreatedDate;
    accountCreateBy = Account_CreatedBy;
    accountLastModified = Account_LastModifiedDate;
    accountLastModifiedBy = Account_LastModifiedBy;
    accountRecTypeName = Account_RecordType_Name;
    accountOneKey = Account_OneKeyId;
}