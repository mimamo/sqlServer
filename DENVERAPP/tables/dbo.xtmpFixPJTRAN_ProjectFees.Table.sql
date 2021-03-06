USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xtmpFixPJTRAN_ProjectFees]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpFixPJTRAN_ProjectFees](
	[project] [varchar](50) NULL,
	[pjt_entity] [varchar](50) NULL,
	[tr_id10] [int] NULL,
	[acct] [varchar](50) NULL,
	[batch_id] [varchar](50) NULL,
	[system_cd] [varchar](50) NULL,
	[fiscalNo] [varchar](50) NULL,
	[detail_num] [int] NULL,
	[RecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_xtmpProjectDetailSourceProjFees] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
