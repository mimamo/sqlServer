USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDashboardGroup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDashboardGroup](
	[SecurityGroupKey] [int] NOT NULL,
	[DashboardKey] [int] NOT NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_tDashboardGroup] PRIMARY KEY CLUSTERED 
(
	[SecurityGroupKey] ASC,
	[DashboardKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tDashboardGroup]  WITH NOCHECK ADD  CONSTRAINT [FK_tDashboardGroup_tDashboard] FOREIGN KEY([DashboardKey])
REFERENCES [dbo].[tDashboard] ([DashboardKey])
GO
ALTER TABLE [dbo].[tDashboardGroup] CHECK CONSTRAINT [FK_tDashboardGroup_tDashboard]
GO
ALTER TABLE [dbo].[tDashboardGroup]  WITH NOCHECK ADD  CONSTRAINT [FK_tDashboardGroup_tSecurityGroup] FOREIGN KEY([SecurityGroupKey])
REFERENCES [dbo].[tSecurityGroup] ([SecurityGroupKey])
GO
ALTER TABLE [dbo].[tDashboardGroup] CHECK CONSTRAINT [FK_tDashboardGroup_tSecurityGroup]
GO
