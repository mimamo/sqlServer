USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xkcCpnySub]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xkcCpnySub](
	[FromDescr] [char](30) NULL,
	[FromKey] [char](50) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[ToDescr] [char](30) NULL,
	[ToKey] [char](50) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
