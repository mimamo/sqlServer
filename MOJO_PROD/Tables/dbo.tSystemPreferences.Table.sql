USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSystemPreferences]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSystemPreferences](
	[AccessToken] [varchar](4000) NULL,
	[ActiveDate] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
