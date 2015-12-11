USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActivityEmail]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tActivityEmail](
	[ActivityKey] [int] NOT NULL,
	[UserKey] [int] NULL,
	[UserLeadKey] [int] NULL,
	[OriginalUser] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tActivityEmail] ADD  CONSTRAINT [DF_tActivityEmail_OriginalUser]  DEFAULT ((1)) FOR [OriginalUser]
GO
