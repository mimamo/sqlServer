USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xkcCustInv]    Script Date: 12/21/2015 16:00:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xkcCustInv](
	[FromName] [char](30) NULL,
	[FromKey] [char](15) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[InvNbr] [char](10) NULL,
	[ToName] [char](30) NULL,
	[ToKey] [char](15) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
