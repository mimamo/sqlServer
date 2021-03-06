USE [MID_DEV_APP]
GO
/****** Object:  View [dbo].[vs_Stubdetail_Deduction]    Script Date: 12/21/2015 14:17:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vs_Stubdetail_Deduction] AS 
    select p.RI_ID, s.EmpId, s.TypeId as EarnDedId, sum(s.EDCurrAmt) as CurrAmt
      from Stubdetail s INNER JOIN vs_PRTran_Unique_Chk p 
        ON s.Acct     = p.ChkAcct
       and s.Sub      = p.ChkSub
       and s.ChkNbr   = p.RefNbr
     where s.Stubtype = 'D'
  group by p.RI_ID, s.EmpId, s.TypeId
GO
