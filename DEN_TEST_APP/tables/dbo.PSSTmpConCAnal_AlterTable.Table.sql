USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[PSSTmpConCAnal_AlterTable]    Script Date: 12/21/2015 14:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSTmpConCAnal_AlterTable](
	[CurDue] [float] NOT NULL,
	[CurDueCury] [float] NOT NULL,
	[CurEndDate] [smalldatetime] NOT NULL,
	[CurOwe] [float] NOT NULL,
	[CurOweCury] [float] NOT NULL,
	[PrPdDue] [float] NOT NULL,
	[PrPdDueCury] [float] NOT NULL,
	[PrPdEndDate] [smalldatetime] NOT NULL,
	[PrPdOwe] [float] NOT NULL,
	[PrPdOweCury] [float] NOT NULL,
	[PrYrDue] [float] NOT NULL,
	[PrYrDueCury] [float] NOT NULL,
	[PrYrEndDate] [smalldatetime] NOT NULL,
	[PrYrOwe] [float] NOT NULL,
	[PrYrOweCury] [float] NOT NULL,
	[RI_ID] [int] NOT NULL,
	[SortBy] [char](10) NOT NULL,
	[UserComp] [char](21) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [CurDue]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [CurDueCury]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [CurEndDate]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [CurOwe]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [CurOweCury]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrPdDue]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrPdDueCury]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [PrPdEndDate]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrPdOwe]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrPdOweCury]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrYrDue]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrYrDueCury]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ('01/01/1900') FOR [PrYrEndDate]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrYrOwe]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0.00)) FOR [PrYrOweCury]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ((0)) FOR [RI_ID]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ('') FOR [SortBy]
GO
ALTER TABLE [dbo].[PSSTmpConCAnal_AlterTable] ADD  DEFAULT ('') FOR [UserComp]
GO
