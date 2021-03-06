USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xwrk_BI902]    Script Date: 12/21/2015 16:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BI902](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[status_pa] [char](1) NOT NULL,
	[project_billwith] [char](16) NOT NULL,
	[hold_status] [char](2) NOT NULL,
	[acct] [char](16) NOT NULL,
	[source_trx_date] [smalldatetime] NOT NULL,
	[amount] [float] NOT NULL,
	[project] [char](16) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[project_desc] [char](30) NOT NULL,
	[sort_num] [smallint] NOT NULL,
	[pm_id01] [char](30) NOT NULL,
	[code_ID] [char](4) NULL,
	[descr] [char](30) NULL,
	[end_date] [smalldatetime] NOT NULL,
	[li_type] [char](1) NOT NULL,
	[Name] [char](30) NULL,
	[draft_num] [char](10) NOT NULL,
	[acct_group_cd] [char](2) NOT NULL,
	[Bill_Status] [varchar](1) NOT NULL,
 CONSTRAINT [PK_xwrk_BI902] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
