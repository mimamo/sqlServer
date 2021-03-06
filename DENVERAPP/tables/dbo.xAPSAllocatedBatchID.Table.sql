USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xAPSAllocatedBatchID]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPSAllocatedBatchID](
	[batch_id] [varchar](10) NOT NULL,
	[crtd_datetime] [datetime] NOT NULL,
 CONSTRAINT [PK_xAPSAllocatedBatchID] PRIMARY KEY CLUSTERED 
(
	[batch_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPSAllocatedBatchID] ADD  CONSTRAINT [DF_xAPSAllocatedBatchID_crtd_datetime]  DEFAULT (getdate()) FOR [crtd_datetime]
GO
