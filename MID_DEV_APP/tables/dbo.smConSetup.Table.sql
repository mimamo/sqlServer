USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[smConSetup]    Script Date: 12/21/2015 14:16:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smConSetup](
	[AdjustAcct] [char](10) NOT NULL,
	[AdjustSub] [char](24) NOT NULL,
	[AutoBatNbr] [smallint] NOT NULL,
	[AutoPrint] [smallint] NOT NULL,
	[CreditAdjAcct] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DebitAdjAcct] [char](10) NOT NULL,
	[DepositAcct] [char](10) NOT NULL,
	[DepositSub] [char](24) NOT NULL,
	[LastAccrual] [smalldatetime] NOT NULL,
	[LastBatNbr] [char](10) NOT NULL,
	[LastBilling] [smalldatetime] NOT NULL,
	[LastDepositBillling] [smalldatetime] NOT NULL,
	[LastDiscBilling] [smalldatetime] NOT NULL,
	[LastMiscBilling] [smalldatetime] NOT NULL,
	[LastRevenue] [smalldatetime] NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[MiscAcct] [char](10) NOT NULL,
	[MiscSub] [char](24) NOT NULL,
	[PartialAdjust] [smallint] NOT NULL,
	[PartialDeposits] [smallint] NOT NULL,
	[SetUpID] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [smallint] NOT NULL,
	[User4] [smallint] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
