public without sharing virtual class C3C_MDT_ControlMapper {

    public virtual String getObjectName() { return 'C3C_MDT_control__mdt'; }

    @AuraEnabled public String recordId {get;set;}
    @AuraEnabled public String masterLabel {get;set;}
    @AuraEnabled public String qualifiedName {get;set;}
    @AuraEnabled public String developerName {get;set;}

    public C3C_MDT_ControlMapper() {}
    public virtual Object newInstance(Object params)
    {
        if(params instanceOf SObject) { buildMetadataControl(((SObject) params)); }

        return this;
    }

    public C3C_MDT_ControlMapper buildMetadataControl(SObject mdt_control)
    {
        this.recordId = (String) mdt_control.get('Id');
        this.developerName = (String) mdt_control.get('DeveloperName');
        this.qualifiedName = (String) mdt_control.get('QualifiedApiName');
        this.masterLabel = (String) mdt_control.get('MasterLabel');

        return this;
    }
}