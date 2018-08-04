SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Upsert] AS
SELECT DISTINCT
    p.SSB_CRMSYSTEM_ACCT_ID__c,
    p.Name, --CONVERT(NVARCHAR(300), Name, 1252) Name,
    p.BillingStreet,
    p.BillingCity,
    p.BillingState,
    p.BillingPostalCode,
    p.BillingCountry,
    p.Phone,
    p.[LoadType],
    c.EmailPrimary AS PersonEmail,
	'0121N0000018S8UQAU' AS RecordTypeId
FROM [dbo].[vwCRMLoad_Account_Std_Prep] p
    INNER JOIN dbo.Account c WITH (NOLOCK) ON c.SSB_CRMSYSTEM_ACCT_ID = p.SSB_CRMSYSTEM_ACCT_ID__c
WHERE LoadType = 'Upsert'
      

GO
