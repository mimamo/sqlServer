USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DDDepositor_BankID_CpnyID]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDDepositor_BankID_CpnyID] @Parm1 varchar ( 6), @Parm2 varchar ( 10) as
    Select d.* from DDDepositor d join Employee e on d.EmpID = e.EmpID where BankID like @Parm1 AND e.CpnyID like @Parm2 ORDER by BankID, d.EmpID
GO
