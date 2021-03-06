USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PJARPAY]    Script Date: 12/21/2015 14:05:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJARPAY](
	[applied_amt] [float] NOT NULL,
	[check_refnbr] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CustId] [char](15) NOT NULL,
	[discount_amt] [float] NOT NULL,
	[doctype] [char](2) NOT NULL,
	[invoice_refnbr] [char](10) NOT NULL,
	[invoice_type] [char](2) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[pjt_entity] [char](32) NOT NULL,
	[Project] [char](16) NOT NULL,
	[status] [char](1) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjarpay0] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[doctype] ASC,
	[check_refnbr] ASC,
	[invoice_refnbr] ASC,
	[invoice_type] ASC,
	[lupd_datetime] ASC,
	[applied_amt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
