USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[smWrkServCall]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smWrkServCall](
	[ExtCost] [float] NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[ServiceCallID] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
