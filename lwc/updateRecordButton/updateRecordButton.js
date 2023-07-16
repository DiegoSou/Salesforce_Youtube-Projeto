import { api, track, LightningElement, wire } from 'lwc';
import { MessageContext, subscribe  } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

export default class UpdateRecordButton extends LightningElement 
{
    @wire(MessageContext) messageContext;
    subscription = null;

    @api targetObject;
    @api recordId;

    @track loading;
    methodName = '';

    connectedCallback(){
        subscribe(
            this.messageContext, 
            CallServiceChannel,
            (call) => { if(call.response.from == 'update-record-button') { this.handleRecordUpdate(call.response) } },
            {}
        );
    }

    handleRecordUpdate(response)
    {
        let callAppService = this.template.querySelector("c-call-app-service");

        this.loading = false;

        if(response.data)
        {
            let successMsg = JSON.parse(response.data);

            callAppService.notificationToast('Success', successMsg, 'success');
        }
    }
    
    handleUpdateRecordClick()
    {
        let callAppService = this.template.querySelector("c-call-app-service");
        if(this.targetObject === 'Channel') { this.methodName = 'callUpdateChannel'; }
        if(this.targetObject === 'Video') { this.methodName = 'callUpdateVideo'; }
        
        this.loading = true;
        
        callAppService.cmp = 'update-record-button';
        callAppService.call('SelectedChannelAdapter', this.methodName, { recordId : this.recordId });
    }
}