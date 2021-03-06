USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_SalesPerson]    Script Date: 12/21/2015 16:13:27 ******/
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
