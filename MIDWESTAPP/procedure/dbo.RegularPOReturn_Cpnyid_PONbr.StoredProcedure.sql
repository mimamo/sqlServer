USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[RegularPOReturn_Cpnyid_PONbr]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RegularPOReturn_Cpnyid_PONbr]
    @CpnyID varchar ( 10),
    @PONbr varchar(10)
as

Select * from PurchOrd
   Where CpnyID = @CpnyID
     and PONbr LIKE @PONbr
     and POType = 'OR'
     and RcptStage IN ('F','P')
   Order by PONbr
GO
