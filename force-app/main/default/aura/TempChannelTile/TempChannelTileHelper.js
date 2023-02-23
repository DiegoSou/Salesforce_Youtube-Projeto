({
    constructClickTileEvent : function(component, nameEvent) {
        let objData = component.get("v.tempChannel");
        let indexTile = component.get("v.index");
        let eventC = component.getEvent(nameEvent);

        eventC.setParams({
            objData : objData,
            indexTile : indexTile
        });

        return eventC;
    }
})