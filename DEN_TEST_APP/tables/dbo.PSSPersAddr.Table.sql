USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSPersAddr]    Script Date: 12/21/2015 14:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSPersAddr](
	[Account] [char](50) NOT NULL,
	[AddrActiveFr] [smalldatetime] NOT NULL,
	[AddrActiveTo] [smalldatetime] NOT NULL,
	[AddrCode] [char](15) NOT NULL,
	[AddrLine1] [char](100) NOT NULL,
	[AddrLine2] [char](100) NOT NULL,
	[AddrLine3] [char](100) NOT NULL,
	[AddrTypeCode] [char](10) NOT NULL,
	[Attn] [char](100) NOT NULL,
	[City] [char](100) NOT NULL,
	[ClientCode] [char](10) NOT NULL,
	[Country] [char](3) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Fax] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Phone] [char](10) NOT NULL,
	[PhoneExt] [char](10) NOT NULL,
	[Salutation] [char](100) NOT NULL,
	[SendMail] [char](1) NOT NULL,
	[State] [char](2) NOT NULL,
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
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Account]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('01/01/1900') FOR [AddrActiveFr]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('01/01/1900') FOR [AddrActiveTo]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [AddrCode]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [AddrLine1]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [AddrLine2]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [AddrLine3]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [AddrTypeCode]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Attn]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [ClientCode]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Country]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Fax]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Phone]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [PhoneExt]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Salutation]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [SendMail]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSPersAddr] ADD  DEFAULT ('') FOR [Zip]
GO
