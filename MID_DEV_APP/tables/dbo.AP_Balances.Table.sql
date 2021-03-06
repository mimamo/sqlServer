USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[AP_Balances]    Script Date: 12/21/2015 14:16:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AP_Balances](
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CurrBal] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CYBox00] [float] NOT NULL,
	[CYBox01] [float] NOT NULL,
	[CYBox02] [float] NOT NULL,
	[CYBox03] [float] NOT NULL,
	[CYBox04] [float] NOT NULL,
	[CYBox05] [float] NOT NULL,
	[CYBox06] [float] NOT NULL,
	[CYBox07] [float] NOT NULL,
	[CYBox08] [float] NOT NULL,
	[CYBox09] [float] NOT NULL,
	[CYBox10] [float] NOT NULL,
	[CYBox11] [float] NOT NULL,
	[CYBox12] [float] NOT NULL,
	[CYInterest] [float] NOT NULL,
	[FutureBal] [float] NOT NULL,
	[LastChkDate] [smalldatetime] NOT NULL,
	[LastVODate] [smalldatetime] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[NYBox00] [float] NOT NULL,
	[NYBox01] [float] NOT NULL,
	[NYBox02] [float] NOT NULL,
	[NYBox03] [float] NOT NULL,
	[NYBox04] [float] NOT NULL,
	[NYBox05] [float] NOT NULL,
	[NYBox06] [float] NOT NULL,
	[NYBox07] [float] NOT NULL,
	[NYBox08] [float] NOT NULL,
	[NYBox09] [float] NOT NULL,
	[NYBox10] [float] NOT NULL,
	[NYBox11] [float] NOT NULL,
	[NYBox12] [float] NOT NULL,
	[NYInterest] [float] NOT NULL,
	[PerNbr] [char](6) NOT NULL,
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
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[VendID] [char](15) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [AP_Balances0] PRIMARY KEY CLUSTERED 
(
	[VendID] ASC,
	[CpnyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AP_Balances] ADD  DEFAULT ((0)) FOR [CYBox11]
GO
ALTER TABLE [dbo].[AP_Balances] ADD  DEFAULT ((0)) FOR [CYBox12]
GO
ALTER TABLE [dbo].[AP_Balances] ADD  DEFAULT ((0)) FOR [NYBox11]
GO
ALTER TABLE [dbo].[AP_Balances] ADD  DEFAULT ((0)) FOR [NYBox12]
GO
