USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[SOPrintQueue_Temp]    Script Date: 12/21/2015 15:54:55 ******/
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
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [CpnyID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [DeviceName]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [InvcNbr]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT ((0)) FOR [NotesOn]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [ReportName]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT ((0)) FOR [Reprint]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [Seq]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [ShipperID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [SiteID]
GO
ALTER TABLE [dbo].[SOPrintQueue_Temp] ADD  DEFAULT (' ') FOR [SOTypeID]
GO
