USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xCHARPAY]    Script Date: 12/21/2015 13:56:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xCHARPAY](
	[Custid] [char](15) NULL,
	[Linenbr] [smallint] NULL,
	[NewPayNbr] [char](10) NULL,
	[OldPayNbr] [char](10) NULL,
	[Special] [char](2) NULL,
	[Sub] [char](24) NULL,
	[USER1] [char](30) NULL,
	[USER2] [char](30) NULL,
	[USER3] [char](15) NULL,
	[USER4] [char](15) NULL,
	[USER5] [float] NULL,
	[USER6] [float] NULL,
	[USER7] [smalldatetime] NULL,
	[USER8] [smalldatetime] NULL,
	[USER9] [char](30) NULL,
	[USER10] [char](30) NULL,
	[USER11] [float] NULL,
	[USER12] [float] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
