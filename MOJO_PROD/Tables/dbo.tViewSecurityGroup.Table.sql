USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tViewSecurityGroup]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tViewSecurityGroup](
	[ViewKey] [int] NOT NULL,
	[SecurityGroupKey] [int] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tViewSecurityGroup] ADD  CONSTRAINT [DF_tViewSecurityGroup_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
