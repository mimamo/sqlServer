USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[xiwDonovanDtl]    Script Date: 12/21/2015 16:00:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xiwDonovanDtl](
	[DonovanDtlKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DonovanHdrKey] [int] NOT NULL,
	[Account] [char](25) NOT NULL,
	[InvoiceDate] [smalldatetime] NULL,
	[InvNbr] [char](50) NOT NULL,
	[ChkNbr] [char](25) NOT NULL,
	[CurDebit] [float] NOT NULL,
	[CurBal] [float] NOT NULL,
	[PrintPayees] [char](10) NOT NULL,
	[ImportAPRefNbr] [char](10) NOT NULL,
	[ImportStatus] [int] NOT NULL,
	[ImportMsg] [char](255) NOT NULL,
 CONSTRAINT [xiwDonovanDtl0] PRIMARY KEY CLUSTERED 
(
	[DonovanDtlKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
