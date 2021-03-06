USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_All]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnTypeDep_All]
   @VendCust	varchar(1),
   @VendID	varchar(15),	
   @EStatus	varchar(1)

AS
   SELECT       *
   FROM		XDDTxnTypeDep
   WHERE	VendCust = @VendCust
   		and VendID = @VendID
   		and EStatus LIKE @EStatus
   ORDER BY	EStatus
GO
