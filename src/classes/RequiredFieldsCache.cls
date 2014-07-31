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
        Account.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Account.Name => 'Some account'
        },
        Opportunity.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Opportunity.StageName => 'Stage',
            Opportunity.Name => 'Some opportunity',
            Opportunity.CloseDate => Date.today().addMonths(1)
        },
        User.sObjectType => new Map<Schema.SObjectField, Object>
        {
            User.IsActive => true,
            User.LastName => 'Doe',
            User.LocaleSidKey => 'en_US',
            User.LanguageLocaleKey => 'en_US',
            User.EmailEncodingKey => 'ISO-8859-1',
            User.Email => 'testxxx000' +'@test.com',
            User.TimeZoneSidKey => 'America/New_York',
            
            User.ProfileId => GenericIdCache.get(Profile.sObjectType)
        }
    };
}