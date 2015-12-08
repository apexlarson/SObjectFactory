@IsTest
public class RequiredFieldsCache
{
    public static Map<SObjectField, Object> get(SObjectType sObjectType)
    {
        return cache.containsKey(sObjectType) ?
            cache.get(sObjectType) : new Map<SObjectField, Object>();
    }

    public static IFieldProvider getGenericParentProvider(SObjectType sObjectType)
    {
        if (!genericParentProviders.containsKey(sObjectType))
            genericParentProviders.put(sObjectType, SObjectFactory.provideGenericParent(sObjectType));
        return genericParentProviders.get(sObjectType);
    }
    static Map<SObjectType, IFieldProvider> genericParentProviders = new Map<SObjectType, IFieldProvider>();
    
    static Map<SObjectType, Map<SObjectField, Object>> cache =
        new Map<SObjectType, Map<SObjectField, Object>>
    {
        Account.sObjectType => new Map<SObjectField, Object>
        {
            Account.Name => 'Some Account'
        },
        AccountContactRole.sObjectType => new Map<SObjectField, Object>
        {
            AccountContactRole.AccountId => getGenericParentProvider(Account.sObjectType),
            AccountContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        AccountShare.sObjectType => new Map<SObjectField, Object>
        {
            AccountShare.AccountAccessLevel => 'Edit',
            AccountShare.OpportunityAccessLevel => 'Edit',
            AccountShare.AccountId => getGenericParentProvider(Account.sObjectType),
            AccountShare.UserOrGroupId => getGenericParentProvider(Group.sObjectType)
        },
        AccountTeamMember.sObjectType => new Map<SObjectField, Object>
        {
            AccountTeamMember.AccountId => getGenericParentProvider(Account.sObjectType),
            AccountTeamMember.UserId => getGenericParentProvider(User.sObjectType)
        },
        Announcement.sObjectType => new Map<SObjectField, Object>
        {
            Announcement.FeedItemId => SObjectFactory.provideGenericParent(FeedItem.sObjectType, FeedItem.ParentId, getGenericParentProvider(CollaborationGroup.sObjectType)),
            Announcement.ExpirationDate => Date.today().addDays(1)
        },
        Asset.sObjectType => new Map<SObjectField, Object>
        {
            Asset.AccountId => getGenericParentProvider(Account.sObjectType),
            Asset.Name => 'Some Asset'
        },
        Attachment.sObjectType => new Map<SObjectField, Object>
        {
            Attachment.ParentId => getGenericParentProvider(Account.sObjectType),
            Attachment.Body => Blob.valueOf('body'),
            Attachment.Name => 'Some Attachment'
        },
        Campaign.sObjectType => new Map<SObjectField, Object>
        {
            Campaign.Name => 'Some Campaign'
        },
        CampaignMember.sObjectType => new Map<SObjectField, Object>
        {
            CampaignMember.CampaignId => getGenericParentProvider(Campaign.sObjectType),
            CampaignMember.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        CaseArticle.sObjectType => new Map<SObjectField, Object>
        {
            CaseArticle.CaseId => getGenericParentProvider(Case.sObjectType),
            CaseArticle.KnowledgeArticleId => SObjectFactory.provideQueriedParent(KnowledgeArticle.sObjectType)
        },
        CaseComment.sObjectType => new Map<SObjectField, Object>
        {
            CaseComment.ParentId => getGenericParentProvider(Case.sObjectType)
        },
        CaseContactRole.sObjectType => new Map<SObjectField, Object>
        {
            CaseContactRole.CasesId => getGenericParentProvider(Case.sObjectType),
            CaseContactRole.ContactId => getGenericParentProvider(Contact.sObjectType),
            CaseContactRole.Role => 'Role'
        },
        CaseShare.sObjectType => new Map<SObjectField, Object>
        {
            CaseShare.CaseId => getGenericParentProvider(Case.sObjectType),
            CaseShare.UserOrGroupId => getGenericParentProvider(Group.sObjectType),
            CaseShare.CaseAccessLevel => 'Edit'
        },
        CaseSolution.sObjectType => new Map<SObjectField, Object>
        {
            CaseSolution.CaseId => getGenericParentProvider(Case.sObjectType),
            CaseSolution.SolutionId => getGenericParentProvider(Solution.sObjectType)
        },
        CaseTeamMember.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamMember.TeamRoleId => getGenericParentProvider(CaseTeamRole.sObjectType),
            CaseTeamMember.ParentId => getGenericParentProvider(Case.sObjectType),
            CaseTeamMember.MemberId => getGenericParentProvider(User.sObjectType)
        },
        CaseTeamRole.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamRole.Name => SObjectFactory.provideUniqueString('Some Role'),
            CaseTeamRole.AccessLevel => 'Edit'
        },
        CaseTeamTemplate.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamTemplate.Name => SObjectFactory.provideUniqueString('Some Template')
        },
        CaseTeamTemplateMember.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamTemplateMember.TeamTemplateId => getGenericParentProvider(CaseTeamTemplate.sObjectType),
            CaseTeamTemplateMember.TeamRoleId => getGenericParentProvider(CaseTeamRole.sObjectType),
            CaseTeamTemplateMember.MemberId => getGenericParentProvider(User.sObjectType)
        },
        CaseTeamTemplateRecord.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamTemplateRecord.TeamTemplateId => getGenericParentProvider(CaseTeamTemplate.sObjectType),
            CaseTeamTemplateRecord.ParentId => getGenericParentProvider(Case.sObjectType)
        },
        CollaborationGroup.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroup.Name => SObjectFactory.provideUniqueString('Chatter Group'),
            CollaborationGroup.CollaborationType => 'Public'
        },
        CollaborationGroupMember.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroupMember.CollaborationGroupId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationGroupMember.MemberId => getGenericParentProvider(User.sObjectType)
        },
        CollaborationGroupRecord.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroupRecord.CollaborationGroupId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationGroupRecord.RecordId => getGenericParentProvider(Account.sObjectType)
        },
        CollaborationGroupMemberRequest.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroupMemberRequest.CollaborationGroupId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationGroupMemberRequest.RequesterId => UserInfo.getUserId()
        },
        CollaborationInvitation.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationInvitation.SharedEntityId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationInvitation.InvitedUserEmail => 'jdoe@counsyl.com'
        },
        Contact.sObjectType => new Map<SObjectField, Object>
        {
            Contact.LastName => 'Doe'
        },
        ContentVersion.sObjectType => new Map<SObjectField, Object>
        {
            ContentVersion.Title => 'Some Content',
            ContentVersion.PathOnClient => 'some/path',
            ContentVersion.VersionData => Blob.valueOf('data')
        },
        Contract.sObjectType => new Map<SObjectField, Object>
        {
            Contract.AccountId => getGenericParentProvider(Account.sObjectType)
        },
        ContractContactRole.sObjectType => new Map<SObjectField, Object>
        {
            ContractContactRole.ContractId => getGenericParentProvider(Contract.sObjectType),
            ContractContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        ContractLineItem.sObjectType => new Map<SObjectField, Object>
        {
            ContractLineItem.ServiceContractId => getGenericParentProvider(ServiceContract.sObjectType),
            ContractLineItem.PricebookEntryId => getGenericParentProvider(PricebookEntry.sObjectType),
            ContractLineItem.Quantity => 1,
            ContractLineItem.UnitPrice => 1
        },
        Document.sObjectType => new Map<SObjectField, Object>
        {
            Document.FolderId => getGenericParentProvider(User.sObjectType),
            Document.Name => 'Some Document'
        },
        EmailMessage.sObjectType => new Map<SObjectField, Object>
        {
            EmailMessage.ParentId => getGenericParentProvider(Case.sObjectType)
        },
        EmailTemplate.sObjectType => new Map<SObjectField, Object>
        {
            EmailTemplate.DeveloperName => SObjectFactory.provideUniqueString('Template'),
            EmailTemplate.FolderId => getGenericParentProvider(User.sObjectType),
            EmailTemplate.TemplateType => 'Text',
            EmailTemplate.Name => 'Some Template'
        },
        Entitlement.sObjectType => new Map<SObjectField, Object>
        {
            Entitlement.AccountId => getGenericParentProvider(Account.sObjectType),
            Entitlement.Name => 'Some Entitlement'
        },
        EntitlementContact.sObjectType => new Map<SObjectField, Object>
        {
            EntitlementContact.EntitlementId => getGenericParentProvider(Entitlement.sObjectType),
            EntitlementContact.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        EntitlementTemplate.sObjectType => new Map<SObjectField, Object>
        {
            EntitlementTemplate.Name => SObjectFactory.provideUniqueString('Template')
        },
        EntitySubscription.sObjectType => new Map<SObjectField, Object>
        {
            EntitySubscription.ParentId => getGenericParentProvider(Account.sObjectType),
            EntitySubscription.SubscriberId => getGenericParentProvider(User.sObjectType)
        },
        Event.sObjectType => new Map<SObjectField, Object>
        {
            Event.ActivityDateTime => Datetime.now(),
            Event.DurationInMinutes => 60
        },
        EventRelation.sObjectType => new Map<SObjectField, Object>
        {
            EventRelation.EventId => getGenericParentProvider(Event.sObjectType),
            EventRelation.RelationId => getGenericParentProvider(User.sObjectType)
        },
        FeedComment.sObjectType => new Map<SObjectField, Object>
        {
            FeedComment.FeedItemId => getGenericParentProvider(FeedItem.sObjectType),
            FeedComment.CommentBody => 'Some Comment'
        },
        FeedItem.sObjectType => new Map<SObjectField, Object>
        {
            FeedItem.ParentId => getGenericParentProvider(Account.sObjectType),
            FeedItem.Body => 'Some Content'
        },
        FeedLike.sObjectType => new Map<SObjectField, Object>
        {
            FeedLike.FeedItemId => getGenericParentProvider(FeedItem.sObjectType)
        },
        SObjectType.FieldPermissions.getSObjectType() => new Map<SObjectField, Object>
        {
            FieldPermissions.Field => String.valueOf(Opportunity.sObjectType) + '.' + String.valueOf(Opportunity.Amount),
            FieldPermissions.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
            FieldPermissions.SObjectType => String.valueOf(Opportunity.sObjectType),
            FieldPermissions.PermissionsRead => true
        },
        GoogleDoc.sObjectType => new Map<SObjectField, Object>
        {
            GoogleDoc.Url => SObjectFactory.provideUniqueString('https://docs.google.com/a/example.com/file/d/'),
            GoogleDoc.ParentId => getGenericParentProvider(Account.sObjectType),
            GoogleDoc.Name => 'Some Document'
        },
        Group.sObjectType => new Map<SObjectField, Object>
        {
            Group.Name => 'Some Group'
        },
        GroupMember.sObjectType => new Map<SObjectField, Object>
        {
            GroupMember.GroupId => getGenericParentProvider(Group.sObjectType),
            GroupMember.UserOrGroupId => getGenericParentProvider(User.sObjectType)
        },
        Holiday.sObjectType => new Map<SObjectField, Object>
        {
            Holiday.Name => 'Some Holiday',
            Holiday.ActivityDate => Date.today()
        },
        Idea.sObjectType => new Map<SObjectField, Object>
        {
            Idea.CommunityId => SObjectFactory.provideQueriedParent(Community.sObjectType),
            Idea.Categories => 'Training',
            Idea.Title => 'Some Idea'
        },
        IdeaComment.sObjectType => new Map<SObjectField, Object>
        {
            IdeaComment.IdeaId => getGenericParentProvider(Idea.sObjectType)
        },
        Lead.sObjectType => new Map<SObjectField, Object>
        {
            Lead.LastName => 'Doe',
            Lead.Company => 'ACME'
        },
        LeadShare.sObjectType => new Map<SObjectField, Object>
        {
            LeadShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            LeadShare.LeadId => getGenericParentProvider(Lead.sObjectType),
            LeadShare.LeadAccessLevel => 'Edit'
        },
        LiveAgentSession.sObjectType => new Map<SObjectField, Object>
        {
            LiveAgentSession.AgentId => getGenericParentProvider(User.sObjectType),
            LiveAgentSession.LoginTime => Datetime.now(),
            LiveAgentSession.LogoutTime => Datetime.now()
        },
        LiveAgentSessionShare.sObjectType => new Map<SObjectField, Object>
        {
            LiveAgentSessionShare.ParentId => getGenericParentProvider(LiveAgentSession.sObjectType),
            LiveAgentSessionShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            LiveAgentSessionShare.AccessLevel => 'Edit'
        },
        LiveChatTranscript.sObjectType => new Map<SObjectField, Object>
        {
            LiveChatTranscript.LiveChatVisitorId => getGenericParentProvider(LiveChatVisitor.sObjectType)
        },
        LiveChatTranscriptEvent.sObjectType => new Map<SObjectField, Object>
        {
            LiveChatTranscriptEvent.LiveChatTranscriptId => getGenericParentProvider(LiveChatTranscript.sObjectType),
            LiveChatTranscriptEvent.Time => Datetime.now(),
            LiveChatTranscriptEvent.Type => 'Transfer'
        },
        LiveChatTranscriptShare.sObjectType => new Map<SObjectField, Object>
        {
            LiveChatTranscriptShare.ParentId => getGenericParentProvider(LiveChatTranscript.sObjectType),
            LiveChatTranscriptShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            LiveChatTranscriptShare.AccessLevel => 'Edit'
        },
        LiveChatTranscriptSkill.sObjectType => new Map<SObjectField, Object>
        {
            LiveChatTranscriptSkill.TranscriptId => getGenericParentProvider(LiveChatTranscript.sObjectType),
            LiveChatTranscriptSkill.SkillId => SObjectFactory.provideQueriedParent(Skill.sObjectType)
        },
        MilestoneType.sObjectType => new Map<SObjectField, Object>
        {
            MilestoneType.Name => SObjectFactory.provideUniqueString('MilestoneType')
        },
        NetworkModeration.sObjectType => new Map<SObjectField, Object>
        {
            NetworkModeration.NetworkId => SObjectFactory.provideQueriedParent(Community.sObjectType),
            NetworkModeration.EntityId => getGenericParentProvider(FeedItem.sObjectType)
        },
        Note.sObjectType => new Map<SObjectField, Object>
        {
            Note.ParentId => getGenericParentProvider(Account.sObjectType),
            Note.Title => 'Some Note'
        },
        SObjectType.ObjectPermissions.getSObjectType() => new Map<SObjectField, Object>
        {
            ObjectPermissions.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
            ObjectPermissions.SObjectType => String.valueOf(Account.sObjectType),
            ObjectPermissions.PermissionsRead => true
        },
        Opportunity.sObjectType => new Map<SObjectField, Object>
        {
            Opportunity.AccountId => getGenericParentProvider(Account.sObjectType),
            Opportunity.Name => 'Some Opportunity',
            Opportunity.StageName => 'Some Stage',
            Opportunity.CloseDate => Date.today()
        },
        OpportunityCompetitor.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityCompetitor.OpportunityId => getGenericParentProvider(Opportunity.sObjectType)
        },
        OpportunityContactRole.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityContactRole.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
            OpportunityContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        OpportunityLineItem.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityLineItem.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
            OpportunityLineItem.PricebookEntryId => getGenericParentProvider(PricebookEntry.sObjectType),
            OpportunityLineItem.UnitPrice => 1,
            OpportunityLineItem.Quantity => 1
        },
        OpportunityShare.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityShare.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
            OpportunityShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            OpportunityShare.OpportunityAccessLevel => 'Edit'
        },
        Partner.sObjectType => new Map<SObjectField, Object>
        {
            Partner.AccountFromId => getGenericParentProvider(Account.sObjectType),
            Partner.AccountToId => SObjectFactory.provideGenericParent(Account.sObjectType)
        },
        PermissionSet.sObjectType => new Map<SObjectField, Object>
        {
            PermissionSet.Name => SObjectFactory.provideUniqueString('TestPermissions'),
            PermissionSet.Label => SObjectFactory.provideUniqueString('Test Permissions')
        },
        PermissionSetAssignment.sObjectType => new Map<SObjectField, Object>
        {
            PermissionSetAssignment.PermissionSetId => getGenericParentProvider(PermissionSet.sObjectType),
            PermissionSetAssignment.AssigneeId => getGenericParentProvider(User.sObjectType)
        },
        Pricebook2.sObjectType => new Map<SObjectField, Object>
        {
            Pricebook2.Name => 'Some Pricebook'
        },
        PricebookEntry.sObjectType => new Map<SObjectField, Object>
        {
            PricebookEntry.Product2Id => getGenericParentProvider(Product2.sObjectType),
            PricebookEntry.Pricebook2Id => Test.getStandardPricebookId(),
            PricebookEntry.IsActive => true,
            PricebookEntry.UnitPrice => 1
        },
        Product2.sObjectType => new Map<SObjectField, Object>
        {
            Product2.Name => 'Some Product'
        },
        ProductEntitlementTemplate.sObjectType => new Map<SObjectField, Object>
        {
            ProductEntitlementTemplate.EntitlementTemplateId => getGenericParentProvider(EntitlementTemplate.sObjectType),
            ProductEntitlementTemplate.Product2Id => getGenericParentProvider(Product2.sObjectType)
        },
        PushTopic.sObjectType => new Map<SObjectField, Object>
        {
            PushTopic.Name => SObjectFactory.provideUniqueString('PushTopic'),
            PushTopic.Query => 'SELECT Id FROM Account WHERE Name = null',
            PushTopic.ApiVersion => 35
        },
        QuantityForecast.sObjectType => new Map<SObjectField, Object>
        {
            QuantityForecast.OwnerId => SObjectFactory.provideGenericParent(User.sObjectType, User.ForecastEnabled, true),
            QuantityForecast.StartDate => Date.today(),
            QuantityForecast.Quota => 10
        },
        Question.sObjectType => new Map<SObjectField, Object>
        {
            Question.CommunityId => SObjectFactory.provideQueriedParent(Community.sObjectType),
            Question.Title => 'Some Question'
        },
        QuestionDataCategorySelection.sObjectType => new Map<SObjectField, Object>
        {
            QuestionDataCategorySelection.ParentId => getGenericParentProvider(Question.sObjectType),
            QuestionDataCategorySelection.DataCategoryName => 'Privacy_and_Security',
            QuestionDataCategorySelection.DataCategoryGroupName => 'Support'
        },
        SObjectType.QueueSobject.getSObjectType() => new Map<SObjectField, Object>
        {
            QueueSobject.QueueId => SObjectFactory.provideGenericParent(Group.sObjectType, Group.Type, 'Queue'),
            QueueSobject.SobjectType => String.valueOf(Case.sObjectType)
        },
        QuickText.sObjectType => new Map<SObjectField, Object>
        {
            QuickText.Message => 'Some Message',
            QuickText.Name => 'Some Text'
        },
        QuickTextShare.sObjectType => new Map<SObjectField, Object>
        {
            QuickTextShare.ParentId => getGenericParentProvider(QuickText.sObjectType),
            QuickTextShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            QuickTextShare.AccessLevel => 'Edit'
        },
        Reply.sObjectType => new Map<SObjectField, Object>
        {
            Reply.QuestionId => getGenericParentProvider(Question.sObjectType),
            Reply.Body => 'Some Body'
        },
        RevenueForecast.sObjectType => new Map<SObjectField, Object>
        {
            RevenueForecast.OwnerId => SObjectFactory.provideGenericParent(User.sObjectType, User.ForecastEnabled, true),
            RevenueForecast.StartDate => Date.today(),
            RevenueForecast.Quota => 10
        },
        SearchPromotionRule.sObjectType => new Map<SObjectField, Object>
        {
            SearchPromotionRule.Query => 'some query'
        },
        ServiceContract.sObjectType => new Map<SObjectField, Object>
        {
            ServiceContract.Pricebook2Id => Test.getStandardPricebookId(),
            ServiceContract.Name => 'Some Contract'
        },
        ServiceContractShare.sObjectType => new Map<SObjectField, Object>
        {
            ServiceContractShare.ParentId => getGenericParentProvider(ServiceContract.sObjectType),
            ServiceContractShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            ServiceContractShare.AccessLevel => 'Edit'
        },
        Solution.sObjectType => new Map<SObjectField, Object>
        {
            Solution.SolutionName => 'Some Solution'
        },
        SetupEntityAccess.sObjectType => new Map<SObjectField, Object>
        {
            SetupEntityAccess.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
            SetupEntityAccess.SetupEntityId => SObjectFactory.provideQueriedParent(
                'SELECT Id FROM ApexClass WHERE NamespacePrefix = null LIMIT 1'
            )
        },
        SocialPersona.sObjectType => new Map<SObjectField, Object>
        {
            SocialPersona.ParentId => getGenericParentProvider(Account.sObjectType),
            SocialPersona.Provider => 'Twitter',
            SocialPersona.Name => 'Somebody'
        },
        SocialPost.sObjectType => new Map<SObjectField, Object>
        {
            SocialPost.Name => 'Some Post'
        },
        SocialPostShare.sObjectType => new Map<SObjectField, Object>
        {
            SocialPostShare.ParentId => getGenericParentProvider(SocialPost.sObjectType),
            SocialPostShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            SocialPostShare.AccessLevel => 'Edit'
        },
        StreamingChannel.sObjectType => new Map<SObjectField, Object>
        {
            StreamingChannel.Name => SObjectFactory.provideUniqueString('/u/TestChannel')
        },
        StreamingChannelShare.sObjectType => new Map<SObjectField, Object>
        {
            StreamingChannelShare.ParentId => getGenericParentProvider(StreamingChannel.sObjectType),
            StreamingChannelShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            StreamingChannelShare.AccessLevel => 'Edit'
        },
        Topic.sObjectType => new Map<SObjectField, Object>
        {
            Topic.Name => SObjectFactory.provideUniqueString('Topic')
        },
        TopicAssignment.sObjectType => new Map<SObjectField, Object>
        {
            TopicAssignment.EntityId => getGenericParentProvider(FeedItem.sObjectType),
            TopicAssignment.TopicId => getGenericParentProvider(Topic.sObjectType)
        },
        User.sObjectType => new Map<SObjectField, Object>
        {
            User.LastName => 'Doe',
            User.LocaleSidKey => 'en_US',
            User.Email => 'jdoe@example.com',
            User.LanguageLocaleKey => 'en_US',
            User.EmailEncodingKey => 'ISO-8859-1',
            User.TimeZoneSidKey => 'America/Denver',
            User.ProfileId => SObjectFactory.provideStandardProfile(),
            User.Alias => SObjectFactory.provideUniqueFixedLengthString('jdoe', 7),
            User.CommunityNickname => SObjectFactory.provideUniqueString('johndoe'),
            User.Username => SObjectFactory.provideUniqueString('1234567890abcxyz@example.com')
        },
        UserPackageLicense.sObjectType => new Map<SObjectField, Object>
        {
            UserPackageLicense.UserId => getGenericParentProvider(User.sObjectType),
            UserPackageLicense.PackageLicenseId => SObjectFactory.provideQueriedParent(PackageLicense.sObjectType)
        },
        UserProvisioningRequest.sObjectType => new Map<SObjectField, Object>
        {
            UserProvisioningRequest.State => 'New',
            UserProvisioningRequest.Operation => 'Read',
            UserProvisioningRequest.ApprovalStatus => 'Denied'
        },
        UserProvisioningRequestShare.sObjectType => new Map<SObjectField, Object>
        {
            UserProvisioningRequestShare.ParentId => getGenericParentProvider(UserProvisioningRequest.sObjectType),
            UserProvisioningRequestShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            UserProvisioningRequestShare.AccessLevel => 'Edit'
        },
        UserRole.sObjectType => new Map<SObjectField, Object>
        {
            UserRole.Name => 'Some Role'
        },
        UserShare.sObjectType => new Map<SObjectField, Object>
        {
            UserShare.UserId => getGenericParentProvider(User.sObjectType),
            UserShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            UserShare.UserAccessLevel => 'Edit'
        },
        Vote.sObjectType => new Map<SObjectField, Object>
        {
            Vote.ParentId => getGenericParentProvider(Question.sObjectType),
            Vote.Type => 'Up'
        }
    };
}