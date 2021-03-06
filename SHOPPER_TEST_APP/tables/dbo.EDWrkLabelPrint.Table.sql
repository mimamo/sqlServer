USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[EDWrkLabelPrint]    Script Date: 12/21/2015 16:06:18 ******/
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
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [ContainerID]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [DataFile]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [IniFileName]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [LabelDBPath]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [LabelFileName]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT ((0)) FOR [NbrCopy]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT ('01/01/1900') FOR [Printed]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [PrinterName]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[EDWrkLabelPrint] ADD  DEFAULT (' ') FOR [SiteID]
GO
