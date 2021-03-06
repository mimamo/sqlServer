USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[RetainerLines]    Script Date: 12/21/2015 16:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RetainerLines](
	[RetainerLineID] [int] IDENTITY(1,1) NOT NULL,
	[RetainerID] [int] NOT NULL,
	[LineNbr] [smallint] NOT NULL,
	[LineDesc] [char](40) NOT NULL,
	[LineRate] [float] NOT NULL,
	[Period1Hours] [float] NOT NULL,
	[Period2Hours] [float] NOT NULL,
	[Period3Hours] [float] NOT NULL,
	[Period4Hours] [float] NOT NULL,
	[Period5Hours] [float] NOT NULL,
	[Period6Hours] [float] NOT NULL,
	[Period7Hours] [float] NOT NULL,
	[Period8Hours] [float] NOT NULL,
	[Period9Hours] [float] NOT NULL,
	[Period10Hours] [float] NOT NULL,
	[Period11Hours] [float] NOT NULL,
	[Period12Hours] [float] NOT NULL,
 CONSTRAINT [PK_RetainerLines] PRIMARY KEY CLUSTERED 
(
	[RetainerLineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RetainerLines]  WITH CHECK ADD  CONSTRAINT [FK_RetainerLines_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[RetainerLines] CHECK CONSTRAINT [FK_RetainerLines_Retainers]
GO
