USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xwrk_MC_Data2]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_Data2](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Brand] [varchar](25) NULL,
	[Brand2] [varchar](25) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[BusinessUnit2] [varchar](50) NULL,
	[SubUnit] [varchar](20) NULL,
	[Department] [varchar](18) NULL,
	[ProjectID] [char](16) NOT NULL,
	[ProjectDesc] [char](60) NULL,
	[ClientID] [char](30) NOT NULL,
	[ProductID] [char](30) NOT NULL,
	[Employee_Name] [varchar](100) NULL,
	[Title] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[SalesMarketing2] [varchar](20) NULL,
	[CurMonth] [int] NULL,
	[CurHours] [float] NOT NULL,
	[fCastHours] [float] NULL,
	[Year] [int] NULL,
	[fiscalno] [char](6) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
