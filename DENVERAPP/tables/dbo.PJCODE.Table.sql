USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PJCODE]    Script Date: 12/21/2015 15:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCODE](
	[code_type] [char](4) NOT NULL,
	[code_value] [char](30) NOT NULL,
	[code_value_desc] [char](30) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](30) NOT NULL,
	[data2] [char](16) NOT NULL,
	[data3] [smalldatetime] NOT NULL,
	[data4] [float] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjcode0] PRIMARY KEY CLUSTERED 
(
	[code_type] ASC,
	[code_value] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
