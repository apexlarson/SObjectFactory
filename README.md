SObjectFactory
==============
The idea behind this project is to write a Testing Utility to kill all Testing Utilities. Well, perhaps that is overstating the scope a little bit. But it should be able to create any type of sObject you want in a form that can be inserted into the database.

The core of the logic is in the eponymous SObjectFactory class, which is kept concise through the use of a few field repositories that will populate required information as needed. I am playing around with a Builder to wrap the syntax and handle more complex responsibilities.

Examples
--------
    User someUserINeed = (User)SObjectFactory.create(User.sObjectType);
    List<Account> accountsOwnedByThisUser = SObjectFactory.create(
        10, Account.sObjectType, new Map<Schema.SObjectField, Object>
        {
            Account.OwnerId => someUserINeed.Id
        }
    );
