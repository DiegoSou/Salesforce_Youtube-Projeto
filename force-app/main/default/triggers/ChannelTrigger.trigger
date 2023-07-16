trigger ChannelTrigger on Channel__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) 
{
    new ChannelTriggerHandler().run();   
}