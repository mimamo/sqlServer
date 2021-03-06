USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[smContractRev]    Script Date: 12/21/2015 16:00:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smContractRev](
	[Comment] [char](60) NOT NULL,
	[ContractID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CR_ID01] [char](30) NOT NULL,
	[CR_ID02] [char](30) NOT NULL,
	[CR_ID03] [char](20) NOT NULL,
	[CR_ID04] [char](20) NOT NULL,
	[CR_ID05] [char](10) NOT NULL,
	[CR_ID06] [char](10) NOT NULL,
	[CR_ID07] [char](4) NOT NULL,
	[CR_ID08] [float] NOT NULL,
	[CR_ID09] [smalldatetime] NOT NULL,
	[CR_ID10] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[GLBatNbr] [char](10) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerPost] [char](6) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[RevAmount] [float] NOT NULL,
	[RevDate] [smalldatetime] NOT NULL,
	[RevFlag] [smallint] NOT NULL,
	[SalesAcct] [char](10) NOT NULL,
	[SalesSub] [char](24) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TaskID] [char](32) NOT NULL,
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
