SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Upsert] AS
SELECT p.[SSB_CRMSYSTEM_ACCT_ID__c] ,
       p.[SSB_CRMSYSTEM_CONTACT_ID__c] ,
       p.Prefix ,
       p.FirstName ,
       p.LastName ,
       p.Suffix ,
       p.MailingStreet ,
       p.MailingCity ,
       p.MailingState ,
       p.MailingPostalCode ,
       p.MailingCountry ,
       p.Phone ,
       p.Email ,
       p.LoadType ,
       a.crm_id
FROM   [dbo].[vwCRMLoad_Contact_Std_Prep] p
       left JOIN dbo.Account a ON p.SSB_CRMSYSTEM_ACCT_ID__c = a.SSB_CRMSYSTEM_ACCT_ID
                                   AND a.SSB_CRMSYSTEM_ACCT_ID != a.crm_id
WHERE  LoadType = 'Upsert';
GO
