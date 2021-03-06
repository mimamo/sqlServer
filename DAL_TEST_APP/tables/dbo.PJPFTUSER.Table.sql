USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[PJPFTUSER]    Script Date: 12/21/2015 13:56:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJPFTUSER](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DayRange] [smallint] NOT NULL,
	[DecPlHrs] [smallint] NOT NULL,
	[Desc_Cust_Chars] [smallint] NOT NULL,
	[Desc_Cust_Code] [smallint] NOT NULL,
	[Desc_Oper_Chars] [smallint] NOT NULL,
	[Desc_Oper_Code] [smallint] NOT NULL,
	[Desc_Proj_Chars] [smallint] NOT NULL,
	[Desc_Proj_Code] [smallint] NOT NULL,
	[Desc_Task_Chars] [smallint] NOT NULL,
	[Desc_Task_Code] [smallint] NOT NULL,
	[Display_CmplStep] [smallint] NOT NULL,
	[Display_CmplTask] [smallint] NOT NULL,
	[Display_Order] [char](1) NOT NULL,
	[Display_ProjActive] [smallint] NOT NULL,
	[Display_ProjInActive] [smallint] NOT NULL,
	[Display_ProjPlan] [smallint] NOT NULL,
	[Display_TaskActive] [smallint] NOT NULL,
	[Display_TaskInActive] [smallint] NOT NULL,
	[Display_TaskPlan] [smallint] NOT NULL,
	[Display_WeekEnd] [char](1) NOT NULL,
	[Employee] [char](10) NOT NULL,
	[FontSize] [char](5) NOT NULL,
	[IntervalFut] [smallint] NOT NULL,
	[IntervalPast] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[Prox_AmtYellowN] [smallint] NOT NULL,
	[Prox_AmtYellowP] [smallint] NOT NULL,
	[Prox_DateYellowN] [smallint] NOT NULL,
	[Prox_DateYellowP] [smallint] NOT NULL,
	[Prox_HrsYellowN] [smallint] NOT NULL,
	[Prox_HrsYellowP] [smallint] NOT NULL,
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
	[ShowCpnyID] [char](1) NOT NULL,
	[ShowGLAcct] [char](1) NOT NULL,
	[ShowGLSub] [char](1) NOT NULL,
	[ShowHrsToCmp] [char](1) NOT NULL,
	[ShowLbrClass] [char](1) NOT NULL,
	[ShowNonBill] [char](1) NOT NULL,
	[ShowOT] [char](1) NOT NULL,
	[ShowStepCmpO] [char](1) NOT NULL,
	[ShowTaskCmpO] [char](1) NOT NULL,
	[ShowWklyDesc] [char](1) NOT NULL,
	[TimeInterval] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PJPFTUSER0] PRIMARY KEY CLUSTERED 
(
	[Employee] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('01/01/1900') FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [Crtd_Prog]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [Crtd_User]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [DayRange]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [DecPlHrs]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Cust_Chars]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Cust_Code]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Oper_Chars]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Oper_Code]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Proj_Chars]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Proj_Code]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Task_Chars]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Desc_Task_Code]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_CmplStep]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_CmplTask]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [Display_Order]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_ProjActive]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_ProjInActive]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_ProjPlan]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_TaskActive]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_TaskInActive]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Display_TaskPlan]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [Display_WeekEnd]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [Employee]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [FontSize]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [IntervalFut]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [IntervalPast]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('01/01/1900') FOR [LUpd_DateTime]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [LUpd_Prog]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [LUpd_User]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [NoteID]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Prox_AmtYellowN]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Prox_AmtYellowP]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Prox_DateYellowN]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Prox_DateYellowP]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Prox_HrsYellowN]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [Prox_HrsYellowP]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [S4Future01]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [S4Future02]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [S4Future03]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [S4Future04]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [S4Future05]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [S4Future06]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('01/01/1900') FOR [S4Future07]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('01/01/1900') FOR [S4Future08]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [S4Future09]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [S4Future10]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [S4Future11]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [S4Future12]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowCpnyID]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowGLAcct]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowGLSub]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowHrsToCmp]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowLbrClass]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowNonBill]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowOT]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowStepCmpO]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowTaskCmpO]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [ShowWklyDesc]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [TimeInterval]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [User1]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [User2]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [User3]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ((0)) FOR [User4]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [User5]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('') FOR [User6]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('01/01/1900') FOR [User7]
GO
ALTER TABLE [dbo].[PJPFTUSER] ADD  DEFAULT ('01/01/1900') FOR [User8]
GO
