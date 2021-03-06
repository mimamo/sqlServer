USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_PA938]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_PA938](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[CustomerCode] [char](30) NOT NULL,
	[CustomerName] [char](30) NOT NULL,
	[ProductCode] [char](30) NOT NULL,
	[ProductDesc] [char](30) NOT NULL,
	[Project] [char](16) NOT NULL,
	[JobCat] [char](4) NOT NULL,
	[ExtCost] [float] NULL,
	[CostVouched] [float] NULL,
	[ProjectDesc] [char](30) NOT NULL,
	[PONumber] [char](20) NOT NULL,
	[StatusPA] [char](1) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[OnShelfDate] [smalldatetime] NOT NULL,
	[CloseDate] [smalldatetime] NOT NULL,
	[Type] [char](16) NOT NULL,
	[SubType] [char](4) NOT NULL,
	[ECD] [smalldatetime] NULL,
	[OfferNum] [char](30) NOT NULL,
	[ClientContact] [char](30) NOT NULL,
	[ContactEmailAddress] [char](50) NOT NULL,
	[Differentiator] [float] NOT NULL,
	[PTODesignator] [float] NOT NULL,
	[PM] [char](10) NOT NULL,
	[FJ_Estimate] [float] NOT NULL,
	[EstimateAmountEAC] [float] NOT NULL,
	[EstimateAmountFAC] [float] NOT NULL,
	[EstimateAmountTotal] [float] NOT NULL,
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
	[FunctionsEntered] [varchar](255) NOT NULL,
 CONSTRAINT [PK_xwrk_PA938] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
