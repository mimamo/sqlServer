USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[DDSetup]    Script Date: 12/21/2015 14:33:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DDSetup](
	[ACHCompanyID] [char](10) NOT NULL,
	[AchCrLf] [char](1) NOT NULL,
	[ACHFileName] [char](255) NOT NULL,
	[ACHFillBlock] [char](1) NOT NULL,
	[ACHImmDest] [char](10) NOT NULL,
	[ACHImmDestN] [char](23) NOT NULL,
	[ACHImmOrig] [char](10) NOT NULL,
	[ACHImmOrigN] [char](23) NOT NULL,
	[ACHInclDR] [char](1) NOT NULL,
	[CommMAnswer] [char](30) NOT NULL,
	[CommMAttn] [char](30) NOT NULL,
	[CommMBusy] [char](30) NOT NULL,
	[CommMConnect] [char](40) NOT NULL,
	[CommMDialPrefix] [char](30) NOT NULL,
	[CommMHangUp] [char](50) NOT NULL,
	[CommMHighBaud] [int] NOT NULL,
	[CommMInit] [char](128) NOT NULL,
	[CommMMake] [char](25) NOT NULL,
	[CommMModel] [char](40) NOT NULL,
	[CommMNum] [int] NOT NULL,
	[CommMReset] [char](30) NOT NULL,
	[CommPBaud] [int] NOT NULL,
	[CommPCommPort] [smallint] NOT NULL,
	[CommPDataBit] [char](1) NOT NULL,
	[CommPDTR] [smallint] NOT NULL,
	[CommPEcho] [smallint] NOT NULL,
	[CommPHandShake] [smallint] NOT NULL,
	[CommPhone] [char](30) NOT NULL,
	[CommPParity] [char](1) NOT NULL,
	[CommPRTS] [smallint] NOT NULL,
	[CommPStopBit] [char](1) NOT NULL,
	[CommPXferProto] [smallint] NOT NULL,
	[CommType] [char](1) NOT NULL,
	[CommUserProg] [char](255) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[CpnyName] [char](30) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DistTypeDflt] [char](1) NOT NULL,
	[Init] [char](1) NOT NULL,
	[LowPayDflt] [char](1) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[PathACHScript] [char](255) NOT NULL,
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
	[SetupID] [char](2) NOT NULL,
	[TestMode] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [DDSetup0] PRIMARY KEY CLUSTERED 
(
	[SetupID] ASC,
	[CpnyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
