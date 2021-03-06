USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_BI902_I]    Script Date: 12/21/2015 14:26:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BI902_I](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](50) NOT NULL,
	[RunDate] [char](50) NOT NULL,
	[RunTime] [char](50) NOT NULL,
	[TerminalNum] [char](50) NOT NULL,
	[status_pa] [char](50) NOT NULL,
	[project_billwith] [char](50) NOT NULL,
	[hold_status] [char](50) NOT NULL,
	[acct] [char](50) NOT NULL,
	[source_trx_date] [smalldatetime] NOT NULL,
	[amount] [float] NOT NULL,
	[project] [char](50) NOT NULL,
	[pjt_entity] [char](50) NOT NULL,
	[project_desc] [char](50) NOT NULL,
	[sort_num] [smallint] NOT NULL,
	[pm_id01] [char](50) NOT NULL,
	[code_ID] [char](50) NULL,
	[descr] [char](50) NULL,
	[end_date] [smalldatetime] NOT NULL,
	[li_type] [char](50) NOT NULL,
	[Name] [char](50) NULL,
	[draft_num] [char](50) NOT NULL,
	[acct_group_cd] [char](50) NOT NULL,
	[Bill_Status] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
