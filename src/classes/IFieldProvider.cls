/**
 *  @project SObjectBuilder
 *  @group SObjectBuilder
 *  @description An interface which, when implemented and used as a value in a call to SObjectBuilder, provides greater
 *      control over the value of the field. Instead of each record getting the same value, each record will call the
 *      getValue() method and assign its return value to that record. This will allow you to generate different values
 *      for each record being generated.
 *
 *      For examples, check the various providers which implement this interface in the SObjectFieldProviders class.
 */
public interface IFieldProvider {
    /**
     *  @description Called once per record being generated in the SObjectBuilder. the return value of this method is
     *      used as the value for that field.
     *  @return The value to be used.
     */
    Object getValue();
}