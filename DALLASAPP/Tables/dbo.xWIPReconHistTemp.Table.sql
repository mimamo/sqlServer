USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xWIPReconHistTemp]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xWIPReconHistTemp](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Ledger] [varchar](3) NOT NULL,
	[SRC] [varchar](6) NOT NULL,
	[ClientID] [varchar](30) NOT NULL,
	[Client] [varchar](50) NOT NULL,
	[FiscalNo] [varchar](6) NOT NULL,
	[ProductID] [varchar](30) NOT NULL,
	[Product] [varchar](50) NOT NULL,
	[JobID] [varchar](50) NOT NULL,
	[Job] [varchar](50) NOT NULL,
	[Acct] [varchar](50) NOT NULL,
	[Amount] [float] NOT NULL,
 CONSTRAINT [PK_xWIPReconHistTemp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
