USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_01896]    Script Date: 12/21/2015 14:10:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_01896](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[RunDate] [smalldatetime] NOT NULL,
	[RunTime] [varchar](25) NOT NULL,
	[TerminalNum] [varchar](50) NOT NULL,
	[acct_grp] [varchar](13) NOT NULL,
	[Amount] [float] NULL,
	[pm_id01] [char](30) NOT NULL,
	[Name] [char](30) NULL,
	[pm_id02] [char](30) NOT NULL,
	[descr] [char](30) NULL,
	[project] [char](16) NOT NULL,
	[project_desc] [char](30) NOT NULL,
	[pjt_entity] [char](32) NULL,
	[trans_date] [smalldatetime] NULL,
	[acct] [char](16) NULL,
	[status_pa] [char](1) NOT NULL,
	[Batch_ID] [char](10) NOT NULL,
	[Detail_Num] [int] NOT NULL,
	[System_cd] [char](2) NOT NULL,
	[fiscalno] [char](6) NOT NULL,
 CONSTRAINT [PK_xwrk_01896] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
