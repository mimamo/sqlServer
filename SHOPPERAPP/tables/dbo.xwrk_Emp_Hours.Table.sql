USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_Emp_Hours]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_Emp_Hours](
	[eID] [int] IDENTITY(1,1) NOT NULL,
	[FileNbr] [varchar](15) NULL,
	[EmpID] [varchar](30) NULL,
	[EmpName] [varchar](50) NULL,
	[Department] [varchar](6) NULL,
	[Rate] [decimal](10, 2) NULL,
	[TotHrs] [decimal](14, 2) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
