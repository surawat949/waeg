import { LightningElement,api } from 'lwc';
import Contact_obj from '@salesforce/schema/Contact';
import AccTemplate from '@salesforce/schema/Contact.Account_Template__c';
import AccPotal from '@salesforce/schema/Contact.Account_Portal__c';
import AccLanguage from '@salesforce/schema/Contact.Account_Language__c';
import DateFormat from '@salesforce/schema/Contact.Date_Format__c';
import TimeFormat from  '@salesforce/schema/Contact.Time_Format__c';
import TimeZoneOffset from '@salesforce/schema/Contact.Time_Zone_Offset__c';
import SyncToPardot from  '@salesforce/schema/Contact.Sync_to_Pardot__c';
import TestEnv from '@salesforce/schema/Contact.Test_Environment__c';
import PortalUserName from '@salesforce/schema/Contact.Portal_User_Name__c';
import Language from '@salesforce/schema/Contact.Language_Pick__c';

import InviteEmail from '@salesforce/schema/Contact.Invite_Portal_Email__c';
import InvitationHash from '@salesforce/schema/Contact.Registration_Invitation_Hash__c';
import CMDTPotal from '@salesforce/schema/Contact.CMDT_Portal__c';
import CMDTRegistration from '@salesforce/schema/Contact.CMDT_BUILD_Registration__c';
import CMDTMain from  '@salesforce/schema/Contact.CMDT_MAIN_Registration__c';
import CMDTRegister from '@salesforce/schema/Contact.CMDT_Register__c';
import CMDTPwdReset from  '@salesforce/schema/Contact.CMDT_Password_Reset__c';
import CMDTProdReg from '@salesforce/schema/Contact.CMDT_PROD_Registration__c';
import CMDTUrl from '@salesforce/schema/Contact.CMDT_Contact_Us_URL__c';
import SendEmailFlg from '@salesforce/schema/Contact.Send_Registration_Email_Flag__c';
import HoyaNetLogin from '@salesforce/schema/Contact.HoyaNet_Login__c';
//Custom Labels
import PortalSetting from '@salesforce/label/c.Portal_Setting';
import User from '@salesforce/label/c.User';
import Registrations from '@salesforce/label/c.Registrations';
import RegHoyanet from '@salesforce/label/c.Registration_Hoyanet';
export default class TabContactActivationPortal extends LightningElement {
    @api receivedId;
    custLabel={PortalSetting,User,Registrations,RegHoyanet};
    Contact_Obj = Contact_obj;
    fields1 = [AccTemplate,AccPotal,AccLanguage];
    fields2 = [DateFormat,TimeFormat,TimeZoneOffset];
    fields3 = [SyncToPardot,TestEnv];
    portalUser =[PortalUserName];
    Language = [Language];
    inviteEmail = [InviteEmail];
    fields4 = [InvitationHash,CMDTPotal];
    cmdtReg = [CMDTRegistration];
    fields5 = [CMDTMain,CMDTRegister];
    cmdtPwdReset =[CMDTPwdReset];
    fields6=[CMDTProdReg,CMDTUrl];
    sendEmail =[SendEmailFlg];
    hoyaNetLogin =[HoyaNetLogin];
}