USE [DEN_TEST_APP]
GO
/****** Object:  Table [dbo].[TimecardFavorite]    Script Date: 12/21/2015 14:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimecardFavorite](
	[UserID] [nvarchar](20) NOT NULL,
	[JobID] [nvarchar](20) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_TimecardFavorite] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[JobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TimecardFavorite] ADD  CONSTRAINT [DF_TimecardFavorite_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
