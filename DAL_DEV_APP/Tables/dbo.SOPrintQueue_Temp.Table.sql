USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[SOPrintQueue_Temp]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SOPrintQueue_Temp](
	[CpnyID] [char](10) NOT NULL,
	[DeviceName] [char](40) NOT NULL,
	[InvcNbr] [char](15) NOT NULL,
	[NotesOn] [smallint] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[ReportName] [char](30) NOT NULL,
	[Reprint] [smallint] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[Seq] [char](4) NOT NULL,
	[ShipperID] [char](15) NOT NULL,
	[SiteID] [char](10) NOT NULL,
	[SOTypeID] [char](4) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_CpnyID]  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_DeviceName]  DEFAULT (' ') FOR [DeviceName]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_InvcNbr]  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_NotesOn]  DEFAULT ((0)) FOR [NotesOn]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_ReportName]  DEFAULT (' ') FOR [ReportName]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_Reprint]  DEFAULT ((0)) FOR [Reprint]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_RI_ID]  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_Seq]  DEFAULT (' ') FOR [Seq]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_ShipperID]  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_SiteID]  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  CONSTRAINT [DF_SOPrintQueue_Temp_SOTypeID]  DEFAULT (' ') FOR [SOTypeID]
GO
