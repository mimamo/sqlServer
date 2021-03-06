USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_MC_FCast_Audit]    Script Date: 12/21/2015 13:35:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_MC_FCast_Audit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AUDIT_STAMP] [datetime] NOT NULL,
	[AUDIT_ACTN] [char](15) NOT NULL,
	[AUDIT_USER] [char](30) NOT NULL,
	[BusinessUnit] [varchar](50) NULL,
	[SubUnit] [varchar](50) NULL,
	[Department] [varchar](50) NULL,
	[SalesMarketing] [varchar](20) NULL,
	[fMonth] [int] NULL,
	[fPpl] [float] NULL,
	[fYear] [int] NULL,
	[fte_adj] [float] NULL,
	[adj_fPpl] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
