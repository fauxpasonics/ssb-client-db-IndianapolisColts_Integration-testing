CREATE TABLE [dbo].[Contact_Custom_CRMResults]
(
[SSB_CRMSYSTEM_SSID_Winner__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_DimCustomerID__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_SSID_TIX__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Type_Description__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Group_Buyer__c] [bit] NULL,
[Current_STH__c] [bit] NULL,
[Is_Renewed__c] [bit] NULL,
[Previous_Group_Buyer__c] [bit] NULL,
[Previous_STH__c] [bit] NULL,
[Ticket_Buyer_Tenure__c] [bit] NULL,
[Ticket_Buyer_Since_Date__c] [datetime2] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
