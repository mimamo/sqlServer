USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[IN10550_Wrk]    Script Date: 12/21/2015 13:35:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10550_Wrk](
	[ComputerName] [char](21) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[KitID] [char](30) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10550_Wrk] ADD  CONSTRAINT [DF_IN10550_Wrk_ComputerName]  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[IN10550_Wrk] ADD  CONSTRAINT [DF_IN10550_Wrk_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10550_Wrk] ADD  CONSTRAINT [DF_IN10550_Wrk_KitID]  DEFAULT (' ') FOR [KitID]
GO
ALTER TABLE [dbo].[IN10550_Wrk] ADD  CONSTRAINT [DF_IN10550_Wrk_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
