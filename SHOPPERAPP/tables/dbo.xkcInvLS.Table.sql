USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xkcInvLS]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xkcInvLS](
	[FromKey] [char](25) NULL,
	[Global] [smallint] NULL,
	[GridOrder] [smallint] NULL,
	[Invtid] [char](30) NULL,
	[Invtid_Descr] [char](60) NULL,
	[LinkSpecID] [smallint] NULL,
	[ToKey] [char](25) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
