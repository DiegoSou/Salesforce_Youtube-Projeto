import { LightningElement, api, wire } from 'lwc';
import callService from '@salesforce/apex/APP_CallService.callService';

import { MessageContext, publish } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CallAppService extends LightningElement 
{
    @api cmp;
    @wire(MessageContext) messageContext;

    // Método para chamar qualquer tipo de Service, através das adapters, basta especificar o nome da Adapter em className
    // Method to call any Service Class, through Adapters, passing the name of Adapter Class on className param

    // fires message channel / subscriber must always check if the response data is not null
    // we'll catch an error only if the error is a User Exception, which is allowed to users visualize
    @api call(className, methodName, paramsNameTypeValueJson)
    {
        console.log('Call service to ' + methodName);
        
        let response = {
            from : this.cmp,
            data : null,
            error : null
        };

        callService({ className : className, methodName : methodName, paramsNameTypeValueJson : paramsNameTypeValueJson })
        .then((dataJson) => {
            response.data = dataJson;
        })
        .catch((errorJson) => {
            response.error = errorJson.body.message;
        })
        .finally(() => {
            publish(this.messageContext, CallServiceChannel, { response : response});
        })
    }

    @api notificationToast(title, message, variant)
    {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }


    @api notificationComponent(message, variant)
    {
        // let customToast = this.template.querySelector('c-custom-toast');
        // customToast.display(message, variant);
    }
}