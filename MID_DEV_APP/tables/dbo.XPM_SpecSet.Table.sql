USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[XPM_SpecSet]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[XPM_SpecSet](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr] [char](60) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Permission00] [char](1) NOT NULL,
	[Permission01] [char](1) NOT NULL,
	[Permission02] [char](1) NOT NULL,
	[Permission03] [char](1) NOT NULL,
	[Permission04] [char](1) NOT NULL,
	[Permission05] [char](1) NOT NULL,
	[Permission06] [char](1) NOT NULL,
	[Permission07] [char](1) NOT NULL,
	[Permission08] [char](1) NOT NULL,
	[Permission09] [char](1) NOT NULL,
	[Permission10] [char](1) NOT NULL,
	[Permission11] [char](1) NOT NULL,
	[Permission12] [char](1) NOT NULL,
	[Permission13] [char](1) NOT NULL,
	[Permission14] [char](1) NOT NULL,
	[Permission15] [char](1) NOT NULL,
	[Permission16] [char](1) NOT NULL,
	[Permission17] [char](1) NOT NULL,
	[Permission18] [char](1) NOT NULL,
	[Permission19] [char](1) NOT NULL,
	[Permission20] [char](1) NOT NULL,
	[Permission21] [char](1) NOT NULL,
	[Permission22] [char](1) NOT NULL,
	[Permission23] [char](1) NOT NULL,
	[Permission24] [char](1) NOT NULL,
	[Permission25] [char](1) NOT NULL,
	[Permission26] [char](1) NOT NULL,
	[Permission27] [char](1) NOT NULL,
	[Permission28] [char](1) NOT NULL,
	[Permission29] [char](1) NOT NULL,
	[Permission30] [char](1) NOT NULL,
	[Permission31] [char](1) NOT NULL,
	[Permission32] [char](1) NOT NULL,
	[Permission33] [char](1) NOT NULL,
	[Permission34] [char](1) NOT NULL,
	[Permission35] [char](1) NOT NULL,
	[Permission36] [char](1) NOT NULL,
	[Permission37] [char](1) NOT NULL,
	[Permission38] [char](1) NOT NULL,
	[Permission39] [char](1) NOT NULL,
	[Permission40] [char](1) NOT NULL,
	[Permission41] [char](1) NOT NULL,
	[Permission42] [char](1) NOT NULL,
	[Permission43] [char](1) NOT NULL,
	[Permission44] [char](1) NOT NULL,
	[Permission45] [char](1) NOT NULL,
	[Permission46] [char](1) NOT NULL,
	[Permission47] [char](1) NOT NULL,
	[Permission48] [char](1) NOT NULL,
	[Permission49] [char](1) NOT NULL,
	[Permission50] [char](1) NOT NULL,
	[Permission51] [char](1) NOT NULL,
	[Permission52] [char](1) NOT NULL,
	[Permission53] [char](1) NOT NULL,
	[Permission54] [char](1) NOT NULL,
	[Permission55] [char](1) NOT NULL,
	[Permission56] [char](1) NOT NULL,
	[Permission57] [char](1) NOT NULL,
	[Permission58] [char](1) NOT NULL,
	[Permission59] [char](1) NOT NULL,
	[Permission60] [char](1) NOT NULL,
	[Permission61] [char](1) NOT NULL,
	[Permission62] [char](1) NOT NULL,
	[Permission63] [char](1) NOT NULL,
	[Permission64] [char](1) NOT NULL,
	[Permission65] [char](1) NOT NULL,
	[Permission66] [char](1) NOT NULL,
	[Permission67] [char](1) NOT NULL,
	[Permission68] [char](1) NOT NULL,
	[Permission69] [char](1) NOT NULL,
	[Permission70] [char](1) NOT NULL,
	[Permission71] [char](1) NOT NULL,
	[Permission72] [char](1) NOT NULL,
	[Permission73] [char](1) NOT NULL,
	[Permission74] [char](1) NOT NULL,
	[Permission75] [char](1) NOT NULL,
	[Permission76] [char](1) NOT NULL,
	[Permission77] [char](1) NOT NULL,
	[Permission78] [char](1) NOT NULL,
	[Permission79] [char](1) NOT NULL,
	[Permission80] [char](1) NOT NULL,
	[Permission81] [char](1) NOT NULL,
	[Permission82] [char](1) NOT NULL,
	[Permission83] [char](1) NOT NULL,
	[Permission84] [char](1) NOT NULL,
	[Permission85] [char](1) NOT NULL,
	[Permission86] [char](1) NOT NULL,
	[Permission87] [char](1) NOT NULL,
	[Permission88] [char](1) NOT NULL,
	[Permission89] [char](1) NOT NULL,
	[Permission90] [char](1) NOT NULL,
	[Permission91] [char](1) NOT NULL,
	[Permission92] [char](1) NOT NULL,
	[Permission93] [char](1) NOT NULL,
	[Permission94] [char](1) NOT NULL,
	[Permission95] [char](1) NOT NULL,
	[Permission96] [char](1) NOT NULL,
	[Permission97] [char](1) NOT NULL,
	[Permission98] [char](1) NOT NULL,
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
	[SpecSetId] [char](3) NOT NULL,
	[Status] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ('1/1/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Descr]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ('1/1/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission00]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission01]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission02]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission03]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission04]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission05]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission06]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission07]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission08]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission09]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission10]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission11]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission12]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission13]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission14]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission15]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission16]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission17]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission18]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission19]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission20]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission21]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission22]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission23]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission24]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission25]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission26]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission27]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission28]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission29]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission30]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission31]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission32]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission33]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission34]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission35]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission36]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission37]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission38]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission39]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission40]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission41]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission42]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission43]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission44]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission45]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission46]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission47]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission48]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission49]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission50]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission51]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission52]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission53]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission54]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission55]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission56]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission57]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission58]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission59]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission60]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission61]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission62]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission63]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission64]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission65]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission66]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission67]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission68]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission69]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission70]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission71]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission72]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission73]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission74]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission75]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission76]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission77]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission78]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission79]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission80]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission81]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission82]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission83]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission84]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission85]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission86]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission87]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission88]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission89]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission90]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission91]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission92]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission93]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission94]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission95]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission96]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission97]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Permission98]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ('1/1/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ('1/1/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [SpecSetId]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ('1/1/1900') FOR [User7]
GO
ALTER TABLE [dbo].[XPM_SpecSet] ADD  DEFAULT ('1/1/1900') FOR [User8]
GO
