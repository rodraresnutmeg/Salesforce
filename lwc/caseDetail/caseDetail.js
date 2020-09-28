import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from "lightning/uiRecordApi";

import getCaseIdByChatId            from '@salesforce/apex/CaseService.getCaseIdByChatId';
import getRelatedCasesByChatId      from '@salesforce/apex/CaseService.getRelatedCasesByChatId';
import updateRecordChat             from '@salesforce/apex/CaseService.updateRecordChat';
import createCaseFromLiveChatPage   from '@salesforce/apex/CaseService.createCaseFromLiveChatPage';

import ID_FIELD         from '@salesforce/schema/Case.Id';
import STATUS_FIELD     from '@salesforce/schema/Case.Status';


const COLS = [
    { label: 'Case Number', fieldName: 'link', type: 'url',
        typeAttributes: {
            label: { fieldName: 'CaseNumber'}
        }
    },
    { label: 'Status', fieldName: 'Status' },
    { label: 'Subject', fieldName: 'Subject' },
    {
        type: 'button',
        label: 'Action',
        typeAttributes: {
            label: 'Attach',
            variant: 'brand'
        }
    },
];

export default class CaseDetail extends LightningElement {
    @api recordId;

    @api caseRecordId;
    @track error;

    @track columns = COLS;

    @track showRelatedCases = false;
    @track relatedCases;
    @track isEditMode = false;

    STATUS_CLOSED = 'Closed';

    wiredCaseResult;
    wiredRelatedCasesResult;

    @api
    handleRefresh() {
        return refreshApex(this.wiredCaseResult);
    }

    handleShowRelatedCases() {
        this.showRelatedCases = !this.showRelatedCases;
        return this.showRelatedCases;
    }

    @wire(getCaseIdByChatId, {recordId : '$recordId'})
    wireCase(result) {
        this.wiredCaseResult = result;
        if (result.data) {
            this.caseRecordId = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.caseRecordId = undefined;
        } else {
            this.error = undefined;
            this.caseRecordId = undefined;
        }
    }

    @wire(getRelatedCasesByChatId, {recordId : '$recordId'})
    wireRelatedCases(result) {
        this.wiredRelatedCasesResult = result;
        if (result.data) {
            let arr = JSON.parse(JSON.stringify(result.data));
            arr.forEach(function(item, i, arr) {
                item.link = "/lightning/r/" + item.Id + "/view";
            });
            this.relatedCases = arr;
        } else if (result.error) {
            this.relatedCases = undefined;
        } else {
            this.relatedCases = undefined;
        }
    }

    handleRowAction(event) {
        const fields = {};
        fields['recordId'] = this.recordId;
        fields['caseId'] = event.detail.row.Id;

        updateRecordChat(fields)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Chat updated',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(new CustomEvent('recordChange'));
                return refreshApex(this.wiredCaseResult);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleCreateNewCase(event) {
        const fields = {};
        fields['recordId'] = this.recordId;

        createCaseFromLiveChatPage(fields)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'New Case has been created',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(new CustomEvent('recordChange'));
                return refreshApex(this.wiredRelatedCasesResult);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleCloseCase() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.caseRecordId;
        fields[STATUS_FIELD.fieldApiName] = this.STATUS_CLOSED;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case has been closed',
                        variant: 'success'
                    })
                );
                this.template.querySelector('lightning-record-edit-form').submit();
                return refreshApex(this.wiredRelatedCasesResult);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error closing case',
                        message: error.body.output.errors[0].message,
                        variant: 'error'
                    })
                );
            });
    }

    handleEditMode(event) {
        this.isEditMode = !this.isEditMode;
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        return this.isEditMode;
    }

    handleSuccess(event) {
        this.isEditMode = false;
    }

    handleError(event) {
        const error = event.detail;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error saving case',
                message: error.detail,
                variant: 'error'
            })
        );
    }

}