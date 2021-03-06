USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tAPILog]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tAPILog](
	[APILogKey] [uniqueidentifier] NULL,
	[ActionDate] [datetime] NULL,
	[IP] [varchar](250) NULL,
	[UserToken] [varchar](2500) NULL,
	[Path] [varchar](500) NULL,
	[Verb] [varchar](25) NULL,
	[Request] [varchar](max) NULL,
	[Response] [varchar](max) NULL,
	[CompanyKey] [int] NULL,
	[UserKey] [int] NULL,
	[ApiAccessToken] [varchar](2500) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
