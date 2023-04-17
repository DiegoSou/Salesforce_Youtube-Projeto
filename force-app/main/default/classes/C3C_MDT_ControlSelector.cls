public without sharing class C3C_MDT_ControlSelector implements C3C_MDT_IControlSelector
{
    // registro para indicar qual será o metadado utilizado, através do seu dev name;
    public C3C_MDT_ControlDomain domainInstance 
    {
        get {
            if(domainInstance == null) {setDomainInstance('C3C_MDT_control');}
            return domainInstance;
        }
        private set;
    }

    public C3C_MDT_IControlSelector setDomainInstance(String devName)
    {
        domainInstance = new C3C_MDT_ControlDomain().defineMetadataInstance(devName);

        return this;
    }

    public List<SObject> getAllMDTs()
    {
        String fields = '';
        for(String key : domainInstance.fieldNameByDataType.keySet())
        {
            fields += ','+key;
        }
        String query = ('SELECT {fields} FROM {sobject}').replace('{fields}', fields).replace('{sobject}', domainInstance.getObjectName()).replaceFirst(',', '');
        
        return (List<SObject>) Database.query(query);
    }
}