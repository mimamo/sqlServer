USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[smWrkExpire]    Script Date: 12/21/2015 13:56:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkExpire](
	[ActBilled] [float] NOT NULL,
	[ActCalls] [smallint] NOT NULL,
	[ActHours] [float] NOT NULL,
	[ActLabor] [float] NOT NULL,
	[ActMaterial] [float] NOT NULL,
	[ContractID] [char](10) NOT NULL,
	[EstBilled] [float] NOT NULL,
	[EstCalls] [smallint] NOT NULL,
	[EstHours] [float] NOT NULL,
	[EstLabor] [float] NOT NULL,
	[EstMaterial] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
