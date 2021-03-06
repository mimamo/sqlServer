USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_PA929]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_PA929](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RI_ID] [smallint] NOT NULL,
	[UserId] [char](47) NOT NULL,
	[SystemDate] [char](10) NOT NULL,
	[SystemTime] [char](7) NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[CustomerCode] [char](30) NULL,
	[CustomerName] [char](60) NOT NULL,
	[ProductCode] [char](30) NULL,
	[ProductDesc] [char](30) NOT NULL,
	[Project_Billwith] [char](16) NOT NULL,
	[ProjectDesc] [char](60) NULL,
	[JobCat] [char](4) NULL,
	[ExtCost] [float] NULL,
	[CostVouched] [float] NULL,
	[PONumber] [char](20) NULL,
	[StatusPA] [char](1) NULL,
	[StartDate] [smalldatetime] NULL,
	[OnShelfDate] [smalldatetime] NULL,
	[CloseDate] [smalldatetime] NULL,
	[Type] [char](16) NULL,
	[SubType] [char](4) NULL,
	[ECD] [smalldatetime] NULL,
	[OfferNum] [char](30) NULL,
	[ClientContact] [char](30) NULL,
	[ContactEmailAddress] [char](50) NULL,
	[RetailCustName] [char](30) NULL,
	[RetailCustomerID] [char](30) NULL,
	[Differentiator] [float] NULL,
	[PTODesignator] [float] NULL,
	[PM] [char](10) NULL,
	[AcctService] [char](10) NULL,
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
	[ULEAmount] [float] NOT NULL,
	[ULECreate_Date] [smalldatetime] NOT NULL,
	[SortByHeader] [varchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
