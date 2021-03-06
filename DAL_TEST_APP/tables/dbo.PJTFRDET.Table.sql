USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJTFRDET]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJTFRDET](
	[Amount] [float] NOT NULL,
	[Batch_ID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryTranAmt] [float] NOT NULL,
	[LineID] [smallint] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](6) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[OrigBatch_ID] [char](10) NOT NULL,
	[OrigDetail_Num] [int] NOT NULL,
	[OrigFiscalNo] [char](6) NOT NULL,
	[OrigSystem_Cd] [char](2) NOT NULL,
	[SeqNum] [smallint] NOT NULL,
	[TfrType] [char](1) NOT NULL,
	[ToAcctCat] [char](16) NOT NULL,
	[ToGLAcct] [char](10) NOT NULL,
	[ToPjt_Entity] [char](32) NOT NULL,
	[ToProject] [char](16) NOT NULL,
	[ToSubAcct] [char](24) NOT NULL,
	[Units] [float] NOT NULL,
	[user1] [char](30) NOT NULL,
	[user2] [char](30) NOT NULL,
	[user3] [float] NOT NULL,
	[user4] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjtfrdet0] PRIMARY KEY NONCLUSTERED 
(
	[Batch_ID] ASC,
	[LineID] ASC,
	[SeqNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
