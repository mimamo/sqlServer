USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PSSEscrowCode]    Script Date: 12/21/2015 13:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSEscrowCode](
	[AcctId] [char](10) NOT NULL,
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[Amt] [float] NOT NULL,
	[City] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LineId] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Name] [char](60) NOT NULL,
	[SortBy] [smallint] NOT NULL,
	[State] [char](2) NOT NULL,
	[TypeCode] [char](6) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[ZipCode] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [AcctId]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [Addr1]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [Addr2]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ((0.00)) FOR [Amt]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [City]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ((0)) FOR [LineId]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [Name]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ((0)) FOR [SortBy]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [State]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [TypeCode]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [VendID]
GO
ALTER TABLE [dbo].[PSSEscrowCode] ADD  DEFAULT ('') FOR [ZipCode]
GO
