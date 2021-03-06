USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[Snote]    Script Date: 12/21/2015 13:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Snote](
	[dtRevisedDate] [smalldatetime] NOT NULL,
	[nID] [int] IDENTITY(1,1) NOT NULL,
	[sLevelName] [char](20) NOT NULL,
	[sTableName] [char](20) NOT NULL,
	[sNoteText] [text] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [SNote0] PRIMARY KEY CLUSTERED 
(
	[nID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
