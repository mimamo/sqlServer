USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_TM093]    Script Date: 12/21/2015 14:26:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM093](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](25) NOT NULL,
	[RunDate] [varchar](12) NOT NULL,
	[RunTime] [varchar](12) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[Type] [char](10) NOT NULL,
	[Period_End_Date] [smalldatetime] NOT NULL,
	[DepartmentID] [char](24) NOT NULL,
	[Department] [char](30) NOT NULL,
	[Date_Hired] [smalldatetime] NOT NULL,
	[EmployeeID] [char](10) NOT NULL,
	[EmpName] [varchar](50) NOT NULL,
	[SupervisorID] [char](10) NOT NULL,
	[SupName] [varchar](50) NOT NULL,
	[ApproverID] [char](10) NOT NULL,
	[ApprName] [varchar](50) NOT NULL,
	[TC_Status] [char](1) NOT NULL,
	[Emp_Status] [char](1) NOT NULL,
	[Date_Termed] [smalldatetime] NOT NULL,
	[FactoredTermDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_xwrk_TM093] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
