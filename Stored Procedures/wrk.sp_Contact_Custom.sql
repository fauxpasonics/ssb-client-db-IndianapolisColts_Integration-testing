SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [wrk].[sp_Contact_Custom]
AS 

MERGE INTO dbo.Contact_Custom Target
USING dbo.Contact source
ON source.[SSB_CRMSYSTEM_CONTACT_ID] = target.[SSB_CRMSYSTEM_CONTACT_ID__c]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([SSB_CRMSYSTEM_ACCT_ID__c], [SSB_CRMSYSTEM_CONTACT_ID__c]) VALUES (source.[SSB_CRMSYSTEM_ACCT_ID], Source.[SSB_CRMSYSTEM_CONTACT_ID])
WHEN NOT MATCHED BY SOURCE THEN
DELETE ;

EXEC dbo.sp_CRMProcess_ConcatIDs 'Contact'

UPDATE a
SET a.[SSB_CRMSYSTEM_SSID_Winner__c] = b.[SSID], a.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] = b.SourceSystem
FROM [dbo].Contact_Custom a
INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b ON b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID__c]

--UPDATE a
--SET SeasonTicket_Years = recent.SeasonTicket_Years
----SELECT *
--FROM dbo.[Contact_Custom] a
--INNER JOIN dbo.CRMProcess_DistinctContacts recent ON [recent].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]

--====================
--Current STH
--Date: 7/23/2018
--Modified By:
--Modified On:
--====================

SELECT DISTINCT mac.SSB_CRMSYSTEM_CONTACT_ID, 1 AS 'Current STH Flag' 
INTO #curr_sth
FROM IndianapolisColts.dbo.FactTicketSales_V2 fts 
INNER JOIN IndianapolisColts.dbo.DimPlan_V2 pln ON fts.DimPlanId = pln.DimPlanId
INNER JOIN IndianapolisColts.dbo.DimTicketCustomer_V2 dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
INNER JOIN IndianapolisColts.dbo.vwDimCustomer_ModAcctId mac ON dtc.ETL__SSID_TM_acct_id = mac.AccountId
AND mac.SourceSystem = 'TM' AND mac.CustomerType = 'Primary'
WHERE fts.DimSeasonId = 20
AND fts.DimPlanId IN (9,10)



UPDATE cc 
SET cc.Current_STH__c = #curr_sth.[Current STH Flag]
FROM dbo.Contact_Custom cc
LEFT JOIN #curr_sth ON cc.SSB_CRMSYSTEM_Contact_ID__c = SSB_CRMSYSTEM_CONTACT_ID


--====================
--Previous STH
--Date: 7/23/2018
--Modified By:
--Modified On:
--====================

SELECT DISTINCT mac.SSB_CRMSYSTEM_CONTACT_ID, 1 AS 'Previous STH Flag' 
INTO #prev_sth
FROM IndianapolisColts.dbo.FactTicketSales_V2 fts 
INNER JOIN IndianapolisColts.dbo.DimPlan_V2 pln ON fts.DimPlanId = pln.DimPlanId
INNER JOIN IndianapolisColts.dbo.DimTicketCustomer_V2 dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
INNER JOIN IndianapolisColts.dbo.vwDimCustomer_ModAcctId mac ON dtc.ETL__SSID_TM_acct_id = mac.AccountId
AND mac.SourceSystem = 'TM' AND mac.CustomerType = 'Primary'
WHERE fts.DimSeasonId IN (8,10)
AND fts.DimPlanId IN (3,4)

UPDATE cc
SET cc.Previous_STH__c = #prev_sth.[Previous STH Flag]
FROM dbo.Contact_Custom cc
LEFT JOIN #prev_sth ON cc.SSB_CRMSYSTEM_Contact_ID__c = SSB_CRMSYSTEM_CONTACT_ID



--====================
--Current Group
--Date: 7/23/2018
--Modified By:
--Modified On:
--====================

SELECT DISTINCT mac.SSB_CRMSYSTEM_CONTACT_ID ,1 AS 'Current Group Buyer'
INTO #curr_group
FROM IndianapolisColts.dbo.FactTicketSales_V2 fts
INNER JOIN IndianapolisColts.dbo.DimPriceCode_V2 dpc ON fts.DimPriceCodeId = dpc.DimPriceCodeId
INNER JOIN IndianapolisColts.dbo.DimTicketCustomer_V2 dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
INNER JOIN IndianapolisColts.dbo.vwDimCustomer_ModAcctId mac ON dtc.ETL__SSID_TM_acct_id = mac.AccountId
AND mac.SourceSystem = 'TM'
AND mac.CustomerType = 'Primary'
WHERE dpc.PC2 = 'G'
AND fts.DimSeasonId = 20


UPDATE cc
SET cc.Current_Group_Buyer__c = #curr_group.[Current Group Buyer]
FROM dbo.Contact_Custom cc
LEFT JOIN #curr_group ON cc.SSB_CRMSYSTEM_Contact_ID__c = SSB_CRMSYSTEM_CONTACT_ID



--====================
--Previous Group
--Date: 7/23/2018
--Modified By:
--Modified On:
--====================


SELECT DISTINCT mac.SSB_CRMSYSTEM_CONTACT_ID ,1 AS 'Previous Group Buyer'
INTO #prev_group
FROM IndianapolisColts.dbo.FactTicketSales_V2 fts
INNER JOIN IndianapolisColts.dbo.DimPriceCode_V2 dpc ON fts.DimPriceCodeId = dpc.DimPriceCodeId
INNER JOIN IndianapolisColts.dbo.DimTicketCustomer_V2 dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
INNER JOIN IndianapolisColts.dbo.vwDimCustomer_ModAcctId mac ON dtc.ETL__SSID_TM_acct_id = mac.AccountId
AND mac.CustomerType = 'Primary'
WHERE dpc.PC2 = 'G'
AND fts.DimSeasonId IN (8,10)


UPDATE cc 
SET cc.Previous_Group_Buyer__c = #prev_group.[Previous Group Buyer]
FROM dbo.Contact_Custom cc
LEFT JOIN #prev_group ON cc.SSB_CRMSYSTEM_Contact_ID__c = SSB_CRMSYSTEM_CONTACT_ID

--====================
--Is Renewed
--Date: 7/23/2018
--Modified By:
--Modified On:
--====================

SELECT x.SSB_CRMSYSTEM_CONTACT_ID, CASE WHEN x.[Renewal Pct] > .2 THEN 1 ELSE 0 END AS [Is Renewed]
INTO #is_renew
FROM
(
	SELECT DISTINCT mac.SSB_CRMSYSTEM_CONTACT_ID,
	CASE WHEN SUM(fts.TM_block_purchase_price) = 0 THEN 1 ELSE SUM(fts.PaidAmount) END/CASE WHEN SUM(fts.TM_block_purchase_price) = 0 THEN 1 ELSE SUM(fts.TM_block_purchase_price) END AS [Renewal Pct]
	FROM IndianapolisColts.dbo.FactTicketSales_V2 fts 
	INNER JOIN IndianapolisColts.dbo.DimPlan_V2 pln ON fts.DimPlanId = pln.DimPlanId
	INNER JOIN IndianapolisColts.dbo.DimTicketCustomer_V2 dtc ON fts.DimTicketCustomerId = dtc.DimTicketCustomerId
	INNER JOIN IndianapolisColts.dbo.vwDimCustomer_ModAcctId mac ON dtc.ETL__SSID_TM_acct_id = mac.AccountId
	AND mac.SourceSystem = 'TM' AND mac.CustomerType = 'Primary'
	WHERE fts.DimSeasonId = 20
	AND fts.DimPlanId IN (9,10)
	GROUP BY mac.SSB_CRMSYSTEM_CONTACT_ID
) x


UPDATE cc 
SET cc.Is_Renewed__c = #is_renew.[Is Renewed]
FROM dbo.Contact_Custom cc
LEFT JOIN #is_renew ON cc.SSB_CRMSYSTEM_Contact_ID__c = SSB_CRMSYSTEM_CONTACT_ID



--====================
--STH Tenure
--Date: 7/23/2018
--Modified By:
--Modified On:
--====================


SELECT mac.SSB_CRMSYSTEM_CONTACT_ID, TRY_CAST(MIN(c.Since_date) AS DATE) AS [Ticket Buyer Since Date],
DATEDIFF(YEAR,MIN(c.Since_date),GETDATE()) + 1 AS [Ticket Buyer Tenure]
INTO #tenure
FROM IndianapolisColts.ods.TM_Cust c
INNER JOIN IndianapolisColts.dbo.vwDimCustomer_ModAcctId mac ON c.acct_id = mac.AccountId
AND mac.SourceSystem = 'TM' AND mac.CustomerType = 'Primary'
GROUP BY mac.SSB_CRMSYSTEM_CONTACT_ID


UPDATE cc 
SET cc.Ticket_Buyer_Since_date__c = #tenure.[Ticket Buyer Since Date],
cc.Ticket_Buyer_Tenure__c = #tenure.[Ticket Buyer Tenure]
FROM dbo.Contact_Custom cc
LEFT JOIN #tenure ON cc.SSB_CRMSYSTEM_Contact_ID__c = SSB_CRMSYSTEM_CONTACT_ID

EXEC dbo.sp_CRMLoad_Contact_ProcessLoad_Criteria

EXEC wrk.Materialize_KeyAccounts

GO
