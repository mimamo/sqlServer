USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tForm]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tForm](
	[FormKey] [int] IDENTITY(1,1) NOT NULL,
	[FormDefKey] [int] NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[FormNumber] [int] NOT NULL,
	[Author] [int] NOT NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[DateClosed] [smalldatetime] NULL,
	[AssignedTo] [int] NULL,
	[Subject] [varchar](150) NULL,
	[DueDate] [smalldatetime] NULL,
	[Priority] [smallint] NULL,
	[CustomFieldKey] [int] NULL,
	[ContactCompanyKey] [int] NULL,
 CONSTRAINT [PK_tForm] PRIMARY KEY NONCLUSTERED 
(
	[FormKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tForm]  WITH NOCHECK ADD  CONSTRAINT [FK_tForm_tFormDef] FOREIGN KEY([FormDefKey])
REFERENCES [dbo].[tFormDef] ([FormDefKey])
GO
ALTER TABLE [dbo].[tForm] CHECK CONSTRAINT [FK_tForm_tFormDef]
GO
ALTER TABLE [dbo].[tForm] ADD  CONSTRAINT [DF_tForm_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[tForm] ADD  CONSTRAINT [DF_tForm_Priority]  DEFAULT ((2)) FOR [Priority]
GO
