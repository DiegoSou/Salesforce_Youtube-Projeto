({
    constructClickTileEvent : function(component, nameEvent) {
        let objData = component.get("v.tempChannel");
        let indexTile = component.get("v.index");
        let eventC = component.getEvent(nameEvent);

        eventC.setParams({
            channelTile : objData,
            index : indexTile
        });

        return eventC;
    }
})