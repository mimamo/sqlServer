USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPENTEX]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPENTEX](
	[COMPUTED_DATE] [smalldatetime] NOT NULL,
	[COMPUTED_PC] [float] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[ENTERED_PC] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NOTEID] [int] NOT NULL,
	[PE_ID11] [char](30) NOT NULL,
	[PE_ID12] [char](30) NOT NULL,
	[PE_ID13] [char](16) NOT NULL,
	[PE_ID14] [char](16) NOT NULL,
	[PE_ID15] [char](4) NOT NULL,
	[PE_ID16] [float] NOT NULL,
	[PE_ID17] [float] NOT NULL,
	[PE_ID18] [smalldatetime] NOT NULL,
	[PE_ID19] [smalldatetime] NOT NULL,
	[PE_ID20] [int] NOT NULL,
	[PE_ID21] [char](30) NOT NULL,
	[PE_ID22] [char](30) NOT NULL,
	[PE_ID23] [char](16) NOT NULL,
	[PE_ID24] [char](16) NOT NULL,
	[PE_ID25] [char](4) NOT NULL,
	[PE_ID26] [float] NOT NULL,
	[PE_ID27] [float] NOT NULL,
	[PE_ID28] [smalldatetime] NOT NULL,
	[PE_ID29] [smalldatetime] NOT NULL,
	[PE_ID30] [int] NOT NULL,
	[PJT_ENTITY] [char](32) NOT NULL,
	[PROJECT] [char](16) NOT NULL,
	[REVISION_DATE] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjpentex0] PRIMARY KEY CLUSTERED 
(
	[PROJECT] ASC,
	[PJT_ENTITY] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
