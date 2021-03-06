USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_TM095]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM095](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](25) NOT NULL,
	[RunDate] [varchar](12) NOT NULL,
	[RunTime] [varchar](12) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[Account] [varchar](16) NOT NULL,
	[Employee_ID] [varchar](50) NOT NULL,
	[Employee_Name] [varchar](100) NOT NULL,
	[Sub_Account] [varchar](4) NOT NULL,
	[Department] [varchar](50) NOT NULL,
	[Job] [char](16) NOT NULL,
	[Job_Description] [varchar](50) NOT NULL,
	[Timecard_Status] [char](1) NULL,
	[Week_Ending_Date] [smalldatetime] NULL,
	[DocNbr] [varchar](12) NOT NULL,
	[BatchID] [varchar](12) NOT NULL,
	[Date_Entered] [smalldatetime] NULL,
	[CreatedDateTime] [smalldatetime] NULL,
	[Hours] [float] NOT NULL,
	[Client_ID] [varchar](50) NOT NULL,
	[ClassID] [char](10) NOT NULL,
	[Client_Name] [varchar](50) NOT NULL,
	[Fiscal_No] [varchar](50) NOT NULL,
	[DetailNum] [int] NOT NULL,
	[Product_ID] [varchar](10) NOT NULL,
	[xTrans_Date] [varchar](50) NOT NULL,
	[Product] [varchar](50) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[ProdGroup] [varchar](50) NOT NULL,
	[xConDate] [smalldatetime] NULL,
	[YearWorked] [int] NOT NULL,
	[YearPosted] [int] NOT NULL,
	[System_cd] [varchar](50) NOT NULL,
 CONSTRAINT [PK_xwrk_TM095] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
