USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_MC_Forecast_BAK_10_2012]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_Forecast_BAK_10_2012](
	[BusinessUnit] [varchar](50) NULL,
	[Department] [varchar](50) NULL,
	[Employee] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[fMonth] [int] NULL,
	[fPpl] [float] NULL,
	[fYear] [int] NULL,
	[fte_adj] [float] NULL,
	[adj_fPpl] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
