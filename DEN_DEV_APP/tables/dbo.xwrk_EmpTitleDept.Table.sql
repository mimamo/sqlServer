USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_EmpTitleDept]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_EmpTitleDept](
	[eID] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [varchar](30) NULL,
	[Title] [varchar](75) NULL,
	[Department] [varchar](10) NULL,
	[ChangeDate] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
