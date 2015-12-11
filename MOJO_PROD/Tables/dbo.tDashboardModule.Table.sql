USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDashboardModule]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDashboardModule](
	[DashboardModuleKey] [int] IDENTITY(1,1) NOT NULL,
	[DashboardKey] [int] NOT NULL,
	[DashboardModuleDefKey] [int] NOT NULL,
	[Pane] [smallint] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_tDashboardModule] PRIMARY KEY CLUSTERED 
(
	[DashboardModuleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tDashboardModule]  WITH NOCHECK ADD  CONSTRAINT [FK_tDashboardModule_tDashboard] FOREIGN KEY([DashboardKey])
REFERENCES [dbo].[tDashboard] ([DashboardKey])
GO
ALTER TABLE [dbo].[tDashboardModule] CHECK CONSTRAINT [FK_tDashboardModule_tDashboard]
GO
