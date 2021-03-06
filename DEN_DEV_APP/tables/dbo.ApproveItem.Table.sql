USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[ApproveItem]    Script Date: 12/21/2015 14:05:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApproveItem](
	[Action] [char](20) NOT NULL,
	[Action_DateTime] [smalldatetime] NOT NULL,
	[Approver] [uniqueidentifier] NOT NULL,
	[Billable] [char](1) NOT NULL,
	[ChkSeq] [char](2) NOT NULL,
	[Comment] [nvarchar](1000) NOT NULL,
	[CpnyID] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EarnType] [char](10) NOT NULL,
	[EmpId] [char](10) NOT NULL,
	[LineId] [int] NOT NULL,
	[EmpName] [char](30) NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[Qty] [float] NOT NULL,
	[RateMult] [float] NOT NULL,
	[RecordID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RefNbr] [char](10) NOT NULL,
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
	[SS_BillableHours] [float] NOT NULL,
	[SS_ContractID] [char](10) NOT NULL,
	[SS_EquipmentID] [char](10) NOT NULL,
	[SS_ExtPrice] [float] NOT NULL,
	[SS_InvtLocId] [char](10) NOT NULL,
	[SS_LineTypes] [char](1) NOT NULL,
	[SS_LineItemID] [char](30) NOT NULL,
	[SS_PostFlag] [char](1) NOT NULL,
	[SS_ServiceCallID] [char](10) NOT NULL,
	[SS_UnitPrice] [float] NOT NULL,
	[StdUnitRate] [float] NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[TranDate] [smalldatetime] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WorkComp] [char](6) NOT NULL,
	[WrkLocId] [char](6) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [ApproveItem0] PRIMARY KEY CLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
