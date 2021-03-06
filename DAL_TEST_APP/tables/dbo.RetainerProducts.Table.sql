USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[RetainerProducts]    Script Date: 12/21/2015 13:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RetainerProducts](
	[RetainerProductID] [int] IDENTITY(1,1) NOT NULL,
	[RetainerID] [int] NOT NULL,
	[RetainerProductCode] [char](3) NOT NULL,
 CONSTRAINT [PK_RetainerProducts] PRIMARY KEY CLUSTERED 
(
	[RetainerProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RetainerProducts]  WITH CHECK ADD  CONSTRAINT [FK_RetainerProducts_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[RetainerProducts] CHECK CONSTRAINT [FK_RetainerProducts_Retainers]
GO
