USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_Delete]    Script Date: 12/21/2015 15:49:37 ******/
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
