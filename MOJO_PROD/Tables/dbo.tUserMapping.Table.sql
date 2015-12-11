USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tUserMapping]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tUserMapping](
	[OwnerUserKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[CMFolderKey] [int] NOT NULL,
	[Uid] [varchar](2500) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
