import { LightningElement, api, track, wire } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

export default class VideoSearchResults extends LightningElement 
{
    @track videoList;
    
    @wire(MessageContext) messageContext;

    connectedCallback()
    {
        subscribe(
            this.messageContext,
            CallServiceChannel,
            (call) => this.handleSearch(call.response),
            {} 
        );
    }

    @api search(channelId, searchParam)
    {
        let callService = this.template.querySelector('c-call-app-service');

        let params = [
            {
                name : 'searchParam',
                type : 'String',
                value : searchParam
            },
            {
                name : 'channelId',
                type : 'String',
                value : channelId
            }
        ];

        callService.call('SearchVideoAdapter', 'searchVideos', JSON.stringify(params));
    }

    handleSearch(response)
    {
        let callService = this.template.querySelector('c-call-app-service');

        if(response.from == 'video-search-results')
        {
            if(response.data)
            {
                this.videoList = JSON.parse(response.data);
                
                this.dispatchEvent(new CustomEvent('searchresult', { detail : this.videoList }));
            }

            if(response.error)
            {
                console.log('Erro');
            }
        }
    }
}


// this.handleSearch(
//     {
//         from : 'video-search-results',
//         data : '[{"attributes":{"type":"Video__c"},"VideoYtbId__c":"ixg9D-k02qs","Title__c":"Componente Aura na Prática","Video_URL__c":"https://youtube.com/video/ixg9D-k02qs","Channel__c":"a00Dn000007vPVNIA2","Publish_Date__c":"2022-02-15T16:23:49.000+0000","Description__c":"Iniciando na carreira Salesforce? Então nos siga nas redes sociais: https://www.instagram.com/c3csoftware/ ...","Thumbnail__c":"https://i.ytimg.com/vi/ixg9D-k02qs/default.jpg"},{"attributes":{"type":"Video__c"},"VideoYtbId__c":"mWi9i3Syjvs","Title__c":"Desenvolvedor Salesforce, e agora?","Video_URL__c":"https://youtube.com/video/mWi9i3Syjvs","Channel__c":"a00Dn000007vPVNIA2","Publish_Date__c":"2021-12-10T03:43:46.000+0000","Description__c":"Iniciando na carreira Salesforce? Então nos siga nas redes sociais: https://www.instagram.com/c3csoftware/ ...","Thumbnail__c":"https://i.ytimg.com/vi/mWi9i3Syjvs/default.jpg"},{"attributes":{"type":"Video__c"},"VideoYtbId__c":"A-s6YFIWgxM","Title__c":"Como fazer testes unitários?","Video_URL__c":"https://youtube.com/video/A-s6YFIWgxM","Channel__c":"a00Dn000007vPVNIA2","Publish_Date__c":"2021-12-17T03:57:36.000+0000","Description__c":"Iniciando na carreira Salesforce? Então nos siga nas redes sociais: https://www.instagram.com/c3csoftware/ ...","Thumbnail__c":"https://i.ytimg.com/vi/A-s6YFIWgxM/default.jpg"}]'
//     }
// )