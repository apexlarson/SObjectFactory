/**
 *  @project SObjectBuilder
 *  @group SObjectBuilder
 *  @description This class defines fields which are required, or very common, between different records of the same
 *      type. When the SObjectFactory is creating a new record, it will first get the fields and values from this class.
 *
 *      This class, unlike other classes in the SObjectBuilder package, is ment to be modified. Whenever a developer
 *      tries to create a new record and encounters an required field exception, or a failed validation rule, an entry
 *      should be added to the objectTypeToFields map to prevent that error from happening.
 */
@IsTest
public class RequiredFieldsCache {
    public class RequiredFieldsCacheException extends Exception { }
    public static final String TEMPLATE_ERROR_MSG = 'The template "{0}" for {1} does not exist in RequiredFieldsCache. Please add it before using it in a test.';
    static final Date DEFAULT_DATE = Date.today().addDays(20);

    /**
     *  @description Gets a map of field to default value for a given SObject Type and template.
     *      Generally, this method will not be called directly.
     *  @param sObjectType The sObjectType of the defaults you are trying to access.
     *  @param template (Optional) The template for this sObjectType you want.
     *  @return Default field to value map for the given sObjectType and template.
     */
    public static Map<Schema.SObjectField, Object> get(Schema.SObjectType sObjectType, String template) {
        Map<Schema.SObjectField, Object> fieldToValue = objectTypeToFields.containsKey(sObjectType) ?
            objectTypeToFields.get(sObjectType).clone() : new Map<Schema.SObjectField, Object>();

        if (String.isNotBlank(template)) {
            if (templateToFields.containsKey(sObjectType) && templateToFields.get(sObjectType).containsKey(template)) {
                fieldToValue.putAll(templateToFields.get(sObjectType).get(template));
            } else {
                String msg = String.format(TEMPLATE_ERROR_MSG, new List<String>{ template, sObjectType.getDescribe().getName() });
                throw new RequiredFieldsCacheException(msg);
            }
        }

        return fieldToValue;
    }

    /**
     *  @description This is a map of SObjectType to a map of sObjectField to default values. Whenever SObjectBuilder
     *      is used to generate an sObject, this map is used to determine the default fields for that record. Unlike
     *      the rest of this utility, this map is expected to be modified.
     *
     *      To follow best practices when using this map:
     *          # Objects should be included in the map starting with Standard Objects, then Custom Objects, and ending
     *            with Managed Objects. Within each section, the objects should be sorted alphabetically.
     *          # Only add field to values that are required in order to insert  or use a record.
     *          # objectTypeToFields should always be set up so that no additional fields must be set in order to insert
     *            the record.
     *          # If there are different, distinct types of records of the same type, use the templatesToFields map
     *            to create them. Be sure that the previous rule is still followed.
     *          # Unit tests should never rely on specific values in the required fields cache.
     */
    @TestVisible
    private static final Map<Schema.SObjectType, Map<Schema.SObjectField, Object>> objectTypeToFields =
        new Map<Schema.SObjectType, Map<Schema.SObjectField, Object>>
    {
        Account.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Account.Name => 'Some account'
        },
        Campaign.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Campaign.Name => 'do the thing'
        },
        Contact.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Contact.LastName => 'Testworth',
            Contact.Dependent_No__c => 1
        },
        Contract.sObjectType => new Map<Schema.SObjectField, Object>
        {
            //Contract.AccountId => new SObjectParentProviders.GenericParentProvider()
        },
        EmailTemplate.sObjectType => new Map<Schema.SObjectField, Object>
        {
            EmailTemplate.Name => 'Email Template Name',
            EmailTemplate.DeveloperName => 'Email_Template_Name',
            EmailTemplate.FolderId => UserInfo.getUserId(),
            EmailTemplate.IsActive => true,
            EmailTemplate.TemplateType => 'text'
        },
        Event.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Event.DurationInMinutes => 30,
            Event.ActivityDateTime => DEFAULT_DATE
        },
        Group.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Group.Name => 'Some group'
        },
        Lead.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Lead.State => 'CO',
            Lead.LastName => 'Coyote',
            Lead.Company => 'ACME, Inc.'
        },
        Opportunity.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Opportunity.StageName => 'Stage',
            Opportunity.Name => 'Some opportunity',
            Opportunity.CloseDate => DEFAULT_DATE
        },
        Pricebook2.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Pricebook2.Name => 'Test Pricebook'
        },
        PricebookEntry.sObjectType => new Map<Schema.SObjectField, Object>
        {
            //PricebookEntry.Product2Id => new SObjectParentProviders.UniqueParentProvider(),
            PricebookEntry.Pricebook2Id => Test.getStandardPricebookId(),
            PricebookEntry.UnitPrice => 7
        },
        Product2.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Product2.Name => 'SObject Builder'
        },
        User.sObjectType => new Map<Schema.SObjectField, Object>
        {
            User.IsActive => true,
            User.LastName => 'Doe',
            User.LocaleSidKey => 'en_US',
            User.LanguageLocaleKey => 'en_US',
            User.EmailEncodingKey => 'ISO-8859-1',
            User.Email => 'testxxx000@exmaple.com',
            User.TimeZoneSidKey => 'America/New_York',
            User.ProfileId => SObjectFieldProviders.standardProfileProvider,
            User.Alias => new SObjectFieldProviders.UniqueFixedLengthStringProvider('abc', 7),
            User.CommunityNickname => new SObjectFieldProviders.UniqueStringProvider('johndoe'),
            User.Username => new SObjectFieldProviders.UniqueStringProvider('test_xyz=exmaple@example.com')
        },
        FeedComment.sObjectType => new Map<Schema.SObjectField, Object>
        {
            FeedComment.FeedItemId => new SObjectParentProviders.GenericParentProvider(FeedItem.sObjectType)
        },
        FeedItem.sObjectType => new Map<Schema.SObjectField, Object>
        {
            FeedItem.ParentId => new SObjectParentProviders.GenericParentProvider(Case.sObjectType),
            FeedItem.body => 'Test Body'
        },
        Member__c.sObjectType => new Map<Schema.SObjectField, Object>
        {
            Member__c.Name => '05005055555',
            Member__c.Date_of_Birth__c => Date.valueOf('1950-01-01'),
            Member__c.Dependent_No__c => 1,
            Member__c.First_Name__c => 'Community',
            Member__c.Last_Name__c => 'Tester',
            Member__c.Group_Number__c => '12345-000-00000-00000',
            Member__c.Product_Category__c => 'Dental',
            Member__c.Member_Unique_ID__c => new SObjectFieldProviders.UniqueStringProvider()
        }
    };

    /**
     *  @description Similar to the objectTypeToFields map, this map contains templates that can be used to quickly
     *      create different types of the same record. For example, if you have two types of contacts, Customers and
     *      Providers, and each have a different record type and set of required fields, you may define two templates
     *      called "Customer" and "Provider", and when using SObjectBuilder, pass in the template to the constructor.
     *
     *      If a template requires a field set by the sobjectTypeToFields map to be null / unset, then it can override
     *      the sobjectTypeToFields map by setting that field to null. Any field set by SObjectBuilder.put() will
     *      override anything defined by this map or the sobjectTypeToFields map.
     *
     *      Best practices for using this map are:
     *          # Objects should be included in the map starting with Standard Objects, then Custom Objects, and ending
     *            with Managed Objects. Within each section, the objects should be sorted alphabetically.
     *          # Add fields which are needed to create and work with a given type of record here.
     *          # Do not add fields which are required to simply insert a record here. Those belong in the
     *            objectTypeToFields map.
     *          # templateToFields should always be set up so that no additional fields must be set in order to insert
     *            records with any template.
     *          # Unit tests should never rely on specific values in the required fields cache.
     */
    @TestVisible
    private static final Map<Schema.SObjectType, Map<String, Map<Schema.SObjectField, Object>>> templateToFields =
        new Map<Schema.SObjectType, Map<String, Map<Schema.SObjectField, Object>>>
    {
        Account.sObjectType => new Map<String, Map<Schema.SObjectField, Object>>
        {
            'Enterprise_Business' => new Map<Schema.SObjectField, Object>
            {
                Account.Name => 'Some Enterprise Account'
            },
            'Small_Business' => new Map<Schema.SObjectField, Object>
            {
                Account.Name => 'Some Small Business Account',
                Account.NumberOfEmployees => 10
            },
            'Government_Entity' => new Map<Schema.SObjectField, Object>
            {
                Account.Name => 'Some Washington Government Account',
                Account.BillingState => 'WA'
            }
        },
        Case.SObjectType => new Map<String, Map<Schema.SObjectField, Object>>
        {
            'Secure_Message' => new Map<Schema.SObjectField, Object>
            {
                Case.RecordTypeId => new SObjectFieldProviders.RecordTypeProvider('Secure_Message')
            },
            'Group_Services' => new Map<Schema.SObjectField, Object>
            {
                Case.RecordTypeId => new SObjectFieldProviders.RecordTypeProvider('Group_Services')
            },
            'Onboarding' => new Map<Schema.SObjectField, Object>
            {
                Case.RecordTypeId => new SObjectFieldProviders.RecordTypeProvider('Onboarding')
            }
        },
        Opportunity.sObjectType => new Map<String, Map<Schema.SObjectField, Object>>
        {
            'Service' => new Map<Schema.SObjectField, Object>
            {
                Opportunity.Type => 'Service Only'
            },
            'Sales' => new Map<Schema.SObjectField, Object>
            {
                Opportunity.LeadSource => 'Web'
            }
        }
    };
}