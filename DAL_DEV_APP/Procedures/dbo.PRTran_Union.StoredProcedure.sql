USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_Union]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_Union] @parm1 varchar ( 10) as
    select * from PRTran where
                  Union_cd like @parm1
GO
