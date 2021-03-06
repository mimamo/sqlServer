USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[VendItem]    Script Date: 12/21/2015 14:10:21 ******/
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
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_AlternateID]  DEFAULT (' ') FOR [AlternateID]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_Contact]  DEFAULT (' ') FOR [Contact]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_EMailAddr]  DEFAULT (' ') FOR [EMailAddr]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_Fax]  DEFAULT (' ') FOR [Fax]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_FiscYr]  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_LastCost]  DEFAULT ((0)) FOR [LastCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_LastRcvd]  DEFAULT ('01/01/1900') FOR [LastRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_LeadTime]  DEFAULT ((0)) FOR [LeadTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_NoteID]  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_Phone]  DEFAULT (' ') FOR [Phone]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost00]  DEFAULT ((0)) FOR [PTDAvgCost00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost01]  DEFAULT ((0)) FOR [PTDAvgCost01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost02]  DEFAULT ((0)) FOR [PTDAvgCost02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost03]  DEFAULT ((0)) FOR [PTDAvgCost03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost04]  DEFAULT ((0)) FOR [PTDAvgCost04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost05]  DEFAULT ((0)) FOR [PTDAvgCost05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost06]  DEFAULT ((0)) FOR [PTDAvgCost06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost07]  DEFAULT ((0)) FOR [PTDAvgCost07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost08]  DEFAULT ((0)) FOR [PTDAvgCost08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost09]  DEFAULT ((0)) FOR [PTDAvgCost09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost10]  DEFAULT ((0)) FOR [PTDAvgCost10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost11]  DEFAULT ((0)) FOR [PTDAvgCost11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDAvgCost12]  DEFAULT ((0)) FOR [PTDAvgCost12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd00]  DEFAULT ((0)) FOR [PTDCostRcvd00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd01]  DEFAULT ((0)) FOR [PTDCostRcvd01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd02]  DEFAULT ((0)) FOR [PTDCostRcvd02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd03]  DEFAULT ((0)) FOR [PTDCostRcvd03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd04]  DEFAULT ((0)) FOR [PTDCostRcvd04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd05]  DEFAULT ((0)) FOR [PTDCostRcvd05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd06]  DEFAULT ((0)) FOR [PTDCostRcvd06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd07]  DEFAULT ((0)) FOR [PTDCostRcvd07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd08]  DEFAULT ((0)) FOR [PTDCostRcvd08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd09]  DEFAULT ((0)) FOR [PTDCostRcvd09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd10]  DEFAULT ((0)) FOR [PTDCostRcvd10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd11]  DEFAULT ((0)) FOR [PTDCostRcvd11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRcvd12]  DEFAULT ((0)) FOR [PTDCostRcvd12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet00]  DEFAULT ((0)) FOR [PTDCostRet00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet01]  DEFAULT ((0)) FOR [PTDCostRet01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet02]  DEFAULT ((0)) FOR [PTDCostRet02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet03]  DEFAULT ((0)) FOR [PTDCostRet03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet04]  DEFAULT ((0)) FOR [PTDCostRet04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet05]  DEFAULT ((0)) FOR [PTDCostRet05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet06]  DEFAULT ((0)) FOR [PTDCostRet06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet07]  DEFAULT ((0)) FOR [PTDCostRet07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet08]  DEFAULT ((0)) FOR [PTDCostRet08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet09]  DEFAULT ((0)) FOR [PTDCostRet09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet10]  DEFAULT ((0)) FOR [PTDCostRet10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet11]  DEFAULT ((0)) FOR [PTDCostRet11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDCostRet12]  DEFAULT ((0)) FOR [PTDCostRet12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime00]  DEFAULT ((0)) FOR [PTDLeadTime00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime01]  DEFAULT ((0)) FOR [PTDLeadTime01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime02]  DEFAULT ((0)) FOR [PTDLeadTime02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime03]  DEFAULT ((0)) FOR [PTDLeadTime03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime04]  DEFAULT ((0)) FOR [PTDLeadTime04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime05]  DEFAULT ((0)) FOR [PTDLeadTime05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime06]  DEFAULT ((0)) FOR [PTDLeadTime06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime07]  DEFAULT ((0)) FOR [PTDLeadTime07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime08]  DEFAULT ((0)) FOR [PTDLeadTime08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime09]  DEFAULT ((0)) FOR [PTDLeadTime09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime10]  DEFAULT ((0)) FOR [PTDLeadTime10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime11]  DEFAULT ((0)) FOR [PTDLeadTime11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDLeadTime12]  DEFAULT ((0)) FOR [PTDLeadTime12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd00]  DEFAULT ((0)) FOR [PTDQtyRcvd00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd01]  DEFAULT ((0)) FOR [PTDQtyRcvd01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd02]  DEFAULT ((0)) FOR [PTDQtyRcvd02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd03]  DEFAULT ((0)) FOR [PTDQtyRcvd03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd04]  DEFAULT ((0)) FOR [PTDQtyRcvd04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd05]  DEFAULT ((0)) FOR [PTDQtyRcvd05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd06]  DEFAULT ((0)) FOR [PTDQtyRcvd06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd07]  DEFAULT ((0)) FOR [PTDQtyRcvd07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd08]  DEFAULT ((0)) FOR [PTDQtyRcvd08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd09]  DEFAULT ((0)) FOR [PTDQtyRcvd09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd10]  DEFAULT ((0)) FOR [PTDQtyRcvd10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd11]  DEFAULT ((0)) FOR [PTDQtyRcvd11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRcvd12]  DEFAULT ((0)) FOR [PTDQtyRcvd12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet00]  DEFAULT ((0)) FOR [PTDQtyRet00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet01]  DEFAULT ((0)) FOR [PTDQtyRet01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet02]  DEFAULT ((0)) FOR [PTDQtyRet02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet03]  DEFAULT ((0)) FOR [PTDQtyRet03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet04]  DEFAULT ((0)) FOR [PTDQtyRet04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet05]  DEFAULT ((0)) FOR [PTDQtyRet05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet06]  DEFAULT ((0)) FOR [PTDQtyRet06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet07]  DEFAULT ((0)) FOR [PTDQtyRet07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet08]  DEFAULT ((0)) FOR [PTDQtyRet08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet09]  DEFAULT ((0)) FOR [PTDQtyRet09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet10]  DEFAULT ((0)) FOR [PTDQtyRet10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet11]  DEFAULT ((0)) FOR [PTDQtyRet11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDQtyRet12]  DEFAULT ((0)) FOR [PTDQtyRet12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr00]  DEFAULT ((0)) FOR [PTDRcptNbr00]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr01]  DEFAULT ((0)) FOR [PTDRcptNbr01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr02]  DEFAULT ((0)) FOR [PTDRcptNbr02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr03]  DEFAULT ((0)) FOR [PTDRcptNbr03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr04]  DEFAULT ((0)) FOR [PTDRcptNbr04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr05]  DEFAULT ((0)) FOR [PTDRcptNbr05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr06]  DEFAULT ((0)) FOR [PTDRcptNbr06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr07]  DEFAULT ((0)) FOR [PTDRcptNbr07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr08]  DEFAULT ((0)) FOR [PTDRcptNbr08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr09]  DEFAULT ((0)) FOR [PTDRcptNbr09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr10]  DEFAULT ((0)) FOR [PTDRcptNbr10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr11]  DEFAULT ((0)) FOR [PTDRcptNbr11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PTDRcptNbr12]  DEFAULT ((0)) FOR [PTDRcptNbr12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PYAvgCost]  DEFAULT ((0)) FOR [PYAvgCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PYCostRcvd]  DEFAULT ((0)) FOR [PYCostRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PYCostRet]  DEFAULT ((0)) FOR [PYCostRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PYQtyRcvd]  DEFAULT ((0)) FOR [PYQtyRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_PYQtyRet]  DEFAULT ((0)) FOR [PYQtyRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_UnitCost]  DEFAULT ((0)) FOR [UnitCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_VendID]  DEFAULT (' ') FOR [VendID]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_VendorType]  DEFAULT (' ') FOR [VendorType]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDAvgCost]  DEFAULT ((0)) FOR [YTDAvgCost]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDCostRcvd]  DEFAULT ((0)) FOR [YTDCostRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDCostRet]  DEFAULT ((0)) FOR [YTDCostRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDLeadTime]  DEFAULT ((0)) FOR [YTDLeadTime]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDQtyRcvd]  DEFAULT ((0)) FOR [YTDQtyRcvd]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDQtyRet]  DEFAULT ((0)) FOR [YTDQtyRet]
GO
ALTER TABLE [dbo].[VendItem] ADD  CONSTRAINT [DF_VendItem_YTDRcptNbr]  DEFAULT ((0)) FOR [YTDRcptNbr]
GO
