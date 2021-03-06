USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[RQReason]    Script Date: 12/21/2015 16:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RQReason](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[ItemNbr] [char](10) NOT NULL,
	[ItemLineNbr] [smallint] NOT NULL,
	[ItemType] [char](1) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[S4Future1] [char](30) NOT NULL,
	[S4Future2] [char](30) NOT NULL,
	[S4Future3] [float] NOT NULL,
	[S4Future4] [float] NOT NULL,
	[S4Future5] [float] NOT NULL,
	[S4Future6] [float] NOT NULL,
	[S4Future7] [smalldatetime] NOT NULL,
	[S4Future8] [smalldatetime] NOT NULL,
	[S4Future9] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[ZZReason] [text] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
