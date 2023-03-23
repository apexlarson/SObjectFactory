/**
 *  @project SObjectBuilder
 *  @group SObjectBuilder
 *  @description This class keeps track of the parameters being used to generate SObjectBuilder. This information can
 *      then be passed into a dynamic provider, and is used to assist with error tracking.
 */
@IsTest
public class SObjectFactoryState {
    /**
     *  @description The number of records being generated in this call.
     */
    public final Integer count;
    /**
     *  @description The sObjectType of the records being generated.
     */
    public final Schema.SObjectType sObjectType;
    /**
     *  @description The template being used for the records being generated. This may be null.
     */
    public final String template;

    /**
     *  @description Creates a new instance of an SObjectFactoryState with the given parameters.
     *  @param count The number of records being generated in this call.
     *  @param sObjectType The sObjectType of the records being generated.
     *  @param template (Optional) The template being used for the records being generated.
     */
    public SObjectFactoryState(Integer count, Schema.SObjectType sObjectType, String template) {
        this.count = count;
        this.sObjectType = sObjectType;
        this.template = template;
    }

    /**
     *  @description Outputs the factory state in a format that is easy to read, to assist with debugging.
     *  @return A developer-friendly string describing the state of the SObjectBuilder.
     */
    public override String toString() {
        // Can't JSON serialize a SObjectType. Thanks Salesforce.
        return JSON.serialize(new Map<String, String>{
            'SObjectType' => String.valueOf(sObjectType),
            'Template' => template,
            'Count' => String.valueOf(count)
        });
    }
}