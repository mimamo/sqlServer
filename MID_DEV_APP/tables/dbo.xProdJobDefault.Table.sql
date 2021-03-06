USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xProdJobDefault]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xProdJobDefault](
	[alloc_method_cd] [char](4) NOT NULL,
	[approver] [char](10) NOT NULL,
	[bill_type_cd] [char](4) NOT NULL,
	[biller] [char](10) NOT NULL,
	[billingApprovReq] [char](1) NOT NULL,
	[code_group] [char](30) NOT NULL,
	[copy_num] [smallint] NULL,
	[CustID] [char](15) NOT NULL,
	[inv_attach_cd] [char](2) NOT NULL,
	[inv_Format_cd] [char](2) NOT NULL,
	[Product] [char](4) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NULL,
	[User4] [float] NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
