USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RegularPO_Cpnyid_PONbr]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RegularPO_Cpnyid_PONbr]
    @CpnyID varchar ( 10),
    @PONbr varchar(10)
as

Select * from PurchOrd
   Where CpnyID = @CpnyID
     and PONbr LIKE @PONbr
     and POType = 'OR'
     and Status IN ('P','O')
   Order by PONbr
GO
