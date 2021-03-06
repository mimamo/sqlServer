USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[PJEMPLOYXREFMSP]    Script Date: 12/21/2015 14:33:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJEMPLOYXREFMSP](
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](47) NOT NULL,
	[Employee] [char](10) NOT NULL,
	[Employee_MSPID] [char](36) NOT NULL,
	[Employee_MSPName] [char](60) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](47) NOT NULL,
	[ProjectManager] [char](1) NOT NULL,
	[WindowsUserAcct] [char](85) NOT NULL,
	[TStamp] [timestamp] NOT NULL,
 CONSTRAINT [PJEMPLOYXREFMSP0] PRIMARY KEY CLUSTERED 
(
	[CpnyID] ASC,
	[Employee] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
