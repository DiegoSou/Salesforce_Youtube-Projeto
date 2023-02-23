({
    addChannel : function(component, event, helper) {
        let eventC = helper.constructClickTileEvent(component, "clickAddTile");
        eventC.fire();
    },

    removeChannel : function(component, event, helper)
    {
        let eventC = helper.constructClickTileEvent(component, "clickRemoveTile");
        eventC.fire();
    }
})