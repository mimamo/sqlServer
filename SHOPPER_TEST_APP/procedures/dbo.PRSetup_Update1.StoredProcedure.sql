USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRSetup_Update1]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRSetup_Update1] @parm1 varchar ( 6) as
       Update PRSetup
           Set EmpRGP = @parm1
GO
