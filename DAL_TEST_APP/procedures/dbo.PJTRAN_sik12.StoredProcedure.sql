USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sik12]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sik12] @parm1 varchar (16) , @parm2 smalldatetime , @parm3 smalldatetime    as
select * from PJTRAN
where
        project = @parm1 and
        alloc_flag <> 'X'   and
        trans_date >= @parm2 and
        trans_date <= @parm3
GO
