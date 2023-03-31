import { LightningElement } from 'lwc';

const nonEditableFields = new Set(['Id', 'QualifiedApiName', 'DeveloperName']);
const nonListedFields = new Set(['attributes']);

export default class ConfigureMdt extends LightningElement 
{
    mdt_control;
    lwc_metadatas;

    renderedCallback() 
    {
        this.mdt_control =  this.template.querySelector('c-lwc-mdt-control');
        this.lwc_metadatas = this.template.querySelector('c-lwc-metadatas');
    }

    handleSelected(event) 
    {  
        this.lwc_metadatas.setDevName(this.mdt_control.getSelected());
        this.lwc_metadatas.setColumns(this.formatColumns(JSON.parse(this.mdt_control.getColumns())));

        this.lwc_metadatas.retrieveMetadatas();
    }

    // Formata as colunas pro modelo datatable
    formatColumns(unformatColumns) 
    {
        let cols = []; 
        Object.keys(unformatColumns).forEach((k) => { if(!nonListedFields.has(k)) cols.unshift(this.getColumnFormat(k, unformatColumns[k])); });
        
        return cols;  
    }

    // Cria o objeto de coluna
    getColumnFormat(keyCol, typeCol)
    {
        let col = new Object();
        col.editable = nonEditableFields.has(keyCol) ? false : true;
        col.label = keyCol.replace('__c', '');
        col.fieldName = keyCol;
        col.type = this.switchTypeColumn(typeCol);
        console.log(col.type);
        return col;
    }

    // Tipos das colunas
    switchTypeColumn(typeCol)
    {
        console.log('Type colum - ' + typeCol);
        switch (typeCol) 
        {
            case 'STRING' :
                return 'text';
                break;
            case 'DOUBLE' :
                return 'number';
                break;
            case 'BOOLEAN' :
                return 'boolean'
                break;
            case 'PHONE' :
                return 'phone';
                break;
            case 'EMAIL' :
                return 'email';
                break;
            case 'PERCENT' :
                return 'percent';
                break;
            case 'CURRENCY' :
                return 'currency';
                break;
            case 'DATETIME' :
                return 'date';
                break;
            default :
                return 'text';
        }
    }
}