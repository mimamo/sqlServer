USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLOC_SPK0]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLOC_SPK0]  @parm1 varchar (4)   as
select * from PJALLOC
where    alloc_method_cd = @parm1
order by alloc_method_cd ,
step_number
GO
