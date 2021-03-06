USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[SlsPerHist]    Script Date: 12/21/2015 15:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SlsPerHist](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FiscYr] [char](4) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
	[PtdCOGS00] [float] NOT NULL,
	[PtdCOGS01] [float] NOT NULL,
	[PtdCOGS02] [float] NOT NULL,
	[PtdCOGS03] [float] NOT NULL,
	[PtdCOGS04] [float] NOT NULL,
	[PtdCOGS05] [float] NOT NULL,
	[PtdCOGS06] [float] NOT NULL,
	[PtdCOGS07] [float] NOT NULL,
	[PtdCOGS08] [float] NOT NULL,
	[PtdCOGS09] [float] NOT NULL,
	[PtdCOGS10] [float] NOT NULL,
	[PtdCOGS11] [float] NOT NULL,
	[PtdCOGS12] [float] NOT NULL,
	[PtdRcpt00] [float] NOT NULL,
	[PtdRcpt01] [float] NOT NULL,
	[PtdRcpt02] [float] NOT NULL,
	[PtdRcpt03] [float] NOT NULL,
	[PtdRcpt04] [float] NOT NULL,
	[PtdRcpt05] [float] NOT NULL,
	[PtdRcpt06] [float] NOT NULL,
	[PtdRcpt07] [float] NOT NULL,
	[PtdRcpt08] [float] NOT NULL,
	[PtdRcpt09] [float] NOT NULL,
	[PtdRcpt10] [float] NOT NULL,
	[PtdRcpt11] [float] NOT NULL,
	[PtdRcpt12] [float] NOT NULL,
	[PtdSls00] [float] NOT NULL,
	[PtdSls01] [float] NOT NULL,
	[PtdSls02] [float] NOT NULL,
	[PtdSls03] [float] NOT NULL,
	[PtdSls04] [float] NOT NULL,
	[PtdSls05] [float] NOT NULL,
	[PtdSls06] [float] NOT NULL,
	[PtdSls07] [float] NOT NULL,
	[PtdSls08] [float] NOT NULL,
	[PtdSls09] [float] NOT NULL,
	[PtdSls10] [float] NOT NULL,
	[PtdSls11] [float] NOT NULL,
	[PtdSls12] [float] NOT NULL,
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
	[SlsperId] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[YtdCOGS] [float] NOT NULL,
	[YtdRcpt] [float] NOT NULL,
	[YtdSls] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [SlsperHist0] PRIMARY KEY CLUSTERED 
(
	[SlsperId] ASC,
	[FiscYr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_Crtd_Prog]  DEFAULT (' ') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_Crtd_User]  DEFAULT (' ') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_FiscYr]  DEFAULT (' ') FOR [FiscYr]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_LUpd_DateTime]  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_LUpd_Prog]  DEFAULT (' ') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_LUpd_User]  DEFAULT (' ') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_NoteId]  DEFAULT ((0)) FOR [NoteId]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PerNbr]  DEFAULT (' ') FOR [PerNbr]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS00]  DEFAULT ((0)) FOR [PtdCOGS00]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS01]  DEFAULT ((0)) FOR [PtdCOGS01]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS02]  DEFAULT ((0)) FOR [PtdCOGS02]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS03]  DEFAULT ((0)) FOR [PtdCOGS03]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS04]  DEFAULT ((0)) FOR [PtdCOGS04]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS05]  DEFAULT ((0)) FOR [PtdCOGS05]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS06]  DEFAULT ((0)) FOR [PtdCOGS06]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS07]  DEFAULT ((0)) FOR [PtdCOGS07]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS08]  DEFAULT ((0)) FOR [PtdCOGS08]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS09]  DEFAULT ((0)) FOR [PtdCOGS09]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS10]  DEFAULT ((0)) FOR [PtdCOGS10]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS11]  DEFAULT ((0)) FOR [PtdCOGS11]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdCOGS12]  DEFAULT ((0)) FOR [PtdCOGS12]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt00]  DEFAULT ((0)) FOR [PtdRcpt00]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt01]  DEFAULT ((0)) FOR [PtdRcpt01]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt02]  DEFAULT ((0)) FOR [PtdRcpt02]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt03]  DEFAULT ((0)) FOR [PtdRcpt03]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt04]  DEFAULT ((0)) FOR [PtdRcpt04]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt05]  DEFAULT ((0)) FOR [PtdRcpt05]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt06]  DEFAULT ((0)) FOR [PtdRcpt06]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt07]  DEFAULT ((0)) FOR [PtdRcpt07]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt08]  DEFAULT ((0)) FOR [PtdRcpt08]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt09]  DEFAULT ((0)) FOR [PtdRcpt09]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt10]  DEFAULT ((0)) FOR [PtdRcpt10]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt11]  DEFAULT ((0)) FOR [PtdRcpt11]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdRcpt12]  DEFAULT ((0)) FOR [PtdRcpt12]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls00]  DEFAULT ((0)) FOR [PtdSls00]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls01]  DEFAULT ((0)) FOR [PtdSls01]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls02]  DEFAULT ((0)) FOR [PtdSls02]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls03]  DEFAULT ((0)) FOR [PtdSls03]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls04]  DEFAULT ((0)) FOR [PtdSls04]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls05]  DEFAULT ((0)) FOR [PtdSls05]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls06]  DEFAULT ((0)) FOR [PtdSls06]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls07]  DEFAULT ((0)) FOR [PtdSls07]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls08]  DEFAULT ((0)) FOR [PtdSls08]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls09]  DEFAULT ((0)) FOR [PtdSls09]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls10]  DEFAULT ((0)) FOR [PtdSls10]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls11]  DEFAULT ((0)) FOR [PtdSls11]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_PtdSls12]  DEFAULT ((0)) FOR [PtdSls12]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_SlsperId]  DEFAULT (' ') FOR [SlsperId]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User1]  DEFAULT (' ') FOR [User1]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User2]  DEFAULT (' ') FOR [User2]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User3]  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User4]  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User5]  DEFAULT (' ') FOR [User5]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User6]  DEFAULT (' ') FOR [User6]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User7]  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_User8]  DEFAULT ('01/01/1900') FOR [User8]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_YtdCOGS]  DEFAULT ((0)) FOR [YtdCOGS]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_YtdRcpt]  DEFAULT ((0)) FOR [YtdRcpt]
GO
ALTER TABLE [dbo].[SlsPerHist] ADD  CONSTRAINT [DF_SlsPerHist_YtdSls]  DEFAULT ((0)) FOR [YtdSls]
GO
