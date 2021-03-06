USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[RQVendEval]    Script Date: 12/21/2015 15:54:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RQVendEval](
	[Addr1] [char](60) NOT NULL,
	[Addr2] [char](60) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[City] [char](30) NOT NULL,
	[Comment] [char](60) NOT NULL,
	[Country] [char](3) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[Email] [char](80) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Output] [char](1) NOT NULL,
	[Phone] [char](30) NOT NULL,
	[QuoteAmt] [float] NOT NULL,
	[QuoteNbr] [char](10) NOT NULL,
	[ReqNbr] [char](10) NOT NULL,
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
	[State] [char](3) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VOC] [char](1) NOT NULL,
	[Zip] [char](10) NOT NULL,
	[zzCommentText] [text] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
