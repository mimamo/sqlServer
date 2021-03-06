USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_BU971]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BU971](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[ProjectAPS] [char](16) NOT NULL,
	[ProjectAGY] [char](16) NOT NULL,
	[ProjectDescAPS] [char](60) NOT NULL,
	[JobCatAPS] [char](4) NOT NULL,
	[PMAGY] [char](10) NOT NULL,
	[PMAPS] [char](10) NOT NULL,
	[FunctionCodeAPS] [char](32) NOT NULL,
	[FunctionDescrAPS] [char](60) NOT NULL,
	[CustomerCodeAPS] [char](30) NOT NULL,
	[CustomerNameAPS] [char](60) NOT NULL,
	[ClientClassIDAPS] [char](6) NULL,
	[ProductCodeAPS] [char](30) NOT NULL,
	[ProductDescrAPS] [char](30) NOT NULL,
	[StatusAPS] [char](1) NOT NULL,
	[StatusAGY] [char](1) NOT NULL,
	[Start_DateAPS] [smalldatetime] NOT NULL,
	[Close_DateAPS] [smalldatetime] NOT NULL,
	[Close_DateAGY] [smalldatetime] NOT NULL,
	[OnShelf_DateAPS] [smalldatetime] NOT NULL,
	[LastActivityDateAGY] [smalldatetime] NOT NULL,
	[LastActivityDateAPS] [smalldatetime] NOT NULL,
	[PONumAPS] [char](20) NOT NULL,
	[ExtCost] [float] NOT NULL,
	[CostVouched] [float] NOT NULL,
	[CLECurrLockedEst] [char](4) NOT NULL,
	[CLEProjectNoteID] [int] NOT NULL,
	[CLECreate_Date] [smalldatetime] NOT NULL,
	[CLEFSYear] [int] NOT NULL,
	[CLERevID] [char](4) NOT NULL,
	[CLEPrevRevID] [char](4) NOT NULL,
	[CLERevStatus] [char](2) NOT NULL,
	[CLERevDescr] [char](60) NOT NULL,
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
	[DaysSinceLastAct] [int] NULL,
	[DaysSinceOpen] [int] NULL,
 CONSTRAINT [PK_xwrk_BU971] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
