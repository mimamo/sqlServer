USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[PSSDeprMethodsHdr]    Script Date: 12/21/2015 16:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSDeprMethodsHdr](
	[ConvMonth] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DBRate] [float] NOT NULL,
	[DBSwitchtoSL] [smallint] NOT NULL,
	[DBTimesSLRate] [smallint] NOT NULL,
	[DeprDescr] [char](60) NOT NULL,
	[DeprMethod] [char](20) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MidConvention] [char](1) NOT NULL,
	[RecovPeriod] [float] NOT NULL,
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
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0)) FOR [ConvMonth]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0.00)) FOR [DBRate]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0)) FOR [DBSwitchtoSL]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0)) FOR [DBTimesSLRate]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [DeprDescr]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [DeprMethod]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [MidConvention]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0.00)) FOR [RecovPeriod]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0.00)) FOR [User3]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ((0.00)) FOR [User4]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PSSDeprMethodsHdr] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
