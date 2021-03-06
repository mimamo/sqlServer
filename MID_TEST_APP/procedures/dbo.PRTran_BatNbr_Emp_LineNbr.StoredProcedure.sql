USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_BatNbr_Emp_LineNbr]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PRTran_BatNbr_Emp_LineNbr]
@BatNbr   varchar(10),
@EmpID    varchar(10),
@LineNbr1 smallint,
@LineNbr2 smallint
AS
SELECT *
FROM PRTran
WHERE BatNbr=@BatNbr AND EmpID=@EmpID
      AND LineNbr BETWEEN @LineNbr1 AND @LineNbr2
GO
