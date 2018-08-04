SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Update] AS
--updateme - Hashes
SELECT 
a.[SSB_CRMSYSTEM_ACCT_ID__c]									  
, a.[SSB_CRMSYSTEM_CONTACT_ID__c]								  
, a.Prefix													  --,b.Salutation
, a.FirstName												  --,b.FirstName
, a.LastName												  --,b.LastName
, a.Suffix													  --,b.Suffix
, a.MailingStreet											  --,b.MailingStreet
, a.MailingCity												  --,b.MailingCity
, a.MailingState											  --,b.MailingState
, a.MailingPostalCode										  --,b.MailingPostalCode
, a.MailingCountry											  --,b.MailingCountry
, a.Phone													  --,b.Phone
, a.Email													  --,b.Email
, a.id												  
, LoadType	
FROM [dbo].[vwCRMLoad_Contact_Std_Prep] a
JOIN prodcopy.vw_contact b ON a.id = b.id
LEFT JOIN dbo.KeyAccounts_Materialized k ON k.SSBID = a.[SSB_CRMSYSTEM_CONTACT_ID__c] AND Withhold_StandardUpdate = 1
WHERE LoadType = 'Update'
AND k.ssbid IS null
AND (1=2
OR isnull(a.FirstName,'')					  != isnull(b.FirstName,'')
OR isnull(a.LastName,'')					  != isnull(b.LastName,'')
OR isnull(a.Suffix,'')						  != isnull(b.Suffix,'')
OR isnull(a.MailingStreet,'')				  != isnull(b.MailingStreet,'')
OR isnull(a.MailingCity,'')					  != isnull(b.MailingCity,'')
OR isnull(a.MailingState,'')				  != isnull(b.MailingState,'')
OR isnull(a.MailingPostalCode,'')			  != isnull(b.MailingPostalCode,'')
OR isnull(a.MailingCountry,'')				  != isnull(b.MailingCountry,'')
OR isnull(a.Phone,'')						  != isnull(b.Phone,'')
OR isnull(a.Email,'')						  != isnull(b.Email,'')
)
GO
