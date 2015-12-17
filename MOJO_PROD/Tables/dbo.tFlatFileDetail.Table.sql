USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tFlatFileDetail]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tFlatFileDetail](
	[FlatFileDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[FlatFileKey] [int] NOT NULL,
	[StartIndex] [smallint] NOT NULL,
	[EndIndex] [smallint] NOT NULL,
	[FieldCaption] [varchar](100) NOT NULL,
	[FieldValue] [varchar](300) NOT NULL,
	[ValueIsFieldName] [tinyint] NOT NULL,
	[Alignment] [tinyint] NOT NULL,
	[Placeholder] [char](1) NOT NULL,
	[RecordType] [smallint] NOT NULL,
	[Required] [tinyint] NOT NULL,
	[Format] [smallint] NOT NULL,
	[GroupingFunction] [smallint] NOT NULL,
	[VoidOverrideValue] [varchar](300) NULL,
 CONSTRAINT [PK__tFlatFil__532161A73B2EEBF9] PRIMARY KEY CLUSTERED 
(
	[FlatFileDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tFlatFileDetail] ADD  CONSTRAINT [DF_tFlatFileDetail_RecordType]  DEFAULT ((1)) FOR [RecordType]
GO
ALTER TABLE [dbo].[tFlatFileDetail] ADD  CONSTRAINT [DF_tFlatFileDetail_Required]  DEFAULT ((0)) FOR [Required]
GO
ALTER TABLE [dbo].[tFlatFileDetail] ADD  CONSTRAINT [DF_tFlatFileDetail_Format]  DEFAULT ((0)) FOR [Format]
GO
ALTER TABLE [dbo].[tFlatFileDetail] ADD  CONSTRAINT [DF_tFlatFileDetail_GroupingFunction]  DEFAULT ((0)) FOR [GroupingFunction]
GO
