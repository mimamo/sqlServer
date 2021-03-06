USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFieldSet]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFieldSet](
	[FieldSetKey] [int] IDENTITY(1,1) NOT NULL,
	[OwnerEntityKey] [int] NULL,
	[AssociatedEntity] [varchar](50) NOT NULL,
	[FieldSetName] [varchar](75) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[CreatedByKey] [int] NULL,
	[CreatedByDate] [datetime] NULL,
	[UpdatedByKey] [int] NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_tFieldSet] PRIMARY KEY NONCLUSTERED 
(
	[FieldSetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tFieldSet] ADD  CONSTRAINT [DF_tFieldSet_Active]  DEFAULT ((1)) FOR [Active]
GO
