USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[XPM_Control]    Script Date: 12/21/2015 14:10:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[XPM_Control](
	[BufferName] [char](50) NOT NULL,
	[ClearAction] [char](1) NOT NULL,
	[ClearExplicitly] [smallint] NOT NULL,
	[ClearMethod] [char](1) NOT NULL,
	[ColumnName] [char](20) NOT NULL,
	[ControlName] [char](30) NOT NULL,
	[ControlType] [char](1) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DefaultDisp] [smallint] NOT NULL,
	[DefaultLength] [smallint] NOT NULL,
	[DefaultParm5] [smallint] NOT NULL,
	[DefaultType] [smallint] NOT NULL,
	[DefaultValue] [char](50) NOT NULL,
	[DfltScope] [char](1) NOT NULL,
	[DfltSpecSet] [char](3) NOT NULL,
	[Enabled] [smallint] NOT NULL,
	[EntryRestriction] [smallint] NOT NULL,
	[EventChk] [char](1) NOT NULL,
	[EventClick] [char](1) NOT NULL,
	[EventDefault] [char](1) NOT NULL,
	[EventDisplay] [char](1) NOT NULL,
	[EventLGF] [char](1) NOT NULL,
	[EventLineChk] [char](1) NOT NULL,
	[EventLoad] [char](1) NOT NULL,
	[EventPV] [char](1) NOT NULL,
	[FieldClass] [smallint] NOT NULL,
	[FieldNameDisp] [smallint] NOT NULL,
	[FieldNameLength] [smallint] NOT NULL,
	[FieldNameType] [smallint] NOT NULL,
	[FieldNameValue] [char](50) NOT NULL,
	[KeyField] [smallint] NOT NULL,
	[LevelKey] [smallint] NOT NULL,
	[LevelLastKey] [smallint] NOT NULL,
	[LevelNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MasterColumn] [char](20) NOT NULL,
	[MasterTable] [char](20) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PrivacyIndex] [smallint] NOT NULL,
	[PrivacyPVId] [char](30) NOT NULL,
	[PrivacyType] [smallint] NOT NULL,
	[PVId] [char](30) NOT NULL,
	[PVParm500] [smallint] NOT NULL,
	[PVParm501] [smallint] NOT NULL,
	[PVParm502] [smallint] NOT NULL,
	[PVParm503] [smallint] NOT NULL,
	[PVParm504] [smallint] NOT NULL,
	[PVParm505] [smallint] NOT NULL,
	[PVParm506] [smallint] NOT NULL,
	[PVParm507] [smallint] NOT NULL,
	[PVParmDisp00] [smallint] NOT NULL,
	[PVParmDisp01] [smallint] NOT NULL,
	[PVParmDisp02] [smallint] NOT NULL,
	[PVParmDisp03] [smallint] NOT NULL,
	[PVParmDisp04] [smallint] NOT NULL,
	[PVParmDisp05] [smallint] NOT NULL,
	[PVParmDisp06] [smallint] NOT NULL,
	[PVParmDisp07] [smallint] NOT NULL,
	[PVParmLength00] [smallint] NOT NULL,
	[PVParmLength01] [smallint] NOT NULL,
	[PVParmLength02] [smallint] NOT NULL,
	[PVParmLength03] [smallint] NOT NULL,
	[PVParmLength04] [smallint] NOT NULL,
	[PVParmLength05] [smallint] NOT NULL,
	[PVParmLength06] [smallint] NOT NULL,
	[PVParmLength07] [smallint] NOT NULL,
	[PVParmType00] [smallint] NOT NULL,
	[PVParmType01] [smallint] NOT NULL,
	[PVParmType02] [smallint] NOT NULL,
	[PVParmType03] [smallint] NOT NULL,
	[PVParmType04] [smallint] NOT NULL,
	[PVParmType05] [smallint] NOT NULL,
	[PVParmType06] [smallint] NOT NULL,
	[PVParmType07] [smallint] NOT NULL,
	[PVParmValue00] [char](50) NOT NULL,
	[PVParmValue01] [char](50) NOT NULL,
	[PVParmValue02] [char](50) NOT NULL,
	[PVParmValue03] [char](50) NOT NULL,
	[PVParmValue04] [char](50) NOT NULL,
	[PVParmValue05] [char](50) NOT NULL,
	[PVParmValue06] [char](50) NOT NULL,
	[PVParmValue07] [char](50) NOT NULL,
	[RestrictPV] [smallint] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[ScreenId] [char](7) NOT NULL,
	[StdDfltScope] [char](1) NOT NULL,
	[StdPrivacyIndex] [smallint] NOT NULL,
	[StdPrivacyType] [smallint] NOT NULL,
	[TabIndex] [smallint] NOT NULL,
	[TableName] [char](20) NOT NULL,
	[UnboundControl] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[ViewRestriction] [smallint] NOT NULL,
	[Visible] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [BufferName]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [ClearAction]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [ClearExplicitly]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [ClearMethod]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [ColumnName]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [ControlName]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [ControlType]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ('1/1/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [DefaultDisp]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [DefaultLength]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [DefaultParm5]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [DefaultType]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [DefaultValue]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [DfltScope]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [DfltSpecSet]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [Enabled]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [EntryRestriction]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventChk]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventClick]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventDefault]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventDisplay]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventLGF]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventLineChk]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventLoad]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [EventPV]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [FieldClass]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [FieldNameDisp]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [FieldNameLength]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [FieldNameType]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [FieldNameValue]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [KeyField]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [LevelKey]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [LevelLastKey]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [LevelNbr]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ('1/1/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [MasterColumn]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [MasterTable]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PrivacyIndex]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PrivacyPVId]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PrivacyType]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVId]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm500]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm501]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm502]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm503]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm504]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm505]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm506]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParm507]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp00]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp01]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp02]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp03]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp04]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp05]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp06]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmDisp07]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength00]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength01]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength02]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength03]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength04]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength05]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength06]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmLength07]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType00]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType01]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType02]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType03]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType04]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType05]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType06]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [PVParmType07]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue00]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue01]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue02]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue03]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue04]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue05]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue06]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [PVParmValue07]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [RestrictPV]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ('1/1/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ('1/1/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [ScreenId]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [StdDfltScope]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [StdPrivacyIndex]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [StdPrivacyType]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [TabIndex]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [TableName]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [UnboundControl]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ('1/1/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ('1/1/1900') FOR [User8]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [ViewRestriction]
GO
ALTER TABLE [dbo].[XPM_Control] ADD  DEFAULT ((0)) FOR [Visible]
GO
