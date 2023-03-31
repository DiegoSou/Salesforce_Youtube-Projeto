import { LightningElement, api, wire } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

// serve para preencher duas variáveis: o metadado selecionado, e as colunas (representando campos) deste metadado
export default class MdtControl extends LightningElement 
{
    @wire(MessageContext) messageContext;

    mdt_selected; // Metadado selecionado
    mdt_columns;  // Colunas do metadado selecionado      
    
    loading = true;

    // public function - retorna o metadado selecionado
    @api getSelected() { return this.mdt_selected; }

    // public function - retorna as colunas do metadado selecionado
    @api getColumns() { return this.mdt_columns; }

    // Define inscrição pro canal de eventos e o que fazer após cada chamada
    connectedCallback()
    {
        subscribe(
            this.messageContext,
            CallServiceChannel,
            (call) => {
                console.log(call.response.from);
                if(call.response.from == 'control-get-metadatas') { this.handleCallToGetMetadatas(call.response); }
                if(call.response.from == 'control-get-columns')
                {
                    this.mdt_columns = JSON.parse(call.response.data);
                    this.dispatchEvent(new CustomEvent('generatedcolumns')); 
                }
            },
            {}
        );
    }

    renderedCallback()
    {
        // Prevents re-reloading
        if(this.loading)
        {
            let callService = this.template.querySelector('c-call-app-service');
            let params = 
            [
                {
                    name : 'mdtlabel',
                    type : 'String',
                    value : 'C3C_MDT_control'
                }
            ];

            callService.cmp = 'control-get-metadatas';
            callService.call('C3C_MDT_ControlAdapter', 'getMetadatas', JSON.stringify(params));
        }
    }

    // Constrói a lista de rótulos dos metadados controláveis/configuráveis
    handleCallToGetMetadatas(response)
    {
        let res = JSON.parse(JSON.parse(response.data));

        if(res.length > 0) { this.generateHtmlSelect(res.map((v) => v.MasterLabel)); }
    }

    // Gera uma tag select com cada option representando um metadado disponível
    generateHtmlSelect(masterlabels)
    {
        let htmlvalue = '';
        let container = this.template.querySelector('div[data-id="select-container"]');
        
        htmlvalue = '<div class="slds-select_container"><select class="slds-select" id="select-01" required="">';
        masterlabels.forEach((label) => {htmlvalue += '<option value="'+label+'">'+label+'</option>'});
        htmlvalue += '</select></div>';

        container.innerHTML = htmlvalue;
        this.loading = false;
    }

    generateColumns()
    {
        let callService = this.template.querySelector('c-call-app-service');
        let params = [
            {
                name : 'mdtlabel',
                type : 'String',
                value : this.mdt_selected
            }
        ];

        callService.cmp = 'control-get-columns';
        callService.call('C3C_MDT_ControlAdapter', 'getColumns', JSON.stringify(params));
    }

    // Metadado selecionado
    handleSelected() 
    {  
        let selectTag = this.template.querySelector('select'); 
        this.mdt_selected = selectTag.options[selectTag.selectedIndex].value;  // seta o metadado selecionado
        
        this.generateColumns();  // call para gerar as colunas | pegar os campos do metadado selecionado 
    }
}