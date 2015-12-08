SObjectFactory
==============
The idea behind this utility is to generate records that can be inserted into the database of any `SObjectType` that is itself createable. Test authors should be able to specify **only data they care about**, freed from the concerns of which fields are required. A key paradigm this utility adopts is that `build` will generate record(s) but not perform any `DML`, while `create` will generate the same record(s) and insert them. This paradigm is consistent accross both the `SObjectFactory` and `SObjectBuilder` classes.

The `SObjectFactory` class is the underlying engine to accomplish the above. The core functionality resides in the final `build` method, which accepts the `sObjectType` to be created, count of records, and any additional fields. This method merges the provided field-value pairs with any in the `RequiredFieldsCache` (provided fields win), then generates a list containing the desired number and type of records with these fields filled in.

Methods in this class are best suited for creating simple record(s) where none of their data matters, or where only one field has data that is material to the test. For example:

    Id someUserId = SObjectFactory.create(User.sObjectType).Id;
    Lead someLead = (Lead)SObjectFactory.create(Lead.sObjectType, Lead.Email, 'jdoe@example.com');

RequiredFieldsCache
===================
Much of the magic in this utility lies in the RequiredFieldsCache class, which maintains a repository of all fields that must be populated, and how. I have often been asked why this step is not approached programmatically (i.e. via describes), and the answer is that the ways in which a field becomes required are more complex than such an approach can solve. Consider simply a validation rule that requires Opportunity Close Date to be at least one month in the future. Try to determine a valid value for that field programatically, let alone even that it is required. Trigger validations can get far more complex and difficult to analyze than the above example.

The only class in this utility that should need to change is the `RequiredFieldsCache`, except when a new `IFieldProvider` must be added. When you have a new object you want to be able to create with `SObjectFactory`, you simply need to populate its required fields into the cache. For example, if you added a custom setting named `My_Setting__c`:

    Map<SObjectType, Map<SObjectField, Object>> cache = new Map<SObjectType, Map<SObjectField, Object>>
    {
        My_Setting__c.sObjectType => new Map<SObjectField, Object>
        {
            My_Setting__c.Name => SObjectFactory.provideUniqueString('Setting')
        }
    }

SObjectBuilder
==============
When providing data for multiple fields, `SObjectFactory` can be fairly unwieldy. This is where `SObjectBuilder` comes in, providing syntactic sugar. Whereas the factory methods are all static, the builder methods are all instance. All methods in the builder can be chained, until calling either `getRecord` to return a single record, or `getRecords` to return a list thereof. It also has helper methods to create records as a System Administrator or mock insert by providing dummy ids.

    final Integer RECORD_COUNT = Limits.getLimitQueries() + 1;
    List<Opportunity> opportunities = new SObjectBuilder(Opportunity.sObjectType)
        .put(Opportunity.AccountId, SObjectFactory.provideGenericParent(Account.sObjectType))
        .put(Opportunity.CloseDate, SObjectFactory.provideUniqueDate())
        .provideDummyIds().count(RECORD_COUNT).build().getRecords();
    
    final String CUSTOM_SETTING_NAME = 'Some name';
    new SObjectBuilder(My_Setting__c.sObjectType)
        .put(My_Setting__c.Name, CUSTOM_SETTING_NAME)
        .createAsAdmin();

SObjectFieldProviders
=====================
Values provided to the factory do not have to be static, or even known at compile time. There are a variety of providers that allow for deferred assignment, which is especially useful when trying to create or query for related records in a limits-conscious way. These allow, for instance, to request a generic parent for a required lookup field that will not be inserted until needed. This deferred assignment is also critical in enabling chained generic parent records, for instance a `Lead` that looks up to an `Opportunity` that looks up to an `Account` that looks up to a `User`. The easiest way to access these, in general, is through the `SObjectFactory.provide` methods.

    SObjectFieldProviders.GenericParentProvider parent = SObjectFactory.provideGenericParent(
        Account.sObjectType, Account.OwnerId, SObjectFactory.provideGenericParent(User.sObjectType)
    );
    SObjectFieldProviders.UniqueStringProviders uniqueString = SObjectFactory.provideUniqueString();
    SObjectFieldProviders.MultiParentProvider parents = SObjectFactory.provideParents(Contact.sObjectType, 25);
