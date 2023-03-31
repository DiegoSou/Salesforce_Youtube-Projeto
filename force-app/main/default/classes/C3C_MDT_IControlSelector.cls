public interface C3C_MDT_IControlSelector {
    C3C_MDT_ControlDomain getGeneric();
    C3C_MDT_IControlSelector setGeneric(String devName);

    List<SObject> getAllMDTs();
}