USE [SHOPPER_DEV_APP]
GO
/****** Object:  Table [dbo].[RetainerLineVendor]    Script Date: 12/21/2015 14:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RetainerLineVendor](
	[RetainerLineVendID] [int] IDENTITY(1,1) NOT NULL,
	[RetainerID] [int] NOT NULL,
	[RetainerLineID] [int] NOT NULL,
	[VendID] [char](15) NOT NULL,
 CONSTRAINT [PK_RetainerLineVendor] PRIMARY KEY CLUSTERED 
(
	[RetainerLineVendID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[RetainerLineVendor]  WITH CHECK ADD  CONSTRAINT [FK_RetainerLineVendor_RetainerLines] FOREIGN KEY([RetainerLineID])
REFERENCES [dbo].[RetainerLines] ([RetainerLineID])
GO
ALTER TABLE [dbo].[RetainerLineVendor] CHECK CONSTRAINT [FK_RetainerLineVendor_RetainerLines]
GO
ALTER TABLE [dbo].[RetainerLineVendor]  WITH CHECK ADD  CONSTRAINT [FK_RetainerLineVendor_Retainers] FOREIGN KEY([RetainerID])
REFERENCES [dbo].[Retainers] ([RetainerID])
GO
ALTER TABLE [dbo].[RetainerLineVendor] CHECK CONSTRAINT [FK_RetainerLineVendor_Retainers]
GO
