USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[xJATemplateHdr_IWT]    Script Date: 12/21/2015 13:56:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xJATemplateHdr_IWT](
	[TemplateHdrKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActiveOnly] [smallint] NOT NULL,
	[AgingDate] [smalldatetime] NOT NULL,
	[SupressDefaultDtl] [smallint] NOT NULL,
	[TemplateID] [varchar](50) NOT NULL,
	[UnbilledOnly] [smallint] NOT NULL,
	[SortBillWith] [smallint] NOT NULL,
 CONSTRAINT [PK_xJATemplateHdr_IWT] PRIMARY KEY CLUSTERED 
(
	[TemplateHdrKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xJATemplateHdr_IWT] ADD  CONSTRAINT [DF_xJATemplateHdr_IWT_UnbilledOnly]  DEFAULT ((0)) FOR [UnbilledOnly]
GO
ALTER TABLE [dbo].[xJATemplateHdr_IWT] ADD  CONSTRAINT [DF_xJATemplateHdr_IWT_SortBillWith]  DEFAULT ((0)) FOR [SortBillWith]
GO
