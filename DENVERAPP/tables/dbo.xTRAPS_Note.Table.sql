USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xTRAPS_Note]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xTRAPS_Note](
	[NoteID] [int] NOT NULL,
	[Note] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
