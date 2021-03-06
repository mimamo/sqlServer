USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[EDNoteExport_Wrk]    Script Date: 12/21/2015 14:10:05 ******/
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
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  CONSTRAINT [DF_EDNoteExport_Wrk_ComputerName]  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  CONSTRAINT [DF_EDNoteExport_Wrk_LineNbr]  DEFAULT ((0)) FOR [LineNbr]
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  CONSTRAINT [DF_EDNoteExport_Wrk_nID]  DEFAULT ((0)) FOR [nID]
GO
ALTER TABLE [dbo].[EDNoteExport_Wrk] ADD  CONSTRAINT [DF_EDNoteExport_Wrk_NoteText]  DEFAULT (' ') FOR [NoteText]
GO
