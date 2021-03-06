USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[smconchglog]    Script Date: 12/21/2015 14:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smconchglog](
	[ChangedDate] [smalldatetime] NOT NULL,
	[ChangedTime] [varchar](8) NOT NULL,
	[ContractID] [varchar](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [varchar](8) NOT NULL,
	[Crtd_User] [varchar](10) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [varchar](8) NOT NULL,
	[Lupd_User] [varchar](10) NOT NULL,
	[NewValue] [varchar](255) NOT NULL,
	[NoteId] [int] NOT NULL,
	[OldValue] [varchar](255) NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[S4Future01] [varchar](30) NOT NULL,
	[S4Future02] [varchar](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [varchar](10) NOT NULL,
	[S4Future12] [varchar](10) NOT NULL,
	[User1] [varchar](30) NOT NULL,
	[User2] [varchar](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [varchar](10) NOT NULL,
	[User6] [varchar](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UserID] [varchar](47) NOT NULL,
	[ValueChanged] [varchar](20) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
