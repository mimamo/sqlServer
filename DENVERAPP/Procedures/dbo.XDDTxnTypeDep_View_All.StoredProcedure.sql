USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_View_All]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnTypeDep_View_All]
   @VendCust	varchar(1),
   @VendID	varchar(15),	
   @EStatus	varchar(1)

AS
   SELECT       *
   FROM		XDD_vp_TxnTypeDep
   WHERE	VendCust = @VendCust
   			and VendID = @VendID
   			and EStatus LIKE @EStatus
   ORDER BY	EStatus
GO
