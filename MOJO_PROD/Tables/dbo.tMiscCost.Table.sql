USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMiscCost]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMiscCost](
	[MiscCostKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[TaskKey] [int] NULL,
	[ExpenseDate] [smalldatetime] NULL,
	[ShortDescription] [varchar](200) NULL,
	[LongDescription] [varchar](1000) NULL,
	[ItemKey] [int] NULL,
	[ClassKey] [int] NULL,
	[Quantity] [decimal](24, 4) NULL,
	[UnitCost] [money] NULL,
	[UnitDescription] [varchar](30) NULL,
	[TotalCost] [money] NULL,
	[UnitRate] [money] NULL,
	[Markup] [decimal](24, 4) NULL,
	[Billable] [tinyint] NULL,
	[BillableCost] [money] NULL,
	[AmountBilled] [money] NULL,
	[EnteredByKey] [int] NULL,
	[DateEntered] [smalldatetime] NULL,
	[InvoiceLineKey] [int] NULL,
	[WriteOff] [tinyint] NULL,
	[WIPPostingInKey] [int] NOT NULL,
	[WIPPostingOutKey] [int] NOT NULL,
	[TransferComment] [varchar](500) NULL,
	[WriteOffReasonKey] [int] NULL,
	[DateBilled] [smalldatetime] NULL,
	[JournalEntryKey] [int] NULL,
	[OnHold] [tinyint] NULL,
	[BilledComment] [varchar](2000) NULL,
	[DepartmentKey] [int] NULL,
	[TransferInDate] [smalldatetime] NULL,
	[TransferOutDate] [smalldatetime] NULL,
	[TransferFromKey] [int] NULL,
	[TransferToKey] [int] NULL,
	[WIPAmount] [money] NULL,
	[OldWIPAmount] [money] NULL,
	[BilledItem] [int] NULL,
	[ExchangeRate] [decimal](24, 7) NULL,
	[CurrencyID] [varchar](10) NULL,
	[RootTransferFromKey] [int] NULL,
	[AdjustmentType] [smallint] NULL,
 CONSTRAINT [PK_tMiscCost] PRIMARY KEY NONCLUSTERED 
(
	[MiscCostKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_WriteOff]  DEFAULT ((0)) FOR [WriteOff]
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_WIPPostingInKey]  DEFAULT ((0)) FOR [WIPPostingInKey]
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_WIPPostingOutKey]  DEFAULT ((0)) FOR [WIPPostingOutKey]
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_OnHold]  DEFAULT ((0)) FOR [OnHold]
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_WIPAmount]  DEFAULT ((0)) FOR [WIPAmount]
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
ALTER TABLE [dbo].[tMiscCost] ADD  CONSTRAINT [DF_tMiscCost_AdjustmentType]  DEFAULT ((0)) FOR [AdjustmentType]
GO
