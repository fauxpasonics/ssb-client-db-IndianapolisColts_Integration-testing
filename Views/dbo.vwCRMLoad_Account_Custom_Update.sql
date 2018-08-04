SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Account_Custom_Update]
AS

SELECT  z.[crm_id] id							 
, b.[SSB_CRMSYSTEM_SSID_Winner__c]						 -- ,c.[SSB_CRMSYSTEM_SSID_Winner__c]
, b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c]			 -- ,c.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c]
, b.DimCustIDs [SSB_CRMSYSTEM_DimCustomerID__c]			 -- ,c.[SSB_CRMSYSTEM_DimCustomerID__c]
, b.AccountId [SSB_CRMSYSTEM_SSID_TIX__c]				 -- ,c.[SSB_CRMSYSTEM_SSID_TIX__c]

-- SELECT *
-- SELECT COUNT(*) 
FROM dbo.[Account_Custom] b 
INNER JOIN dbo.Account z ON b.SSB_CRMSYSTEM_ACCT_ID__c = z.[SSB_CRMSYSTEM_Acct_ID]
LEFT JOIN  prodcopy.vw_Account c ON z.[crm_id] = c.id
----INNER JOIN dbo.CRMLoad_Acct_ProcessLoad_Criteria pl ON b.SSB_CRMSYSTEM_Acct_ID = pl.SSB_CRMSYSTEM_Acct_ID
LEFT JOIN (SELECT DISTINCT c.SSB_CRMSYSTEM_ACCT_ID AS SSBID, ka.Withhold_CustomUpdate
				FROM dbo.KeyAccounts_Materialized ka
				INNER JOIN dbo.contact c ON c.SSB_CRMSYSTEM_CONTACT_ID = ka.SSBID) k
		ON z.SSB_CRMSYSTEM_ACCT_ID = k.SSBID AND k.Withhold_CustomUpdate = 1
WHERE z.[SSB_CRMSYSTEM_Acct_ID] <> z.[crm_id]
AND k.SSBID is NULL
AND  (1=2
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.[SSB_CRMSYSTEM_SSID_Winner__c])),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[SSB_CRMSYSTEM_SSID_Winner__c] AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c])),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.AccountId)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.SSB_CRMSYSTEM_SSID_TIX__c AS VARCHAR(MAX)))),''))
	)
GO
