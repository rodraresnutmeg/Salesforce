import {api, LightningElement, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import userId from '@salesforce/user/Id';
import getAccountById from '@salesforce/apex/AccountService.getAccountById';

import CASE_ID_FIELD            from '@salesforce/schema/Case.Id';
import STATUS_FIELD             from '@salesforce/schema/Case.Status';
import OWNER_ID_FIELD           from '@salesforce/schema/Case.OwnerId';
import CASE_ACCOUNT_ID_FIELD    from '@salesforce/schema/Case.AccountId';

import ACCOUNT_ID_FIELD         from '@salesforce/schema/Account.Id';

import OPP_ACCOUNT_ID_FIELD     from '@salesforce/schema/Opportunity.AccountId';

export default class CaseQuickActions extends LightningElement {
    @track error;

    @api recordId;
    @api objectApiName;

    accountRecordId;

    case;
    opp; // Opportunity

    showCloseCaseButton     = false;
    showAssignToMeButton    = false;
    showPhoneOptOutButton   = false;

    isAssignedToMe = true;
    isStatusClosed = true;

    STATUS_CLOSED = 'Closed';

    PhoneOptInOutLabel  = 'Phone Opt In';
    PhoneOptInLabel     = 'Phone Opt In';
    PhoneOptOutLabel    = 'Phone Opt Out';

    phoneOptOutValue = false;

    renderedCallback() {
        if (this.objectApiName === 'Case' && this.case !== undefined) {
            this.accountRecordId        = getFieldValue(this.case, CASE_ACCOUNT_ID_FIELD);
            this.showCloseCaseButton    = true;
            this.showAssignToMeButton   = true;
            this.showPhoneOptOutButton  = true;
        }

        if (this.objectApiName === 'Opportunity' && this.opp !== undefined) {
            this.accountRecordId        = getFieldValue(this.opp, OPP_ACCOUNT_ID_FIELD);
            this.showPhoneOptOutButton  = true;
        }

        if (this.objectApiName === 'Account') {
            this.accountRecordId        = this.recordId;
            this.showPhoneOptOutButton  = true;
        }

        if (this.accountRecordId !== undefined) {
            const fields = {};
            fields['accId'] = this.accountRecordId;

            getAccountById(fields)
                .then((res) => {
                    this.phoneOptOutValue = res.Phone_Opt_Out__pc;

                    this.PhoneOptInOutLabel = this.phoneOptOutValue
                        ? this.PhoneOptInLabel
                        : this.PhoneOptOutLabel;
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

    }

    handlePhoneOptOut() {
        const fields = {};
        fields[ACCOUNT_ID_FIELD.fieldApiName]   = this.accountRecordId;
        fields['Phone_Opt_Out__pc']             = !this.phoneOptOutValue;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: this.PhoneOptInOutLabel,
                        variant: 'success'
                    })
                );

                this.phoneOptOutValue   = !this.phoneOptOutValue;
                this.PhoneOptInOutLabel = this.phoneOptOutValue
                    ? this.PhoneOptInLabel
                    : this.PhoneOptOutLabel;
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    wiredCaseResult;

    @wire(getRecord, { recordId: '$recordId', fields: [
        STATUS_FIELD,
        OWNER_ID_FIELD,
        CASE_ACCOUNT_ID_FIELD
    ] })
    wireCase(result) {
        this.wiredCaseResult = result;

        if (result.data) {
            this.error          = undefined;
            this.case           = result.data;
            this.isAssignedToMe = (getFieldValue(this.case, OWNER_ID_FIELD) === userId);
            this.isStatusClosed = (getFieldValue(this.case, STATUS_FIELD) === this.STATUS_CLOSED);
            this.renderedCallback();
        } else if (result.error) {
            this.error  = result.error;
            this.case   = undefined;
        } else {
            this.error  = undefined;
            this.case   = undefined;
        }
    }

    wiredOppResult;

    @wire(getRecord, { recordId: '$recordId', fields: [
        OPP_ACCOUNT_ID_FIELD
    ] })
    wireOpp(result) {
        this.wiredOppResult = result;

        if (result.data) {
            this.error  = undefined;
            this.opp    = result.data;
            this.renderedCallback();
        } else if (result.error) {
            this.error  = result.error;
            this.opp    = undefined;
        } else {
            this.error  = undefined;
            this.opp    = undefined;
        }
    }

    handleAssignToMe() {
        const fields = {};
        fields[CASE_ID_FIELD.fieldApiName]  = this.recordId;
        fields[OWNER_ID_FIELD.fieldApiName] = userId;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case assigned',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleCloseCase() {
        const fields = {};
        fields[CASE_ID_FIELD.fieldApiName]  = this.recordId;
        fields[STATUS_FIELD.fieldApiName]   = this.STATUS_CLOSED;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case closed',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

}