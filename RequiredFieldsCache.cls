@IsTest
public class RequiredFieldsCache
{
    public static Map<Schema.SObjectField, Object> get(Schema.SObjectType sObjectType)
    {
        return objectTypeToFields.containsKey(sObjectType) ?
            objectTypeToFields.get(sObjectType) :
            new Map<Schema.SObjectField, Object>();
    }
    
    static Map<Schema.SObjectType, Map<Schema.SObjectField, Object>> objectTypeToFields =
        new Map<Schema.SObjectType, Map<Schema.SObjectField, Object>>
    {
        Lead.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Lead.State => 'CO',
            Lead.LastName => 'Coyote',
            Lead.Company => 'ACME, Inc.'
        },
        Group.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Group.Name => 'Some group'
        },
        Opportunity.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Opportunity.StageName => 'Stage',
            Opportunity.Name => 'Some opportunity',
            Opportunity.CloseDate => Date.today().addMonths(1)
        },
    };
}