USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLOC_SALL]    Script Date: 12/21/2015 16:13:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLOC_SALL]  @parm1 varchar (4)   as
select * from PJALLOC
where    alloc_method_cd LIKE @parm1
order by alloc_method_cd ,
step_number
GO
