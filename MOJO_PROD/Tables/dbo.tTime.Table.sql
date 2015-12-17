USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTime]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTime](
	[TimeKey] [uniqueidentifier] NOT NULL,
	[TimeSheetKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[RateLevel] [int] NOT NULL,
	[WorkDate] [smalldatetime] NULL,
	[StartTime] [smalldatetime] NULL,
	[EndTime] [smalldatetime] NULL,
	[ActualHours] [decimal](24, 4) NOT NULL,
	[PauseHours] [decimal](24, 4) NULL,
	[ActualRate] [money] NOT NULL,
	[CostRate] [money] NULL,
	[BilledService] [int] NULL,
	[BilledHours] [decimal](24, 4) NULL,
	[BilledRate] [money] NULL,
	[InvoiceLineKey] [int] NULL,
	[WriteOff] [tinyint] NULL,
	[Comments] [varchar](2000) NULL,
	[Downloaded] [tinyint] NULL,
	[WIPPostingInKey] [int] NOT NULL,
	[WIPPostingOutKey] [int] NOT NULL,
	[TransferComment] [varchar](500) NULL,
	[WriteOffReasonKey] [int] NULL,
	[DateBilled] [smalldatetime] NULL,
	[OnHold] [tinyint] NULL,
	[BilledComment] [varchar](2000) NULL,
	[TaskAssignmentKey] [int] NULL,
	[DetailTaskKey] [int] NULL,
	[TransferInDate] [smalldatetime] NULL,
	[TransferOutDate] [smalldatetime] NULL,
	[TransferFromKey] [uniqueidentifier] NULL,
	[TransferToKey] [uniqueidentifier] NULL,
	[WIPAmount] [money] NULL,
	[Verified] [tinyint] NULL,
	[VoucherKey] [int] NULL,
	[CurrencyID] [varchar](10) NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
	[HCostRate] [money] NULL,
	[TitleKey] [int] NULL,
	[TransferSourceKey] [uniqueidentifier] NULL,
	[IsAdjustment] [tinyint] NULL,
	[DepartmentKey] [int] NULL,
	[DeliverableKey] [int] NULL,
 CONSTRAINT [PK_tTime] PRIMARY KEY NONCLUSTERED 
(
	[TimeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_RateLevel]  DEFAULT ((1)) FOR [RateLevel]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_WriteOff]  DEFAULT ((0)) FOR [WriteOff]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_WIPPostingKey]  DEFAULT ((0)) FOR [WIPPostingInKey]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_WIPPostingOutKey]  DEFAULT ((0)) FOR [WIPPostingOutKey]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_WIPAmount]  DEFAULT ((0)) FOR [WIPAmount]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_Verified]  DEFAULT ((1)) FOR [Verified]
GO
ALTER TABLE [dbo].[tTime] ADD  CONSTRAINT [DF_tTime_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
