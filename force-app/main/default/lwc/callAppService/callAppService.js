import { LightningElement, api, wire } from 'lwc';
import callService from '@salesforce/apex/APP_CallService.callService';

import { MessageContext, publish } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

export default class CallAppService extends LightningElement 
{
    @wire(MessageContext) messageContext;

    // Método para chamar qualquer tipo de Service, através das adapters, basta especificar o nome da Adapter em className
    // Method to call any Service Class, through Adapters, passing the name of Adapter Class on className param

    @api call(className, methodName, paramsNameTypeValueJson)
    {
        console.log('Call service to ' + methodName);
        
        callService({ className : className, methodName : methodName, paramsNameTypeValueJson : paramsNameTypeValueJson })
        .then((dataJson) => {
            // fires message channel
            publish(this.messageContext, CallServiceChannel, { response : dataJson });
        })
        .catch((error) => {
            console.log(error.message);
        });
    }
}