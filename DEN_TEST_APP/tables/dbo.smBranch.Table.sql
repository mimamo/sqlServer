USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[smBranch]    Script Date: 12/21/2015 14:10:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smBranch](
	[Addr1] [char](30) NOT NULL,
	[Addr2] [char](30) NOT NULL,
	[Attn] [char](30) NOT NULL,
	[BranchId] [char](10) NOT NULL,
	[City] [char](30) NOT NULL,
	[Country] [char](3) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[FaxNbr] [char](15) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[Name] [char](30) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Phone] [char](15) NOT NULL,
	[SB_ID01] [char](30) NOT NULL,
	[SB_ID02] [char](30) NOT NULL,
	[SB_ID03] [char](20) NOT NULL,
	[SB_ID04] [char](20) NOT NULL,
	[SB_ID05] [char](10) NOT NULL,
	[SB_ID06] [char](10) NOT NULL,
	[SB_ID07] [char](4) NOT NULL,
	[SB_ID08] [float] NOT NULL,
	[SB_ID09] [smalldatetime] NOT NULL,
	[SB_ID10] [smallint] NOT NULL,
	[ShortKey] [char](3) NOT NULL,
	[State] [char](3) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[Zip] [char](9) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
