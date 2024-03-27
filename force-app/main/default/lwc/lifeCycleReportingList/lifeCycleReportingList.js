import { LightningElement, api } from 'lwc';

export default class LifeCycleReportingList extends LightningElement {
    @api records
    @api stage
}