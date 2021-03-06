USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[xwrk_BU009]    Script Date: 12/21/2015 14:33:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BU009](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[CustClass] [char](6) NOT NULL,
	[CustID] [char](30) NOT NULL,
	[CustName] [char](30) NOT NULL,
	[ProdID] [char](30) NOT NULL,
	[ProdDesc] [char](30) NOT NULL,
	[JobID] [char](16) NOT NULL,
	[Job] [char](30) NOT NULL,
	[JobStatus] [char](1) NOT NULL,
	[FunctionID] [varchar](6) NOT NULL,
	[Function] [char](30) NOT NULL,
	[PMID] [char](10) NOT NULL,
	[AcctServiceID] [char](10) NOT NULL,
	[ClientRefNum] [char](20) NOT NULL,
	[OfferNum] [char](30) NOT NULL,
	[Category] [char](10) NOT NULL,
	[CLEFunction] [varchar](6) NOT NULL,
	[CLERevID] [varchar](5) NOT NULL,
	[CLEAmount] [float] NOT NULL,
	[ULEFunction] [varchar](6) NOT NULL,
	[ULERevID] [varchar](5) NOT NULL,
	[ULEAmount] [float] NOT NULL,
	[ULEStatus] [char](2) NOT NULL,
	[Hours] [float] NOT NULL,
 CONSTRAINT [PK_xwrk_BU009] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
