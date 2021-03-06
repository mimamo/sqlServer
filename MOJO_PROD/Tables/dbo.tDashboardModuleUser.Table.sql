USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDashboardModuleUser]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tDashboardModuleUser](
	[UserKey] [int] NOT NULL,
	[DashboardModuleKey] [int] NOT NULL,
	[DisplayStatus] [smallint] NOT NULL,
	[Settings] [text] NULL,
 CONSTRAINT [PK_tDashboardModuleUser] PRIMARY KEY CLUSTERED 
(
	[UserKey] ASC,
	[DashboardModuleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tDashboardModuleUser]  WITH NOCHECK ADD  CONSTRAINT [FK_tDashboardModuleUser_tDashboardModule] FOREIGN KEY([DashboardModuleKey])
REFERENCES [dbo].[tDashboardModule] ([DashboardModuleKey])
GO
ALTER TABLE [dbo].[tDashboardModuleUser] CHECK CONSTRAINT [FK_tDashboardModuleUser_tDashboardModule]
GO
