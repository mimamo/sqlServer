USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[XDDEBFile]    Script Date: 12/21/2015 14:26:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XDDEBFile](
	[AmtApprvLvl1_A_User] [char](47) NOT NULL,
	[AmtApprvLvl1_A_PW] [char](15) NOT NULL,
	[AmtApprvLvl1_B_User] [char](47) NOT NULL,
	[AmtApprvLvl1_B_PW] [char](15) NOT NULL,
	[AmtApprvLvl1_C_User] [char](47) NOT NULL,
	[AmtApprvLvl1_C_PW] [char](15) NOT NULL,
	[AmtApprvLvl1_D_User] [char](47) NOT NULL,
	[AmtApprvLvl1_D_PW] [char](15) NOT NULL,
	[AmtApprvLvl1_E_User] [char](47) NOT NULL,
	[AmtApprvLvl1_E_PW] [char](15) NOT NULL,
	[AmtApprvLvl2_A_User] [char](47) NOT NULL,
	[AmtApprvLvl2_A_PW] [char](15) NOT NULL,
	[AmtApprvLvl2_B_User] [char](47) NOT NULL,
	[AmtApprvLvl2_B_PW] [char](15) NOT NULL,
	[AmtApprvLvl2_C_User] [char](47) NOT NULL,
	[AmtApprvLvl2_C_PW] [char](15) NOT NULL,
	[AmtApprvLvl2_D_User] [char](47) NOT NULL,
	[AmtApprvLvl2_D_PW] [char](15) NOT NULL,
	[AmtApprvLvl2_E_User] [char](47) NOT NULL,
	[AmtApprvLvl2_E_PW] [char](15) NOT NULL,
	[AREFTInvoices] [smallint] NOT NULL,
	[AREFTTotal] [float] NOT NULL,
	[Batch_PreNote] [char](1) NOT NULL,
	[BatchCount] [smallint] NOT NULL,
	[BatchTotal] [float] NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_Time] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EBFileNbr] [char](6) NOT NULL,
	[EffDate] [smalldatetime] NOT NULL,
	[FileName] [char](80) NOT NULL,
	[FilePath] [char](128) NOT NULL,
	[FileType] [char](1) NOT NULL,
	[FormatID] [char](15) NOT NULL,
	[KeepDelete] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_Time] [smalldatetime] NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[Module] [char](2) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PPAP] [smallint] NOT NULL,
	[PPAPVoid] [smallint] NOT NULL,
	[PPPR] [smallint] NOT NULL,
	[PPPRVoid] [smallint] NOT NULL,
	[Ret_CommType] [char](1) NOT NULL,
	[Ret_CommUserProg] [char](128) NOT NULL,
	[Ret_DelFile] [smallint] NOT NULL,
	[Ret_GoodRecs] [int] NOT NULL,
	[Ret_WrkAcct] [char](10) NOT NULL,
	[Ret_WrkCpnyID] [char](10) NOT NULL,
	[Ret_WrkSub] [char](24) NOT NULL,
	[Sequence] [smallint] NOT NULL,
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
	[TransmitDate] [smalldatetime] NOT NULL,
	[UnbalancedFile] [smallint] NOT NULL,
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
 CONSTRAINT [XDDEBFile0] PRIMARY KEY CLUSTERED 
(
	[FileType] ASC,
	[EBFileNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_A_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_A_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_B_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_B_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_C_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_C_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_D_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_D_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_E_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl1_E_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_A_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_A_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_B_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_B_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_C_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_C_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_D_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_D_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_E_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [AmtApprvLvl2_E_PW]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [AREFTInvoices]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [AREFTTotal]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Batch_PreNote]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [BatchCount]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [BatchTotal]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [CpnyID]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [Crtd_Time]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [EBFileNbr]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [EffDate]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [FileName]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [FilePath]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [FileType]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [FormatID]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [KeepDelete]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [LUpd_Time]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Module]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [PPAP]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [PPAPVoid]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [PPPR]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [PPPRVoid]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Ret_CommType]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Ret_CommUserProg]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [Ret_DelFile]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [Ret_GoodRecs]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Ret_WrkAcct]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Ret_WrkCpnyID]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [Ret_WrkSub]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [Sequence]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [SKFuture01]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [SKFuture02]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [SKFuture03]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [SKFuture04]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [SKFuture05]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [SKFuture06]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [SKFuture07]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [SKFuture08]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [SKFuture09]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [SKFuture10]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [SKFuture11]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [SKFuture12]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [TransmitDate]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [UnbalancedFile]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [User10]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XDDEBFile] ADD  DEFAULT ('') FOR [User9]
GO
