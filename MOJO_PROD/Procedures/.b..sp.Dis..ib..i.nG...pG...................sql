USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDistributionGroupGet]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDistributionGroupGet]
	@DistributionGroupKey int

AS -- Encrypt


		SELECT *
		FROM tDistributionGroup (NOLOCK)
		WHERE
			DistributionGroupKey = @DistributionGroupKey

	RETURN 1
GO
