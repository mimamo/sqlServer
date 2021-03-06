USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xkcOrder]    Script Date: 12/21/2015 14:26:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xkcOrder](
	[Cpnyid] [char](10) NULL,
	[DupCpnyid] [char](10) NULL,
	[Linenbr] [smallint] NULL,
	[NewOrdnbr] [char](15) NULL,
	[OldOrdnbr] [char](15) NULL,
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
