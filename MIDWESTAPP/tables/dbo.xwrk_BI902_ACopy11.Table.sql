USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xwrk_BI902_ACopy11]    Script Date: 12/21/2015 15:54:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BI902_ACopy11](
	[ID] [int] NULL,
	[RI_ID] [int] NULL,
	[UserID] [varchar](50) NULL,
	[RunDate] [varchar](50) NULL,
	[RunTime] [varchar](50) NULL,
	[TerminalNum] [varchar](50) NULL,
	[status_pa] [varchar](50) NULL,
	[project_billwith] [varchar](50) NULL,
	[hold_status] [varchar](50) NULL,
	[acct] [varchar](50) NULL,
	[source_trx_date] [datetime] NULL,
	[amount] [float] NULL,
	[project] [varchar](50) NULL,
	[pjt_entity] [varchar](50) NULL,
	[project_desc] [varchar](50) NULL,
	[sort_num] [smallint] NULL,
	[pm_id01] [varchar](50) NULL,
	[code_ID] [varchar](50) NULL,
	[descr] [varchar](50) NULL,
	[end_date] [datetime] NULL,
	[li_type] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[draft_num] [varchar](50) NULL,
	[acct_group_cd] [varchar](50) NULL,
	[Bill_Status] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
