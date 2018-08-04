SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Update] AS

SELECT 
a.[SSB_CRMSYSTEM_ACCT_ID__c]
, a.Name													--,b.Name
, a.BillingStreet											--,b.BillingStreet
, a.BillingCity												--,b.BillingCity
, a.BillingState											--,b.BillingState
, a.BillingPostalCode										--,b.BillingPostalCode
, a.BillingCountry											--,b.BillingCountry
, a.Phone													--,b.Phone
, a.id														--,b.id
, LoadType													
, a.PersonEmail												--,b.PersonEmail
FROM [dbo].[vwCRMLoad_Account_Std_Prep] a
JOIN prodcopy.vw_account b on a.id = b.id
LEFT JOIN (SELECT DISTINCT c.SSB_CRMSYSTEM_ACCT_ID AS SSBID, ka.Withhold_StandardUpdate
				FROM dbo.KeyAccounts_Materialized ka
				INNER JOIN dbo.contact c ON c.SSB_CRMSYSTEM_CONTACT_ID = ka.SSBID) k
		ON a.[SSB_CRMSYSTEM_ACCT_ID__c] = k.SSBID AND k.Withhold_StandardUpdate = 1
WHERE LoadType = 'Update'
AND k.ssbid is NULL
AND  (HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.Name ))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.Name ))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.BillingStreet ))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.BillingStreet ))),'')) 
	Or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(REPLACE(REPLACE(REPLACE(REPLACE(a.Phone,')',''),'(',''),'-',''),' ','') ))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(REPLACE(REPLACE(REPLACE(REPLACE(b.Phone,')',''),'(',''),'-',''),' ','') ))),'') )
	Or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.PersonEmail ))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.PersonEmail ))),'')) 
	)



GO
