USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_MC_Data_Bak_20150407]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[xwrk_MC_Data_Bak_20150407](
	[Brand] [varchar](25) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[SubUnit] [varchar](20) NULL,
	[Employee_Name] [varchar](100) NULL,
	[DepartmentID] [varchar](18) NULL,
	[Department] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[POS] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[xconDate] [datetime] NULL,
	[CurMonth] [int] NULL,
	[Year] [int] NULL,
	[Hours] [float] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProjectDesc] [char](60) NULL,
	[ClientID] [char](30) NOT NULL,
	[ProdID] [char](30) NOT NULL,
	[fiscalno] [char](6) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
