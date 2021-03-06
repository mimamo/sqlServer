USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[RC_ReportUsage]    Script Date: 12/21/2015 14:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RC_ReportUsage](
	[USERID] [uniqueidentifier] NOT NULL,
	[ReportCenter] [char](21) NOT NULL,
	[ReferenceCount] [int] NOT NULL,
	[REPORT_ID] [int] NOT NULL,
 CONSTRAINT [PKRC_ReportUsage] PRIMARY KEY NONCLUSTERED 
(
	[USERID] ASC,
	[ReportCenter] ASC,
	[REPORT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
