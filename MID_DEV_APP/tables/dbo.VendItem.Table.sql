USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[VendItem]    Script Date: 12/21/2015 14:16:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VendItem](
	[AlternateID] [char](30) NOT NULL,
	[Contact] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EMailAddr] [char](80) NOT NULL,
	[Fax] [char](30) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[LastCost] [float] NOT NULL,
	[LastRcvd] [smalldatetime] NOT NULL,
	[LeadTime] [float] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Phone] [char](30) NOT NULL,
	[PTDAvgCost00] [float] NOT NULL,
	[PTDAvgCost01] [float] NOT NULL,
	[PTDAvgCost02] [float] NOT NULL,
	[PTDAvgCost03] [float] NOT NULL,
	[PTDAvgCost04] [float] NOT NULL,
	[PTDAvgCost05] [float] NOT NULL,
	[PTDAvgCost06] [float] NOT NULL,
	[PTDAvgCost07] [float] NOT NULL,
	[PTDAvgCost08] [float] NOT NULL,
	[PTDAvgCost09] [float] NOT NULL,
	[PTDAvgCost10] [float] NOT NULL,
	[PTDAvgCost11] [float] NOT NULL,
	[PTDAvgCost12] [float] NOT NULL,
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
	[PTDCostRet00] [float] NOT NULL,
	[PTDCostRet01] [float] NOT NULL,
	[PTDCostRet02] [float] NOT NULL,
	[PTDCostRet03] [float] NOT NULL,
	[PTDCostRet04] [float] NOT NULL,
	[PTDCostRet05] [float] NOT NULL,
	[PTDCostRet06] [float] NOT NULL,
	[PTDCostRet07] [float] NOT NULL,
	[PTDCostRet08] [float] NOT NULL,
	[PTDCostRet09] [float] NOT NULL,
	[PTDCostRet10] [float] NOT NULL,
	[PTDCostRet11] [float] NOT NULL,
	[PTDCostRet12] [float] NOT NULL,
	[PTDLeadTime00] [float] NOT NULL,
	[PTDLeadTime01] [float] NOT NULL,
	[PTDLeadTime02] [float] NOT NULL,
	[PTDLeadTime03] [float] NOT NULL,
	[PTDLeadTime04] [float] NOT NULL,
	[PTDLeadTime05] [float] NOT NULL,
	[PTDLeadTime06] [float] NOT NULL,
	[PTDLeadTime07] [float] NOT NULL,
	[PTDLeadTime08] [float] NOT NULL,
	[PTDLeadTime09] [float] NOT NULL,
	[PTDLeadTime10] [float] NOT NULL,
	[PTDLeadTime11] [float] NOT NULL,
	[PTDLeadTime12] [float] NOT NULL,
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
	[PTDQtyRet00] [float] NOT NULL,
	[PTDQtyRet01] [float] NOT NULL,
	[PTDQtyRet02] [float] NOT NULL,
	[PTDQtyRet03] [float] NOT NULL,
	[PTDQtyRet04] [float] NOT NULL,
	[PTDQtyRet05] [float] NOT NULL,
	[PTDQtyRet06] [float] NOT NULL,
	[PTDQtyRet07] [float] NOT NULL,
	[PTDQtyRet08] [float] NOT NULL,
	[PTDQtyRet09] [float] NOT NULL,
	[PTDQtyRet10] [float] NOT NULL,
	[PTDQtyRet11] [float] NOT NULL,
	[PTDQtyRet12] [float] NOT NULL,
	[PTDRcptNbr00] [float] NOT NULL,
	[PTDRcptNbr01] [float] NOT NULL,
	[PTDRcptNbr02] [float] NOT NULL,
	[PTDRcptNbr03] [float] NOT NULL,
	[PTDRcptNbr04] [float] NOT NULL,
	[PTDRcptNbr05] [float] NOT NULL,
	[PTDRcptNbr06] [float] NOT NULL,
	[PTDRcptNbr07] [float] NOT NULL,
	[PTDRcptNbr08] [float] NOT NULL,
	[PTDRcptNbr09] [float] NOT NULL,
	[PTDRcptNbr10] [float] NOT NULL,
	[PTDRcptNbr11] [float] NOT NULL,
	[PTDRcptNbr12] [float] NOT NULL,
	[PYAvgCost] [float] NOT NULL,
	[PYCostRcvd] [float] NOT NULL,
	[PYCostRet] [float] NOT NULL,
	[PYQtyRcvd] [float] NOT NULL,
	[PYQtyRet] [float] NOT NULL,
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
	[UnitCost] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[VendorType] [char](1) NOT NULL,
	[YTDAvgCost] [float] NOT NULL,
	[YTDCostRcvd] [float] NOT NULL,
	[YTDCostRet] [float] NOT NULL,
	[YTDLeadTime] [float] NOT NULL,
	[YTDQtyRcvd] [float] NOT NULL,
	[YTDQtyRet] [float] NOT NULL,
	[YTDRcptNbr] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [Contact]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [EMailAddr]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [LastCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ('01/01/1900') FOR [LastRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [LeadTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDAvgCost12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRcvd12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDCostRet12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDLeadTime12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRcvd12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDQtyRet12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr00]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PTDRcptNbr12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PYAvgCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PYCostRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PYCostRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PYQtyRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [PYQtyRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT (' ') FOR [VendorType]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDAvgCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDCostRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDCostRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDLeadTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDQtyRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDQtyRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  DEFAULT ((0)) FOR [YTDRcptNbr]
GO
