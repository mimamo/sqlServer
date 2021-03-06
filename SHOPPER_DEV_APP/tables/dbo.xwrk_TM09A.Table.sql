USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_TM09A]    Script Date: 12/21/2015 14:33:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM09A](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](25) NOT NULL,
	[RunDate] [varchar](12) NOT NULL,
	[RunTime] [varchar](12) NOT NULL,
	[TerminalNum] [varchar](25) NOT NULL,
	[Type] [char](10) NOT NULL,
	[Period_End_Date] [smalldatetime] NOT NULL,
	[Date_Entered] [smalldatetime] NOT NULL,
	[Day1Hours] [float] NOT NULL,
	[Day2Hours] [float] NOT NULL,
	[Day3Hours] [float] NOT NULL,
	[Day4Hours] [float] NOT NULL,
	[Day5Hours] [float] NOT NULL,
	[Day6Hours] [float] NOT NULL,
	[Day7Hours] [float] NOT NULL,
	[UnpaidHours] [float] NOT NULL,
	[Client_ID] [varchar](20) NOT NULL,
	[Product_ID] [varchar](20) NOT NULL,
	[Project_ID] [varchar](20) NOT NULL,
	[Emp_Name] [varchar](50) NOT NULL,
	[Emp_Status] [char](1) NOT NULL,
	[TC_Status] [char](1) NOT NULL,
	[Empmnt_Status] [char](2) NOT NULL,
	[Effective_Date] [smalldatetime] NOT NULL,
	[labor_class_cd] [char](4) NOT NULL,
	[HourlyRate] [float] NOT NULL,
	[SalaryAmt] [float] NOT NULL,
	[Emp_ID] [varchar](50) NOT NULL,
	[PTOHours] [float] NOT NULL,
	[GENHours] [float] NOT NULL,
	[WTDHours] [float] NOT NULL,
	[Project] [varchar](30) NOT NULL,
	[LineNbr] [varchar](25) NOT NULL,
	[DocNbr] [varchar](12) NOT NULL,
	[ADPFileID] [varchar](10) NOT NULL,
	[TempEmp] [bit] NOT NULL,
	[DateTimeCompleted] [smalldatetime] NOT NULL,
	[DateTimeApproved] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_xwrk_TM09A] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
