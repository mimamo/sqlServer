USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_Union2]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_Union2] @parm1 varchar ( 10) as
    select * from Deduction where
                  Union_cd like @parm1
             order by DedId
GO
