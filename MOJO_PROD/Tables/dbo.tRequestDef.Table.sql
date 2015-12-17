USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRequestDef]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRequestDef](
	[RequestDefKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[RequestName] [varchar](200) NOT NULL,
	[FieldSetKey] [int] NULL,
	[RequestPrefix] [varchar](20) NOT NULL,
	[Description] [varchar](500) NULL,
	[NextRequestNum] [int] NOT NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[ProjectDescription] [text] NULL,
	[RequireProjectName] [tinyint] NULL,
	[DisplayProjectFields] [tinyint] NULL,
	[MinDays] [smallint] NULL,
	[RequesterToProjectTeam] [tinyint] NULL,
	[DisplayCampaign] [tinyint] NULL,
	[SendConfirmation] [tinyint] NULL,
	[ConfirmationMessage] [varchar](500) NULL,
	[PrintSpecOnSeparatePages] [tinyint] NULL,
	[TemplateProjectNumber] [varchar](50) NULL,
	[CreatedByKey] [int] NULL,
	[CreatedByDate] [datetime] NULL,
	[UpdatedByKey] [int] NULL,
 CONSTRAINT [PK_tRequestDef] PRIMARY KEY CLUSTERED 
(
	[RequestDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tRequestDef] ADD  CONSTRAINT [DF_tRequestDef_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
