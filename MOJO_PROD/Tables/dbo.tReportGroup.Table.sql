USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tReportGroup]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tReportGroup](
	[ReportGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GroupName] [varchar](300) NOT NULL,
	[GroupType] [smallint] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tReportGroup] PRIMARY KEY NONCLUSTERED 
(
	[ReportGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tReportGroup] ADD  CONSTRAINT [DF_tReportGroup_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[tReportGroup] ADD  CONSTRAINT [DF_tReportGroup_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
