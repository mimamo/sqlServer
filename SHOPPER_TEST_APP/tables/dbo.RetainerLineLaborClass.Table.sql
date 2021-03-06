USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[RetainerLineLaborClass]    Script Date: 12/21/2015 16:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RetainerLineLaborClass](
	[RetainerLineClassID] [int] IDENTITY(1,1) NOT NULL,
	[RetainerID] [int] NOT NULL,
	[RetainerLineID] [int] NOT NULL,
	[LaborClass] [char](30) NOT NULL,
 CONSTRAINT [PK_RetainerLineLaborClass] PRIMARY KEY CLUSTERED 
(
	[RetainerLineClassID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RetainerLineLaborClass]  WITH CHECK ADD  CONSTRAINT [FK_RetainerLineLaborClass_RetainerLines] FOREIGN KEY([RetainerLineID])
REFERENCES [dbo].[RetainerLines] ([RetainerLineID])
GO
ALTER TABLE [dbo].[RetainerLineLaborClass] CHECK CONSTRAINT [FK_RetainerLineLaborClass_RetainerLines]
GO
ALTER TABLE [dbo].[RetainerLineLaborClass]  WITH CHECK ADD  CONSTRAINT [FK_RetainerLineLaborClass_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[RetainerLineLaborClass] CHECK CONSTRAINT [FK_RetainerLineLaborClass_Retainers]
GO
