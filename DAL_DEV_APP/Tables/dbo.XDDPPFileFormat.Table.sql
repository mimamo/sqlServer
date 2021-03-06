USE [DAL_DEV_APP]
GO
/****** Object:  Table [dbo].[XDDPPFileFormat]    Script Date: 12/21/2015 13:35:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDPPFileFormat](
	[BankTransitNoCD] [smallint] NOT NULL,
	[BlockFill] [smallint] NOT NULL,
	[CrLf] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[HeadTrailNotes] [char](255) NOT NULL,
	[KeepDelete] [char](1) NOT NULL,
	[LastEffDate] [smalldatetime] NOT NULL,
	[LeadingSpace] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MultiAcctAllowed] [smallint] NOT NULL,
	[MultiAcctImplInRpt] [smallint] NOT NULL,
	[MultiAcctReqdInRpt] [smallint] NOT NULL,
	[NoteID] [int] NOT NULL,
	[RecordLen] [smallint] NOT NULL,
	[Selected] [char](1) NOT NULL,
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
	[TrailerRecord] [smallint] NOT NULL,
	[TrimRecord] [smallint] NOT NULL,
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
	[VoidChkSeparate] [smallint] NOT NULL,
	[XDDBankPP01Descr] [char](30) NOT NULL,
	[XDDBankPP01Mask] [char](30) NOT NULL,
	[XDDBankPP02Descr] [char](30) NOT NULL,
	[XDDBankPP02Mask] [char](30) NOT NULL,
	[XDDBankPP03Descr] [char](30) NOT NULL,
	[XDDBankPP03Mask] [char](30) NOT NULL,
	[XDDBankPP04Descr] [char](30) NOT NULL,
	[XDDBankPP04Mask] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [XDDPPFileFormat0] PRIMARY KEY CLUSTERED 
(
	[FormatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [BankTransitNoCD]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [BlockFill]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [CrLf]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [Descr]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [HeadTrailNotes]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [KeepDelete]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [LastEffDate]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [LeadingSpace]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [MultiAcctAllowed]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [MultiAcctImplInRpt]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [MultiAcctReqdInRpt]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [RecordLen]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [Selected]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [TrailerRecord]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [TrimRecord]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [User9]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ((0)) FOR [VoidChkSeparate]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP01Descr]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP01Mask]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP02Descr]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP02Mask]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP03Descr]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP03Mask]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP04Descr]
GO
ALTER TABLE [dbo].[XDDPPFileFormat] ADD  DEFAULT ('') FOR [XDDBankPP04Mask]
GO
