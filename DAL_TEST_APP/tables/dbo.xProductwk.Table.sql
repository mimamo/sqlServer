USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xProductwk]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xProductwk](
	[Product] [char](4) NOT NULL,
	[pm_1d02] [char](30) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
