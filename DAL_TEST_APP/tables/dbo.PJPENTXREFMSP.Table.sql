USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPENTXREFMSP]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPENTXREFMSP](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](47) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](47) NOT NULL,
	[Pjt_Entity] [char](32) NOT NULL,
	[Pjt_Entity_MSPID] [char](36) NOT NULL,
	[Project] [char](16) NOT NULL,
	[Project_MSPID] [char](36) NOT NULL,
	[Status] [char](1) NOT NULL,
	[TStamp] [timestamp] NOT NULL,
 CONSTRAINT [PJPENTXREFMSP0] PRIMARY KEY CLUSTERED 
(
	[Project] ASC,
	[Pjt_Entity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
