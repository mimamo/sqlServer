USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_SumBy_neBat_Emp_Ref]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PRTran_SumBy_neBat_Emp_Ref] @BatNbr varchar(10), @EmpID varchar(10), @RefNbr varchar(10) AS
    select TotID, Coalesce(Sum(Qty),0)
      from PRTran
     inner JOIN TSTotal ON PRTran.EarnDedID = TSTotal.ETid
     where BatNbr     <>   @BatNbr
       and EmpID      LIKE @EmpID
       and TimeShtFlg <>   0
       and Paid       =    0
       and TimeShtNbr LIKE @RefNbr
  group by TotID
GO
