USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[APTranDt]    Script Date: 12/21/2015 14:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[APTranDt](
	[AlternateID] [char](30) NOT NULL,
	[APLineRef] [char](5) NOT NULL,
	[BOMLineRef] [char](5) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[CuryExtCost] [float] NOT NULL,
	[CuryExtCostVar] [float] NOT NULL,
	[CuryID] [char](4) NOT NULL,
	[CuryInvcExtCost] [float] NOT NULL,
	[CuryInvcUnitCost] [float] NOT NULL,
	[CuryMultDiv] [char](1) NOT NULL,
	[CuryRate] [float] NOT NULL,
	[CuryUnitCost] [float] NOT NULL,
	[CuryUnitCostVar] [float] NOT NULL,
	[Descr] [char](60) NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[ExtCost] [float] NOT NULL,
	[ExtCostVar] [float] NOT NULL,
	[InvcExtCost] [float] NOT NULL,
	[InvcQty] [float] NOT NULL,
	[InvcUnitCost] [float] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[Labor_Class_Cd] [char](4) NOT NULL,
	[LineID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineRef] [char](5) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[ProjectID] [char](16) NOT NULL,
	[PurchAcct] [char](10) NOT NULL,
	[PurchSub] [char](24) NOT NULL,
	[Qty] [float] NOT NULL,
	[QtyVar] [float] NOT NULL,
	[RcptLineRef] [char](5) NOT NULL,
	[RcptNbr] [char](10) NOT NULL,
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
	[SiteID] [char](10) NOT NULL,
	[SOLineRef] [char](5) NOT NULL,
	[SONbr] [char](10) NOT NULL,
	[SOType] [char](2) NOT NULL,
	[TaskID] [char](32) NOT NULL,
	[UnitCost] [float] NOT NULL,
	[UnitCostVar] [float] NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[WOCostType] [char](2) NOT NULL,
	[WONbr] [char](10) NOT NULL,
	[WOStepNbr] [char](5) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [APTranDT0] PRIMARY KEY CLUSTERED 
(
	[RefNbr] ASC,
	[APLineRef] ASC,
	[LineNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
