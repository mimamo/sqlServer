USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[EDWrkLabelPrint]    Script Date: 12/21/2015 15:42:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDWrkLabelPrint](
	[ContainerID] [char](10) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[DataFile] [char](255) NOT NULL,
	[IniFileName] [char](255) NOT NULL,
	[LabelDBPath] [char](255) NOT NULL,
	[LabelFileName] [char](255) NOT NULL,
	[NbrCopy] [smallint] NOT NULL,
	[Printed] [smalldatetime] NOT NULL,
	[PrinterName] [char](20) NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_ContainerID]  DEFAULT (' ') FOR [ContainerID]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_DataFile]  DEFAULT (' ') FOR [DataFile]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_IniFileName]  DEFAULT (' ') FOR [IniFileName]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_LabelDBPath]  DEFAULT (' ') FOR [LabelDBPath]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_LabelFileName]  DEFAULT (' ') FOR [LabelFileName]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_NbrCopy]  DEFAULT ((0)) FOR [NbrCopy]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_Printed]  DEFAULT ('01/01/1900') FOR [Printed]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_PrinterName]  DEFAULT (' ') FOR [PrinterName]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  CONSTRAINT [DF_EDWrkLabelPrint_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
