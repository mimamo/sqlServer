USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tService]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tService](
	[ServiceKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ServiceCode] [varchar](50) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[HourlyRate1] [money] NULL,
	[HourlyRate2] [money] NULL,
	[HourlyRate3] [money] NULL,
	[HourlyRate4] [money] NULL,
	[HourlyRate5] [money] NULL,
	[Active] [tinyint] NULL,
	[Description1] [varchar](100) NULL,
	[Description2] [varchar](100) NULL,
	[Description3] [varchar](100) NULL,
	[Description4] [varchar](100) NULL,
	[Description5] [varchar](100) NULL,
	[WorkTypeKey] [int] NULL,
	[InvoiceDescription] [varchar](500) NULL,
	[GLAccountKey] [int] NULL,
	[ClassKey] [int] NULL,
	[HourlyCost] [money] NULL,
	[Taxable] [tinyint] NULL,
	[Taxable2] [tinyint] NULL,
	[LinkID] [varchar](100) NULL,
	[DepartmentKey] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [tService_PK] PRIMARY KEY CLUSTERED 
(
	[ServiceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tService]  WITH CHECK ADD  CONSTRAINT [tCompany_tService_FK1] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tService] CHECK CONSTRAINT [tCompany_tService_FK1]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_HourlyRate1]  DEFAULT ((0)) FOR [HourlyRate1]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_HourlyRate2]  DEFAULT ((0)) FOR [HourlyRate2]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_HourlyRate3]  DEFAULT ((0)) FOR [HourlyRate3]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_HourlyRate4]  DEFAULT ((0)) FOR [HourlyRate4]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_HourlyRate5]  DEFAULT ((0)) FOR [HourlyRate5]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tService] ADD  CONSTRAINT [DF_tService_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
