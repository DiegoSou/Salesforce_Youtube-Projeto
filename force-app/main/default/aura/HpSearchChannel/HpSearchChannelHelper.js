({
    constructClickTileEvent : function(component, objData, indexTile, nameEvent) {
        let eventC = component.getEvent(nameEvent);

        eventC.setParams({
            objData : objData,
            indexTile : indexTile
        });

        return eventC;
    },
    
   	handleHasSaved : function(component, helper)
    {
    	let passRecord = helper.constructClickTileEvent(component, '', '', 'passRecord');
        
        component.set('v.displaysListChannel', []);  
        component.set('v.foundChannelList', []);           
        passRecord.fire();
    }
})