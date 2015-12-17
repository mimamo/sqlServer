USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_Union]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_Union] @parm1 varchar ( 4), @parm2 varchar ( 10), @parm3 varchar ( 10) as
    select * from Deduction where
                  CalYr       = @parm1 and
                  Union_cd like @parm2 and
                  DedId    like @parm3
             order by DedId
GO
