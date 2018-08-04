SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Contact_Custom_Update]
AS

SELECT  z.[crm_id] id
, b.[SSB_CRMSYSTEM_SSID_Winner__c]								-- ,c.[SSB_CRMSYSTEM_SSID_Winner__c]
,b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c]					-- ,c.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c]
, b.SSB_CRMSYSTEM_DimCustomerID__c								-- ,c.[SSB_CRMSYSTEM_DimCustomerID__c]
, b.AccountId [SSB_CRMSYSTEM_SSID_TIX__c]						-- ,c.[SSB_CRMSYSTEM_SSID_TIX__c]
, b.Account_Type_Description__c	
, b.Current_Group_Buyer__c	
, b.Current_STH__c	
, b.Is_Renewed__c	
, b.Previous_Group_Buyer__c	
, b.Previous_STH__c	
, b.Ticket_Buyer_Tenure__c	
, b.Ticket_Buyer_Since_Date__c
-- SELECT *
-- SELECT COUNT(*) 
FROM dbo.[Contact_Custom] b 
INNER JOIN dbo.Contact z ON b.SSB_CRMSYSTEM_CONTACT_ID__c = z.[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN  prodcopy.vw_contact c ON z.[crm_id] = c.id
--INNER JOIN dbo.CRMLoad_Contact_ProcessLoad_Criteria pl ON b.SSB_CRMSYSTEM_CONTACT_ID = pl.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN dbo.KeyAccounts_Materialized k ON k.ssbid = z.SSB_CRMSYSTEM_CONTACT_ID AND k.Withhold_CustomUpdate = 1
WHERE z.[SSB_CRMSYSTEM_CONTACT_ID] <> z.[crm_id]
AND k.ssbid IS NULL
AND  (1=2
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.[SSB_CRMSYSTEM_SSID_Winner__c])),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[SSB_CRMSYSTEM_SSID_Winner__c] AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c])),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(b.AccountId)),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.[SSB_CRMSYSTEM_SSID_TIX__c] AS VARCHAR(MAX)))),''))
	OR ISNULL(b.Account_Type_Description__c,'')	!= ISNULL(c.Account_Type_Description__c,'')	
	OR ISNULL(b.Current_Group_Buyer__c	,'')!= ISNULL(c.Current_Group_Buyer__c	,'')
	OR ISNULL(b.Current_STH__c	,'')!= ISNULL(c.Current_STH__c	,'')
	OR ISNULL(b.Is_Renewed__c	,'')!= ISNULL(c.Is_Renewed__c	,'')
	OR ISNULL(b.Previous_Group_Buyer__c	,'')!= ISNULL(c.Previous_Group_Buyer__c	,'')
	OR ISNULL(b.Previous_STH__c	,'')!= ISNULL(c.Previous_STH__c	,'')
	OR ISNULL(b.Ticket_Buyer_Tenure__c	,'')!= ISNULL(c.Ticket_Buyer_Tenure__c	,'')
	OR ISNULL(b.Ticket_Buyer_Since_Date__c,'')!= ISNULL(c.Ticket_Buyer_Since_Date__c,'')
	)
GO
