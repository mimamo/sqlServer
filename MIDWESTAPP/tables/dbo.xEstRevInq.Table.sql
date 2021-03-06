USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xEstRevInq]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xEstRevInq](
	[NoteID] [int] NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[pjt_entity_desc] [char](30) NOT NULL,
	[project] [char](16) NOT NULL,
	[PrevEst] [float] NOT NULL,
	[RevAmt] [float] NOT NULL,
	[RevId] [char](4) NOT NULL,
	[RevisedEst] [float] NOT NULL,
	[Actual] [float] NOT NULL,
	[Variance] [float] NOT NULL,
	[Billed] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
