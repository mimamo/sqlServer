USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xKCTask]    Script Date: 12/21/2015 14:10:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xKCTask](
	[FromDescr] [char](30) NULL,
	[FromKey] [char](32) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[Project] [char](16) NULL,
	[ToDescr] [char](30) NULL,
	[ToKey] [char](32) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
