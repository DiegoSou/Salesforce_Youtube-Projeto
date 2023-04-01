public class C3C_MDT_ControlSelector extends fflib_SObjectSelector implements C3C_MDT_IControlSelector
{
    // sObjectType do atual mdt
    public Schema.SObjectType getSObjectType() { return getGeneric().getMdtSObjectType(); }

    // Campos __c do mdt + os defaults da domain
    public List<Schema.SObjectField> getSObjectFieldList() { return getGeneric().getMdtFieldMap().values(); } 

    // Pega todos os registros do atual mdt
    public List<SObject> getAllMDTs()
    {
        fflib_QueryFactory query = newQueryFactory();
        
        return (List<SObject>) this.libDatabase.queryExecute(query.toSOQL());
    }

    // mdt genérico
    public C3C_MDT_ControlDomain generic {get; private set;}
    public C3C_MDT_ControlDomain getGeneric() { if(generic == null) setGeneric('C3C_MDT_control'); return generic; }

    // utilize esse método para indicar qual será o metadado utilizado, através do seu dev name;
    public C3C_MDT_IControlSelector setGeneric(String devName) { this.generic = (new C3C_MDT_ControlDomain()).setDeveloperName(devName); return (C3C_MDT_IControlSelector) this; }
}