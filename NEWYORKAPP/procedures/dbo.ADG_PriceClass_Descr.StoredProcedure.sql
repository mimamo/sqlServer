USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PriceClass_Descr]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[ADG_PriceClass_Descr]
	@PriceClassID	VarChar(6)
As
	SELECT Descr
	FROM PriceClass (NoLock)
	WHERE PriceClassID = @PriceClassID
GO
