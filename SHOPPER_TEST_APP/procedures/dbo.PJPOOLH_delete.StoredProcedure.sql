USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLH_delete]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPOOLH_delete] @parm1 varchar (10) as
   delete from pjpoolh where period = @parm1
GO
