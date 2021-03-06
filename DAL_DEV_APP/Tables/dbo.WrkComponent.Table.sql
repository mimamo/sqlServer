USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkComponent]    Script Date: 12/21/2015 13:35:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkComponent](
	[CmpnentID] [char](30) NOT NULL,
	[CmpnentType] [char](1) NOT NULL,
	[GrossReqQty] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[WrkComponent] ADD  CONSTRAINT [DF_WrkComponent_CmpnentID]  DEFAULT (' ') FOR [CmpnentID]
GO
ALTER TABLE [dbo].[WrkComponent] ADD  CONSTRAINT [DF_WrkComponent_CmpnentType]  DEFAULT (' ') FOR [CmpnentType]
GO
ALTER TABLE [dbo].[WrkComponent] ADD  CONSTRAINT [DF_WrkComponent_GrossReqQty]  DEFAULT ((0)) FOR [GrossReqQty]
GO
