USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[RC_ReportRoleAssignments]    Script Date: 12/21/2015 14:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RC_ReportRoleAssignments](
	[Role] [uniqueidentifier] NOT NULL,
	[REPORT_ID] [int] NOT NULL,
 CONSTRAINT [PKRC_ReportRoleAssignments] PRIMARY KEY NONCLUSTERED 
(
	[REPORT_ID] ASC,
	[Role] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
