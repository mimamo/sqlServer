USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRSetup_Update1]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRSetup_Update1] @parm1 varchar ( 6) as
       Update PRSetup
           Set EmpRGP = @parm1
GO
