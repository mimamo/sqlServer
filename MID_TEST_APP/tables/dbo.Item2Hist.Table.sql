USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[Item2Hist]    Script Date: 12/21/2015 14:26:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Item2Hist](
	[BegQty] [float] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[PTDIRCompletes00] [float] NOT NULL,
	[PTDIRCompletes01] [float] NOT NULL,
	[PTDIRCompletes02] [float] NOT NULL,
	[PTDIRCompletes03] [float] NOT NULL,
	[PTDIRCompletes04] [float] NOT NULL,
	[PTDIRCompletes05] [float] NOT NULL,
	[PTDIRCompletes06] [float] NOT NULL,
	[PTDIRCompletes07] [float] NOT NULL,
	[PTDIRCompletes08] [float] NOT NULL,
	[PTDIRCompletes09] [float] NOT NULL,
	[PTDIRCompletes10] [float] NOT NULL,
	[PTDIRCompletes11] [float] NOT NULL,
	[PTDIRCompletes12] [float] NOT NULL,
	[PTDIRHits00] [float] NOT NULL,
	[PTDIRHits01] [float] NOT NULL,
	[PTDIRHits02] [float] NOT NULL,
	[PTDIRHits03] [float] NOT NULL,
	[PTDIRHits04] [float] NOT NULL,
	[PTDIRHits05] [float] NOT NULL,
	[PTDIRHits06] [float] NOT NULL,
	[PTDIRHits07] [float] NOT NULL,
	[PTDIRHits08] [float] NOT NULL,
	[PTDIRHits09] [float] NOT NULL,
	[PTDIRHits10] [float] NOT NULL,
	[PTDIRHits11] [float] NOT NULL,
	[PTDIRHits12] [float] NOT NULL,
	[PTDQtyAdjd00] [float] NOT NULL,
	[PTDQtyAdjd01] [float] NOT NULL,
	[PTDQtyAdjd02] [float] NOT NULL,
	[PTDQtyAdjd03] [float] NOT NULL,
	[PTDQtyAdjd04] [float] NOT NULL,
	[PTDQtyAdjd05] [float] NOT NULL,
	[PTDQtyAdjd06] [float] NOT NULL,
	[PTDQtyAdjd07] [float] NOT NULL,
	[PTDQtyAdjd08] [float] NOT NULL,
	[PTDQtyAdjd09] [float] NOT NULL,
	[PTDQtyAdjd10] [float] NOT NULL,
	[PTDQtyAdjd11] [float] NOT NULL,
	[PTDQtyAdjd12] [float] NOT NULL,
	[PTDQtyDShpSls00] [float] NOT NULL,
	[PTDQtyDShpSls01] [float] NOT NULL,
	[PTDQtyDShpSls02] [float] NOT NULL,
	[PTDQtyDShpSls03] [float] NOT NULL,
	[PTDQtyDShpSls04] [float] NOT NULL,
	[PTDQtyDShpSls05] [float] NOT NULL,
	[PTDQtyDShpSls06] [float] NOT NULL,
	[PTDQtyDShpSls07] [float] NOT NULL,
	[PTDQtyDShpSls08] [float] NOT NULL,
	[PTDQtyDShpSls09] [float] NOT NULL,
	[PTDQtyDShpSls10] [float] NOT NULL,
	[PTDQtyDShpSls11] [float] NOT NULL,
	[PTDQtyDShpSls12] [float] NOT NULL,
	[PTDQtyIssd00] [float] NOT NULL,
	[PTDQtyIssd01] [float] NOT NULL,
	[PTDQtyIssd02] [float] NOT NULL,
	[PTDQtyIssd03] [float] NOT NULL,
	[PTDQtyIssd04] [float] NOT NULL,
	[PTDQtyIssd05] [float] NOT NULL,
	[PTDQtyIssd06] [float] NOT NULL,
	[PTDQtyIssd07] [float] NOT NULL,
	[PTDQtyIssd08] [float] NOT NULL,
	[PTDQtyIssd09] [float] NOT NULL,
	[PTDQtyIssd10] [float] NOT NULL,
	[PTDQtyIssd11] [float] NOT NULL,
	[PTDQtyIssd12] [float] NOT NULL,
	[PTDQtyRcvd00] [float] NOT NULL,
	[PTDQtyRcvd01] [float] NOT NULL,
	[PTDQtyRcvd02] [float] NOT NULL,
	[PTDQtyRcvd03] [float] NOT NULL,
	[PTDQtyRcvd04] [float] NOT NULL,
	[PTDQtyRcvd05] [float] NOT NULL,
	[PTDQtyRcvd06] [float] NOT NULL,
	[PTDQtyRcvd07] [float] NOT NULL,
	[PTDQtyRcvd08] [float] NOT NULL,
	[PTDQtyRcvd09] [float] NOT NULL,
	[PTDQtyRcvd10] [float] NOT NULL,
	[PTDQtyRcvd11] [float] NOT NULL,
	[PTDQtyRcvd12] [float] NOT NULL,
	[PTDQtySls00] [float] NOT NULL,
	[PTDQtySls01] [float] NOT NULL,
	[PTDQtySls02] [float] NOT NULL,
	[PTDQtySls03] [float] NOT NULL,
	[PTDQtySls04] [float] NOT NULL,
	[PTDQtySls05] [float] NOT NULL,
	[PTDQtySls06] [float] NOT NULL,
	[PTDQtySls07] [float] NOT NULL,
	[PTDQtySls08] [float] NOT NULL,
	[PTDQtySls09] [float] NOT NULL,
	[PTDQtySls10] [float] NOT NULL,
	[PTDQtySls11] [float] NOT NULL,
	[PTDQtySls12] [float] NOT NULL,
	[PTDQtyTrsfrIn00] [float] NOT NULL,
	[PTDQtyTrsfrIn01] [float] NOT NULL,
	[PTDQtyTrsfrIn02] [float] NOT NULL,
	[PTDQtyTrsfrIn03] [float] NOT NULL,
	[PTDQtyTrsfrIn04] [float] NOT NULL,
	[PTDQtyTrsfrIn05] [float] NOT NULL,
	[PTDQtyTrsfrIn06] [float] NOT NULL,
	[PTDQtyTrsfrIn07] [float] NOT NULL,
	[PTDQtyTrsfrIn08] [float] NOT NULL,
	[PTDQtyTrsfrIn09] [float] NOT NULL,
	[PTDQtyTrsfrIn10] [float] NOT NULL,
	[PTDQtyTrsfrIn11] [float] NOT NULL,
	[PTDQtyTrsfrIn12] [float] NOT NULL,
	[PTDQtyTrsfrOut00] [float] NOT NULL,
	[PTDQtyTrsfrOut01] [float] NOT NULL,
	[PTDQtyTrsfrOut02] [float] NOT NULL,
	[PTDQtyTrsfrOut03] [float] NOT NULL,
	[PTDQtyTrsfrOut04] [float] NOT NULL,
	[PTDQtyTrsfrOut05] [float] NOT NULL,
	[PTDQtyTrsfrOut06] [float] NOT NULL,
	[PTDQtyTrsfrOut07] [float] NOT NULL,
	[PTDQtyTrsfrOut08] [float] NOT NULL,
	[PTDQtyTrsfrOut09] [float] NOT NULL,
	[PTDQtyTrsfrOut10] [float] NOT NULL,
	[PTDQtyTrsfrOut11] [float] NOT NULL,
	[PTDQtyTrsfrOut12] [float] NOT NULL,
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
	[YTDIRCompletes] [float] NOT NULL,
	[YTDIRHits] [float] NOT NULL,
	[YTDQtyAdjd] [float] NOT NULL,
	[YTDQtyDShpSls] [float] NOT NULL,
	[YTDQtyIssd] [float] NOT NULL,
	[YTDQtyRcvd] [float] NOT NULL,
	[YTDQtySls] [float] NOT NULL,
	[YTDQtyTrsfrIn] [float] NOT NULL,
	[YTDQtyTrsfrOut] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [BegQty]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRCompletes12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDIRHits12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyAdjd12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyDShpSls12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyIssd12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtySls12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrIn12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut00]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [PTDQtyTrsfrOut12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDIRCompletes]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDIRHits]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtyAdjd]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtyDShpSls]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtyIssd]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtyRcvd]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtySls]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtyTrsfrIn]
GO
ALTER TABLE [dbo].[Item2Hist] ADD  DEFAULT ((0)) FOR [YTDQtyTrsfrOut]
GO
