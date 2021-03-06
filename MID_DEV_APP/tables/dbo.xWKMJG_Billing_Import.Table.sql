USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[xWKMJG_Billing_Import]    Script Date: 12/21/2015 14:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xWKMJG_Billing_Import](
	[LogKey] [int] NOT NULL,
	[InvoiceNumber] [varchar](50) NULL,
	[InvoiceDate] [smalldatetime] NULL,
	[project] [varchar](50) NULL,
	[pjt_entity] [varchar](100) NULL,
	[amount] [float] NULL,
	[BatNbr] [varchar](50) NULL,
	[CuryID] [varchar](50) NULL,
	[FiscalNo] [char](6) NULL,
	[CpnyID] [varchar](50) NULL,
	[SystemCD] [varchar](50) NULL,
	[APSBTD] [varchar](50) NULL,
	[APSREV] [varchar](50) NULL,
	[APSAGYCOS] [varchar](50) NULL,
	[APSAGYBILL] [varchar](50) NULL,
	[APSCOS] [varchar](50) NULL,
	[APSWIP] [varchar](50) NULL,
	[APSRECOVER] [varchar](50) NULL,
	[APSWIPGL] [varchar](50) NULL,
	[PRODWIPGL] [varchar](50) NULL,
	[APSREVGL] [varchar](50) NULL,
	[APSCOSGL] [varchar](50) NULL,
	[TOAGENCYJOB] [varchar](50) NULL,
	[AGENCYSUB] [varchar](50) NULL,
	[STUDIOSUB] [varchar](50) NULL,
	[APSFNCSALESTAX] [varchar](50) NULL,
	[APSFNCVALUEADD] [varchar](50) NULL,
	[APSFNCDISCOUNT] [varchar](50) NULL,
	[AGENCYCUST] [varchar](50) NULL,
	[SALESTAXLB] [varchar](50) NULL,
	[DateTransferred] [smalldatetime] NULL,
	[Error] [text] NULL,
	[TransferStatus] [varchar](50) NULL,
	[RecordID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
