USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xLotsermst]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xLotsermst](
	[invtid] [char](30) NOT NULL,
	[invtid_descr] [char](60) NOT NULL,
	[LotSerNbr] [char](25) NOT NULL,
	[userid] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
