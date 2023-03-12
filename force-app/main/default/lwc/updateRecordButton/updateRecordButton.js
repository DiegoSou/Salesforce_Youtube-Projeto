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
        this.subscribeToChannel();
    }

    handleRecordUpdate(response)
    {
        let callAppService = this.template.querySelector("c-call-app-service");

        if(response.from == 'update-record-button')
        {
            this.loading = false;

            if(response.data)
            {
                let successMsg = JSON.parse(response.data);
    
                callAppService.notificationToast('Success', successMsg, 'success');
            }
    
            if(response.error)
            {
                let exceptionData = JSON.parse(response.error); 
    
                callAppService.notificationToast(exceptionData.title, exceptionData.message, exceptionData.view);
            }
        }
    }
    
    handleUpdateRecordClick()
    {
        let callAppService = this.template.querySelector("c-call-app-service");
        if(this.targetObject === 'Channel') { this.methodName = 'callUpdateChannel'; }
        if(this.targetObject === 'Video') { this.methodName = 'callUpdateVideo'; }
        
        let params = [
            {
                name : 'recordId',
                type : 'String',
                value : this.recordId
            }
        ];
        
        this.loading = true;
        callAppService.call('SelectedChannelAdapter', this.methodName, JSON.stringify(params));
    }

    // HELPER
    subscribeToChannel()
    {
        this.subscription = subscribe(
            this.messageContext, 
            CallServiceChannel,
            (call) => this.handleRecordUpdate(call.response),
            {}
        );
    }
}