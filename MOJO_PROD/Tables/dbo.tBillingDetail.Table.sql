USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBillingDetail]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBillingDetail](
	[BillingDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[BillingKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NULL,
	[EntityGuid] [uniqueidentifier] NULL,
	[Action] [smallint] NOT NULL,
	[Quantity] [decimal](24, 4) NULL,
	[Rate] [money] NULL,
	[Total] [money] NULL,
	[Comments] [varchar](2000) NULL,
	[WriteOffReasonKey] [int] NULL,
	[TransferProjectKey] [int] NULL,
	[TransferTaskKey] [int] NULL,
	[AsOfDate] [smalldatetime] NULL,
	[TMPercentage] [decimal](24, 4) NULL,
	[ServiceKey] [int] NULL,
	[RateLevel] [int] NULL,
	[EditComments] [varchar](2000) NULL,
	[EditorKey] [int] NULL,
	[GeneratedTotal] [money] NULL,
 CONSTRAINT [PK_tBillingDetail] PRIMARY KEY CLUSTERED 
(
	[BillingDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tBillingDetail] ADD  CONSTRAINT [DF_tBillingDetail_TMPercentage]  DEFAULT ((1)) FOR [TMPercentage]
GO
