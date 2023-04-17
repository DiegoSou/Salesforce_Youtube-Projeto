/** Pode representar uma instância de qualquer metadado na org */ 

public class C3C_MDT_ControlDomain extends C3C_MDT_ControlMapper
{
    public override String getObjectName() { return developerName + '__mdt'; }

    public Set<String> defaultFields 
    {
        get {
            if(defaultFields == null) { defaultFields = new Set<String> {'Id','MasterLabel','QualifiedApiName','DeveloperName'}; }
            return defaultFields; 
        }
        private set;
    }

    public Map<String, String> fieldNameByDataType 
    {
        get {
            if(fieldNameByDataType == null) { fieldNameByDataType = new Map<String,String>(); }
            return fieldNameByDataType; 
        }
        private set;
    }

    public C3C_MDT_ControlDomain defineMetadataInstance(String developerName)
    {
        this.developerName = developerName;

        for(Schema.SObjectField field : Schema.getGlobalDescribe().get(getObjectName()).getDescribe().fields.getMap().values())
        {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            if(fieldResult.getName().endsWith('__c') || defaultFields.contains(fieldResult.getName())) 
            { 
                fieldNameByDataType.put(fieldResult.getName(), fieldResult.getType().name());
            }
        }

        return this;
    }

    // Constrói um Custom Metadata do metadado representado por esta domain e os valores tragos em json | template => dados
    public Metadata.CustomMetadata buildCustomMetadataByInstanceJSON(String mdtJsonInstance)
    {
        Metadata.CustomMetadata customMdt = new Metadata.CustomMetadata(); // Custom Metadata 
        SObject mdtSobject = (SObject) JSON.deserialize(mdtJsonInstance, Type.forName(getObjectName())); // metadado preenchido
        
        String fullNameSufix = mdtSobject.get('Id') == null ? ((String) mdtSobject.get('MasterLabel')).replaceAll(' ', '_') : (String) mdtSobject.get('QualifiedApiName');

        customMdt.fullName = (developerName + '.' + fullNameSufix);
        customMdt.label = (String) mdtSobject.get('MasterLabel');
        customMdt.protected_x = false;

        // Campos personalizados
        for(String fieldname : fieldNameByDataType.keySet()) 
        {
            if(!fieldname.endsWith('__c')) { continue; }

            Metadata.CustomMetadataValue valueField = new Metadata.CustomMetadataValue();

            valueField.field = fieldname;
            valueField.value = mdtSobject.get(fieldname);
            customMdt.values.add(valueField);
        }
        
        return customMdt;
    }
}