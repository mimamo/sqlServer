USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJNOTES]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJNOTES](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[key_index] [char](2) NOT NULL,
	[key_value] [char](64) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[notes1] [char](254) NOT NULL,
	[notes2] [char](254) NOT NULL,
	[notes3] [char](254) NOT NULL,
	[note_disp] [char](40) NOT NULL,
	[note_type_cd] [char](4) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjnotes0] PRIMARY KEY CLUSTERED 
(
	[note_type_cd] ASC,
	[key_value] ASC,
	[key_index] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
