USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xJAReportDetailWrk_IWT]    Script Date: 12/21/2015 16:00:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJAReportDetailWrk_IWT](
	[SessionGUID] [varchar](255) NOT NULL,
	[Acct_group_cd] [varchar](2) NULL,
	[Amount] [decimal](15, 3) NULL,
	[BilledAmount] [decimal](15, 3) NULL,
	[Employee] [varchar](10) NULL,
	[Emp_name] [varchar](60) NULL,
	[Estimate] [decimal](15, 3) NULL,
	[Ih_id12] [varchar](30) NULL,
	[Inv_format_cd] [varchar](4) NULL,
	[Invoice_num] [varchar](10) NULL,
	[Invoice_type] [varchar](4) NULL,
	[MarkupAmount] [decimal](15, 3) NULL,
	[Project] [varchar](16) NULL,
	[Pjt_entity] [varchar](32) NULL,
	[Pjt_entity_desc] [varchar](60) NULL,
	[Rate] [decimal](15, 3) NULL,
	[Trans_date] [smalldatetime] NULL,
	[TranType] [varchar](2) NULL,
	[Tr_comment] [varchar](100) NULL,
	[Tr_id02] [varchar](30) NULL,
	[Tr_id03] [varchar](16) NULL,
	[Tr_id04] [varchar](16) NULL,
	[Tr_id08] [smalldatetime] NULL,
	[Units] [decimal](15, 3) NULL,
	[Vendor_num] [varchar](15) NULL,
	[Vendor_name] [varchar](60) NULL,
	[POLineItem] [varchar](30) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
