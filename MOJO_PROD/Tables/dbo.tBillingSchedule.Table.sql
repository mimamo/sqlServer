USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBillingSchedule]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBillingSchedule](
	[BillingScheduleKey] [int] IDENTITY(1,1) NOT NULL,
	[ProjectKey] [int] NOT NULL,
	[NextBillDate] [smalldatetime] NULL,
	[TaskAssignmentKey] [int] NULL,
	[Comments] [varchar](4000) NULL,
	[BillingKey] [int] NULL,
	[TaskKey] [int] NULL,
	[PercentBudget] [decimal](24, 4) NULL,
 CONSTRAINT [PK_tBillingSchedule] PRIMARY KEY CLUSTERED 
(
	[BillingScheduleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
