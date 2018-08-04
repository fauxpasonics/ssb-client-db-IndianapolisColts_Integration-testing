SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[sp_Account_Custom]
AS 


MERGE INTO dbo.Account_Custom Target
USING dbo.[Account] source
ON source.[SSB_CRMSYSTEM_ACCT_ID] = target.[SSB_CRMSYSTEM_ACCT_ID__c]
WHEN NOT MATCHED THEN
INSERT ([SSB_CRMSYSTEM_ACCT_ID__c]) VALUES (Source.[SSB_CRMSYSTEM_ACCT_ID]);

EXEC dbo.sp_CRMProcess_ConcatIDs 'Account'

--UPDATE a
--SET SeasonTicket_Years = recent.SeasonTicket_Years
----SELECT *
--FROM dbo.[Account_Custom] a
--INNER JOIN dbo.CRMProcess_DistinctAccounts recent ON a.SSB_CRMSYSTEM_ACCT_ID = recent.SSB_CRMSYSTEM_ACCT_ID

UPDATE a
SET a.[SSB_CRMSYSTEM_SSID_Winner__c] =b.SSID, a.[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] =b.SourceSystem
FROM [dbo].[Account_Custom] a
INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b ON ISNULL([b].[SSB_CRMSYSTEM_ACCT_ID],b.[SSB_CRMSYSTEM_CONTACT_ID]) = [a].[SSB_CRMSYSTEM_ACCT_ID__c]
INNER JOIN dbo.[vwDimCustomer_ModAcctId] c ON b.[DimCustomerId] = c.[DimCustomerId] AND c.[SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG] = 1

EXEC dbo.sp_CRMLoad_Account_ProcessLoad_Criteria


GO
