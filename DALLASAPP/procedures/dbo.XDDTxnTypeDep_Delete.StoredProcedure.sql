USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_Delete]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnTypeDep_Delete]
   @VendCust	varchar(1),
   @VendID	varchar(15)

AS
   DELETE
   FROM		XDDTxnTypeDep
   WHERE	VendCust = @VendCust
   		and VendID = @VendID
GO
