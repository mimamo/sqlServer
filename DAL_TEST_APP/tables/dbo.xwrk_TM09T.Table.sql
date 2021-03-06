USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_TM09T]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM09T](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](30) NOT NULL,
	[RunDate] [smalldatetime] NOT NULL,
	[RunTime] [varchar](30) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[Date_Entered] [smalldatetime] NULL,
	[Period_End_Date] [smalldatetime] NOT NULL,
	[Employee] [char](40) NOT NULL,
	[EmployeeID] [char](10) NOT NULL,
	[Date_Hired] [smalldatetime] NOT NULL,
	[DepartmentID] [char](24) NOT NULL,
	[Emp_Status] [char](1) NOT NULL,
	[DaysDiff] [int] NULL,
	[TCRefNbr] [char](10) NULL,
	[TCSTatus] [char](1) NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[CutOffDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_xwrk_TM09T] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
