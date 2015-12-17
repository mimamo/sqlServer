USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tGLAccountRec]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGLAccountRec](
	[GLAccountRecKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[GLAccountKey] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[StartBalance] [money] NOT NULL,
	[EndBalance] [money] NOT NULL,
	[Completed] [tinyint] NOT NULL,
	[OtherIncrease] [money] NULL,
	[OtherDecrease] [money] NULL,
	[Comments] [text] NULL,
	[FilterStart] [smalldatetime] NULL,
	[FilterEnd] [smalldatetime] NULL,
	[GLCompanyKey] [int] NULL,
	[OpeningRec] [tinyint] NULL,
	[OpeningUncleared] [money] NULL,
	[OpeningCleared] [money] NULL,
 CONSTRAINT [PK_tGLAccountRec] PRIMARY KEY CLUSTERED 
(
	[GLAccountRecKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tGLAccountRec] ADD  CONSTRAINT [DF_tGLAccountRec_Completed]  DEFAULT ((0)) FOR [Completed]
GO
