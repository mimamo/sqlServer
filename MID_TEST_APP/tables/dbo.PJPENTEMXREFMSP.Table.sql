USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPENTEMXREFMSP]    Script Date: 12/21/2015 14:26:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPENTEMXREFMSP](
	[Assignment_MSPID] [char](36) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](47) NOT NULL,
	[Employee] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](47) NOT NULL,
	[Pjt_Entity] [char](32) NOT NULL,
	[Project] [char](16) NOT NULL,
	[Status] [char](1) NOT NULL,
	[SubTask_Name] [char](50) NOT NULL,
	[TStamp] [timestamp] NOT NULL,
 CONSTRAINT [PJPENTEMXREFMSP0] PRIMARY KEY CLUSTERED 
(
	[Project] ASC,
	[Pjt_Entity] ASC,
	[Employee] ASC,
	[SubTask_Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
