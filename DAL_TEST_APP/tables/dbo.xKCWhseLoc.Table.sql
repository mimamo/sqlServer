USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xKCWhseLoc]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xKCWhseLoc](
	[FromDescr] [char](30) NULL,
	[FromKey] [char](10) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[Siteid] [char](10) NULL,
	[ToDescr] [char](30) NULL,
	[ToKey] [char](10) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
