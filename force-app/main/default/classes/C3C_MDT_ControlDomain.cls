public class C3C_MDT_ControlDomain
{
    public Object newInstance(Object params)
    {
        return new C3C_MDT_ControlDomain((SObject) params);
    }

    @AuraEnabled public String recordId {get;set;}
    
    @AuraEnabled public String developerName {get; private set;}
    @AuraEnabled public String masterLabel {get;set;}
    @AuraEnabled public String qualifiedName {get;set;}

    public C3C_MDT_ControlDomain(){}

    public C3C_MDT_ControlDomain(SObject mdt_control)
    {
        this.recordId = (String) mdt_control.get('Id');

        this.developerName = (String) mdt_control.get('DeveloperName');
        this.qualifiedName = (String) mdt_control.get('QualifiedApiName');
        this.masterLabel = (String) mdt_control.get('MasterLabel');
    }

    // Get|Set campos padrão
    public String getDeveloperName() { if(developerName == null) setDeveloperName('C3C_MDT_ControlDomain'); return developerName; }
    public C3C_MDT_ControlDomain setDeveloperName(String key) { this.developerName = key; return this; }

    // Genéricos (Que podem ser usados para qualquer metadado)
    public Set<String> mdtDefaultFields {get; private set;}
    public Map<String, String> fieldNameByDataType {get; private set;}
    public Schema.SObjectType mdtSObjectType {get; private set;}
    public Map<String, Schema.SObjectField> mdtFieldMap {get; private set;}

    // Get Genéricos
    public Set<String> getMdtDefaultFields() { if(mdtDefaultFields == null) setMdtDefaultFields();  return this.mdtDefaultFields; }
    public Map<String, String> getFieldNameByDataType() { if(fieldNameByDataType == null) setFieldNameByDataType(); return fieldNameByDataType; }
    public Schema.SObjectType getMdtSObjectType() { if(mdtSObjectType == null) setMdtSObjectType(); return this.mdtSObjectType; }
    public Map<String, Schema.SObjectField> getMdtFieldMap() { if(mdtFieldMap == null) setMdtFieldMap(); return this.mdtFieldMap; }

    // Set Genéricos
    public C3C_MDT_ControlDomain setMdtDefaultFields() { this.mdtDefaultFields = new Set<String> { 'Id', 'DeveloperName', 'QualifiedApiName', 'MasterLabel' }; return this; }
    public C3C_MDT_ControlDomain setFieldNameByDataType() { this.fieldNameByDataType = new Map<String, String>(); return this; }
    public C3C_MDT_ControlDomain setMdtSObjectType() { this.mdtSObjectType = Schema.getGlobalDescribe().get(getDeveloperName() + '__mdt'); return this; }
    public C3C_MDT_ControlDomain setMdtFieldMap()
    {
        Map<String, Schema.SObjectField> mdtFields = new Map<String, Schema.SObjectField>(); 

        for(Schema.SObjectField field : getMdtSObjectType().getDescribe().fields.getMap().values())
        {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();

            if(!fieldResult.getName().endsWith('__c') && !getMdtDefaultFields().contains(fieldResult.getName())) { continue; }

            mdtFields.put(fieldResult.getName(), field);   
            this.getFieldNameByDataType().put(fieldResult.getName(), fieldResult.getType().name());
        }
         
        this.mdtFieldMap = mdtFields;
        return this;
    }

    // Constrói um Custom Metadata do atual metadado representado por esta domain e os valores tragos em json | template => dados
    public Metadata.CustomMetadata buildCustomMetadataByInstance(String mdtJsonInstance)
    {
        Metadata.CustomMetadata customMdt = new Metadata.CustomMetadata(); // Custom Metadata
        SObject mdtSobject = (SObject) JSON.deserialize(mdtJsonInstance, Type.forName(getDeveloperName() + '__mdt')); // SObject deste metadado com os campos
        
        // Campos padrão | se for um novo registro, qualified seria um número ex: 99, 101
        customMdt.fullName = mdtSobject.get('Id') == null ? (getDeveloperName() +'.'+ ((String) mdtSobject.get('MasterLabel')).replaceAll(' ', '_')) : (getDeveloperName() +'.'+ (String) mdtSobject.get('QualifiedApiName'));
        customMdt.label = (String) mdtSobject.get('MasterLabel');
        customMdt.protected_x = false;

        // Campos personalizados
        if(getFieldNameByDataType().isEmpty()) { setMdtFieldMap(); } // Verifica se o template foi carregado
        for(String fieldname : getFieldNameByDataType().keySet()) 
        {
            if(getFieldNameByDataType().get(fieldname) == 'DATE') { System.debug('DATEEE' + mdtSobject.get(fieldname)); }
            if(!fieldname.endsWith('__c')) { continue; }

            Metadata.CustomMetadataValue valueField = new Metadata.CustomMetadataValue();

            valueField.field = fieldname;
            valueField.value = mdtSobject.get(fieldname);
            customMdt.values.add(valueField);
        }
        return customMdt;
    }

    // [{"Id":"m0D880000008MmXEAU","DeveloperName":"AccountDomain","MasterLabel":"AccountDom","QualifiedApiName":"AccountDomain","ClasseApex__c":"AccountDomain","Estatico__c":false,"Edited":true}]
}