USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDashboardModuleDef]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDashboardModuleDef](
	[DashboardModuleDefKey] [int] NOT NULL,
	[DisplayName] [varchar](200) NOT NULL,
	[DashboardType] [smallint] NOT NULL,
	[DashboardModuleGroupKey] [int] NULL,
	[DefDisplayOrder] [int] NOT NULL,
	[Description] [varchar](500) NULL,
	[SourceFile] [varchar](300) NOT NULL,
	[WidgetKey] [int] NULL,
 CONSTRAINT [PK_tDashboardModuleDef] PRIMARY KEY CLUSTERED 
(
	[DashboardModuleDefKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDashboardModuleDef] ADD  CONSTRAINT [DF_tDashboardModuleDef_DisplayOrder]  DEFAULT ((0)) FOR [DefDisplayOrder]
GO
