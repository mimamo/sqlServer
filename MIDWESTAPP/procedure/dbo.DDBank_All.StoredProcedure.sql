USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DDBank_All]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDBank_All] @parm1 varchar ( 6) as
    Select * from DDBank where BankID like @parm1 ORDER by BankID
GO
