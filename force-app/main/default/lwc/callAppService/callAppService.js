import { LightningElement, api, wire } from 'lwc';
import callService from '@salesforce/apex/APP_CallService.callService';

import { MessageContext, publish } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CallAppService extends LightningElement 
{
    @wire(MessageContext) messageContext;
    @api cmp;

    // Método para chamar qualquer tipo de Service, através das adapters, basta especificar o nome da Adapter em className
    @api call(className, methodName, paramsNameValue)
    {
        console.log('Call service to ' + methodName);
        
        let response = 
        {
            from : this.cmp,
            data : null,
            error : null
        };

        callService({ className : className, methodName : methodName, paramsNameValueJson : JSON.stringify(paramsNameValue) })
        .then((dataJson) => {
            response.data = dataJson;
        })
        .catch((errorJson) => {
            response.error = errorJson.body.message;

            let errNotify = JSON.parse(response.error);
            this.notificationToast(errNotify.title, errNotify.message, errNotify.view);
        })
        .finally(() => {
            publish(this.messageContext, CallServiceChannel, { response : response });
        })
    }

    @api notificationToast(title, message, view)
    {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: view
        }));
    }
}