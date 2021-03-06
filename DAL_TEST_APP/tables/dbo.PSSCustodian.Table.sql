USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSCustodian]    Script Date: 12/21/2015 13:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSCustodian](
	[ABA] [char](20) NOT NULL,
	[AcctMicrDepSymb] [char](3) NOT NULL,
	[AcctMicrSetup] [smallint] NOT NULL,
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[City] [char](15) NOT NULL,
	[ConAddr1] [char](30) NOT NULL,
	[ConAddr2] [char](30) NOT NULL,
	[ConCity] [char](15) NOT NULL,
	[ConState] [char](2) NOT NULL,
	[ConZip] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustodianCode] [char](6) NOT NULL,
	[CustodianName] [char](60) NOT NULL,
	[DepRtNum] [char](11) NOT NULL,
	[Fax] [char](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[OnUsAcctMicrSetup] [smallint] NOT NULL,
	[OnUsField] [char](17) NOT NULL,
	[Phone] [char](10) NOT NULL,
	[PhoneExt] [char](10) NOT NULL,
	[RtNum] [char](11) NOT NULL,
	[State] [char](2) NOT NULL,
	[TaxId] [char](10) NOT NULL,
	[Type] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [ABA]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [AcctMicrDepSymb]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ((0)) FOR [AcctMicrSetup]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [ConAddr1]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [ConAddr2]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [ConCity]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [ConState]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [ConZip]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [CustodianCode]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [CustodianName]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [DepRtNum]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Fax]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('01/01/1900') FOR [Lupd_DateTime]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ((0)) FOR [OnUsAcctMicrSetup]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [OnUsField]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [PhoneExt]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [RtNum]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [TaxId]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Type]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSCustodian] ADD  DEFAULT ('') FOR [Zip]
GO
