USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xPA940Sort]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xPA940Sort](
	[SortName] [char](30) NOT NULL,
	[sortID] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
