USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[Wrk13610]    Script Date: 12/21/2015 16:12:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk13610](
	[FirstTagNbr] [int] NOT NULL,
	[LastTagNbr] [int] NOT NULL,
	[PacketNbr] [int] NOT NULL,
	[PIID] [char](10) NOT NULL,
	[TotalNbrTags] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
