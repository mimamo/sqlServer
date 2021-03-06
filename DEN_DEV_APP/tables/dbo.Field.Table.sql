USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[Field]    Script Date: 12/21/2015 14:05:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Field](
	[Active] [char](1) NOT NULL,
	[Caption] [char](40) NOT NULL,
	[ControlType] [smallint] NOT NULL,
	[DArray] [char](1) NOT NULL,
	[DArraySize] [smallint] NOT NULL,
	[DefaultConst] [char](20) NOT NULL,
	[DefaultStructFld] [char](20) NOT NULL,
	[DefaultStructRec] [char](20) NOT NULL,
	[FieldName] [char](20) NOT NULL,
	[Heading] [char](40) NOT NULL,
	[MaskType] [char](3) NOT NULL,
	[OldFieldName] [char](20) NOT NULL,
	[pBlankErr] [char](1) NOT NULL,
	[pDecimalPlaces] [smallint] NOT NULL,
	[pDefaultType] [char](1) NOT NULL,
	[pDisplayLen] [smallint] NOT NULL,
	[pEnabled] [char](1) NOT NULL,
	[pFalseText] [char](10) NOT NULL,
	[pFieldClass] [smallint] NOT NULL,
	[pFieldDclLen] [smallint] NOT NULL,
	[pFieldDclType] [smallint] NOT NULL,
	[pMaxVal] [float] NOT NULL,
	[pMinVal] [float] NOT NULL,
	[pTrueText] [char](10) NOT NULL,
	[pVisible] [char](1) NOT NULL,
	[PVParmConstant00] [char](20) NOT NULL,
	[PVParmConstant01] [char](20) NOT NULL,
	[PVParmConstant02] [char](20) NOT NULL,
	[PVParmConstant03] [char](20) NOT NULL,
	[PVParmField00] [char](20) NOT NULL,
	[PVParmField01] [char](20) NOT NULL,
	[PVParmField02] [char](20) NOT NULL,
	[PVParmField03] [char](20) NOT NULL,
	[PVParmRec00] [char](20) NOT NULL,
	[PVParmRec01] [char](20) NOT NULL,
	[PVParmRec02] [char](20) NOT NULL,
	[PVParmRec03] [char](20) NOT NULL,
	[PVParmType00] [char](1) NOT NULL,
	[PVParmType01] [char](1) NOT NULL,
	[PVParmType02] [char](1) NOT NULL,
	[PVParmType03] [char](1) NOT NULL,
	[RecField] [char](40) NOT NULL,
	[RecordName] [char](20) NOT NULL,
	[TotalPrecision] [smallint] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [Field0] PRIMARY KEY CLUSTERED 
(
	[RecordName] ASC,
	[FieldName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
