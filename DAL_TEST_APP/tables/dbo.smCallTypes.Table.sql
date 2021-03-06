USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[smCallTypes]    Script Date: 12/21/2015 13:56:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smCallTypes](
	[CallTypeDesc] [char](30) NOT NULL,
	[CallTypeDuration] [char](1) NOT NULL,
	[CallTypeId] [char](10) NOT NULL,
	[CallTypeSubAccount] [char](24) NOT NULL,
	[CogsAcct] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[SalesAcct] [char](10) NOT NULL,
	[SalesSub] [char](24) NOT NULL,
	[SubFromSite] [smallint] NOT NULL,
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
