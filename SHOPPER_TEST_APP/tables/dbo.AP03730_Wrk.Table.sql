USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[AP03730_Wrk]    Script Date: 12/21/2015 16:06:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP03730_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[VendId] [char](15) NULL,
	[GL_SetupId] [char](2) NULL,
	[AP_SetupId] [char](2) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
