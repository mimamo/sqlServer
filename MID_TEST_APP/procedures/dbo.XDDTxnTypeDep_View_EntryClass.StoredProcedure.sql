USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnTypeDep_View_EntryClass]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnTypeDep_View_EntryClass]
   @VendCust	varchar(1),
   @VendID	varchar(15),	
   @EntryClass	varchar(4)

AS
   SELECT       EStatus, EntryClassCanChg
   FROM		XDD_vp_TxnTypeDep
   WHERE	VendCust = @VendCust
   		and VendID = @VendID
   		and T_EntryClass LIKE @EntryClass
   ORDER BY	EntryClass
GO
