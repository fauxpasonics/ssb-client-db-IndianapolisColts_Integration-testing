SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[Materialize_KeyAccounts]
as

TRUNCATE TABLE dbo.KeyAccounts_Materialized

INSERT INTO dbo.KeyAccounts_Materialized (  
                                         SSBID ,
                                         Withhold_StandardUpdate ,
                                         Withhold_CustomUpdate ,
                                         Withhold_Merging
                                     )
SELECT
                                         SSBID ,

                                         Withhold_StandardUpdate ,
                                         Withhold_CustomUpdate ,
                                         Withhold_Merging
										 FROM dbo.vw_KeyAccounts


GO
