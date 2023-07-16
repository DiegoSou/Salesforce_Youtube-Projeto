({
    constructClickTileEvent : function(component, objData, indexTile, nameEvent) {
        let eventC = component.getEvent(nameEvent);

        eventC.setParams({
            channelTile : objData,
            index : indexTile
        });

        return eventC;
    },
    
   	handleHasSaved : function(component, helper)
    {
    	let passRecord = helper.constructClickTileEvent(component, '', '', 'passRecord');
        
        component.set('v.displaysListChannel', []);  
        component.set('v.foundChannelList', []);
        component.set('v.searchParam', '');       
        passRecord.fire();
    }
})