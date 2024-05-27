import { LightningElement, api } from 'lwc';

export default class LifeCycleReportingList extends LightningElement {
    @api records
    @api stage
    @api accountstats
    @api visitaddflag;
    @api taskstats
    @api lensesnetsalesl12mo;
    @api addnewiconflag;
}