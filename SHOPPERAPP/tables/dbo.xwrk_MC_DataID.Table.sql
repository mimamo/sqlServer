USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_MC_DataID]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_DataID](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Brand] [varchar](20) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[SubUnit] [varchar](20) NULL,
	[Department] [varchar](18) NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProjectDesc] [char](60) NULL,
	[ClientID] [char](30) NOT NULL,
	[ProductID] [char](30) NOT NULL,
	[Employee_Name] [varchar](100) NULL,
	[Title] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[CurMonth] [int] NULL,
	[CurHours] [float] NOT NULL,
	[Year] [int] NULL,
	[fiscalno] [char](6) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
