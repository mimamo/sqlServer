USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChk_Emp_Seq_PV]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChk_Emp_Seq_PV] @EmpId  varchar(10), @ChkSeq varchar(2) As
    Select CalcChk.* from CalcChk, CheckSeq
                    where CalcChk.ChkSeq    = CheckSeq.ChkSeq
                      and CalcChk.EmpID  like @EmpId
                      and CalcChk.ChkSeq like @ChkSeq
                 Order by CalcChk.ChkSeq
GO
