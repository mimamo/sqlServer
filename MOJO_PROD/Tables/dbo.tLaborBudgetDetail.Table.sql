USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLaborBudgetDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLaborBudgetDetail](
	[LaborBudgetDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[LaborBudgetKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[Locked] [tinyint] NOT NULL,
	[UserReviewed] [tinyint] NOT NULL,
	[UserComments] [varchar](4000) NULL,
	[EditComments] [varchar](4000) NULL,
	[AvailableHours1] [int] NULL,
	[TargetHours1] [int] NULL,
	[TargetDollars1] [money] NULL,
	[AvailableHours2] [int] NULL,
	[TargetHours2] [int] NULL,
	[TargetDollars2] [money] NULL,
	[AvailableHours3] [int] NULL,
	[TargetHours3] [int] NULL,
	[TargetDollars3] [money] NULL,
	[AvailableHours4] [int] NULL,
	[TargetHours4] [int] NULL,
	[TargetDollars4] [money] NULL,
	[AvailableHours5] [int] NULL,
	[TargetHours5] [int] NULL,
	[TargetDollars5] [money] NULL,
	[AvailableHours6] [int] NULL,
	[TargetHours6] [int] NULL,
	[TargetDollars6] [money] NULL,
	[AvailableHours7] [int] NULL,
	[TargetHours7] [int] NULL,
	[TargetDollars7] [money] NULL,
	[AvailableHours8] [int] NULL,
	[TargetHours8] [int] NULL,
	[TargetDollars8] [money] NULL,
	[AvailableHours9] [int] NULL,
	[TargetHours9] [int] NULL,
	[TargetDollars9] [money] NULL,
	[AvailableHours10] [int] NULL,
	[TargetHours10] [int] NULL,
	[TargetDollars10] [money] NULL,
	[AvailableHours11] [int] NULL,
	[TargetHours11] [int] NULL,
	[TargetDollars11] [money] NULL,
	[AvailableHours12] [int] NULL,
	[TargetHours12] [int] NULL,
	[TargetDollars12] [money] NULL,
 CONSTRAINT [PK_tLaborBudgetDetail] PRIMARY KEY CLUSTERED 
(
	[LaborBudgetDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tLaborBudgetDetail] ADD  CONSTRAINT [DF_tLaborBudgetDetail_Locked]  DEFAULT ((0)) FOR [Locked]
GO
ALTER TABLE [dbo].[tLaborBudgetDetail] ADD  CONSTRAINT [DF_tLaborBudgetDetail_UserReviewed]  DEFAULT ((0)) FOR [UserReviewed]
GO
