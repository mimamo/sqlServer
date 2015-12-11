USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDashboardModuleGroup]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDashboardModuleGroup](
	[DashboardModuleGroupKey] [int] NOT NULL,
	[GroupName] [varchar](200) NOT NULL,
	[GroupDescription] [varchar](500) NULL,
	[GroupDisplayOrder] [int] NULL,
 CONSTRAINT [PK_tDashboardModuleGroup] PRIMARY KEY CLUSTERED 
(
	[DashboardModuleGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
