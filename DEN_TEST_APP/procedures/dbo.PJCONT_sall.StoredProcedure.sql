USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONT_sall]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONT_sall] @parm1 varchar (16)  as
select * from PJCONT
where contract like @parm1
order by contract
GO
