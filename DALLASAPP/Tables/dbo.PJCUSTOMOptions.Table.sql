USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJCUSTOMOptions]    Script Date: 12/21/2015 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJCUSTOMOptions](
	[applicationID] [char](10) NOT NULL,
	[co_id01] [char](30) NOT NULL,
	[co_id02] [char](30) NOT NULL,
	[co_id03] [char](16) NOT NULL,
	[co_id04] [char](16) NOT NULL,
	[co_id05] [char](4) NOT NULL,
	[co_id06] [float] NOT NULL,
	[co_id07] [float] NOT NULL,
	[co_id08] [smalldatetime] NOT NULL,
	[co_id09] [smalldatetime] NOT NULL,
	[co_id10] [int] NOT NULL,
	[co_id11] [char](30) NOT NULL,
	[co_id12] [char](30) NOT NULL,
	[co_id13] [char](20) NOT NULL,
	[co_id14] [char](20) NOT NULL,
	[co_id15] [char](10) NOT NULL,
	[co_id16] [char](10) NOT NULL,
	[co_id17] [char](4) NOT NULL,
	[co_id18] [float] NOT NULL,
	[co_id19] [float] NOT NULL,
	[co_id20] [smalldatetime] NOT NULL,
	[defaultoption] [bit] NOT NULL,
	[displayoption] [bit] NOT NULL,
	[enableoption] [bit] NOT NULL,
	[fieldID] [char](10) NOT NULL,
	[labeloption] [bit] NOT NULL,
	[taboption] [bit] NOT NULL,
	[PVoption] [bit] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[userid] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PJCUSTOMOptions0] PRIMARY KEY CLUSTERED 
(
	[applicationID] ASC,
	[fieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
