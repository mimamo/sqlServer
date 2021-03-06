USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[EDNoteExport_Wrk]    Script Date: 12/21/2015 16:00:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EDNoteExport_Wrk](
	[ComputerName] [char](21) NOT NULL,
	[LineNbr] [int] NOT NULL,
	[nID] [int] NOT NULL,
	[NoteText] [char](200) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  DEFAULT ((0)) FOR [nID]
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  DEFAULT (' ') FOR [NoteText]
GO
