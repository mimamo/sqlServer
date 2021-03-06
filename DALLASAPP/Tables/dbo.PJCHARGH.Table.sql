USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJCHARGH]    Script Date: 12/21/2015 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCHARGH](
	[BaseCuryID] [char](4) NOT NULL,
	[batch_amount] [float] NOT NULL,
	[batch_bal] [float] NOT NULL,
	[batch_desc1] [char](50) NOT NULL,
	[batch_id] [char](10) NOT NULL,
	[batch_status] [char](1) NOT NULL,
	[batch_type] [char](4) NOT NULL,
	[cpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[data1] [char](16) NOT NULL,
	[data2] [char](16) NOT NULL,
	[data3] [float] NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[last_detail_num] [smallint] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[post_date] [smalldatetime] NOT NULL,
	[rate_table_id] [char](4) NOT NULL,
	[rate_type_cd] [char](2) NOT NULL,
	[system_cd] [char](2) NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjchargh0] PRIMARY KEY CLUSTERED 
(
	[batch_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
