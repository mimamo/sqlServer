USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xTRAPS_Note]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_Note](
	[NoteID] [int] NOT NULL,
	[Note] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
