USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RegPORet_CpnyID_VendID_PONbr]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RegPORet_CpnyID_VendID_PONbr]
    @CpnyID varchar ( 10),
    @VendID varchar ( 15),
    @PONbr varchar(10)
as

Select * from PurchOrd
   Where CpnyID = @CpnyID
     and VendID = @VendID
     and PONbr LIKE @PONbr
     and POType = 'OR'
     and RcptStage IN ('F','P')
   Order by PONbr
GO
