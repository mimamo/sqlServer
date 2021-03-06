USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[FlexDef]    Script Date: 12/21/2015 15:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FlexDef](
	[Align00] [char](1) NOT NULL,
	[Align01] [char](1) NOT NULL,
	[Align02] [char](1) NOT NULL,
	[Align03] [char](1) NOT NULL,
	[Align04] [char](1) NOT NULL,
	[Align05] [char](1) NOT NULL,
	[Align06] [char](1) NOT NULL,
	[Align07] [char](1) NOT NULL,
	[Caption] [char](31) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[Descr00] [char](15) NOT NULL,
	[Descr01] [char](15) NOT NULL,
	[Descr02] [char](15) NOT NULL,
	[Descr03] [char](15) NOT NULL,
	[Descr04] [char](15) NOT NULL,
	[Descr05] [char](15) NOT NULL,
	[Descr06] [char](15) NOT NULL,
	[Descr07] [char](15) NOT NULL,
	[EditMask00] [char](1) NOT NULL,
	[EditMask01] [char](1) NOT NULL,
	[EditMask02] [char](1) NOT NULL,
	[EditMask03] [char](1) NOT NULL,
	[EditMask04] [char](1) NOT NULL,
	[EditMask05] [char](1) NOT NULL,
	[EditMask06] [char](1) NOT NULL,
	[EditMask07] [char](1) NOT NULL,
	[fieldclass] [char](3) NOT NULL,
	[FieldClassName] [char](15) NOT NULL,
	[FillChar00] [char](1) NOT NULL,
	[FillChar01] [char](1) NOT NULL,
	[FillChar02] [char](1) NOT NULL,
	[FillChar03] [char](1) NOT NULL,
	[FillChar04] [char](1) NOT NULL,
	[FillChar05] [char](1) NOT NULL,
	[FillChar06] [char](1) NOT NULL,
	[FillChar07] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[MaxFieldLen] [smallint] NOT NULL,
	[MaxSegments] [smallint] NOT NULL,
	[NumberSegments] [smallint] NOT NULL,
	[SegLength00] [smallint] NOT NULL,
	[SegLength01] [smallint] NOT NULL,
	[SegLength02] [smallint] NOT NULL,
	[SegLength03] [smallint] NOT NULL,
	[SegLength04] [smallint] NOT NULL,
	[SegLength05] [smallint] NOT NULL,
	[SegLength06] [smallint] NOT NULL,
	[SegLength07] [smallint] NOT NULL,
	[Seperator00] [char](1) NOT NULL,
	[Seperator01] [char](1) NOT NULL,
	[Seperator02] [char](1) NOT NULL,
	[Seperator03] [char](1) NOT NULL,
	[Seperator04] [char](1) NOT NULL,
	[Seperator05] [char](1) NOT NULL,
	[Seperator06] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[Validate00] [smallint] NOT NULL,
	[Validate01] [smallint] NOT NULL,
	[Validate02] [smallint] NOT NULL,
	[Validate03] [smallint] NOT NULL,
	[Validate04] [smallint] NOT NULL,
	[Validate05] [smallint] NOT NULL,
	[Validate06] [smallint] NOT NULL,
	[Validate07] [smallint] NOT NULL,
	[ValidCombosRequired] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [FlexDef0] PRIMARY KEY CLUSTERED 
(
	[FieldClassName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
