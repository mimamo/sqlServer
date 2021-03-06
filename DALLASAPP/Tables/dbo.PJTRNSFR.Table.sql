USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[PJTRNSFR]    Script Date: 12/21/2015 13:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTRNSFR](
	[Batch_Id] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LastSeqNbr] [int] NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [int] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigBatch_Id] [char](10) NOT NULL,
	[OrigDetail_Num] [int] NOT NULL,
	[OrigFiscalNo] [char](6) NOT NULL,
	[OrigSystem_Cd] [char](10) NOT NULL,
	[UTLPer] [char](6) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtrnsfr0] PRIMARY KEY CLUSTERED 
(
	[Batch_Id] ASC,
	[LineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
