USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[SI21690_Wrk]    Script Date: 12/21/2015 14:10:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SI21690_Wrk](
	[RI_ID] [smallint] NOT NULL,
	[TaxId] [char](10) NOT NULL,
	[Descr] [char](30) NOT NULL,
	[SlsTaxGrp_TaxId] [char](10) NOT NULL,
	[SlsTax1_Descr] [char](30) NOT NULL,
	[SlsTax1_TaxRate] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
