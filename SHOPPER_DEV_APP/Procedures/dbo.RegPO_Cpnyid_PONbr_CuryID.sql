USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RegPO_Cpnyid_PONbr_CuryID]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RegPO_Cpnyid_PONbr_CuryID]
    @CpnyID varchar ( 10),
    @CuryID varchar (4),
    @PONbr varchar(10)
as

Select * from PurchOrd
   Where CpnyID = @CpnyID
     and CuryID = @CuryID
     and PONbr LIKE @PONbr
     and POType = 'OR'
     and Status IN ('P','O')
   Order by PONbr
GO
