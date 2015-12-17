USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[xWKMJG_Timecard_Exception_tmp]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xWKMJG_Timecard_Exception_tmp](
	[EntityKey] [int] NULL,
	[Action] [varchar](50) NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateTransferred] [smalldatetime] NULL,
	[Error] [varchar](50) NULL,
	[TransferStatus] [varchar](50) NULL,
	[ProjectNumber] [varchar](50) NULL,
	[FunctionCode] [varchar](50) NULL,
	[UserID] [varchar](50) NULL,
	[TotalHours] [float] NULL,
	[WorkDate] [smalldatetime] NULL,
	[ApproverID] [varchar](50) NULL,
	[TransactionDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
