USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPROJEX]    Script Date: 12/21/2015 16:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPROJEX](
	[computed_date] [smalldatetime] NOT NULL,
	[computed_pc] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[entered_pc] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[PM_ID11] [char](30) NOT NULL,
	[PM_ID12] [char](30) NOT NULL,
	[PM_ID13] [char](16) NOT NULL,
	[PM_ID14] [char](16) NOT NULL,
	[PM_ID15] [char](4) NOT NULL,
	[PM_ID16] [float] NOT NULL,
	[PM_ID17] [float] NOT NULL,
	[PM_ID18] [smalldatetime] NOT NULL,
	[PM_ID19] [smalldatetime] NOT NULL,
	[PM_ID20] [int] NOT NULL,
	[PM_ID21] [char](30) NOT NULL,
	[PM_ID22] [char](30) NOT NULL,
	[PM_ID23] [char](16) NOT NULL,
	[PM_ID24] [char](16) NOT NULL,
	[PM_ID25] [char](4) NOT NULL,
	[PM_ID26] [float] NOT NULL,
	[PM_ID27] [float] NOT NULL,
	[PM_ID28] [smalldatetime] NOT NULL,
	[PM_ID29] [smalldatetime] NOT NULL,
	[PM_ID30] [int] NOT NULL,
	[proj_date1] [smalldatetime] NOT NULL,
	[proj_date2] [smalldatetime] NOT NULL,
	[proj_date3] [smalldatetime] NOT NULL,
	[proj_date4] [smalldatetime] NOT NULL,
	[project] [char](16) NOT NULL,
	[rate_table_labor] [char](4) NOT NULL,
	[revision_date] [smalldatetime] NOT NULL,
	[rev_flag] [char](1) NOT NULL,
	[rev_type] [char](2) NOT NULL,
	[work_comp_cd] [char](6) NOT NULL,
	[work_location] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjprojex0] PRIMARY KEY CLUSTERED 
(
	[project] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
