USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PriceClass_Descr]    Script Date: 12/21/2015 14:34:05 ******/
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
