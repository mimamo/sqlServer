USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_TM200]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_TM200](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[ProdID] [char](30) NULL,
	[DepartmentID] [char](24) NOT NULL,
	[Indicator] [varchar](2) NOT NULL,
	[ClientID] [char](30) NULL,
	[Client] [nvarchar](50) NULL,
	[GroupDesc] [nvarchar](50) NULL,
	[DirectGroupDesc] [nvarchar](50) NULL,
	[Product] [nvarchar](50) NULL,
	[Department] [char](30) NULL,
	[TTLHrs] [float] NULL,
	[xFiscalYear] [varchar](4) NULL,
	[xFiscalNo] [char](35) NULL,
 CONSTRAINT [PK_xwrk_TM200] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
