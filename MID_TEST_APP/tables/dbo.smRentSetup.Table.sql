USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[smRentSetup]    Script Date: 12/21/2015 14:26:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smRentSetup](
	[AutoBranch] [smallint] NOT NULL,
	[AutoTransID] [smallint] NOT NULL,
	[CallStatus] [char](10) NOT NULL,
	[CallType] [char](10) NOT NULL,
	[ContractReqd] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FaultCode] [char](10) NOT NULL,
	[Frequency] [char](1) NOT NULL,
	[Future1] [char](10) NOT NULL,
	[Future2] [char](10) NOT NULL,
	[Future3] [smallint] NOT NULL,
	[Future4] [smallint] NOT NULL,
	[Future5] [smalldatetime] NOT NULL,
	[Future6] [smalldatetime] NOT NULL,
	[Future7] [smallint] NOT NULL,
	[Future8] [smallint] NOT NULL,
	[Future9] [char](30) NOT NULL,
	[Handling] [char](1) NOT NULL,
	[HistoryView] [char](1) NOT NULL,
	[LastBeginDate] [smalldatetime] NOT NULL,
	[LastEndDate] [smalldatetime] NOT NULL,
	[LastTranID] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Multiplier] [float] NOT NULL,
	[OpenPassword] [char](10) NOT NULL,
	[PMCode] [char](10) NOT NULL,
	[Priority] [char](1) NOT NULL,
	[RevAcct] [char](10) NOT NULL,
	[RevSub] [char](24) NOT NULL,
	[SetupId] [char](10) NOT NULL,
	[ShowVoid] [smallint] NOT NULL,
	[TaxSource] [char](1) NOT NULL,
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
