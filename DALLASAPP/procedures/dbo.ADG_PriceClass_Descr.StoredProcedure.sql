USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PriceClass_Descr]    Script Date: 12/21/2015 13:44:42 ******/
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
