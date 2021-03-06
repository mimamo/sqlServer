USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xtmpPJInvHdrB4PreBill]    Script Date: 12/21/2015 13:56:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpPJInvHdrB4PreBill](
	[approver_id] [char](10) NOT NULL,
	[ar_post_code] [char](4) NOT NULL,
	[BaseCuryId] [char](4) NOT NULL,
	[batch_id] [char](10) NOT NULL,
	[begin_date] [smalldatetime] NOT NULL,
	[CpnyId] [char](10) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[CuryEffDate] [smalldatetime] NOT NULL,
	[CuryId] [char](4) NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryRateType] [char](6) NOT NULL,
	[Curygross_amt] [float] NOT NULL,
	[Curyother_amt] [float] NOT NULL,
	[Curypaid_amt] [float] NOT NULL,
	[Curyretention_amt] [float] NOT NULL,
	[Curytax_amt] [float] NOT NULL,
	[customer] [char](15) NOT NULL,
	[docdesc] [char](30) NOT NULL,
	[doctype] [char](2) NOT NULL,
	[draft_num] [char](10) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[fiscalno] [char](6) NOT NULL,
	[gross_amt] [float] NOT NULL,
	[ih_id01] [char](30) NOT NULL,
	[ih_id02] [char](30) NOT NULL,
	[ih_id03] [char](16) NOT NULL,
	[ih_id04] [char](16) NOT NULL,
	[ih_id05] [char](4) NOT NULL,
	[ih_id06] [float] NOT NULL,
	[ih_id07] [float] NOT NULL,
	[ih_id08] [smalldatetime] NOT NULL,
	[ih_id09] [smalldatetime] NOT NULL,
	[ih_id10] [smallint] NOT NULL,
	[ih_id11] [char](30) NOT NULL,
	[ih_id12] [char](30) NOT NULL,
	[ih_id13] [char](4) NOT NULL,
	[ih_id14] [char](20) NOT NULL,
	[ih_id15] [char](10) NOT NULL,
	[ih_id16] [char](10) NOT NULL,
	[ih_id17] [char](10) NOT NULL,
	[ih_id18] [char](4) NOT NULL,
	[ih_id19] [float] NOT NULL,
	[ih_id20] [smalldatetime] NOT NULL,
	[invoice_date] [smalldatetime] NOT NULL,
	[invoice_num] [char](10) NOT NULL,
	[invoice_type] [char](4) NOT NULL,
	[inv_attach_cd] [char](2) NOT NULL,
	[inv_format_cd] [char](2) NOT NULL,
	[inv_status] [char](2) NOT NULL,
	[last_bill_date] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[noteid] [int] NOT NULL,
	[other_amt] [float] NOT NULL,
	[paid_amt] [float] NOT NULL,
	[preparer_id] [char](10) NOT NULL,
	[project_billwith] [char](16) NOT NULL,
	[retention_amt] [float] NOT NULL,
	[slsperid] [char](10) NOT NULL,
	[tax_amt] [float] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
