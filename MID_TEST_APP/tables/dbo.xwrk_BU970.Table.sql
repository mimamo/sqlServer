USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_BU970]    Script Date: 12/21/2015 14:26:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BU970](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[Project] [char](16) NOT NULL,
	[ProjectDesc] [char](30) NOT NULL,
	[JobCat] [varchar](50) NULL,
	[FunctionCode] [char](32) NOT NULL,
	[FunctionDescr] [char](30) NOT NULL,
	[CustomerCode] [char](30) NOT NULL,
	[CustomerName] [char](30) NOT NULL,
	[ProductCode] [char](30) NOT NULL,
	[ProductDescr] [char](30) NOT NULL,
	[StatusPA] [char](1) NOT NULL,
	[Close_Date] [smalldatetime] NOT NULL,
	[BillAddr1] [char](30) NULL,
	[BillAddr2] [char](30) NULL,
	[BillCity] [char](30) NULL,
	[BillState] [char](3) NULL,
	[BillZip] [char](10) NULL,
	[PONum] [char](20) NOT NULL,
	[Supervisor] [char](10) NOT NULL,
	[ExtCost] [float] NOT NULL,
	[CostVouched] [float] NOT NULL,
	[CLECurrLockedEst] [char](4) NOT NULL,
	[CLEProjectNoteID] [int] NOT NULL,
	[CLECreate_Date] [smalldatetime] NOT NULL,
	[CLEFSYear] [int] NULL,
	[CLERevID] [char](4) NOT NULL,
	[CLEPrevRevID] [char](4) NOT NULL,
	[CLERevStatus] [char](2) NOT NULL,
	[CLERevDescr] [char](30) NOT NULL,
	[CLEEstAmount] [float] NOT NULL,
	[CLETaskNoteID] [int] NOT NULL,
	[ActAcct] [char](16) NOT NULL,
	[Amount01] [float] NOT NULL,
	[Amount02] [float] NOT NULL,
	[Amount03] [float] NOT NULL,
	[Amount04] [float] NOT NULL,
	[Amount05] [float] NOT NULL,
	[Amount06] [float] NOT NULL,
	[Amount07] [float] NOT NULL,
	[Amount08] [float] NOT NULL,
	[Amount09] [float] NOT NULL,
	[Amount10] [float] NOT NULL,
	[Amount11] [float] NOT NULL,
	[Amount12] [float] NOT NULL,
	[Amount13] [float] NOT NULL,
	[Amount14] [float] NOT NULL,
	[Amount15] [float] NOT NULL,
	[AmountBF] [float] NOT NULL,
	[FSYearNum] [char](4) NOT NULL,
	[AcctGroupCode] [char](2) NOT NULL,
	[ControlCode] [char](30) NOT NULL,
	[BTDAmount] [float] NOT NULL,
 CONSTRAINT [PK_xwrk_BU970] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
