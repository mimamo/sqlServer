USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[ItemHist]    Script Date: 12/21/2015 16:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemHist](
	[BegBal] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PTDCOGS00] [float] NOT NULL,
	[PTDCOGS01] [float] NOT NULL,
	[PTDCOGS02] [float] NOT NULL,
	[PTDCOGS03] [float] NOT NULL,
	[PTDCOGS04] [float] NOT NULL,
	[PTDCOGS05] [float] NOT NULL,
	[PTDCOGS06] [float] NOT NULL,
	[PTDCOGS07] [float] NOT NULL,
	[PTDCOGS08] [float] NOT NULL,
	[PTDCOGS09] [float] NOT NULL,
	[PTDCOGS10] [float] NOT NULL,
	[PTDCOGS11] [float] NOT NULL,
	[PTDCOGS12] [float] NOT NULL,
	[PTDCostAdjd00] [float] NOT NULL,
	[PTDCostAdjd01] [float] NOT NULL,
	[PTDCostAdjd02] [float] NOT NULL,
	[PTDCostAdjd03] [float] NOT NULL,
	[PTDCostAdjd04] [float] NOT NULL,
	[PTDCostAdjd05] [float] NOT NULL,
	[PTDCostAdjd06] [float] NOT NULL,
	[PTDCostAdjd07] [float] NOT NULL,
	[PTDCostAdjd08] [float] NOT NULL,
	[PTDCostAdjd09] [float] NOT NULL,
	[PTDCostAdjd10] [float] NOT NULL,
	[PTDCostAdjd11] [float] NOT NULL,
	[PTDCostAdjd12] [float] NOT NULL,
	[PTDCostIssd00] [float] NOT NULL,
	[PTDCostIssd01] [float] NOT NULL,
	[PTDCostIssd02] [float] NOT NULL,
	[PTDCostIssd03] [float] NOT NULL,
	[PTDCostIssd04] [float] NOT NULL,
	[PTDCostIssd05] [float] NOT NULL,
	[PTDCostIssd06] [float] NOT NULL,
	[PTDCostIssd07] [float] NOT NULL,
	[PTDCostIssd08] [float] NOT NULL,
	[PTDCostIssd09] [float] NOT NULL,
	[PTDCostIssd10] [float] NOT NULL,
	[PTDCostIssd11] [float] NOT NULL,
	[PTDCostIssd12] [float] NOT NULL,
	[PTDCostRcvd00] [float] NOT NULL,
	[PTDCostRcvd01] [float] NOT NULL,
	[PTDCostRcvd02] [float] NOT NULL,
	[PTDCostRcvd03] [float] NOT NULL,
	[PTDCostRcvd04] [float] NOT NULL,
	[PTDCostRcvd05] [float] NOT NULL,
	[PTDCostRcvd06] [float] NOT NULL,
	[PTDCostRcvd07] [float] NOT NULL,
	[PTDCostRcvd08] [float] NOT NULL,
	[PTDCostRcvd09] [float] NOT NULL,
	[PTDCostRcvd10] [float] NOT NULL,
	[PTDCostRcvd11] [float] NOT NULL,
	[PTDCostRcvd12] [float] NOT NULL,
	[PTDCostTrsfrIn00] [float] NOT NULL,
	[PTDCostTrsfrIn01] [float] NOT NULL,
	[PTDCostTrsfrIn02] [float] NOT NULL,
	[PTDCostTrsfrIn03] [float] NOT NULL,
	[PTDCostTrsfrIn04] [float] NOT NULL,
	[PTDCostTrsfrIn05] [float] NOT NULL,
	[PTDCostTrsfrIn06] [float] NOT NULL,
	[PTDCostTrsfrIn07] [float] NOT NULL,
	[PTDCostTrsfrIn08] [float] NOT NULL,
	[PTDCostTrsfrIn09] [float] NOT NULL,
	[PTDCostTrsfrIn10] [float] NOT NULL,
	[PTDCostTrsfrIn11] [float] NOT NULL,
	[PTDCostTrsfrIn12] [float] NOT NULL,
	[PTDCostTrsfrOut00] [float] NOT NULL,
	[PTDCostTrsfrOut01] [float] NOT NULL,
	[PTDCostTrsfrOut02] [float] NOT NULL,
	[PTDCostTrsfrOut03] [float] NOT NULL,
	[PTDCostTrsfrOut04] [float] NOT NULL,
	[PTDCostTrsfrOut05] [float] NOT NULL,
	[PTDCostTrsfrOut06] [float] NOT NULL,
	[PTDCostTrsfrOut07] [float] NOT NULL,
	[PTDCostTrsfrOut08] [float] NOT NULL,
	[PTDCostTrsfrOut09] [float] NOT NULL,
	[PTDCostTrsfrOut10] [float] NOT NULL,
	[PTDCostTrsfrOut11] [float] NOT NULL,
	[PTDCostTrsfrOut12] [float] NOT NULL,
	[PTDDShpSls00] [float] NOT NULL,
	[PTDDShpSls01] [float] NOT NULL,
	[PTDDShpSls02] [float] NOT NULL,
	[PTDDShpSls03] [float] NOT NULL,
	[PTDDShpSls04] [float] NOT NULL,
	[PTDDShpSls05] [float] NOT NULL,
	[PTDDShpSls06] [float] NOT NULL,
	[PTDDShpSls07] [float] NOT NULL,
	[PTDDShpSls08] [float] NOT NULL,
	[PTDDShpSls09] [float] NOT NULL,
	[PTDDShpSls10] [float] NOT NULL,
	[PTDDShpSls11] [float] NOT NULL,
	[PTDDShpSls12] [float] NOT NULL,
	[PTDSls00] [float] NOT NULL,
	[PTDSls01] [float] NOT NULL,
	[PTDSls02] [float] NOT NULL,
	[PTDSls03] [float] NOT NULL,
	[PTDSls04] [float] NOT NULL,
	[PTDSls05] [float] NOT NULL,
	[PTDSls06] [float] NOT NULL,
	[PTDSls07] [float] NOT NULL,
	[PTDSls08] [float] NOT NULL,
	[PTDSls09] [float] NOT NULL,
	[PTDSls10] [float] NOT NULL,
	[PTDSls11] [float] NOT NULL,
	[PTDSls12] [float] NOT NULL,
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
	[YTDCOGS] [float] NOT NULL,
	[YTDCostAdjd] [float] NOT NULL,
	[YTDCostIssd] [float] NOT NULL,
	[YTDCostRcvd] [float] NOT NULL,
	[YTDCostTrsfrIn] [float] NOT NULL,
	[YTDCostTrsfrOut] [float] NOT NULL,
	[YTDDShpSls] [float] NOT NULL,
	[YTDSls] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [BegBal]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCOGS12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostAdjd12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostIssd12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostRcvd12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrIn12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDCostTrsfrOut12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDDShpSls12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls00]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [PTDSls12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDCOGS]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDCostAdjd]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDCostIssd]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDCostRcvd]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDCostTrsfrIn]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDCostTrsfrOut]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDDShpSls]
GO
ALTER TABLE [dbo].[ItemHist] ADD  DEFAULT ((0)) FOR [YTDSls]
GO
