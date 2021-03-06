USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSFASchedTemp]    Script Date: 12/21/2015 14:05:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSFASchedTemp](
	[AccessNbr] [smallint] NOT NULL,
	[AssetID] [char](10) NOT NULL,
	[AssetSubID] [char](10) NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[ScrnNbr] [char](5) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSFASchedTemp] ADD  DEFAULT ((0)) FOR [AccessNbr]
GO
ALTER TABLE [dbo].[PSSFASchedTemp] ADD  DEFAULT ('') FOR [AssetID]
GO
ALTER TABLE [dbo].[PSSFASchedTemp] ADD  DEFAULT ('') FOR [AssetSubID]
GO
ALTER TABLE [dbo].[PSSFASchedTemp] ADD  DEFAULT ('') FOR [CpnyId]
GO
ALTER TABLE [dbo].[PSSFASchedTemp] ADD  DEFAULT ('') FOR [ScrnNbr]
GO
