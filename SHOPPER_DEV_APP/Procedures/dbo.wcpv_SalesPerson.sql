USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_SalesPerson]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[wcpv_SalesPerson](
	@SlsPerID VARCHAR(10) = '%'
)As
	SELECT	s.Name, s.SlsPerID
	FROM	SalesPerson s (NOLOCK)
	WHERE	s.SlsPerID LIKE @SlsPerID
	ORDER BY s.Name
GO
