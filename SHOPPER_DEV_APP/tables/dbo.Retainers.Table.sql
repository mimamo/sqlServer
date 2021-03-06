USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[Retainers]    Script Date: 12/21/2015 14:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Retainers](
	[RetainerID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [char](15) NOT NULL,
	[RetainerDesc] [char](40) NOT NULL,
	[RetainerNotes] [nvarchar](max) NOT NULL,
	[RetainerFiscalBased] [bit] NOT NULL,
	[Period1FiscalNo] [char](6) NOT NULL,
	[Period2FiscalNo] [char](6) NOT NULL,
	[Period3FiscalNo] [char](6) NOT NULL,
	[Period4FiscalNo] [char](6) NOT NULL,
	[Period5FiscalNo] [char](6) NOT NULL,
	[Period6FiscalNo] [char](6) NOT NULL,
	[Period7FiscalNo] [char](6) NOT NULL,
	[Period8FiscalNo] [char](6) NOT NULL,
	[Period9FiscalNo] [char](6) NOT NULL,
	[Period10FiscalNo] [char](6) NOT NULL,
	[Period11FiscalNo] [char](6) NOT NULL,
	[Period12FiscalNo] [char](6) NOT NULL,
	[Period1Month] [datetime] NOT NULL,
	[Period2Month] [datetime] NOT NULL,
	[Period3Month] [datetime] NOT NULL,
	[Period4Month] [datetime] NOT NULL,
	[Period5Month] [datetime] NOT NULL,
	[Period6Month] [datetime] NOT NULL,
	[Period7Month] [datetime] NOT NULL,
	[Period8Month] [datetime] NOT NULL,
	[Period9Month] [datetime] NOT NULL,
	[Period10Month] [datetime] NOT NULL,
	[Period11Month] [datetime] NOT NULL,
	[Period12Month] [datetime] NOT NULL,
 CONSTRAINT [PK_Retainers] PRIMARY KEY CLUSTERED 
(
	[RetainerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Retainers]  WITH CHECK ADD  CONSTRAINT [FK_Retainers_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[Retainers] CHECK CONSTRAINT [FK_Retainers_Retainers]
GO
