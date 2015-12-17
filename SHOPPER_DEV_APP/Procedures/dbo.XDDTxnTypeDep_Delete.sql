USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_Delete]    Script Date: 12/16/2015 15:55:38 ******/
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
