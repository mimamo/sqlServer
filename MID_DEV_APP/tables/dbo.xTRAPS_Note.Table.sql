USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xTRAPS_Note]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_Note](
	[NoteID] [int] NOT NULL,
	[Note] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
