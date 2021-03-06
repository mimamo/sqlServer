USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xwrk_PA006]    Script Date: 12/21/2015 16:00:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_PA006](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[Disposition] [varchar](11) NOT NULL,
	[Project] [char](16) NOT NULL,
	[Project_desc] [char](30) NOT NULL,
	[status_pa] [char](1) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[ProjectCreated] [smalldatetime] NOT NULL,
	[FunctionCreated] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_xwrk_PA006] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
