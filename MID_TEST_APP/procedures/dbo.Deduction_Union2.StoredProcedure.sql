USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_Union2]    Script Date: 12/21/2015 15:49:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_Union2] @parm1 varchar ( 10) as
    select * from Deduction where
                  Union_cd like @parm1
             order by DedId
GO
