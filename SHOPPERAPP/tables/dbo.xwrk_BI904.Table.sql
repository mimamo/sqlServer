USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_BI904]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_BI904](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RI_ID] [int] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[RunDate] [char](10) NOT NULL,
	[RunTime] [char](7) NOT NULL,
	[TerminalNum] [char](21) NOT NULL,
	[Status] [char](1) NOT NULL,
	[project_billwith] [char](16) NOT NULL,
	[hold_status] [char](2) NOT NULL,
	[acct] [char](16) NOT NULL,
	[source_trx_date] [smalldatetime] NOT NULL,
	[amount] [float] NOT NULL,
	[JobID] [char](16) NOT NULL,
	[Job] [char](30) NOT NULL,
	[sort_num] [smallint] NOT NULL,
	[fiscalno] [varchar](6) NOT NULL,
	[ClientID] [char](30) NOT NULL,
	[ProductID] [char](4) NOT NULL,
	[Product] [char](30) NOT NULL,
	[OnShelfDate] [smalldatetime] NOT NULL,
	[PM] [varchar](10) NOT NULL,
	[ClientRefNum] [varchar](30) NOT NULL,
	[OpenDate] [smalldatetime] NOT NULL,
	[CloseDate] [smalldatetime] NOT NULL,
	[ECD] [smalldatetime] NOT NULL,
	[OfferNum] [varchar](30) NOT NULL,
	[li_type] [char](1) NOT NULL,
	[Client] [char](30) NOT NULL,
	[AcctGroupCode] [char](2) NOT NULL,
	[Bill_Status] [varchar](1) NOT NULL,
	[EstAmount] [float] NOT NULL,
	[OpenPO] [float] NOT NULL,
	[BTD] [float] NOT NULL,
	[Actuals] [float] NOT NULL,
	[ActualsToBill] [float] NOT NULL,
	[EstAmountRem] [float] NOT NULL,
	[ClientContactID] [char](10) NOT NULL,
	[ClientContactName] [varchar](50) NOT NULL,
	[ClientIdentifier] [varchar](60) NOT NULL,
	[Brand] [varchar](60) NOT NULL,
	[Director] [varchar](60) NOT NULL,
	[AcctService] [varchar](50) NOT NULL,
	[CurrLockedEst] [float] NOT NULL,
	[UnlockedEst] [float] NOT NULL,
	[ClassID] [varchar](20) NOT NULL,
	[CurrentAmt] [float] NOT NULL,
	[Past1] [float] NOT NULL,
	[Past2] [float] NOT NULL,
	[Past3] [float] NOT NULL,
	[Over120] [float] NOT NULL,
	[Total] [float] NOT NULL,
 CONSTRAINT [PK_xwrk_BI904] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
