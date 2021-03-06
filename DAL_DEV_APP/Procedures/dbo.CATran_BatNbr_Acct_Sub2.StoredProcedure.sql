USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_BatNbr_Acct_Sub2]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_BatNbr_Acct_Sub2    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CATran_BatNbr_Acct_Sub2] @parm1 varchar ( 10) as
select * from CATran
where batnbr = @parm1
and module = 'CA'
order by cpnyid,
         acct,
         sub,
         ProjectId,
         TaskId,
         EmployeeId,
         Labor_Class_Cd,
         PC_Flag,
         PC_ID,
         PC_Status
GO
