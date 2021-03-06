USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReport]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReport](
	[ReportKey] [int] IDENTITY(1,1) NOT NULL,
	[ViewKey] [int] NULL,
	[Name] [varchar](255) NULL,
	[ReportType] [smallint] NULL,
	[ReportFilter] [varchar](50) NULL,
	[Definition] [text] NULL,
	[FieldDefinition] [text] NULL,
	[ConditionDefinition] [text] NULL,
	[Private] [int] NULL,
	[UserKey] [int] NULL,
	[CompanyKey] [int] NULL,
	[ReportGroupKey] [int] NULL,
	[ReportHeading1] [varchar](200) NULL,
	[ReportHeading1Align] [smallint] NULL,
	[ReportHeading2] [varchar](200) NULL,
	[ReportHeading2Align] [smallint] NULL,
	[Orientation] [smallint] NULL,
	[GroupBy] [smallint] NULL,
	[ShowConditions] [tinyint] NULL,
	[ReportID] [varchar](50) NULL,
	[GroupByDefinition] [text] NULL,
	[LockedColumns] [int] NULL,
	[DefaultReportKey] [int] NULL,
	[AutoExpandGroups] [tinyint] NULL,
	[Deleted] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[ApplicationVersion] [tinyint] NULL,
	[AutoRun] [tinyint] NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_tReport] PRIMARY KEY CLUSTERED 
(
	[ReportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tReport] ADD  CONSTRAINT [DF_tReport_ReportType]  DEFAULT ((0)) FOR [ReportType]
GO
ALTER TABLE [dbo].[tReport] ADD  CONSTRAINT [DF_tReport_CompanyKey]  DEFAULT ((1)) FOR [CompanyKey]
GO
ALTER TABLE [dbo].[tReport] ADD  CONSTRAINT [DF_tReport_ShowConditions]  DEFAULT ((0)) FOR [ShowConditions]
GO
ALTER TABLE [dbo].[tReport] ADD  CONSTRAINT [DF_tReport_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
