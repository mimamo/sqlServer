USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodePercentGetTotal]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodePercentGetTotal]
	(
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt

Select sum(Percentage) as Allocated
From tCBCodePercent (nolock) Where Entity = @Entity and EntityKey = @EntityKey
GO
