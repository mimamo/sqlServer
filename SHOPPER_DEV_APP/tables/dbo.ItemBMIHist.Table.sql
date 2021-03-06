USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[ItemBMIHist]    Script Date: 12/21/2015 14:33:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemBMIHist](
	[BMIBegBal] [float] NOT NULL,
	[BMIPTDCOGS00] [float] NOT NULL,
	[BMIPTDCOGS01] [float] NOT NULL,
	[BMIPTDCOGS02] [float] NOT NULL,
	[BMIPTDCOGS03] [float] NOT NULL,
	[BMIPTDCOGS04] [float] NOT NULL,
	[BMIPTDCOGS05] [float] NOT NULL,
	[BMIPTDCOGS06] [float] NOT NULL,
	[BMIPTDCOGS07] [float] NOT NULL,
	[BMIPTDCOGS08] [float] NOT NULL,
	[BMIPTDCOGS09] [float] NOT NULL,
	[BMIPTDCOGS10] [float] NOT NULL,
	[BMIPTDCOGS11] [float] NOT NULL,
	[BMIPTDCOGS12] [float] NOT NULL,
	[BMIPTDCostAdjd00] [float] NOT NULL,
	[BMIPTDCostAdjd01] [float] NOT NULL,
	[BMIPTDCostAdjd02] [float] NOT NULL,
	[BMIPTDCostAdjd03] [float] NOT NULL,
	[BMIPTDCostAdjd04] [float] NOT NULL,
	[BMIPTDCostAdjd05] [float] NOT NULL,
	[BMIPTDCostAdjd06] [float] NOT NULL,
	[BMIPTDCostAdjd07] [float] NOT NULL,
	[BMIPTDCostAdjd08] [float] NOT NULL,
	[BMIPTDCostAdjd09] [float] NOT NULL,
	[BMIPTDCostAdjd10] [float] NOT NULL,
	[BMIPTDCostAdjd11] [float] NOT NULL,
	[BMIPTDCostAdjd12] [float] NOT NULL,
	[BMIPTDCostIssd00] [float] NOT NULL,
	[BMIPTDCostIssd01] [float] NOT NULL,
	[BMIPTDCostIssd02] [float] NOT NULL,
	[BMIPTDCostIssd03] [float] NOT NULL,
	[BMIPTDCostIssd04] [float] NOT NULL,
	[BMIPTDCostIssd05] [float] NOT NULL,
	[BMIPTDCostIssd06] [float] NOT NULL,
	[BMIPTDCostIssd07] [float] NOT NULL,
	[BMIPTDCostIssd08] [float] NOT NULL,
	[BMIPTDCostIssd09] [float] NOT NULL,
	[BMIPTDCostIssd10] [float] NOT NULL,
	[BMIPTDCostIssd11] [float] NOT NULL,
	[BMIPTDCostIssd12] [float] NOT NULL,
	[BMIPTDCostRcvd00] [float] NOT NULL,
	[BMIPTDCostRcvd01] [float] NOT NULL,
	[BMIPTDCostRcvd02] [float] NOT NULL,
	[BMIPTDCostRcvd03] [float] NOT NULL,
	[BMIPTDCostRcvd04] [float] NOT NULL,
	[BMIPTDCostRcvd05] [float] NOT NULL,
	[BMIPTDCostRcvd06] [float] NOT NULL,
	[BMIPTDCostRcvd07] [float] NOT NULL,
	[BMIPTDCostRcvd08] [float] NOT NULL,
	[BMIPTDCostRcvd09] [float] NOT NULL,
	[BMIPTDCostRcvd10] [float] NOT NULL,
	[BMIPTDCostRcvd11] [float] NOT NULL,
	[BMIPTDCostRcvd12] [float] NOT NULL,
	[BMIYTDCOGS] [float] NOT NULL,
	[BMIYTDCostAdjd] [float] NOT NULL,
	[BMIYTDCostIssd] [float] NOT NULL,
	[BMIYTDCostRcvd] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SiteID] [char](10) NOT NULL,
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
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIBegBal]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS00]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS01]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS02]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS03]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS04]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS05]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS06]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS07]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS08]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS09]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS10]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS11]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCOGS12]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd00]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd01]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd02]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd03]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd04]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd05]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd06]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd07]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd08]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd09]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd10]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd11]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostAdjd12]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd00]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd01]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd02]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd03]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd04]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd05]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd06]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd07]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd08]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd09]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd10]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd11]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostIssd12]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd00]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd01]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd02]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd03]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd04]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd05]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd06]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd07]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd08]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd09]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd10]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd11]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIPTDCostRcvd12]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIYTDCOGS]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIYTDCostAdjd]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIYTDCostIssd]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [BMIYTDCostRcvd]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[ItemBMIHist] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
