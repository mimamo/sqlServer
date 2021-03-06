USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[WrkSUTAG]    Script Date: 12/21/2015 14:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WrkSUTAG](
	[CpnyID] [char](10) NOT NULL,
	[FICAWageLimit] [float] NOT NULL,
	[GLAddr1] [char](30) NOT NULL,
	[GLAddr2] [char](30) NOT NULL,
	[GLCity] [char](30) NOT NULL,
	[GLCpnyName] [char](30) NOT NULL,
	[GLState] [char](3) NOT NULL,
	[GLZip] [char](10) NOT NULL,
	[QtrBegDate] [smalldatetime] NOT NULL,
	[QtrEndDate] [smalldatetime] NOT NULL,
	[RptQtr] [smallint] NOT NULL,
	[RptYr] [char](4) NOT NULL,
	[StateName] [char](15) NOT NULL,
	[StateTaxId] [char](20) NOT NULL,
	[StateWageLimit] [float] NOT NULL,
	[SUTAId] [char](10) NOT NULL,
	[TaxRate] [float] NOT NULL,
	[TotQTDFICAWages] [float] NOT NULL,
	[TotQTDNonWageIncome] [float] NOT NULL,
	[TotQTDStateWages] [float] NOT NULL,
	[TotQTDTaxableWages] [float] NOT NULL,
	[TotSUTATax] [float] NOT NULL,
	[TotYTDFICAWages] [float] NOT NULL,
	[UserId] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [WrkSUTAG0] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
