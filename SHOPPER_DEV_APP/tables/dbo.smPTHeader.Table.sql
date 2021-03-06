USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[smPTHeader]    Script Date: 12/21/2015 14:33:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smPTHeader](
	[BaudRate] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DataBits] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MaxChars] [smallint] NOT NULL,
	[Parity] [smallint] NOT NULL,
	[Phone] [char](30) NOT NULL,
	[ServiceName] [char](60) NOT NULL,
	[StopBits] [smallint] NOT NULL,
	[TemplateDescription] [char](30) NOT NULL,
	[TemplateId] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
