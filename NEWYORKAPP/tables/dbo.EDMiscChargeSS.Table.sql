USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[EDMiscChargeSS]    Script Date: 12/21/2015 16:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDMiscChargeSS](
	[Code] [char](10) NOT NULL,
	[Description] [char](30) NOT NULL,
	[MiscChrgID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDMiscChargeSS] ADD  DEFAULT (' ') FOR [Code]
GO
ALTER TABLE [dbo].[EDMiscChargeSS] ADD  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[EDMiscChargeSS] ADD  DEFAULT (' ') FOR [MiscChrgID]
GO
