USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[kc21chg]    Script Date: 12/21/2015 16:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[kc21chg](
	[FromDescr] [char](60) NULL,
	[FromKey] [char](50) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[Keyid] [char](8) NULL,
	[OrigGlobal] [smallint] NULL,
	[ToDescr] [char](60) NULL,
	[ToKey] [char](50) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
