USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_TM009_A]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM009_A](
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
	[DepartmentID] [varchar](4) NOT NULL,
	[Department] [varchar](50) NOT NULL,
	[Employee_ID] [varchar](50) NOT NULL,
	[Employee_Name] [varchar](100) NOT NULL,
	[TitleID] [varchar](10) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Week_Ending_Date] [smalldatetime] NOT NULL,
	[Date_Entered] [smalldatetime] NOT NULL,
	[ClassID] [varchar](25) NOT NULL,
	[Total] [float] NOT NULL,
	[Fiscal_No] [varchar](50) NOT NULL,
	[MinMonth] [char](3) NOT NULL,
	[MaxMonth] [char](3) NOT NULL,
	[xConDate] [smalldatetime] NOT NULL,
	[YAxisField1] [varchar](35) NULL,
	[YAxisField2] [varchar](35) NULL,
	[YAxisField3] [varchar](35) NULL,
	[YAxisField4] [varchar](35) NULL,
	[YAxisField5] [varchar](35) NULL,
	[YAxisField6] [varchar](35) NULL,
	[XAxisField1] [varchar](35) NULL,
	[XAxisField2] [varchar](35) NULL,
	[SortBy] [varchar](100) NOT NULL,
	[LastSortByParm] [varchar](50) NOT NULL,
	[dispGroupFooter1] [varchar](160) NOT NULL,
	[dispGroupFooter2] [varchar](160) NOT NULL,
	[dispGroupFooter3] [varchar](160) NOT NULL,
	[dispGroupFooter4] [varchar](160) NOT NULL,
	[dispGroupFooter5] [varchar](160) NOT NULL,
	[dispGroupFooter6] [varchar](160) NOT NULL,
	[GroupHeader1] [char](50) NOT NULL,
	[GroupHeader2] [char](50) NOT NULL,
	[GroupHeader3] [char](50) NOT NULL,
	[GroupHeader4] [char](50) NOT NULL,
	[GroupHeader5] [char](50) NOT NULL,
	[GroupHeader6] [char](50) NOT NULL,
	[GroupTitle1] [varchar](153) NOT NULL,
	[GroupTitle2] [varchar](153) NOT NULL,
	[GroupTitle3] [varchar](153) NOT NULL,
	[GroupTitle4] [varchar](153) NOT NULL,
	[GroupTitle5] [varchar](153) NOT NULL,
	[GroupTitle6] [varchar](153) NOT NULL,
	[Year] [varchar](50) NOT NULL,
 CONSTRAINT [PK_xwrk_TM009_A] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
