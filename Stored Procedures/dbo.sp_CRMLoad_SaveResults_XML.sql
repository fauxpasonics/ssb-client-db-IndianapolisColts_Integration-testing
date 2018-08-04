SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROCEDURE [dbo].[sp_CRMLoad_SaveResults_XML]
@ResultCategory VARCHAR(50)
AS

--EXEC dbo.sp_CRMLoad_SaveResults 'Account_Std'
--TRUNCATE TABLE dbo.[CRMLoad_SaveResults_Archived]
DECLARE @XML XML	

IF @ResultCategory = 'Account_Std'
SET @XML = (SELECT * FROM dbo.[Account_CRMResults] FOR XML RAW('Account_Std'), ELEMENTS, ROOT('Root'))

IF @ResultCategory = 'Account_Custom'
SET @XML = (SELECT * FROM dbo.[Account_Custom_CRMResults] FOR XML RAW('Account_Custom'), ELEMENTS, ROOT('Root'))

IF @ResultCategory = 'Contact_Std'
SET @XML = (SELECT * FROM dbo.[Contact_CRMResults] FOR XML RAW('Contact_Std'), ELEMENTS, ROOT('Root'))

IF @ResultCategory = 'Contact_Custom'
SET @XML = (SELECT * FROM dbo.[Contact_Custom_CRMResults] FOR XML RAW('Contact_Custom'), ELEMENTS, ROOT('Root'))

IF @ResultCategory = 'Lead_Std'
SET @XML = (SELECT * FROM dbo.[Lead_CRMResults] FOR XML RAW('Lead_Std'), ELEMENTS, ROOT('Root'))

IF @ResultCategory = 'Lead_Custom'
SET @XML = (SELECT * FROM dbo.[Lead_Custom_CRMResults] FOR XML RAW('Lead_Custom'), ELEMENTS, ROOT('Root'))

INSERT INTO dbo.CRMLoad_SaveResults_Archived
SELECT GETDATE() ArchiveDate, @ResultCategory ResultCategory, @XML XML_Results


GO
