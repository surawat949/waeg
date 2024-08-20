import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';

import ACCOUNT_OBJ from '@salesforce/schema/Account';
import SEIKO_DATA_OBJ from '@salesforce/schema/Seiko_Data__c';

// fields
import VISIONARY_ALLIANCE from '@salesforce/schema/Account.Visionary_Alliance__c';
import LOYALTY_PROGRAMS from '@salesforce/schema/Account.Loyalty_Programms__c';
//import TOTAL_LOYALTY_POINTS from '@salesforce/schema/Account.Total_Loyalty_Points__c'; 
import NETWORK_SIGN_IN from '@salesforce/schema/Account.SVS_sign_in__c';
import NETWORK_SIGN_OUT from '@salesforce/schema/Account.SVS_sign_out__c';
import COMMERCIAL_NETWORK from '@salesforce/schema/Account.Seiko_Network__c';

/*import SEIKO_CATALOG_LAST_TRAINING from '@salesforce/schema/Seiko_Data__c.SEIKO_catalogues_training__c';
import SEIKO_PRODUCT_LAST_TRAINING from '@salesforce/schema/Seiko_Data__c.SEIKO_Products_1rst_training_date__c';
import SEIKO_BOXES_SETTING from '@salesforce/schema/Seiko_Data__c.SVS_Sample_boxes_setting_up__c';
import SVS_COMMUNICATION_KIT from '@salesforce/schema/Seiko_Data__c.SVS_Communication_kit_setting_up__c';*/

import ACCOUNT_ONBOARDING from '@salesforce/schema/Account.Onboarding_Customer__c';
import ACCOUNT_ONBOARDING_DATE from '@salesforce/schema/Account.Onboarding_date__c';

// labels
import VisionaryAllianceHeader from '@salesforce/label/c.VisionaryAlliance';
import startOnboardingProcess from '@salesforce/label/c.Start_OnboardingProcess';
import stopOnboardingProcess from '@salesforce/label/c.Stop_OnboardingProcess';
//import seikoVisionSpecialistHeader from '@salesforce/label/c.SeikoVisionSpecialistProgram';
import LoyaltyProgram from '@salesforce/label/c.TabLoyaltyProgram';
import CommunityProgram from '@salesforce/label/c.Community_Program';

import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';

// apex
import startOnboarding from '@salesforce/apex/tabActivationBusinessProgramController.updateOnboardingFlag';

import getIndicators from '@salesforce/apex/TabActivationAIIndicatorController.getAIIndicators';

export default class TabActivationBusinessProgramRegistration extends LightningElement {
    @api receivedId;
    @api seikoData;
    @api accBrand;
    @api accChannel;
    
    objectapiname = ACCOUNT_OBJ;
    seikoDataObjapiName = SEIKO_DATA_OBJ;
    visionaryAllianceFields = [COMMERCIAL_NETWORK,VISIONARY_ALLIANCE,NETWORK_SIGN_IN,NETWORK_SIGN_OUT];
    AccountOnBoarding = [ACCOUNT_ONBOARDING, ACCOUNT_ONBOARDING_DATE];
    LoyaltyProgram = [LOYALTY_PROGRAMS];
    showLoading = false;
    isIndependentChannel = false;
    onBoarding = false;

    HVCIndicator;
    portalIndicator;
    DataOrderIndicator;
    RemoteEdgingIndicator;
    MountingIndicator;

    HVCProgramFlagMeaning;
    PortalFlagMeaning;
    DataOrdersFlagMeaning;
    RemotEdgingFlagMeaning;
    MountingFlagMeaning;

    @wire(getRecord, { recordId: '$receivedId', fields: [ACCOUNT_ONBOARDING] })
    record({ error, data }) {
        if (data) {
            this.onBoarding = data.fields.Onboarding_Customer__c.value;
        }
    }

    custLabel = {
        VisionaryAllianceHeader,
        startOnboardingProcess,
        stopOnboardingProcess,
        LoyaltyProgram,CommunityProgram
    }
    @wire(getIndicators, {receivedId: '$receivedId'})  getIndicators ({error, data}) {
        if(data){
            this.RemoteEdgingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.RemotEdgingFlag);
            this.MountingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.MountingFlag);
            this.portalIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.PortalFlag);
            this.HVCIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.HVCProgramFlag);
            this.DataOrderIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.DataOrdersFlag);
            this.HVCProgramFlagMeaning = data.HVCProgramFlagMeaning;
            this.PortalFlagMeaning = data.PortalFlagMeaning;
            this.DataOrdersFlagMeaning = data.DataOrdersFlagMeaning;
            this.RemotEdgingFlagMeaning = data.RemotEdgingFlagMeaning;
            this.MountingFlagMeaning = data.MountingFlagMeaning;
            
        }else if(error){
            this.showToast('Error', 'Error', error.body.message);

        }
    }
    
    constructor() {
        super();
        // passed parameters are not yet received here
    }
    connectedCallback() {
        
    }

    getIndicatorImage(indicator){
        if(indicator == 'GREY')
            return 'GreyLight.png';
        else if(indicator == 'GREYALERT')
            return 'GreyLightAlert.png';
        else if(indicator == 'RED')
            return 'RedLight.png';
        else if(indicator == 'REDALERT')
            return 'RedLightAlert.png';
        else if(indicator == 'GREEN')
            return 'GreenLight.png';
        else if(indicator == 'GREENALERT')
            return 'GreenLightAlert.png';

    }

    renderedCallback() {
        /*if (this.accChannel != undefined && (this.accChannel === 'Independent' || this.accChannel === 'Independent Seiko' || this.accChannel === 'Chain' || this.accChannel === 'Chain Seiko')) {
            this.isIndependentChannel = true;
        }*/
    }

    startOnboardingProcess() {
        this.initiateFlip(true);
    }

    stopOnboardingProcess() {
        this.initiateFlip(false);
    }

    initiateFlip(state) {
        this.showLoading = true;
        startOnboarding({accountId : this.receivedId, state:state})
        .then(response => {
            setTimeout(() => {
			    this.dispatchEvent(new RefreshEvent());
                this.showLoading = false;
                if(state){
                    this.showToast('Success', 'Success', 'Started On-boarding process');
                } else {
                    this.showToast('Success', 'Success', 'Stopped On-boarding process');
                }
                
            },1000);
        })
        .catch(error => {
            this.showLoading = false;
            //console.log(error);
            this.showToast('Error', 'Error', error.body.message);
        })
    }

    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}