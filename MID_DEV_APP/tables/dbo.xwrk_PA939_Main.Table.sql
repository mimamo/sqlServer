USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_PA939_Main]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_PA939_Main](
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
	[ProjectDesc] [char](30) NOT NULL,
	[StatusPA] [char](1) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[OnShelfDate] [smalldatetime] NOT NULL,
	[PM] [char](10) NOT NULL,
	[FunctionCode] [char](32) NOT NULL,
	[TrxFunctionCode] [char](32) NOT NULL,
	[FunctionCLE] [float] NOT NULL,
	[TotalCLE] [float] NOT NULL,
	[FunctionBucket] [varchar](7) NOT NULL,
	[PJPENTProject] [char](16) NOT NULL,
 CONSTRAINT [PK_xwrk_PA939_Main] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
