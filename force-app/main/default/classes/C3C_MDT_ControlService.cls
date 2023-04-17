public class C3C_MDT_ControlService implements C3C_MDT_IControlService {

    public class C3C_MDT_ControlServiceException extends Exception {}

    public String metadatas(String key) 
    { 
        return JSON.serialize(instanceC3C_MDT_IControlSelector.setDomainInstance(key).getAllMDTs()); 
    } 
    
    public String columns(String key) 
    {   
        return JSON.serialize(
            new C3C_MDT_ControlDomain().defineMetadataInstance(key).fieldNameByDataType
        ); 
    }

    public void save(String key, String listjson)
    {
        try
        {
            Metadata.DeployContainer container = new Metadata.DeployContainer();
            C3C_MDT_ControlDomain domain = new C3C_MDT_ControlDomain().defineMetadataInstance(key);

            for(String mdtJson : (List<String>) JSON.deserialize(listjson, List<String>.class)) { container.addMetadata(domain.buildCustomMetadataByInstanceJSON(mdtJson)); }
            
            System.debug('Custom Metadata Container | ' + container);
            Id asyncResult = Metadata.Operations.enqueueDeployment(container, null);
            
        } catch(Exception e) { throw new C3C_MDT_ControlServiceException('Erro ao salvar os metadados: ' + e.getMessage() + ' | Linha: ' + e.getLineNumber()); }
    }

    private C3C_MDT_IControlSelector instanceC3C_MDT_IControlSelector {
        get
        {
            if(instanceC3C_MDT_IControlSelector == null)
            {
                instanceC3C_MDT_IControlSelector = (C3C_MDT_IControlSelector) Type.forName('C3C_MDT_ControlSelector').newInstance();
            }

            return instanceC3C_MDT_IControlSelector;
        }
        set;
    }
}