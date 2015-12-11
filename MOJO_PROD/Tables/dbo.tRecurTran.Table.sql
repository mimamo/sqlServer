USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRecurTran]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRecurTran](
	[RecurTranKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Description] [varchar](4000) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[ReminderOption] [varchar](50) NOT NULL,
	[Frequency] [varchar](50) NULL,
	[NextDate] [datetime] NULL,
	[NumberRemaining] [int] NULL,
	[DaysInAdvance] [int] NULL,
	[Active] [tinyint] NULL,
	[CreateAsApproved] [tinyint] NULL,
 CONSTRAINT [PK_tRecurTran] PRIMARY KEY CLUSTERED 
(
	[RecurTranKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
