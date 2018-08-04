CREATE TABLE [dbo].[KeyAccounts_Materialized]
(
[dimcustomerid] [int] NULL,
[SSBID] [uniqueidentifier] NOT NULL,
[ssid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Withhold_StandardUpdate] [bit] NULL,
[Withhold_CustomUpdate] [bit] NULL,
[Withhold_Merging] [bit] NULL
)
GO
ALTER TABLE [dbo].[KeyAccounts_Materialized] ADD CONSTRAINT [PK__KeyAccou__A276111E77807DB9] PRIMARY KEY CLUSTERED  ([SSBID])
GO
