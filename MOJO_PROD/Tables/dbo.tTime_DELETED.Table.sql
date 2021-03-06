USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTime_DELETED]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTime_DELETED](
	[Time_DELETED_Key] [int] IDENTITY(1,1) NOT NULL,
	[TimeKey] [varbinary](50) NOT NULL,
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
 CONSTRAINT [PK_tTime_DELETED] PRIMARY KEY CLUSTERED 
(
	[Time_DELETED_Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tTime_DELETED] ADD  CONSTRAINT [DF_tTime_DELETED_RateLevel]  DEFAULT ((1)) FOR [RateLevel]
GO
ALTER TABLE [dbo].[tTime_DELETED] ADD  CONSTRAINT [DF_tTime_DELETED_WriteOff]  DEFAULT ((0)) FOR [WriteOff]
GO
ALTER TABLE [dbo].[tTime_DELETED] ADD  CONSTRAINT [DF_tTime_DELETED_Downloaded]  DEFAULT ((0)) FOR [Downloaded]
GO
ALTER TABLE [dbo].[tTime_DELETED] ADD  CONSTRAINT [DF_tTime_DELETED_WIPPostingKey]  DEFAULT ((0)) FOR [WIPPostingInKey]
GO
ALTER TABLE [dbo].[tTime_DELETED] ADD  CONSTRAINT [DF_tTime_DELETED_WIPPostingOutKey]  DEFAULT ((0)) FOR [WIPPostingOutKey]
GO
ALTER TABLE [dbo].[tTime_DELETED] ADD  CONSTRAINT [DF_tTime_DELETED_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
