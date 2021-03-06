USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDeposit]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDeposit](
	[DepositKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[DepositID] [varchar](50) NOT NULL,
	[GLAccountKey] [int] NOT NULL,
	[DepositDate] [smalldatetime] NOT NULL,
	[Cleared] [tinyint] NOT NULL,
	[GLCompanyKey] [int] NULL,
 CONSTRAINT [PK_tDeposit] PRIMARY KEY CLUSTERED 
(
	[DepositKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDeposit] ADD  CONSTRAINT [DF_tDeposit_Cleared]  DEFAULT ((0)) FOR [Cleared]
GO
