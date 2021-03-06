USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[PJQUEUEMSP]    Script Date: 12/21/2015 15:42:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJQUEUEMSP](
	[PjqueueMsp_PK] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CpnyID] [nvarchar](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [nvarchar](8) NOT NULL,
	[Crtd_User] [nvarchar](47) NOT NULL,
	[JobUID] [uniqueidentifier] NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[Lupd_User] [nvarchar](47) NOT NULL,
	[KeyUID] [uniqueidentifier] NULL,
	[SLKeyValue] [nvarchar](16) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Type] [nvarchar](10) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[TStamp] [timestamp] NOT NULL,
 CONSTRAINT [PJQUEUEMSP0] PRIMARY KEY NONCLUSTERED 
(
	[PjqueueMsp_PK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
