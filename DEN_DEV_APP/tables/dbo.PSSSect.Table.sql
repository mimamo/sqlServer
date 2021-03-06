USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSSect]    Script Date: 12/21/2015 14:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSSect](
	[Crtd_datetime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Less1Gain] [char](4) NOT NULL,
	[Less1Loss] [char](4) NOT NULL,
	[Lupd_datetime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[More1Gain] [char](4) NOT NULL,
	[More1Loss] [char](4) NOT NULL,
	[Sect] [char](6) NOT NULL,
	[YrEnd] [char](4) NOT NULL,
	[YrStart] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('01/01/1900') FOR [Crtd_datetime]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Less1Gain]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Less1Loss]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('01/01/1900') FOR [Lupd_datetime]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Lupd_Prog]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Lupd_User]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [More1Gain]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [More1Loss]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [Sect]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [YrEnd]
GO
ALTER TABLE [dbo].[PSSSect] ADD  DEFAULT ('') FOR [YrStart]
GO
