USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PJIMPEXP]    Script Date: 12/21/2015 14:33:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJIMPEXP](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[data1] [char](2) NOT NULL,
	[data2] [char](4) NOT NULL,
	[data3] [char](10) NOT NULL,
	[data4] [char](30) NOT NULL,
	[data5] [char](30) NOT NULL,
	[fld01_col] [smallint] NOT NULL,
	[fld02_col] [smallint] NOT NULL,
	[fld03_col] [smallint] NOT NULL,
	[fld04_col] [smallint] NOT NULL,
	[fld05_col] [smallint] NOT NULL,
	[fld06_col] [smallint] NOT NULL,
	[fld07_col] [smallint] NOT NULL,
	[fld08_col] [smallint] NOT NULL,
	[fld09_col] [smallint] NOT NULL,
	[fld10_col] [smallint] NOT NULL,
	[fld11_col] [smallint] NOT NULL,
	[fld12_col] [smallint] NOT NULL,
	[fld13_col] [smallint] NOT NULL,
	[fld14_col] [smallint] NOT NULL,
	[fld15_col] [smallint] NOT NULL,
	[fld16_col] [smallint] NOT NULL,
	[fld17_col] [smallint] NOT NULL,
	[fld18_col] [smallint] NOT NULL,
	[fld19_col] [smallint] NOT NULL,
	[fld20_col] [smallint] NOT NULL,
	[fld21_col] [smallint] NOT NULL,
	[fld22_col] [smallint] NOT NULL,
	[fld23_col] [smallint] NOT NULL,
	[fld24_col] [smallint] NOT NULL,
	[fld25_col] [smallint] NOT NULL,
	[fld26_col] [smallint] NOT NULL,
	[fld27_col] [smallint] NOT NULL,
	[fld28_col] [smallint] NOT NULL,
	[fld29_col] [smallint] NOT NULL,
	[fld30_col] [smallint] NOT NULL,
	[fld31_col] [smallint] NOT NULL,
	[fld32_col] [smallint] NOT NULL,
	[fld33_col] [smallint] NOT NULL,
	[fld34_col] [smallint] NOT NULL,
	[fld35_col] [smallint] NOT NULL,
	[fld36_col] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[map_desc] [char](30) NOT NULL,
	[map_id] [char](8) NOT NULL,
	[map_type] [char](2) NOT NULL,
	[noteid] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjimpexp0] PRIMARY KEY CLUSTERED 
(
	[map_type] ASC,
	[map_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
