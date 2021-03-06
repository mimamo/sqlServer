USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSClient]    Script Date: 12/21/2015 14:33:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSClient](
	[AcctName] [char](60) NOT NULL,
	[ActiveDate] [smalldatetime] NOT NULL,
	[BirthDate] [smalldatetime] NOT NULL,
	[BrokerCode] [char](10) NOT NULL,
	[ClientCode] [char](10) NOT NULL,
	[Company] [char](60) NOT NULL,
	[Contact] [char](100) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[Dept] [char](40) NOT NULL,
	[Email] [char](100) NOT NULL,
	[Email2] [char](100) NOT NULL,
	[Fax] [char](10) NOT NULL,
	[FirstName] [char](30) NOT NULL,
	[IDNbr] [char](20) NOT NULL,
	[InternPhone] [char](20) NOT NULL,
	[LastName] [char](30) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MiddleName] [char](30) NOT NULL,
	[MobilePhone] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Password] [char](20) NOT NULL,
	[PrimPhone] [char](10) NOT NULL,
	[PrimPhoneExt] [char](10) NOT NULL,
	[PrimTaxId] [char](11) NOT NULL,
	[ProofofIDType] [char](1) NOT NULL,
	[RelType] [char](10) NOT NULL,
	[SecurityAns] [char](20) NOT NULL,
	[SecurityQues] [char](100) NOT NULL,
	[SiteName] [char](25) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Suffix] [char](1) NOT NULL,
	[SupplNo] [char](15) NOT NULL,
	[Title] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendId] [char](15) NOT NULL,
	[WebSite] [char](60) NOT NULL,
	[WorkPhone] [char](10) NOT NULL,
	[WorkPhoneExt] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [AcctName]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('01/01/1900') FOR [ActiveDate]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('01/01/1900') FOR [BirthDate]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [BrokerCode]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [ClientCode]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Company]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Contact]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [CustId]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Dept]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Email2]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Fax]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [FirstName]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [IDNbr]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [InternPhone]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [LastName]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [MiddleName]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [MobilePhone]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Password]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [PrimPhone]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [PrimPhoneExt]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [PrimTaxId]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [ProofofIDType]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [RelType]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [SecurityAns]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [SecurityQues]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [SiteName]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Suffix]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [SupplNo]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [Title]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [VendId]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [WebSite]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [WorkPhone]
GO
ALTER TABLE [dbo].[PSSClient] ADD  DEFAULT ('') FOR [WorkPhoneExt]
GO
