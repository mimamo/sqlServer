USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJFISCAL_sall]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJFISCAL_sall] @parm1 varchar (6)  as
select * from PJFISCAL
where   fiscalno like @parm1
	order by fiscalno
GO
