USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[intLogTimeDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[intLogTimeDetail](
	[LogKey] [int] NOT NULL,
	[UserID] [varchar](100) NOT NULL,
	[ProjectNumber] [varchar](50) NULL,
	[SalesAccountNumber] [varchar](100) NULL,
	[TotalHours] [decimal](24, 4) NOT NULL,
	[TransactionDate] [datetime] NULL,
	[WorkDate] [smalldatetime] NULL,
	[ApproverID] [varchar](50) NULL,
	[TimeSheetDateCreated] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
