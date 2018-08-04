SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_CRMProcess_UpdateGUIDs_ProdCopy_Account]
as
UPDATE b
SET [b].[SSB_CRMSYSTEM_ACCT_ID__c] = a.[SSB_CRMSYSTEM_ACCT_ID__c]
--SELECT a.* 
FROM [dbo].[vwCRMProcess_UpdateGUIDs_ProdCopyAccount] a 
INNER JOIN ProdCopy.vw_Account b ON a.accountid = b.accountid
WHERE ISNULL(b.[SSB_CRMSYSTEM_ACCT_ID__c],'a') <> ISNULL(a.[SSB_CRMSYSTEM_ACCT_ID__c],'a')



GO
