@isTest
private class C3C_VFBindingControlTest 
{
    private static C3C_VFBindingControl instance = new C3C_VFBindingControl();
    
    @isTest
    static void bindingTest()
    {   
        instance.param = 'C3C';
        
        instance.create();
        instance.tempBindings[0].MasterLabel = 'TestBinding';
        instance.tempBindings[0].ClasseApex__c = 'TestBinding';
        instance.tempBindings[0].Estatico__c = true;
        
        instance.filter();
        instance.save(); 
        
        instance.Next();
        instance.Previous();
		instance.getHasNext();
        instance.getHasPrevious();
    }
}