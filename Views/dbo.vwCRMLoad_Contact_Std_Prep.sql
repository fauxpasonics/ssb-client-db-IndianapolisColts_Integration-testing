SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create VIEW [dbo].[vwCRMLoad_Contact_Std_Prep]
AS 
SELECT
	  a.[SSB_CRMSYSTEM_ACCT_ID] SSB_CRMSYSTEM_ACCT_ID__c
	  , a.[SSB_CRMSYSTEM_CONTACT_ID] SSB_CRMSYSTEM_CONTACT_ID__c
	  , a.[Prefix]
      , a.[FirstName]
	  , a.[LastName]
	  , a.[Suffix]
      ,a.[AddressPrimaryStreet]  MailingStreet
      ,a.[AddressPrimaryCity]    MailingCity
      ,a.[AddressPrimaryState]   MailingState
      ,a.[AddressPrimaryZip]     MailingPostalCode
      ,a.[AddressPrimaryCountry] MailingCountry
      ,a.[Phone] Phone
      ,a.[crm_id] Id
	  ,b.[crm_id] AccountId
	  ,c.[LoadType]
	  ,a.EmailPrimary AS Email
	    FROM [dbo].Contact a 
	INNER JOIN dbo.Account b ON [b].[SSB_CRMSYSTEM_ACCT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID] AND b.[SSB_CRMSYSTEM_ACCT_ID] <> b.[crm_id]
	INNER JOIN dbo.[CRMLoad_Contact_ProcessLoad_Criteria] c ON [c].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]


GO
