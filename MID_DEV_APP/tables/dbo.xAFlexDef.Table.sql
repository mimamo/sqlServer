USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xAFlexDef]    Script Date: 12/21/2015 14:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAFlexDef](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[Align00] [varchar](1) NULL,
	[Align01] [varchar](1) NULL,
	[Align02] [varchar](1) NULL,
	[Align03] [varchar](1) NULL,
	[Align04] [varchar](1) NULL,
	[Align05] [varchar](1) NULL,
	[Align06] [varchar](1) NULL,
	[Align07] [varchar](1) NULL,
	[Caption] [varchar](31) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[Descr00] [varchar](15) NULL,
	[Descr01] [varchar](15) NULL,
	[Descr02] [varchar](15) NULL,
	[Descr03] [varchar](15) NULL,
	[Descr04] [varchar](15) NULL,
	[Descr05] [varchar](15) NULL,
	[Descr06] [varchar](15) NULL,
	[Descr07] [varchar](15) NULL,
	[EditMask00] [varchar](1) NULL,
	[EditMask01] [varchar](1) NULL,
	[EditMask02] [varchar](1) NULL,
	[EditMask03] [varchar](1) NULL,
	[EditMask04] [varchar](1) NULL,
	[EditMask05] [varchar](1) NULL,
	[EditMask06] [varchar](1) NULL,
	[EditMask07] [varchar](1) NULL,
	[fieldclass] [varchar](3) NULL,
	[FieldClassName] [varchar](15) NULL,
	[FillChar00] [varchar](1) NULL,
	[FillChar01] [varchar](1) NULL,
	[FillChar02] [varchar](1) NULL,
	[FillChar03] [varchar](1) NULL,
	[FillChar04] [varchar](1) NULL,
	[FillChar05] [varchar](1) NULL,
	[FillChar06] [varchar](1) NULL,
	[FillChar07] [varchar](1) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[MaxFieldLen] [smallint] NULL,
	[MaxSegments] [smallint] NULL,
	[NumberSegments] [smallint] NULL,
	[SegLength00] [smallint] NULL,
	[SegLength01] [smallint] NULL,
	[SegLength02] [smallint] NULL,
	[SegLength03] [smallint] NULL,
	[SegLength04] [smallint] NULL,
	[SegLength05] [smallint] NULL,
	[SegLength06] [smallint] NULL,
	[SegLength07] [smallint] NULL,
	[Seperator00] [varchar](1) NULL,
	[Seperator01] [varchar](1) NULL,
	[Seperator02] [varchar](1) NULL,
	[Seperator03] [varchar](1) NULL,
	[Seperator04] [varchar](1) NULL,
	[Seperator05] [varchar](1) NULL,
	[Seperator06] [varchar](1) NULL,
	[User1] [varchar](30) NULL,
	[User2] [varchar](30) NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[Validate00] [smallint] NULL,
	[Validate01] [smallint] NULL,
	[Validate02] [smallint] NULL,
	[Validate03] [smallint] NULL,
	[Validate04] [smallint] NULL,
	[Validate05] [smallint] NULL,
	[Validate06] [smallint] NULL,
	[Validate07] [smallint] NULL,
	[ValidCombosRequired] [smallint] NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),(0))) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),(0))) FOR [ADate]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAFlexDef] ADD  CONSTRAINT [DF_xAFlexDef_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),(0))) FOR [AApplication]
GO
