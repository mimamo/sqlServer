USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_TM011]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM011](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](25) NOT NULL,
	[RunDate] [varchar](12) NOT NULL,
	[RunTime] [varchar](12) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[Client_ID] [varchar](50) NOT NULL,
	[Client_Name] [varchar](50) NOT NULL,
	[Product_ID] [varchar](10) NOT NULL,
	[Product] [varchar](50) NOT NULL,
	[ProdGroup] [varchar](25) NOT NULL,
	[Job] [char](16) NOT NULL,
	[Job_Description] [varchar](50) NOT NULL,
	[DepartmentID] [varchar](5) NOT NULL,
	[Department] [varchar](50) NOT NULL,
	[Employee_ID] [varchar](50) NOT NULL,
	[Employee_Name] [varchar](100) NOT NULL,
	[TitleID] [varchar](10) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Week_Ending_Date] [smalldatetime] NOT NULL,
	[DocNbr] [varchar](12) NOT NULL,
	[Date_Entered] [smalldatetime] NOT NULL,
	[ClassID] [varchar](25) NOT NULL,
	[JanuaryHours] [float] NOT NULL,
	[FebruaryHours] [float] NOT NULL,
	[MarchHours] [float] NOT NULL,
	[AprilHours] [float] NOT NULL,
	[MayHours] [float] NOT NULL,
	[JuneHours] [float] NOT NULL,
	[JulyHours] [float] NOT NULL,
	[AugustHours] [float] NOT NULL,
	[SeptemberHours] [float] NOT NULL,
	[OctoberHours] [float] NOT NULL,
	[NovemberHours] [float] NOT NULL,
	[DecemberHours] [float] NOT NULL,
	[Total] [float] NOT NULL,
	[Fiscal_No] [varchar](50) NOT NULL,
	[MinMonth] [char](3) NOT NULL,
	[MaxMonth] [char](3) NOT NULL,
	[xConDate] [smalldatetime] NOT NULL,
	[CustClassID] [varchar](50) NOT NULL,
	[Source] [varchar](15) NOT NULL,
 CONSTRAINT [PK_xwrk_TM011] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
