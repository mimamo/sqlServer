USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaOrder]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaOrder](
	[MediaOrderKey] [int] IDENTITY(1,1) NOT NULL,
	[MediaWorksheetKey] [int] NOT NULL,
	[OrderNumber] [varchar](30) NOT NULL,
	[Revision] [int] NOT NULL,
	[RevisionDate] [datetime] NULL,
 CONSTRAINT [PK__tMediaOr__55A427BA5AB2844A] PRIMARY KEY CLUSTERED 
(
	[MediaOrderKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaOrder] ADD  CONSTRAINT [DF_tMediaOrder_RevisionDate]  DEFAULT (getutcdate()) FOR [RevisionDate]
GO
