USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[WrkW2Letter]    Script Date: 12/21/2015 13:44:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkW2Letter](
	[Amt] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Descr] [char](50) NOT NULL,
	[Letter] [char](2) NOT NULL,
	[NoteId] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
