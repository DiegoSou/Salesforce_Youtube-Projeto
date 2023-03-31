public class C3C_VFBindingControl 
{
    public class C3C_VFBindingControlException extends Exception {}

    private final Integer PAGE_SIZE = 10;

    // Mapa de Registros Carregados ->  (São os que serão inseridos, listados, ou que já existem)
    public Map<String, C3C_DI_binding__mdt> bindingByApiName {get; set;}  
    
    // Lista de registros na paginação 
    public List<C3C_DI_binding__mdt> bindings {get; set;}  

    // Lista de registros em criação
    public List<C3C_DI_binding__mdt> tempBindings {get; set;}

    // Parâmetro de pesquisa
    public String param {get; set;}
    
    // set controller
    public Apexpages.StandardSetController setCon {
        get {
            if(setCon == null)
            {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, QualifiedApiName, MasterLabel, ClasseApex__c, Estatico__c FROM C3C_DI_binding__mdt]
                ));
            }
            return setCon;
        }
        set;
    }
    
    public C3C_VFBindingControl()
    {
		bindings = new List<C3C_DI_binding__mdt>();
        tempBindings = new List<C3C_DI_binding__mdt>();
        bindingByApiName = new Map<String, C3C_DI_binding__mdt>();
        
        setCon.setPageSize(PAGE_SIZE);
        loadBindingItemData();
    }

    public void create() 
    { 
        tempBindings.add(new C3C_DI_binding__mdt(MasterLabel = '', ClasseApex__c = '', Estatico__c = false)); 

        loadBindingItemData(); 
    }

    public void filter()
    {
        bindings = new List<C3C_DI_binding__mdt>(tempBindings);

        do 
        {
            for(SObject binding : setCon.getRecords()) 
            { if(((C3C_DI_binding__mdt)binding).MasterLabel.startsWithIgnoreCase(param)) bindings.add((C3C_DI_binding__mdt) binding); }   
            
            setCon.next();
        } while(setCon.getHasNext());

        setCon.first();
    }
    
    // Reloads the page
    public void save()
    {
        Metadata.DeployContainer container = new Metadata.DeployContainer();

        List<String> bindingFullNames = new List<String>();
        
        // Retrieve Existing Bindings
        for(String recordName : bindingByApiName.keySet())
        {
            bindingFullNames.add('C3C_DI_binding.' + recordName);  // ["C3C_DI_binding.AccountDomain","C3C_DI_binding.AccountAdapter"]
        } 
        List<Metadata.Metadata> originalRecords = Metadata.Operations.retrieve(
            Metadata.MetadataType.CustomMetadata, bindingFullNames
        );

        // Add to container
        for(Metadata.Metadata originalRecord : originalRecords)
        {
            Metadata.CustomMetadata bindingRecord = (Metadata.CustomMetadata) originalRecord;

            String bindingRecordName = bindingRecord.fullName.substringAfter('.');
            
            C3C_DI_binding__mdt bindingToCopy = bindingByApiName.get(bindingRecordName);
            bindingRecord.label = bindingToCopy.MasterLabel;
            
            for(Metadata.CustomMetadataValue recValue : bindingRecord.values)
            {
                recValue.value = bindingToCopy.get(recValue.field);
            }
            
            container.addMetadata(bindingRecord);
        }

        for(C3C_DI_binding__mdt toCreate : tempBindings)
        {
            Metadata.CustomMetadata bindingRecord = new Metadata.CustomMetadata();
            bindingRecord.fullName = 'C3C_DI_binding.' + toCreate.MasterLabel;
            bindingRecord.label = toCreate.MasterLabel;
            bindingRecord.protected_x = false;

            bindingRecord.values.add(new Metadata.CustomMetadataValue());
            bindingRecord.values[0].field = 'Estatico__c';
            bindingRecord.values[0].value = toCreate.Estatico__c;

            bindingRecord.values.add(new Metadata.CustomMetadataValue());
            bindingRecord.values[1].field = 'ClasseApex__c';
            bindingRecord.values[1].value = toCreate.ClasseApex__c;

            container.addMetadata(bindingRecord);
        }
        
        if(!container.getMetadata().isEmpty() && !Test.isRunningTest()) 
            Id asyncResultId = Metadata.Operations.enqueueDeployment(container, null);

        return;
    }

    public void loadBindingItemData()
    {
        bindings = new List<C3C_DI_binding__mdt>(tempBindings);

        for(SObject record : setCon.getRecords())
        {
            String qualifiedName = (String) record.get('QualifiedApiName');
            
            if(bindingByApiName.containsKey(qualifiedName))
            {
                bindings.add((C3C_DI_binding__mdt) bindingByApiName.get(qualifiedName));
            }
            else
            {
                // Adiciona na lista que exibe os metadados o metadado existente 
                // Adiciona no mapa de listados o novo metadado existente

                C3C_DI_binding__mdt newbinding = new C3C_DI_binding__mdt(
                    QualifiedApiName = (String) record.get('QualifiedApiName'),
                    MasterLabel = (String) record.get('MasterLabel'),
                    ClasseApex__c = (String) record.get('ClasseApex__c'),
                    Estatico__c = (Boolean) record.get('Estatico__c')
                );

                bindings.add(newbinding); 
                bindingByApiName.put(newbinding.QualifiedApiName, newbinding);
            }
        }

        System.debug('Bindings visualize list => ' + bindings);
        System.debug('Bindings loaded map => ' + bindingByApiName);
    }

    public void Previous() 
    {
        if(getHasPrevious()) setCon.previous();
        loadBindingItemData();
    }

    public void Next() 
    {
        if(getHasNext()) setCon.next();
        loadBindingItemData();
    }

    public Boolean getHasPrevious()
    {
        return setCon.getHasPrevious();
    }
    public Boolean getHasNext()
    {
        return setCon.getHasNext();
    }
}