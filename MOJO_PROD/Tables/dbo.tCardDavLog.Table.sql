USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCardDavLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCardDavLog](
	[CardDavLogKey] [varchar](1000) NULL,
	[ActionDate] [datetime] NULL,
	[IP] [varchar](250) NULL,
	[UserKey] [int] NULL,
	[Path] [varchar](500) NULL,
	[Verb] [varchar](25) NULL,
	[Request] [varchar](max) NULL,
	[Response] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
