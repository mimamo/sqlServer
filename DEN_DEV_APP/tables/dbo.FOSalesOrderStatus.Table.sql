USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[FOSalesOrderStatus]    Script Date: 12/21/2015 14:05:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FOSalesOrderStatus](
	[Behavior] [char](4) NOT NULL,
	[CancelDate] [smalldatetime] NOT NULL,
	[Cancelled] [smallint] NOT NULL,
	[ErrorDescription] [char](1024) NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[OrdNbr] [char](15) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SOTypeID] [char](4) NOT NULL,
	[Status] [char](1) NOT NULL,
	[SubscriberOrderID] [char](50) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_Behavior]  DEFAULT (' ') FOR [Behavior]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_CancelDate]  DEFAULT ('01/01/1900') FOR [CancelDate]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_Cancelled]  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_ErrorDescription]  DEFAULT (' ') FOR [ErrorDescription]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_ErrorNumber]  DEFAULT ((0)) FOR [ErrorNumber]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_OrdNbr]  DEFAULT (' ') FOR [OrdNbr]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future01]  DEFAULT (' ') FOR [S4Future01]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future02]  DEFAULT (' ') FOR [S4Future02]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future03]  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future04]  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future05]  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future06]  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future07]  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future08]  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future09]  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future10]  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future11]  DEFAULT (' ') FOR [S4Future11]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_S4Future12]  DEFAULT (' ') FOR [S4Future12]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_SOTypeID]  DEFAULT (' ') FOR [SOTypeID]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_Status]  DEFAULT (' ') FOR [Status]
GO
ALTER TABLE [dbo].[FOSalesOrderStatus] ADD  CONSTRAINT [DF_FOSalesOrderStatus_SubscriberOrderID]  DEFAULT (' ') FOR [SubscriberOrderID]
GO
