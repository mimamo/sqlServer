USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xtmpFixPJInvDet_ProjectFees]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpFixPJInvDet_ProjectFees](
	[project] [varchar](50) NULL,
	[pjt_entity] [varchar](50) NULL,
	[in_id19] [int] NULL,
	[acct] [varchar](50) NULL,
	[draft_num] [varchar](50) NULL,
	[source_trx_id] [int] NULL,
	[RecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_xtmpProjectDetailSourceProjFeesxx] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
