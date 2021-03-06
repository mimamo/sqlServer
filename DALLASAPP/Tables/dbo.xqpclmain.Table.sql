USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xqpclmain]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xqpclmain](
	[customer] [char](15) NOT NULL,
	[perpost] [char](6) NOT NULL,
	[descr] [char](30) NOT NULL,
	[acct] [char](16) NOT NULL,
	[transdate] [smalldatetime] NOT NULL,
	[rev_projfees] [float] NOT NULL,
	[rev_pfdescription] [char](30) NOT NULL,
	[rev_pfacct] [char](30) NOT NULL,
	[rev_retfees] [float] NOT NULL,
	[rev_rfdescription] [char](30) NOT NULL,
	[rev_rfacct] [char](30) NOT NULL,
	[rev_mediafees] [float] NOT NULL,
	[rev_mfdescription] [char](30) NOT NULL,
	[rev_mfacct] [char](30) NOT NULL,
	[rev_prodcomm] [float] NOT NULL,
	[rev_pcdescription] [char](30) NOT NULL,
	[rev_pcacct] [char](30) NOT NULL,
	[rev_studsls] [float] NOT NULL,
	[rev_ssdescription] [char](30) NOT NULL,
	[rev_ssacct] [char](30) NOT NULL,
	[rev_intsls] [float] NOT NULL,
	[rev_isdescription] [char](30) NOT NULL,
	[rev_isacct] [char](30) NOT NULL,
	[rev_total] [float] NOT NULL,
	[dc_dirsal] [float] NOT NULL,
	[dc_dsdescription] [char](30) NOT NULL,
	[dc_dsacct] [char](30) NOT NULL,
	[dc_prrel] [float] NOT NULL,
	[dc_prdescription] [char](30) NOT NULL,
	[dc_pracct] [char](30) NOT NULL,
	[dc_freelance] [float] NOT NULL,
	[dc_fldescription] [char](30) NOT NULL,
	[dc_flacct] [char](30) NOT NULL,
	[dc_sea] [float] NOT NULL,
	[dc_seadescription] [char](30) NOT NULL,
	[dc_seaacct] [char](30) NOT NULL,
	[dc_total] [float] NOT NULL,
	[oa_indirsal] [float] NOT NULL,
	[oa_isdescription] [char](30) NOT NULL,
	[oa_isacct] [char](30) NOT NULL,
	[oa_overhead] [float] NOT NULL,
	[oa_ohdescription] [char](30) NOT NULL,
	[oa_ohacct] [char](30) NOT NULL,
	[oa_total] [float] NOT NULL,
	[netpl] [float] NOT NULL,
	[User1] [char](60) NOT NULL,
	[User2] [char](60) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](60) NOT NULL,
	[User6] [char](60) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [char](60) NOT NULL,
	[User9] [char](60) NOT NULL,
	[User10] [char](60) NOT NULL,
	[User11] [char](60) NOT NULL,
	[User12] [char](60) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [xqpclmain0] PRIMARY KEY CLUSTERED 
(
	[customer] ASC,
	[perpost] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
