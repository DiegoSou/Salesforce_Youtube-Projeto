public class C3C_MDT_ControlService implements C3C_MDT_IControlService {

    public class C3C_MDT_ControlServiceException extends Exception {}

    public String metadatas(String key) 
    { 
        return JSON.serialize
        (
            this.instanceC3C_MDT_IControlSelector.setGeneric(key).getAllMDTs() 
        ); 
    } 
    
    public String columns(String key) 
    { 
        return JSON.serialize
        (
            (new C3C_MDT_ControlDomain()).setDeveloperName(key).setMdtFieldMap().getFieldNameByDataType()
        ); 
    }

    public void save(String key, String listjson)
    {
        try
        {
            Metadata.DeployContainer container = new Metadata.DeployContainer();
    
            C3C_MDT_ControlDomain domain = (new C3C_MDT_ControlDomain()).setDeveloperName(key);
    
            for(String mdtJson : (List<String>) JSON.deserialize(listjson, List<String>.class)) { container.addMetadata(domain.buildCustomMetadataByInstance(mdtJson)); }
            
            System.debug('Custom Metadata Container | ' + container);
    
            Id asyncResult = Metadata.Operations.enqueueDeployment(container, null);
        } catch (Exception e) { throw new C3C_MDT_ControlServiceException('Erro ao salvar os metadados: ' + e.getMessage() + ' | Linha: ' + e.getLineNumber()); }
    }

    private C3C_MDT_IControlSelector instanceC3C_MDT_IControlSelector {
        get
        {
            if(instanceC3C_MDT_IControlSelector == null)
                instanceC3C_MDT_IControlSelector = new C3C_MDT_ControlSelector();

            return instanceC3C_MDT_IControlSelector;
        }
        set;
    }
}