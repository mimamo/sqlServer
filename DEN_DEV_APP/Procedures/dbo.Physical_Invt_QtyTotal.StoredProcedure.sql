USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Physical_Invt_QtyTotal]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Physical_Invt_QtyTotal]
	@PIID VarChar(10)

AS
 Select Sum(Physqty)
	From PIDetail
	Where PIDetail.PIID = @PIID
GO
