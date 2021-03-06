USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[XDDLBFileFormat]    Script Date: 12/21/2015 14:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDLBFileFormat](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DecPl] [smallint] NOT NULL,
	[Descr] [char](60) NOT NULL,
	[DetailRecCode] [char](4) NOT NULL,
	[FileType] [char](1) NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MultiLine] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[OmitHeaderRecs] [smallint] NOT NULL,
	[OmitTrailerRecs] [smallint] NOT NULL,
	[PmtAmtEqSumChkAmts] [smallint] NOT NULL,
	[SamplePathFilename] [char](128) NOT NULL,
	[SKFuture01] [char](30) NOT NULL,
	[SKFuture02] [char](30) NOT NULL,
	[SKFuture03] [float] NOT NULL,
	[SKFuture04] [float] NOT NULL,
	[SKFuture05] [float] NOT NULL,
	[SKFuture06] [float] NOT NULL,
	[SKFuture07] [smalldatetime] NOT NULL,
	[SKFuture08] [smalldatetime] NOT NULL,
	[SKFuture09] [int] NOT NULL,
	[SKFuture10] [int] NOT NULL,
	[SKFuture11] [char](10) NOT NULL,
	[SKFuture12] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User10] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[User9] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDLBFileFormat0] PRIMARY KEY CLUSTERED 
(
	[FormatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [DecPl]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [DetailRecCode]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [FileType]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [MultiLine]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [OmitHeaderRecs]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [OmitTrailerRecs]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [PmtAmtEqSumChkAmts]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [SamplePathFilename]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDLBFileFormat] ADD  DEFAULT ('') FOR [User9]
GO
