USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_MC_Data_L360_BAK_2_14_2013]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_Data_L360_BAK_2_14_2013](
	[Brand] [varchar](20) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[SubUnit] [varchar](20) NULL,
	[Department] [varchar](18) NULL,
	[ProjectID] [char](50) NULL,
	[ProjectDesc] [char](2000) NULL,
	[ClientID] [char](30) NULL,
	[ProductID] [char](300) NULL,
	[Employee_Name] [varchar](8000) NULL,
	[Title] [varchar](30) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[CurMonth] [int] NULL,
	[CurHours] [float] NOT NULL,
	[Year] [int] NULL,
	[fiscalno] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
