USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_Delete_EmpId]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChk_Delete_EmpId] @EmpId varchar(10) as
    delete d from CalcChk c, CalcChkDet d
     where c.EmpID    = @EmpID
       and c.CheckNbr <> ''
       and c.EmpId    = d.EmpId
       and c.ChkSeq   = d.ChkSeq

    delete CalcChk
     where EmpID    = @EmpID
       and CheckNbr <> ''
GO
