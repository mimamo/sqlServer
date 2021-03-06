USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[EDMiscChargeSS]    Script Date: 12/21/2015 13:43:59 ******/
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
ALTER TABLE [dbo].[EDMiscChargeSS] ADD  CONSTRAINT [DF_EDMiscChargeSS_Code]  DEFAULT (' ') FOR [Code]
GO
ALTER TABLE [dbo].[EDMiscChargeSS] ADD  CONSTRAINT [DF_EDMiscChargeSS_Description]  DEFAULT (' ') FOR [Description]
GO
ALTER TABLE [dbo].[EDMiscChargeSS] ADD  CONSTRAINT [DF_EDMiscChargeSS_MiscChrgID]  DEFAULT (' ') FOR [MiscChrgID]
GO
